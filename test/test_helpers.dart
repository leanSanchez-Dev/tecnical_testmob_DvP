import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Configuración común para todos los tests
class TestConfig {
  /// Inicializa SharedPreferences mock para testing
  static void setupSharedPreferences() {
    SharedPreferences.setMockInitialValues({});
  }

  /// Limpia cualquier configuración después de los tests
  static void tearDown() {
    // Limpiar cualquier estado global si es necesario
  }
}

/// Datos de prueba comunes para usar en tests
class TestData {
  static final testUser1 = {
    'firstName': 'Juan',
    'lastName': 'Pérez',
    'birthDate': DateTime(1990, 5, 15),
  };

  static final testUser2 = {
    'firstName': 'María',
    'lastName': 'García',
    'birthDate': DateTime(1985, 12, 25),
  };

  static final testAddress1 = {
    'street': 'Calle 123 # 45-67',
    'city': 'Medellín',
    'state': 'Antioquia',
    'zipCode': '050001',
  };

  static final testAddress2 = {
    'street': 'Carrera 456 # 78-90',
    'city': 'Bogotá',
    'state': 'Cundinamarca',
    'zipCode': '110111',
  };

  static final testAddress3 = {
    'street': 'Avenida Principal 789',
    'city': 'Cali',
    'state': 'Valle del Cauca',
    'zipCode': '760001',
  };
}

/// Matchers personalizados para tests
class CustomMatchers {
  /// Verifica que una fecha esté en un rango válido
  static Matcher isValidBirthDate() {
    return predicate<DateTime>((date) {
      final now = DateTime.now();
      final minDate = DateTime(1900);
      return date.isAfter(minDate) && date.isBefore(now);
    }, 'is a valid birth date');
  }

  /// Verifica que un código postal tenga el formato correcto
  static Matcher isValidZipCode() {
    return predicate<String>((zipCode) {
      return zipCode.isNotEmpty && zipCode.length >= 4 && zipCode.length <= 10;
    }, 'is a valid zip code');
  }

  /// Verifica que una dirección tenga todos los campos requeridos
  static Matcher hasRequiredAddressFields() {
    return predicate<Map<String, dynamic>>((address) {
      return address.containsKey('street') &&
          address.containsKey('city') &&
          address.containsKey('state') &&
          address.containsKey('zipCode') &&
          address['street']?.toString().isNotEmpty == true &&
          address['city']?.toString().isNotEmpty == true &&
          address['state']?.toString().isNotEmpty == true &&
          address['zipCode']?.toString().isNotEmpty == true;
    }, 'has all required address fields');
  }
}
