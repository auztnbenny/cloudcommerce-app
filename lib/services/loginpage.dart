import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  LoginResponse({
    required this.success,
    required this.message,
    this.data,
  });
}

class ApiService {
  static const String baseUrl =
      'http://nwbo1.jubilyhrm.in/WebDataProcessingReact.aspx';

  Future<LoginResponse> login(
      String username, String password, String year, String vehicleNo) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'title': 'UserLogin',
          'ReqUserID': username,
          'ReqPassword': password,
          'ReqAcastart': year,
          'VehicleNo': vehicleNo,
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        // Extract JSON part before HTML
        String jsonPart = response.body.split('||JasonEnd')[0].trim();
        final List<dynamic> parsedData = json.decode(jsonPart);

        if (parsedData.isEmpty) {
          return LoginResponse(success: false, message: 'Invalid response');
        }

        final Map<String, dynamic> data = parsedData[0];
        bool isSuccess =
            data['InfoField1']?.contains('Login Successful') ?? false;

        return LoginResponse(
          success: isSuccess,
          message: data['InfoField1'] ?? 'Unknown response',
          data: data,
        );
      }
      return LoginResponse(
          success: false, message: 'Server error: ${response.statusCode}');
    } catch (e) {
      return LoginResponse(
          success: false, message: 'Connection error: ${e.toString()}');
    }
  }
}
