import 'dart:convert';
import 'package:demo/Model/employee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _lastEmployeeKey = 'last_opened_employee';

  Future<void> saveLastEmployee(Employee employee) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final employeeJson = json.encode(employee.toJson());
      await prefs.setString(_lastEmployeeKey, employeeJson);
    } catch (e) {
      print('Error saving last employee: $e');
    }
  }

  Future<Employee?> getLastEmployee() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final employeeJson = prefs.getString(_lastEmployeeKey);
      
      if (employeeJson != null) {
        final Map<String, dynamic> json = jsonDecode(employeeJson);
        return Employee.fromJson(json);
      }
      return null;
    } catch (e) {
      print('Error getting last employee: $e');
      return null;
    }
  }

  Future<void> clearLastEmployee() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastEmployeeKey);
    } catch (e) {
      print('Error clearing last employee: $e');
    }
  }
}