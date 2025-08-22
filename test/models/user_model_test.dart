import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_dvp/models/user_model.dart';
import 'package:flutter_app_dvp/models/address_model.dart';

void main() {
  group('User Model Tests', () {
    test('Should create a User with valid data', () {
      // Arrange
      final birthDate = DateTime(1990, 5, 15);
      final address = Address(
        street: 'Calle 123',
        city: 'Medellín',
        state: 'Antioquia',
        zipCode: '050001',
      );

      // Act
      final user = User(
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: birthDate,
        addresses: [address],
      );

      // Assert
      expect(user.firstName, 'Juan');
      expect(user.lastName, 'Pérez');
      expect(user.birthDate, birthDate);
      expect(user.addresses.length, 1);
      expect(user.addresses.first, address);
    });

    test('Should create a User with empty addresses list when none provided', () {
      // Act
      final user = User(
        firstName: 'Ana',
        lastName: 'García',
      );

      // Assert
      expect(user.addresses, isNotNull);
      expect(user.addresses.isEmpty, true);
    });

    test('Should convert User to Map correctly', () {
      // Arrange
      final birthDate = DateTime(1990, 5, 15);
      final address = Address(
        street: 'Calle 123',
        city: 'Medellín',
        state: 'Antioquia',
        zipCode: '050001',
      );
      final user = User(
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: birthDate,
        addresses: [address],
      );

      // Act
      final userMap = user.toMap();

      // Assert
      expect(userMap['firstName'], 'Juan');
      expect(userMap['lastName'], 'Pérez');
      expect(userMap['birthDate'], birthDate.toIso8601String());
      expect(userMap['addresses'], isA<List>());
      expect(userMap['addresses'].length, 1);
    });

    test('Should create User from Map correctly', () {
      // Arrange
      final birthDate = DateTime(1990, 5, 15);
      final userMap = {
        'firstName': 'María',
        'lastName': 'López',
        'birthDate': birthDate.toIso8601String(),
        'addresses': [
          {
            'street': 'Carrera 456',
            'city': 'Bogotá',
            'state': 'Cundinamarca',
            'zipCode': '110111',
          }
        ],
      };

      // Act
      final user = User.fromMap(userMap);

      // Assert
      expect(user.firstName, 'María');
      expect(user.lastName, 'López');
      expect(user.birthDate, birthDate);
      expect(user.addresses.length, 1);
      expect(user.addresses.first.street, 'Carrera 456');
    });

    test('Should handle null values in fromMap correctly', () {
      // Arrange
      final userMap = <String, dynamic>{
        'firstName': null,
        'lastName': null,
        'birthDate': null,
        'addresses': null,
      };

      // Act
      final user = User.fromMap(userMap);

      // Assert
      expect(user.firstName, isNull);
      expect(user.lastName, isNull);
      expect(user.birthDate, isNull);
      expect(user.addresses, isEmpty);
    });

    test('Should serialize and deserialize User correctly', () {
      // Arrange
      final originalUser = User(
        firstName: 'Carlos',
        lastName: 'Rodríguez',
        birthDate: DateTime(1985, 12, 25),
        addresses: [
          Address(
            street: 'Avenida Principal 789',
            city: 'Cali',
            state: 'Valle del Cauca',
            zipCode: '760001',
          ),
        ],
      );

      // Act
      final userMap = originalUser.toMap();
      final deserializedUser = User.fromMap(userMap);

      // Assert
      expect(deserializedUser.firstName, originalUser.firstName);
      expect(deserializedUser.lastName, originalUser.lastName);
      expect(deserializedUser.birthDate, originalUser.birthDate);
      expect(deserializedUser.addresses.length, originalUser.addresses.length);
      expect(
        deserializedUser.addresses.first.street,
        originalUser.addresses.first.street,
      );
    });
  });
}
