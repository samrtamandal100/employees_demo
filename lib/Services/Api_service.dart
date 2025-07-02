import 'dart:convert';
import 'dart:io';
import 'package:demo/Model/employee.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://fake-json-api.mock.beeceptor.com';
  static const Duration timeoutDuration = Duration(seconds: 10);

  Future<List<Employee>> getEmployees({int page = 1, int limit = 10}) async {
    try {
      final url = '$baseUrl/users?_page=$page&_limit=$limit';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Employee.fromJson(json)).toList();
      } else {
        throw HttpException(
          'Failed to load employees. Status code: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw const SocketException('No internet connection');
    } on HttpException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch employees: $e');
    }
  }
}