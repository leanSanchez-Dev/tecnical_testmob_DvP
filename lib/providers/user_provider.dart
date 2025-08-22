import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/address_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final String _userKey =
      'user_data'; // Clave para guardar en SharedPreferences

  User? get user => _user;

  // Cargar datos desde SharedPreferences
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);

    if (userData != null) {
      _user = User.fromMap(Map<String, dynamic>.from(json.decode(userData)));
      notifyListeners();
    }
  }

  // Guardar datos en SharedPreferences
  Future<void> _saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (_user != null) {
      final userData = json.encode(_user!.toMap());
      await prefs.setString(_userKey, userData);
    }
  }

  // Crear usuario y guardar
  void createUser(User newUser) {
    _user = newUser;
    _saveUser();
    notifyListeners();
  }

  // Agregar dirección y guardar
  void addAddress(Address address) {
    _user?.addresses.add(address);
    _saveUser();
    notifyListeners();
  }

  // Método para eliminar una dirección
  void removeAddress(Address address) {
    _user?.addresses.remove(address);
    _saveUser();
    notifyListeners();
  }

  // Limpiar datos del usuario y de SharedPreferences
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    _user = null;
    notifyListeners();
  }
}
