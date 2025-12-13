import 'dart:convert';
import 'package:http/http.dart' as http;

class MpesaService {
  final String baseUrl;

  MpesaService({required this.baseUrl});

  Future<Map<String, dynamic>> initiateSTKPush({
    required String phoneNumber,
    required int amount,
    required String accountReference,
    required String transactionDesc,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/mpesa/stk-push'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': phoneNumber,
          'amount': amount,
          'accountReference': accountReference,
          'transactionDesc': transactionDesc,
        }),
      );

      final data = json.decode(response.body);
      return data;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> queryTransaction(String checkoutRequestId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/mpesa/query'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'checkoutRequestId': checkoutRequestId}),
      );

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
