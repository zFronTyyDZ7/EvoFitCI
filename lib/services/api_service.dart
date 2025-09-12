import 'dart:convert';
import 'package:http/http.dart' as http;

/// Classe responsável por comunicação entre app Flutter (EvoFit)
/// e API Spring Boot + MySQL
class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080/api";

  /// Registrar usuário
  static Future<bool> registerUser(
    String name,
    String email,
    String password,
  ) async {
    final url = Uri.parse("$baseUrl/users/register");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      print("✅ Usuário registrado com sucesso!");
      return true;
    } else {
      print("❌ Erro ao registrar: ${response.statusCode} - ${response.body}");
      return false;
    }
  }

  /// Login
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/users");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List users = jsonDecode(response.body);
      return users.any(
        (user) => user["email"] == email && user["password"] == password,
      );
    } else {
      print("❌ Erro no login: ${response.body}");
      return false;
    }
  }

  /// Salvar objetivo
  static Future<bool> saveObjective(String email, String objective) async {
    final url = Uri.parse("$baseUrl/objectives/save");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "objective": objective}),
    );

    if (response.statusCode == 200) {
      print("✅ Objetivo salvo com sucesso!");
      return true;
    } else {
      print(
        "❌ Erro ao salvar objetivo: ${response.statusCode} - ${response.body}",
      );
      return false;
    }
  }
}
