import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_dvp/models/address_model.dart';

void main() {
  group('Address Model Tests', () {
    test('Should create an Address with valid data', () {
      // Act
      final address = Address(
        street: 'Calle 123 # 45-67',
        city: 'Medellín',
        state: 'Antioquia',
        zipCode: '050001',
      );

      // Assert
      expect(address.street, 'Calle 123 # 45-67');
      expect(address.city, 'Medellín');
      expect(address.state, 'Antioquia');
      expect(address.zipCode, '050001');
    });

    test('Should convert Address to Map correctly', () {
      // Arrange
      final address = Address(
        street: 'Carrera 456 # 78-90',
        city: 'Bogotá',
        state: 'Cundinamarca',
        zipCode: '110111',
      );

      // Act
      final addressMap = address.toMap();

      // Assert
      expect(addressMap['street'], 'Carrera 456 # 78-90');
      expect(addressMap['city'], 'Bogotá');
      expect(addressMap['state'], 'Cundinamarca');
      expect(addressMap['zipCode'], '110111');
      expect(addressMap.keys.length, 4);
    });

    test('Should create Address from Map correctly', () {
      // Arrange
      final addressMap = {
        'street': 'Avenida Principal 789',
        'city': 'Cali',
        'state': 'Valle del Cauca',
        'zipCode': '760001',
      };

      // Act
      final address = Address.fromMap(addressMap);

      // Assert
      expect(address.street, 'Avenida Principal 789');
      expect(address.city, 'Cali');
      expect(address.state, 'Valle del Cauca');
      expect(address.zipCode, '760001');
    });

    test('Should serialize and deserialize Address correctly', () {
      // Arrange
      final originalAddress = Address(
        street: 'Transversal 45 # 67-89',
        city: 'Barranquilla',
        state: 'Atlántico',
        zipCode: '080001',
      );

      // Act
      final addressMap = originalAddress.toMap();
      final deserializedAddress = Address.fromMap(addressMap);

      // Assert
      expect(deserializedAddress.street, originalAddress.street);
      expect(deserializedAddress.city, originalAddress.city);
      expect(deserializedAddress.state, originalAddress.state);
      expect(deserializedAddress.zipCode, originalAddress.zipCode);
    });

    test('Should handle different address formats', () {
      // Test case 1: Colombian format
      final colombianAddress = Address(
        street: 'Calle 72 # 10-34',
        city: 'Medellín',
        state: 'Antioquia',
        zipCode: '050034',
      );

      expect(colombianAddress.street, contains('#'));

      // Test case 2: International format
      final internationalAddress = Address(
        street: '123 Main Street',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
      );

      expect(internationalAddress.state.length, 2);

      // Test case 3: Long format
      final longAddress = Address(
        street: 'Avenida de los Insurgentes Sur 1234, Colonia Del Valle',
        city: 'Ciudad de México',
        state: 'Distrito Federal',
        zipCode: '03100',
      );

      expect(longAddress.street.length, greaterThan(30));
    });

    test('Should work with empty strings', () {
      // Act
      final address = Address(
        street: '',
        city: '',
        state: '',
        zipCode: '',
      );

      // Assert
      expect(address.street, '');
      expect(address.city, '');
      expect(address.state, '');
      expect(address.zipCode, '');
    });

    test('Should maintain data integrity through serialization cycles', () {
      // Arrange
      final addresses = [
        Address(
          street: 'Calle 1 # 2-3',
          city: 'City1',
          state: 'State1',
          zipCode: '12345',
        ),
        Address(
          street: 'Carrera 4 # 5-6',
          city: 'City2',
          state: 'State2',
          zipCode: '67890',
        ),
      ];

      // Act & Assert
      for (final originalAddress in addresses) {
        final map = originalAddress.toMap();
        final reconstructedAddress = Address.fromMap(map);

        expect(reconstructedAddress.street, originalAddress.street);
        expect(reconstructedAddress.city, originalAddress.city);
        expect(reconstructedAddress.state, originalAddress.state);
        expect(reconstructedAddress.zipCode, originalAddress.zipCode);
      }
    });
  });
}
