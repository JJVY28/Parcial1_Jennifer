import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'https://parcial1-jennifer.onrender.com';

  /// Enviar formulario de registro de planta
  /// Parámetros obligatorios según backend:
  /// plantName, plantType, userName, customPlantName, telefono, correo
  Future<Map<String, dynamic>> enviarFormulario({
    required String plantName,
    required String plantType,
    required String userName,
    required String customPlantName,
    required String telefono,
    required String correo,
  }) async {
    final url = Uri.parse('$baseUrl/enviarCorreo');
    final body = json.encode({
      'plantName': plantName,
      'plantType': plantType,
      'userName': userName,
      'customPlantName': customPlantName,
      'telefono': telefono,
      'correo': correo,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      // La respuesta es JSON con { success, mensaje }
      return json.decode(response.body);
    } else {
      throw Exception('Error al enviar formulario: ${response.statusCode} ${response.body}');
    }
  }

  /// Verificar humedad y obtener alerta si está fuera de rango
  /// Parámetros según backend: plantType, correo, userName, customPlantName
  Future<Map<String, dynamic>> verificarHumedad({
    required String plantType,
    required String correo,
    required String userName,
    required String customPlantName,
  }) async {
    final url = Uri.parse('$baseUrl/verificar-humedad');
    final body = json.encode({
      'plantType': plantType,
      'correo': correo,
      'userName': userName,
      'customPlantName': customPlantName,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      // Respuesta JSON con { success, mensaje }
      return json.decode(response.body);
    } else {
      throw Exception('Error al verificar humedad: ${response.statusCode} ${response.body}');
    }
  }

  /// Guardar planta en el servidor para verla luego en "Mis Plantas"
  Future<Map<String, dynamic>> guardarPlanta({
    required String plantName,
    required String plantType,
    required String userName,
    required String customPlantName,
    required String telefono,
    required String correo,
  }) async {
    final url = Uri.parse('$baseUrl/registrarPlanta');
    final body = json.encode({
      'plantName': plantName,
      'plantType': plantType,
      'userName': userName,
      'customPlantName': customPlantName,
      'telefono': telefono,
      'correo': correo,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al guardar planta: ${response.statusCode} ${response.body}');
    }
  }

  /// Método para obtener las plantas de un usuario dado su correo
  Future<List<dynamic>> obtenerMisPlantas(String correo) async {
    final url = Uri.parse('$baseUrl/misPlantas');
  final body = json.encode({'correo': correo});

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['success'] == true) {
        return decoded['plantas'];
      } else {
        throw Exception(decoded['mensaje'] ?? 'Error al obtener plantas');
      }
    } else {
      throw Exception('Error al obtener plantas: HTTP ${response.statusCode}');
    }
  }
}
