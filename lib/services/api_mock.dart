// services/api_mock.dart
import 'dart:async';

class MockApiService {
  // Usuário inicial para testes
  static final List<Map<String, String>> _users = [
    {"name": "Teste", "email": "teste@teste.com", "password": "123456"},
  ];

  /// Simula cadastro
  static Future<bool> registerUser(
    String name,
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 1)); // simula delay
    if (_users.any((u) => u['email'] == email)) return false; // já existe
    _users.add({"name": name, "email": email, "password": password});
    return true;
  }

  /// Simula login
  static Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return _users.any((u) => u['email'] == email && u['password'] == password);
  }
}
