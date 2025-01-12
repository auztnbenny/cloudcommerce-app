import 'package:http/http.dart' as http;
import 'dart:convert';

class Order {
  final String orderID;
  final String orderNo;
  final String orderDate;
  final String partyName;
  final String userCode;
  final String totAmt;
  final String delDate;
  final String remarks;
  final String accPartyName;
  final String vehicleNo;

  Order({
    required this.orderID,
    required this.orderNo,
    required this.orderDate,
    required this.partyName,
    required this.userCode,
    required this.totAmt,
    required this.delDate,
    required this.remarks,
    required this.accPartyName,
    required this.vehicleNo,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderID: json['OrderID'] ?? '',
      orderNo: json['OrderNo'] ?? '',
      orderDate: json['OrderDate'] ?? '',
      partyName: json['PartyName'] ?? '',
      userCode: json['UserCode'] ?? '',
      totAmt: json['TotAmt'] ?? '0.00',
      delDate: json['DelDate'] ?? '',
      remarks: json['Remarks'] ?? '',
      accPartyName: json['AccPartyName'] ?? '',
      vehicleNo: json['VehicleNo'] ?? '',
    );
  }
}

class Employee {
  final int empAutoId;
  final String empCode;
  final String employeeName;

  Employee({
    required this.empAutoId,
    required this.empCode,
    required this.employeeName,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      empAutoId: json['EMPAUTOID'] ?? 0,
      empCode: json['EMPCODE'] ?? '',
      employeeName: json['EmployeeName'] ?? '',
    );
  }
}

class OrderService {
  static const String baseUrl =
      'http://nwbo1.jubilyhrm.in/WebDataProcessingReact.aspx';

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  Future<List<Order>> fetchOrders(
      DateTime? selectedDate, Employee? selectedEmployee) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'title': 'GetStockOrderMasterListJason',
          'description': 'get date wise order lists',
          'ReqYear':
              selectedDate?.year.toString() ?? DateTime.now().year.toString(),
          'ReqDate': formatDate(selectedDate ?? DateTime.now()),
          'ReqUserID': selectedEmployee?.empCode ?? '',
          'ReqUserTypeID': '',
        },
      );

      if (response.statusCode == 200) {
        final String responseBody = response.body;
        final jsonEnd = responseBody.indexOf('||JasonEnd');
        if (jsonEnd != -1) {
          final jsonData = responseBody.substring(0, jsonEnd);
          final List<dynamic> data = json.decode(jsonData);
          return data.map((json) => Order.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load orders');
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }

  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'title': 'GetEmployeeMasterList',
          'description': 'get employee list',
          'ReqUserID': '',
          'ReqUserTypeID': '',
        },
      );

      if (response.statusCode == 200) {
        final String responseBody = response.body;
        final jsonEnd = responseBody.indexOf('||JasonEnd');
        if (jsonEnd != -1) {
          final jsonData = responseBody.substring(0, jsonEnd);
          final List<dynamic> data = json.decode(jsonData);
          return data.map((json) => Employee.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load employees');
    } catch (e) {
      throw Exception('Error fetching employees: $e');
    }
  }
}
