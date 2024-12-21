import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NetworkService {
  final String baseUrl = 'http://localhost:8080';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static final NetworkService _instance = NetworkService._internal();

  NetworkService._internal();

  factory NetworkService() {
    return _instance;
  }
  String? _sessionId;
  int? _userId;

  Future<String?> _getSessionId() async {
    return _sessionId;
  }

  Future<int?> _getUserId() async {
    return _userId;
  }

  Future<Map<String, dynamic>> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = await _secureStorage.read(key: 'password');

    if (email != null && password != null) {
      return await login(email, password);
    } else {
      return {'success': false, 'error': 'No saved credentials'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _sessionId = responseData['sessionId'];
        _userId = responseData['userId'];
        _saveSessionData(email, password);

        return {
          'success': true,
          'message': responseData['message'],
          'userId': _userId,
          'fullName': responseData['fullName'],
          'sessionId': _sessionId,
        };
      } else {
        return _handleErrorResponse(response);
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Something went wrong. Please try again later.'
      };
    }
  }

  Future<Map<String, dynamic>> register(
    String fullName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'fullName': fullName,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _sessionId = responseData['sessionId'];
        _userId = responseData['userId'];
        _saveSessionData(email, password);

        return {
          'success': true,
          'message': responseData['message'],
          'userId': _userId,
          'sessionId': _sessionId,
        };
      } else {
        return _handleErrorResponse(response);
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Something went wrong. Please try again later.'
      };
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    final sessionId = await _getSessionId();
    final userId = await _getUserId();
    if (sessionId == null) {
      return {'success': false, 'error': 'No session ID found'};
    }

    final url = Uri.parse('$baseUrl/user?userId=$userId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $sessionId',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'userData': responseData,
        };
      } else {
        return _handleErrorResponse(response);
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to retrieve user data. Please try again later.'
      };
    }
  }

  Future<Map<String, dynamic>> updateUser({
    String? fullName,
    String? email,
    dynamic photo,
  }) async {
    final sessionId = await _getSessionId();
    if (sessionId == null) {
      return {'success': false, 'error': 'No session ID found'};
    }

    final url = Uri.parse('$baseUrl/updateUser');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $sessionId';

    if (fullName != null) {
      request.fields['fullName'] = fullName;
    }
    if (email != null) {
      request.fields['email'] = email;
    }

    if (photo != null) {
      if (photo is File) {
        final mimeType = lookupMimeType(photo.path);
        final mimeTypeData =
            mimeType != null ? mimeType.split('/') : ['image', 'jpeg'];
        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            photo.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        );
      } else if (photo is Uint8List) {
        final mimeTypeData = ['image', 'jpeg'];
        request.files.add(
          http.MultipartFile.fromBytes(
            'photo',
            photo,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
            filename: 'uploaded_image.jpg',
          ),
        );
      }
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        if (email != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', email);
        }
        return {
          'success': true,
          'message': jsonDecode(responseBody)['message']
        };
      } else {
        return _handleErrorResponse(
            http.Response(responseBody, response.statusCode));
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Something went wrong. Please try again later.'
      };
    }
  }

  Future<List<Map<String, dynamic>>> getPopularCars() async {
    return _getWithSession('$baseUrl/cars/popular');
  }

  Future<List<Map<String, dynamic>>> getAllCars() async {
    return _getWithSession('$baseUrl/cars');
  }

  Future<List<Map<String, dynamic>>> getPromotions() async {
    return _getWithSession('$baseUrl/promotions');
  }

  Future<List<Map<String, dynamic>>> _getWithSession(String url) async {
    final sessionId = await _getSessionId();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (sessionId != null) 'Authorization': 'Bearer $sessionId'
        },
      );

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> logout() async {
    final url = Uri.parse('$baseUrl/logout');
    final sessionId = await _getSessionId();

    if (sessionId == null) {
      return {'success': false, 'error': 'No session found to logout'};
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $sessionId',
        },
      );

      if (response.statusCode == 200) {
        _clearSessionData();
        return {
          'success': true,
          'message': jsonDecode(response.body)['message'],
        };
      } else {
        return _handleErrorResponse(response);
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Something went wrong. Please try again later.'
      };
    }
  }

  Future<void> _saveSessionData(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await _secureStorage.write(key: 'password', value: password);
  }

  Future<void> _clearSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await _secureStorage.delete(key: 'password');
    _sessionId = null;
    _userId = null;
  }

  Map<String, dynamic> _handleErrorResponse(http.Response response) {
    final errorData = jsonDecode(response.body);
    return {'success': false, 'error': errorData['error'] ?? 'Request failed'};
  }
}
