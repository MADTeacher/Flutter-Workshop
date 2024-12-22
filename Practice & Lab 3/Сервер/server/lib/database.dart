import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:convert';

part 'database.g.dart';

@DataClassName('Session')
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().customConstraint('UNIQUE')();
  IntColumn get userId => integer().customConstraint('REFERENCES users(id)')();
  DateTimeColumn get expiresAt => dateTime()();
  DateTimeColumn get lastUsed => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('User')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fullName => text()();
  TextColumn get email => text().customConstraint('UNIQUE')();
  TextColumn get passwordHash => text()();
  TextColumn get photo => text().nullable()();
}

@DataClassName('Promotion')
class Promotions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get photo => text()();
}

@DataClassName('Car')
class Cars extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get photos => text()();
  TextColumn get name => text()();
  RealColumn get rating => real()();
  RealColumn get reviewCount => real()();
  RealColumn get rentalPricePerDay => real()();
  BoolColumn get isPopular => boolean()();
  TextColumn get description => text()();
  TextColumn get engineType => text()();
  IntColumn get power => integer()();
  TextColumn get fuelType => text()();
  TextColumn get color => text()();
  TextColumn get driveType => text()();
}

@DriftDatabase(tables: [Users, Cars, Promotions, Sessions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
    },
  );

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<int> registerUser(String fullName, String email, String password) async {
    final user = UsersCompanion(
      fullName: Value(fullName),
      email: Value(email),
      passwordHash: Value(hashPassword(password)),
    );
    return into(users).insert(user);
  }

  Future<User?> authenticateUser(String email, String password) async {
    final query = select(users)..where((tbl) => tbl.email.equals(email));
    final user = await query.getSingleOrNull();

    if (user != null && user.passwordHash == hashPassword(password)) {
      return user;
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    return select(users).get();
  }

  Future<User?> getUserByEmail(String email) async {
    final query = select(users)..where((tbl) => tbl.email.equals(email));
    return await query.getSingleOrNull();
  }

  Future<User?> getUserById(int id) async {
    final query = select(users)..where((tbl) => tbl.id.equals(id));
    return await query.getSingleOrNull();
  }

  Future<void> updateUser({
    required int id,
    required String fullName,
    required String email,
    String? photo,
  }) async {
    final user = UsersCompanion(
      fullName: Value(fullName),
      email: Value(email),
      photo: Value(photo ?? ''),
    );
    await (update(users)..where((tbl) => tbl.id.equals(id))).write(user);
  }


  Future<List<Car>> getAllCars() async {
    return select(cars).get();
  }

  Future<List<Car>> getPopularCars() async {
    return (select(cars)..where((tbl) => tbl.isPopular.equals(true))).get();
  }

  Future<int> addCar({
    required String photos,
    required String name,
    required double rating,
    required double reviewCount,
    required double rentalPricePerDay,
    required bool isPopular,
    required String description,
    required String engineType,
    required int power,
    required String fuelType,
    required String color,
    required String driveType,
  }) async {
    final car = CarsCompanion(
      photos: Value(photos),
      name: Value(name),
      rating: Value(rating),
      reviewCount: Value(reviewCount),
      rentalPricePerDay: Value(rentalPricePerDay),
      isPopular: Value(isPopular),
      description: Value(description),
      engineType: Value(engineType),
      power: Value(power),
      fuelType: Value(fuelType),
      color: Value(color),
      driveType: Value(driveType),
    );
    return into(cars).insert(car);
  }

  Future<List<Promotion>> getAllPromotions() async {
    return select(promotions).get();
  }

  Future<int> addPromotion({
    required String name,
    required String photo,
  }) async {
    final promotion = PromotionsCompanion(
      name: Value(name),
      photo: Value(photo),
    );
    return into(promotions).insert(promotion);
  }

  Future<Session?> createSession(int userId) async {
    final sessionId = _generateSessionId(userId);
    final expiresAt = DateTime.now().add(Duration(minutes: 15));
    final lastUsed = DateTime.now();

    final session = SessionsCompanion(
      sessionId: Value(sessionId),
      userId: Value(userId),
      expiresAt: Value(expiresAt),
      lastUsed: Value(lastUsed),
    );

    final sessionIdInserted = await into(sessions).insert(session);
    return (select(sessions)..where((tbl) => tbl.id.equals(sessionIdInserted))).getSingleOrNull();
  }

  String _generateSessionId(int userId) {
    final bytes = utf8.encode(DateTime.now().toString() + userId.toString());
    return sha256.convert(bytes).toString();
  }

  Future<Session?> getSessionById(String sessionId) async {
    final query = select(sessions)..where((tbl) => tbl.sessionId.equals(sessionId));
    return await query.getSingleOrNull();
  }

  Future<void> updateSessionLastUsed(String sessionId, DateTime lastUsed) async {
    await (update(sessions)
          ..where((tbl) => tbl.sessionId.equals(sessionId)))
        .write(SessionsCompanion(lastUsed: Value(lastUsed)));
  }

  Future<void> deleteSession(String sessionId) async {
    await (delete(sessions)..where((tbl) => tbl.sessionId.equals(sessionId))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = Directory.current.path;
    final file = File(p.join(dbFolder, 'app.db'));
    return NativeDatabase(file);
  });
}