import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService instance = ApiService._internal();
  factory ApiService() => instance;
  ApiService._internal();

  final String baseUrl = 'https://sensivapp-backend.onrender.com';
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  void logout() {
    _token = null;
  }

  Future<Map<String, dynamic>> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logar'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setToken(data['token']);
      return data;
    } else {
      throw Exception(_parseError(response));
    }
  }

  Future<Map<String, dynamic>> registrar(
      String nome, String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/registrar'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'nome': nome, 'email': email, 'senha': senha}),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception(_parseError(response));
    }
  }

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(),
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(),
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(),
    );
    return _handleResponse(response);
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  String _parseError(http.Response response) {
    try {
      final data = json.decode(response.body);
      return data['error'] ?? data['message'] ?? 'Erro desconhecido';
    } catch (_) {
      return 'Erro na conexão (${response.statusCode})';
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else {
      throw Exception(_parseError(response));
    }
  }
}
