import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'package:offline_service_booking/src/infrastructure/core/database_service.dart';

import 'database_service_test.mocks.dart';

// A subclass to inject mocked Database
class DatabaseServicesWithMock extends DatabaseServices {
  final Database _mockDb;
  DatabaseServicesWithMock(this._mockDb);

  @override
  Future<Database> get database async => _mockDb;
}

@GenerateMocks([Database])
void main() {
  late MockDatabase mockDatabase;
  late DatabaseServices db;

  setUp(() {
    mockDatabase = MockDatabase();
    db = DatabaseServicesWithMock(mockDatabase);
  });

  group('DatabaseServices', () {
    test('insertData inserts and returns inserted row id', () async {
      when(mockDatabase.insert(
        any,
        any,
        conflictAlgorithm: anyNamed('conflictAlgorithm'),
      )).thenAnswer((_) async => 1);

      final result = await db.insertData(
        tableName: 'providers',
        data: {
          'name': 'John',
          'contact': '1234567890',
          'location': 'Somewhere',
          'category': 'AC Repair'
        },
      );

      expect(result, 1);
      verify(mockDatabase.insert(any, any, conflictAlgorithm: anyNamed('conflictAlgorithm'))).called(1);
    });

    test('getData returns list of maps', () async {
      final sampleData = [
        {
          'id': 1,
          'name': 'John',
          'contact': '1234567890',
          'location': 'Somewhere',
          'category': 'AC Repair',
        }
      ];

      when(mockDatabase.query('providers', where: null, whereArgs: null))
          .thenAnswer((_) async => sampleData);

      final result = await db.getData(tableName: 'providers');

      expect(result, sampleData);
      verify(mockDatabase.query('providers', where: null, whereArgs: null)).called(1);
    });

    test('updateData updates rows and returns affected row count', () async {
      when(mockDatabase.update(
        any,
        any,
        where: anyNamed('where'),
        whereArgs: anyNamed('whereArgs'),
      )).thenAnswer((_) async => 1);

      final result = await db.updateData(
        tableName: 'providers',
        data: {'name': 'Updated John'},
        where: 'id = ?',
        whereArgs: [1],
      );

      expect(result, 1);
      verify(mockDatabase.update(any, any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs'))).called(1);
    });

    test('deleteData deletes rows and returns count', () async {
      when(mockDatabase.delete(
        any,
        where: anyNamed('where'),
        whereArgs: anyNamed('whereArgs'),
      )).thenAnswer((_) async => 1);

      final result = await db.deleteData(
        tableName: 'providers',
        where: 'id = ?',
        whereArgs: [1],
      );

      expect(result, 1);
      verify(mockDatabase.delete(any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs'))).called(1);
    });
  });
}
