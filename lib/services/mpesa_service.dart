import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class MpesaService {
  final String consumerKey;
  final String consumerSecret;
  final String passKey;
  final String shortCode;
  final String callbackUrl;
  final bool isSandbox;

  MpesaService({
    required this.consumerKey,
    required this.consumerSecret,
    required this.passKey,
    this.shortCode = '174379',
    required this.callbackUrl,
    this.isSandbox = true,
  });

  String get baseUrl => isSandbox 
      ? 'https://sandbox.safaricom.co.ke'
      : 'https://api.safaricom.co.ke';

  Future<String?> getAccessToken() async {
    try {
      final auth = base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
      final response = await http.get(
        Uri.parse('$baseUrl/oauth/v1/generate?grant_type=client_credentials'),
        headers: {'Authorization': 'Basic $auth'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['access_token'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String _generateTimestamp() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}'
           '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
  }

  String _generatePassword(String timestamp) {
    final data = '$shortCode$passKey$timestamp';
    return base64Encode(utf8.encode(data));
  }

  Future<Map<String, dynamic>> initiateSTKPush({
    required String phoneNumber,
    required int amount,
    required String accountReference,
    required String transactionDesc,
  }) async {
    try {
      final token = await getAccessToken();
      if (token == null) {
        return {'success': false, 'message': 'Failed to get access token'};
      }

      final timestamp = _generateTimestamp();
      final password = _generatePassword(timestamp);

      String formattedPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      if (formattedPhone.startsWith('0')) {
        formattedPhone = '254${formattedPhone.substring(1)}';
      } else if (!formattedPhone.startsWith('254')) {
        formattedPhone = '254$formattedPhone';
      }

      final response = await http.post(
        Uri.parse('$baseUrl/mpesa/stkpush/v1/processrequest'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'BusinessShortCode': shortCode,
          'Password': password,
          'Timestamp': timestamp,
          'TransactionType': 'CustomerPayBillOnline',
          'Amount': amount,
          'PartyA': formattedPhone,
          'PartyB': shortCode,
          'PhoneNumber': formattedPhone,
          'CallBackURL': callbackUrl,
          'AccountReference': accountReference,
          'TransactionDesc': transactionDesc,
        }),
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['ResponseCode'] == '0') {
        return {
          'success': true,
          'message': 'STK Push sent successfully',
          'checkoutRequestId': data['CheckoutRequestID'],
          'merchantRequestId': data['MerchantRequestID'],
        };
      } else {
        return {
          'success': false,
          'message': data['errorMessage'] ?? data['ResponseDescription'] ?? 'Payment initiation failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> queryTransaction(String checkoutRequestId) async {
    try {
      final token = await getAccessToken();
      if (token == null) {
        return {'success': false, 'message': 'Failed to get access token'};
      }

      final timestamp = _generateTimestamp();
      final password = _generatePassword(timestamp);

      final response = await http.post(
        Uri.parse('$baseUrl/mpesa/stkpushquery/v1/query'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'BusinessShortCode': shortCode,
          'Password': password,
          'Timestamp': timestamp,
          'CheckoutRequestID': checkoutRequestId,
        }),
      );

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
