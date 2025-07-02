import 'package:demo/Model/employee.dart';
import 'package:demo/Services/Api_service.dart';
import 'package:demo/Services/Store_service.dart';
import 'package:get/get.dart';


class EmployeeController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // Observable variables
  final RxList<Employee> employees = <Employee>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;
  final Rx<Employee?> lastOpenedEmployee = Rx<Employee?>(null);

  // Pagination constants
  static const int itemsPerPage = 10;

  @override
  void onInit() {
    super.onInit();
    loadLastOpenedEmployee();
    loadEmployees();
  }

  Future<void> loadLastOpenedEmployee() async {
    try {
      final employee = await _storageService.getLastEmployee();
      lastOpenedEmployee.value = employee;
     
    } catch (e) {
      print('Error loading last opened employee: $e');
    }
  }

  Future<void> loadEmployees({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      employees.clear();
      errorMessage.value = '';
    }

    if (isLoading.value || isLoadingMore.value) return;

    if (refresh || employees.isEmpty) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final newEmployees = await _apiService.getEmployees(
        page: currentPage.value,
        limit: itemsPerPage,
      );

      if (newEmployees.isEmpty) {
        hasMoreData.value = false;
      } else {
        if (refresh) {
          employees.assignAll(newEmployees);
        } else {
          employees.addAll(newEmployees);
        }
        currentPage.value++;
      }

      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = _getErrorMessage(e);
      
      // If it's the first load and fails, show empty state
      if (employees.isEmpty) {
        hasMoreData.value = false;
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshEmployees() async {
    await loadEmployees(refresh: true);
  }

  Future<void> loadMoreEmployees() async {
    if (hasMoreData.value && !isLoadingMore.value) {
      await loadEmployees();
    }
  }

  Future<void> selectEmployee(Employee employee) async {
    try {
      await _storageService.saveLastEmployee(employee);
      lastOpenedEmployee.value = employee;
      Get.toNamed('/details', arguments: employee);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save employee selection',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  List<Employee> get displayEmployees {
    final List<Employee> displayList = [];
    
    // Add last opened employee at the top if available and not already in the list
    if (lastOpenedEmployee.value != null) {
      displayList.add(lastOpenedEmployee.value!);
    }
    
    // Add other employees, excluding the last opened one to avoid duplicates
    for (final employee in employees) {
      if (lastOpenedEmployee.value == null || employee.id != lastOpenedEmployee.value!.id) {
        displayList.add(employee);
      }
    }
    
    return displayList;
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('No internet connection')) {
      return 'No internet connection. Please check your network and try again.';
    } else if (error.toString().contains('Failed to load employees')) {
      return 'Failed to load employees. Please try again later.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  void clearError() {
    errorMessage.value = '';
  }
}