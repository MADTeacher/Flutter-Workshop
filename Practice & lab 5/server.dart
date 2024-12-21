import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:server/database.dart';
import 'package:mime/mime.dart';
import 'package:shelf_static/shelf_static.dart';


final db = AppDatabase();

Middleware corsHeaders() {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization, Cookie',
    'Access-Control-Allow-Credentials': 'true',
  };

  Response addCorsHeaders(Response response) =>
      response.change(headers: {...response.headers, ...corsHeaders});

  return (Handler handler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: corsHeaders);
      }

      final Response response = await handler(request);
      return addCorsHeaders(response);
    };
  };
}

void main() async {
  final router = Router();

  final staticFilesHandler = createStaticHandler('uploads', defaultDocument: 'index.html');

  router.mount('/uploads/', staticFilesHandler);
  
  router.post('/register', (Request request) async {
    final payload = await request.readAsString();
    final data = Uri.splitQueryString(payload);

    final fullName = data['fullName'];
    final email = data['email'];
    final password = data['password'];
    final confirmPassword = data['confirmPassword'];

    if (fullName == null || email == null || password == null || confirmPassword == null) {
      return Response.badRequest(body: jsonEncode({'error': 'Missing required fields'}));
    }

    if (password != confirmPassword) {
      return Response.badRequest(body: jsonEncode({'error': 'Passwords do not match'}));
    }

    final existingUser = await db.getUserByEmail(email);
    if (existingUser != null) {
      return Response.badRequest(body: jsonEncode({'error': 'Email already exists'}));
    }

    try {
      final userId = await db.registerUser(fullName, email, password);
      
      final session = await db.createSession(userId);

      return Response.ok(jsonEncode({
        'message': 'User registered and logged in',
        'userId': userId,
        'sessionId': session?.sessionId,
      }));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': 'Registration failed', 'details': e.toString()}));
    }
  });

  router.post('/login', (Request request) async {
    final payload = await request.readAsString();
    final data = Uri.splitQueryString(payload);

    final email = data['email'];
    final password = data['password'];

    if (email == null || password == null) {
      return Response.badRequest(body: jsonEncode({'error': 'Missing email or password'}));
    }

    final user = await db.authenticateUser(email, password);
    if (user != null) {
      final session = await db.createSession(user.id);

      return Response.ok(jsonEncode({
        'message': 'Login successful',
        'userId': user.id,
        'fullName': user.fullName,
        'sessionId': session?.sessionId,
      }), headers: {
        'Content-Type': 'application/json',
      });
    } else {
      return Response.forbidden(jsonEncode({'error': 'Invalid email or password'}));
    }
  });

  String? extractSessionId(Request request) {
    final authHeader = request.headers['Authorization'];
    if (authHeader != null && authHeader.startsWith('Bearer ')) {
      return authHeader.substring(7);
    }
    return null;
  }


  router.post('/logout', (Request request) async {
    final sessionId = extractSessionId(request);

    if (sessionId == null || sessionId.isEmpty) {
      return Response.badRequest(body: jsonEncode({'error': 'Не найден идентификатор сессии в заголовке Authorization'}));
    }

    await db.deleteSession(sessionId);

    return Response.ok(jsonEncode({'message': 'Вы успешно вышли из системы'}), headers: {
      'Authorization': 'Bearer ',
    });
  });

  final protectedRouter = Router();

  protectedRouter.get('/users', (Request request) async {
    try {
      final users = await db.getAllUsers();
      final usersList = users.map((user) => {
        'id': user.id,
        'fullName': user.fullName,
        'email': user.email,
      }).toList();

      return Response.ok(jsonEncode(usersList), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: 'Failed to retrieve users: $e');
    }
  });

  protectedRouter.get('/user', (Request request) async {
    try {
      final userId = request.url.queryParameters['userId'];
      final id = int.tryParse(userId ?? '');

      if (id == null) {
        return Response.badRequest(body: jsonEncode({'error': 'Invalid or missing user ID'}));
      }

      final user = await db.getUserById(id);
      if (user == null) {
        return Response.notFound(jsonEncode({'error': 'User not found'}));
      }

      return Response.ok(jsonEncode({
        'id': user.id,
        'fullName': user.fullName,
        'email': user.email,
        'photo': user.photo,
      }), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': 'Failed to retrieve user data', 'details': e.toString()}));
    }
  });

  protectedRouter.post('/updateUser', (Request request) async {
    final boundary = request.headers['content-type']?.split('boundary=')[1];
    if (boundary == null) {
      return Response.badRequest(body: jsonEncode({'error': 'Invalid content type'}));
    }

    final transformer = MimeMultipartTransformer(boundary);
    final parts = await transformer.bind(request.read()).toList();

    String? fullName;
    String? email;
    String? photoPath;

    for (final part in parts) {
      final contentDisposition = part.headers['content-disposition'];
      if (contentDisposition != null && contentDisposition.contains('filename=')) {
        final content = await part.toList();
        final fileName = contentDisposition.split('filename=')[1].replaceAll('"', '');
        final fileBytes = content.expand((e) => e).toList();

        final filePath = 'uploads/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(fileBytes);

        photoPath = filePath;
      } else {
        final field = utf8.decode(await part.expand((bytes) => bytes).toList());
        if (contentDisposition!.contains('name="fullName"')) {
          fullName = field;
        } else if (contentDisposition.contains('name="email"')) {
          email = field;
        }
      }
    }

    final sessionId = extractSessionId(request);
    if (sessionId == null) {
      return Response.forbidden(jsonEncode({'error': 'Not authorized'}));
    }

    final session = await db.getSessionById(sessionId);
    if (session == null) {
      return Response.forbidden(jsonEncode({'error': 'Session not found or expired'}));
    }

    try {

      final user = await db.getUserById(session.userId);
      if (user == null) {
        return Response.notFound(jsonEncode({'error': 'User not found'}));
      }

      await db.updateUser(
        id: session.userId,
        fullName: fullName ?? user.fullName,
        email: email ?? user.email,
        photo: photoPath ?? user.photo,
      );

      return Response.ok(jsonEncode({'message': 'User updated successfully'}));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': 'Failed to update user', 'details': e.toString()}));
    }
  });


  protectedRouter.get('/cars', (Request request) async {
    final languageCode = request.headers['accept-language']?.split(',').first ?? 'en';
    try {
      final cars = await db.getAllCars(languageCode);
      return Response.ok(jsonEncode(cars), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: 'Failed to retrieve cars: $e');
    }
  });

  protectedRouter.get('/cars/popular', (Request request) async {
    final languageCode = request.headers['accept-language']?.split(',').first ?? 'en';
    try {
      final cars = await db.getPopularCars(languageCode);
      return Response.ok(jsonEncode(cars), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: 'Failed to retrieve popular cars: $e');
    }
  });

  protectedRouter.post('/addCar', (Request request) async {
    final boundary = request.headers['content-type']?.split('boundary=')[1];
    if (boundary == null) {
      return Response.badRequest(body: jsonEncode({'error': 'Invalid content type'}));
    }

    final transformer = MimeMultipartTransformer(boundary);
    final parts = await transformer.bind(request.read()).toList();

    String? name;
    double? rating;
    double? reviewCount;
    double? rentalPricePerDay;
    bool? isPopular;
    String? localizedDescription; // JSON
    String? localizedFuelType;    // JSON
    String? localizedColor;       // JSON
    String? driveType;
    String? engineType;
    int? power;

    List<String> photoPaths = [];

    for (final part in parts) {
      final contentDisposition = part.headers['content-disposition'];
      if (contentDisposition != null && contentDisposition.contains('filename=')) {
        // Сохраняем файл
        final content = await part.toList();
        final fileName = contentDisposition.split('filename=')[1].replaceAll('"', '');
        final fileBytes = content.expand((e) => e).toList();

        final filePath = 'uploads/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(fileBytes);

        photoPaths.add(filePath);
      } else {
        // Обрабатываем текстовые данные
        final field = utf8.decode(await part.expand((bytes) => bytes).toList());
        if (contentDisposition!.contains('name="name"')) {
          name = field;
        } else if (contentDisposition.contains('name="rating"')) {
          rating = double.parse(field);
        } else if (contentDisposition.contains('name="reviewCount"')) {
          reviewCount = double.parse(field);
        } else if (contentDisposition.contains('name="rentalPricePerDay"')) {
          rentalPricePerDay = double.parse(field);
        } else if (contentDisposition.contains('name="isPopular"')) {
          isPopular = field == 'true';
        } else if (contentDisposition.contains('name="localizedDescription"')) {
          localizedDescription = field; // Ожидаем JSON
        } else if (contentDisposition.contains('name="localizedFuelType"')) {
          localizedFuelType = field; // Ожидаем JSON
        } else if (contentDisposition.contains('name="localizedColor"')) {
          localizedColor = field; // Ожидаем JSON
        } else if (contentDisposition.contains('name="driveType"')) {
          driveType = field;
        } else if (contentDisposition.contains('name="engineType"')) {
          engineType = field; // Новый параметр
        } else if (contentDisposition.contains('name="power"')) {
          power = int.parse(field); // Новый параметр
        }
      }
    }

    // Проверяем, что обязательные поля переданы
    if (name == null ||
        rating == null ||
        reviewCount == null ||
        rentalPricePerDay == null ||
        isPopular == null ||
        localizedDescription == null ||
        localizedFuelType == null ||
        localizedColor == null ||
        driveType == null || engineType == null || power == null) {
      return Response.badRequest(body: jsonEncode({'error': 'Missing required fields'}));
    }

    try {
      // Преобразуем JSON данные в Map<String, String>
      final Map<String, String> descriptions =
          (jsonDecode(localizedDescription) as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value.toString()));

      final Map<String, String> fuelTypes =
          (jsonDecode(localizedFuelType) as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value.toString()));

      final Map<String, String> colors =
          (jsonDecode(localizedColor) as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value.toString()));

      // Добавляем машину в базу данных
      await db.addCar(
        photos: jsonEncode(photoPaths), // Сериализуем список в JSON
        name: name,
        rating: rating,
        reviewCount: reviewCount,
        rentalPricePerDay: rentalPricePerDay,
        isPopular: isPopular,
        localizedDescriptions: descriptions,
        localizedFuelTypes: fuelTypes,
        localizedColors: colors,
        driveType: driveType,
        engineType: engineType, // Новый параметр
        power: power, 
      );

      return Response.ok(jsonEncode({'message': 'Car added successfully'}));
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': 'Failed to add car', 'details': e.toString()}));
    }
  });

  protectedRouter.get('/promotions', (Request request) async {
    final languageCode = request.headers['accept-language']?.split(',').first ?? 'en';
    try {
      final promotions = await db.getAllPromotions(languageCode);
      return Response.ok(jsonEncode(promotions), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: 'Failed to retrieve promotions: $e');
    }
  });

  protectedRouter.post('/addPromotion', (Request request) async {
    final boundary = request.headers['content-type']?.split('boundary=')[1];
    if (boundary == null) {
      return Response.badRequest(body: jsonEncode({'error': 'Invalid content type'}));
    }

    final transformer = MimeMultipartTransformer(boundary);
    final parts = await transformer.bind(request.read()).toList();

    String? localizedName; // JSON
    String? photoPath;

    for (final part in parts) {
      final contentDisposition = part.headers['content-disposition'];
      if (contentDisposition != null && contentDisposition.contains('filename=')) {
        try {
          final content = await part.toList();
          final fileName = contentDisposition.split('filename=')[1].replaceAll('"', '');
          final fileBytes = content.expand((e) => e).toList();

          final filePath = 'uploads/$fileName';
          final file = File(filePath);
          await file.writeAsBytes(fileBytes);

          photoPath = filePath; // Путь к загруженному файлу
        } catch (e) {
          return Response.internalServerError(
              body: jsonEncode({'error': 'Failed to upload file', 'details': e.toString()}));
        }
      } else {
        final field = utf8.decode(await part.expand((bytes) => bytes).toList());
        if (contentDisposition!.contains('name="localizedName"')) {
          localizedName = field; // JSON строка
        }
      }
    }

    // Проверяем, что обязательные поля заполнены
    if (localizedName == null || photoPath == null) {
      return Response.badRequest(body: jsonEncode({'error': 'Missing required fields'}));
    }

    try {
      // Преобразуем JSON в Map<String, String>
      final Map<String, String> localizedNames =
          (jsonDecode(localizedName) as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value.toString()));

      // Добавляем промоакцию в базу
      await db.addPromotion(
        localizedNames: localizedNames,
        photo: photoPath,
      );

      return Response.ok(jsonEncode({'message': 'Promotion added successfully'}));
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': 'Failed to add promotion', 'details': e.toString()}));
    }
  });



  Middleware sessionChecker() {
    return (Handler handler) {
      return (Request request) async {
        final sessionId = extractSessionId(request);

        if (sessionId == null || sessionId.isEmpty) {
          return Response.forbidden(jsonEncode({'error': 'Not authorized'}));
        }

        final session = await db.getSessionById(sessionId);

        if (session == null) {
          return Response.forbidden(jsonEncode({'error': 'Session not found or expired'}));
        }

        final now = DateTime.now();
        final inactiveDuration = now.difference(session.lastUsed);

        if (inactiveDuration > Duration(minutes: 15)) {
          await db.deleteSession(sessionId);
          return Response.forbidden(jsonEncode({'error': 'Session expired due to inactivity'}));
        }

        await db.updateSessionLastUsed(sessionId, now);

        return handler(request);
      };
    };
  }

  final protectedHandler = Pipeline()
    .addMiddleware(sessionChecker())
    .addHandler(protectedRouter.call);


  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler((Router()
      ..mount('/', router.call)
      ..mount('/', protectedHandler)).call);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('Server running on http://localhost:${server.port}');
}
