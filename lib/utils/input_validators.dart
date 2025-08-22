import 'package:flutter/services.dart';

class InputValidators {
  // Validador para nombres (solo letras y espacios)
  static String? validateName(String? value, {String? fieldName}) {
    fieldName ??= 'Este campo';

    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }

    if (value.trim().length < 2) {
      return '$fieldName debe tener al menos 2 caracteres';
    }

    if (value.trim().length > 50) {
      return '$fieldName no debe exceder 50 caracteres';
    }

    // Regex para permitir solo letras, espacios, acentos y ñ
    final nameRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$');
    if (!nameRegex.hasMatch(value.trim())) {
      return '$fieldName solo puede contener letras y espacios';
    }

    return null;
  }

  // Validador para texto general (direcciones, ciudades, etc.)
  static String? validateText(
    String? value, {
    String? fieldName,
    int? minLength,
    int? maxLength,
  }) {
    fieldName ??= 'Este campo';
    minLength ??= 2;
    maxLength ??= 100;

    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }

    if (value.trim().length < minLength) {
      return '$fieldName debe tener al menos $minLength caracteres';
    }

    if (value.trim().length > maxLength) {
      return '$fieldName no debe exceder $maxLength caracteres';
    }

    return null;
  }

  // Validador para código postal (solo números)
  static String? validateZipCode(String? value, {String? fieldName}) {
    fieldName ??= 'Código postal';

    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }

    // Remover espacios
    final cleanValue = value.replaceAll(RegExp(r'\s+'), '');

    if (cleanValue.length < 4 || cleanValue.length > 10) {
      return '$fieldName debe tener entre 4 y 10 dígitos';
    }

    // Regex para solo números
    final zipRegex = RegExp(r'^\d+$');
    if (!zipRegex.hasMatch(cleanValue)) {
      return '$fieldName solo puede contener números';
    }

    return null;
  }

  // Validador para números en general
  static String? validateNumber(
    String? value, {
    String? fieldName,
    int? min,
    int? max,
  }) {
    fieldName ??= 'Este campo';

    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }

    final number = int.tryParse(value.trim());
    if (number == null) {
      return '$fieldName debe ser un número válido';
    }

    if (min != null && number < min) {
      return '$fieldName debe ser mayor o igual a $min';
    }

    if (max != null && number > max) {
      return '$fieldName debe ser menor o igual a $max';
    }

    return null;
  }

  // Validador para email
  static String? validateEmail(String? value, {String? fieldName}) {
    fieldName ??= 'Email';

    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Ingrese un $fieldName válido';
    }

    return null;
  }

  // Validador para teléfono
  static String? validatePhone(String? value, {String? fieldName}) {
    fieldName ??= 'Teléfono';

    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }

    // Remover espacios, guiones y paréntesis
    final cleanValue = value.replaceAll(RegExp(r'[\s\-\(\)]+'), '');

    if (cleanValue.length < 7 || cleanValue.length > 15) {
      return '$fieldName debe tener entre 7 y 15 dígitos';
    }

    // Permitir + al inicio para códigos de país
    final phoneRegex = RegExp(r'^\+?\d+$');
    if (!phoneRegex.hasMatch(cleanValue)) {
      return '$fieldName solo puede contener números y el símbolo +';
    }

    return null;
  }

  // Validador para fecha de nacimiento
  static String? validateBirthDate(DateTime? value, {String? fieldName}) {
    fieldName ??= 'Fecha de nacimiento';

    if (value == null) {
      return '$fieldName es requerida';
    }

    final now = DateTime.now();
    final age =
        now.year -
        value.year -
        (now.month > value.month ||
                (now.month == value.month && now.day >= value.day)
            ? 0
            : 1);

    if (value.isAfter(now)) {
      return '$fieldName no puede ser en el futuro';
    }

    if (age > 120) {
      return '$fieldName no puede ser mayor a 120 años';
    }

    if (age < 1) {
      return 'Debe ser mayor de 1 año';
    }

    return null;
  }

  // Validador personalizable
  static String? validateCustom(
    String? value, {
    String? fieldName,
    bool required = true,
    int? minLength,
    int? maxLength,
    RegExp? pattern,
    String? patternErrorMessage,
  }) {
    fieldName ??= 'Este campo';

    if (required && (value == null || value.trim().isEmpty)) {
      return '$fieldName es requerido';
    }

    if (value != null && value.trim().isNotEmpty) {
      if (minLength != null && value.trim().length < minLength) {
        return '$fieldName debe tener al menos $minLength caracteres';
      }

      if (maxLength != null && value.trim().length > maxLength) {
        return '$fieldName no debe exceder $maxLength caracteres';
      }

      if (pattern != null && !pattern.hasMatch(value.trim())) {
        return patternErrorMessage ?? '$fieldName tiene un formato inválido';
      }
    }

    return null;
  }
}

// Enumeración para tipos de validación predefinidos
enum ValidationType { name, text, zipCode, number, email, phone, custom }

// Clase para formatters de input
class InputFormatters {
  // Formatter para solo letras y espacios
  static List<TextInputFormatter> nameFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]')),
      LengthLimitingTextInputFormatter(50),
    ];
  }

  // Formatter para solo números
  static List<TextInputFormatter> numberFormatter({int? maxLength}) {
    return [
      FilteringTextInputFormatter.digitsOnly,
      if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
    ];
  }

  // Formatter para código postal
  static List<TextInputFormatter> zipCodeFormatter() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10),
    ];
  }

  // Formatter para teléfono
  static List<TextInputFormatter> phoneFormatter() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s\(\)]')),
      LengthLimitingTextInputFormatter(20),
    ];
  }

  // Formatter para texto general
  static List<TextInputFormatter> textFormatter({int? maxLength}) {
    return [if (maxLength != null) LengthLimitingTextInputFormatter(maxLength)];
  }

  // Formatter para email
  static List<TextInputFormatter> emailFormatter() {
    return [
      FilteringTextInputFormatter.deny(RegExp(r'\s')), // No permitir espacios
      LengthLimitingTextInputFormatter(100),
    ];
  }
}
