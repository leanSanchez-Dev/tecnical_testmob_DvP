import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_dvp/providers/user_provider.dart';
import 'package:flutter_app_dvp/models/user_model.dart';
import 'package:flutter_app_dvp/models/address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('UserProvider Tests', () {
    late UserProvider userProvider;

    setUp(() {
      // Mock SharedPreferences para testing
      SharedPreferences.setMockInitialValues({});
      userProvider = UserProvider();
    });

    test('Should initialize with null user', () {
      // Assert
      expect(userProvider.user, isNull);
    });

    test('Should create user successfully', () {
      // Arrange
      final user = User(
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 5, 15),
      );

      // Act
      userProvider.createUser(user);

      // Assert
      expect(userProvider.user, isNotNull);
      expect(userProvider.user?.firstName, 'Juan');
      expect(userProvider.user?.lastName, 'Pérez');
      expect(userProvider.user?.birthDate, DateTime(1990, 5, 15));
    });

    test('Should add address to existing user', () {
      // Arrange
      final user = User(
        firstName: 'Ana',
        lastName: 'García',
        birthDate: DateTime(1985, 12, 25),
      );
      userProvider.createUser(user);

      final address = Address(
        street: 'Calle 123 # 45-67',
        city: 'Medellín',
        state: 'Antioquia',
        zipCode: '050001',
      );

      // Act
      userProvider.addAddress(address);

      // Assert
      expect(userProvider.user?.addresses.length, 1);
      expect(userProvider.user?.addresses.first.street, 'Calle 123 # 45-67');
      expect(userProvider.user?.addresses.first.city, 'Medellín');
    });

    test('Should add multiple addresses to user', () {
      // Arrange
      final user = User(
        firstName: 'Carlos',
        lastName: 'López',
        birthDate: DateTime(1988, 3, 10),
      );
      userProvider.createUser(user);

      final address1 = Address(
        street: 'Calle 123',
        city: 'Medellín',
        state: 'Antioquia',
        zipCode: '050001',
      );

      final address2 = Address(
        street: 'Carrera 456',
        city: 'Bogotá',
        state: 'Cundinamarca',
        zipCode: '110111',
      );

      // Act
      userProvider.addAddress(address1);
      userProvider.addAddress(address2);

      // Assert
      expect(userProvider.user?.addresses.length, 2);
      expect(userProvider.user?.addresses[0].city, 'Medellín');
      expect(userProvider.user?.addresses[1].city, 'Bogotá');
    });

    test('Should remove address from user', () {
      // Arrange
      final user = User(
        firstName: 'María',
        lastName: 'Rodríguez',
        birthDate: DateTime(1992, 8, 20),
      );
      userProvider.createUser(user);

      final address1 = Address(
        street: 'Calle 123',
        city: 'Medellín',
        state: 'Antioquia',
        zipCode: '050001',
      );

      final address2 = Address(
        street: 'Carrera 456',
        city: 'Bogotá',
        state: 'Cundinamarca',
        zipCode: '110111',
      );

      userProvider.addAddress(address1);
      userProvider.addAddress(address2);

      // Act
      userProvider.removeAddress(address1);

      // Assert
      expect(userProvider.user?.addresses.length, 1);
      expect(userProvider.user?.addresses.first.city, 'Bogotá');
    });

    test('Should handle removing non-existent address gracefully', () {
      // Arrange
      final user = User(
        firstName: 'Pedro',
        lastName: 'Sánchez',
        birthDate: DateTime(1987, 11, 5),
      );
      userProvider.createUser(user);

      final existingAddress = Address(
        street: 'Calle 123',
        city: 'Medellín',
        state: 'Antioquia',
        zipCode: '050001',
      );

      final nonExistentAddress = Address(
        street: 'Carrera 999',
        city: 'Cali',
        state: 'Valle',
        zipCode: '760001',
      );

      userProvider.addAddress(existingAddress);

      // Act
      userProvider.removeAddress(nonExistentAddress);

      // Assert
      expect(userProvider.user?.addresses.length, 1);
      expect(userProvider.user?.addresses.first.street, 'Calle 123');
    });

    test('Should update user data when creating new user', () {
      // Arrange
      final user1 = User(
        firstName: 'Usuario1',
        lastName: 'Apellido1',
        birthDate: DateTime(1990, 1, 1),
      );

      final user2 = User(
        firstName: 'Usuario2',
        lastName: 'Apellido2',
        birthDate: DateTime(1995, 6, 15),
      );

      // Act
      userProvider.createUser(user1);
      userProvider.createUser(user2);

      // Assert
      expect(userProvider.user?.firstName, 'Usuario2');
      expect(userProvider.user?.lastName, 'Apellido2');
      expect(userProvider.user?.birthDate, DateTime(1995, 6, 15));
    });

    test(
      'Should preserve existing addresses when creating user with addresses',
      () {
        // Arrange
        final address1 = Address(
          street: 'Calle Antigua',
          city: 'Ciudad Antigua',
          state: 'Estado Antiguo',
          zipCode: '00000',
        );

        final address2 = Address(
          street: 'Calle Nueva',
          city: 'Ciudad Nueva',
          state: 'Estado Nuevo',
          zipCode: '11111',
        );

        final userWithAddresses = User(
          firstName: 'Usuario',
          lastName: 'ConDirecciones',
          birthDate: DateTime(1985, 12, 31),
          addresses: [address1, address2],
        );

        // Act
        userProvider.createUser(userWithAddresses);

        // Assert
        expect(userProvider.user?.addresses.length, 2);
        expect(userProvider.user?.addresses[0].street, 'Calle Antigua');
        expect(userProvider.user?.addresses[1].street, 'Calle Nueva');
      },
    );

    test('Should handle null user when adding address', () {
      // Arrange
      final address = Address(
        street: 'Calle Test',
        city: 'Ciudad Test',
        state: 'Estado Test',
        zipCode: '12345',
      );

      // Act & Assert
      // No debería lanzar excepción
      expect(() => userProvider.addAddress(address), returnsNormally);
      expect(userProvider.user, isNull);
    });

    test('Should handle null user when removing address', () {
      // Arrange
      final address = Address(
        street: 'Calle Test',
        city: 'Ciudad Test',
        state: 'Estado Test',
        zipCode: '12345',
      );

      // Act & Assert
      // No debería lanzar excepción
      expect(() => userProvider.removeAddress(address), returnsNormally);
      expect(userProvider.user, isNull);
    });

    test('Should notify listeners when user is created', () {
      // Arrange
      bool listenerCalled = false;
      userProvider.addListener(() {
        listenerCalled = true;
      });

      final user = User(
        firstName: 'Test',
        lastName: 'User',
        birthDate: DateTime(1990, 1, 1),
      );

      // Act
      userProvider.createUser(user);

      // Assert
      expect(listenerCalled, isTrue);
    });

    test('Should notify listeners when address is added', () {
      // Arrange
      final user = User(
        firstName: 'Test',
        lastName: 'User',
        birthDate: DateTime(1990, 1, 1),
      );
      userProvider.createUser(user);

      bool listenerCalled = false;
      userProvider.addListener(() {
        listenerCalled = true;
      });

      final address = Address(
        street: 'Test Street',
        city: 'Test City',
        state: 'Test State',
        zipCode: '12345',
      );

      // Act
      userProvider.addAddress(address);

      // Assert
      expect(listenerCalled, isTrue);
    });

    test('Should notify listeners when address is removed', () {
      // Arrange
      final user = User(
        firstName: 'Test',
        lastName: 'User',
        birthDate: DateTime(1990, 1, 1),
      );
      userProvider.createUser(user);

      final address = Address(
        street: 'Test Street',
        city: 'Test City',
        state: 'Test State',
        zipCode: '12345',
      );
      userProvider.addAddress(address);

      bool listenerCalled = false;
      userProvider.addListener(() {
        listenerCalled = true;
      });

      // Act
      userProvider.removeAddress(address);

      // Assert
      expect(listenerCalled, isTrue);
    });
  });
}
