# 💳 M-Pesa Integration Guide

This guide shows how to integrate M-Pesa payments using the Daraja API into your Services Marketplace app.

## 🔑 Prerequisites

1. **M-Pesa Account** - Business or Till Number from Safaricom
2. **Daraja API Credentials**:
   - Consumer Key
   - Consumer Secret
   - Business Short Code
   - Online Passkey
3. **Backend Server** - For secure token generation
4. **Callback URL** - For payment confirmations

## 📋 Step 1: Get Daraja API Credentials

### From Safaricom:
1. Visit [developer.safaricom.co.ke](https://developer.safaricom.co.ke)
2. Sign in/create account
3. Add new app under "My Apps"
4. Get:
   - **Consumer Key**
   - **Consumer Secret**
   - **Business Short Code** (for STK Push)
   - **Online Passkey** (Generate in Sandbox)

### Save Credentials:
Create `.env` file in project root:
```
MPESA_CONSUMER_KEY=your_consumer_key
MPESA_CONSUMER_SECRET=your_consumer_secret
MPESA_BUSINESS_SHORT_CODE=your_short_code
MPESA_PASSKEY=your_passkey
MPESA_CALLBACK_URL=https://your-backend.com/mpesa-callback
```

## 🛠 Step 2: Backend Setup (Node.js/Dart)

### Create M-Pesa Service (Dart Backend):

```dart
// backend/services/mpesa_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class MpesaService {
  final String consumerKey;
  final String consumerSecret;
  final String businessShortCode;
  final String passkey;
  
  MpesaService({
    required this.consumerKey,
    required this.consumerSecret,
    required this.businessShortCode,
    required this.passkey,
  });

  // Get access token
  Future<String> getAccessToken() async {
    final url = Uri.parse('https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials');
    
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    }
    throw Exception('Failed to get access token: ${response.body}');
  }

  // Initiate STK Push
  Future<Map<String, dynamic>> initiateSTKPush({
    required String phoneNumber,
    required double amount,
    required String orderId,
    required String description,
  }) async {
    final token = await getAccessToken();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Generate password
    final dataString = '$businessShortCode$passkey$timestamp';
    final password = base64Encode(utf8.encode(dataString));

    final url = Uri.parse('https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest');
    
    final body = {
      'BusinessShortCode': businessShortCode,
      'Password': password,
      'Timestamp': timestamp,
      'TransactionType': 'CustomerPayBillOnline',
      'Amount': amount.toStringAsFixed(0),
      'PartyA': phoneNumber,
      'PartyB': businessShortCode,
      'PhoneNumber': phoneNumber,
      'CallBackURL': 'https://your-backend.com/mpesa-callback',
      'AccountReference': orderId,
      'TransactionDesc': description,
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to initiate STK Push: ${response.body}');
  }

  // Query payment status
  Future<Map<String, dynamic>> queryPaymentStatus({
    required String checkoutRequestId,
  }) async {
    final token = await getAccessToken();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    
    final dataString = '$businessShortCode$passkey$timestamp';
    final password = base64Encode(utf8.encode(dataString));

    final url = Uri.parse('https://sandbox.safaricom.co.ke/mpesa/stkpushquery/v1/query');
    
    final body = {
      'BusinessShortCode': businessShortCode,
      'Password': password,
      'Timestamp': timestamp,
      'CheckoutRequestID': checkoutRequestId,
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to query payment status: ${response.body}');
  }
}
```

### Create Callback Endpoint (Node.js):

```javascript
// backend/routes/mpesa-callback.js
const express = require('express');
const admin = require('firebase-admin');
const router = express.Router();

router.post('/mpesa-callback', async (req, res) => {
  try {
    const data = req.body.Body.stkCallback;
    const resultCode = data.ResultCode;
    const resultDesc = data.ResultDesc;
    const checkoutRequestId = data.CheckoutRequestId;
    const merchantRequestId = data.MerchantRequestID;
    
    // Get metadata
    const callbackMetadata = data.CallbackMetadata.Item;
    let amount, mpesaReceiptNumber, transactionDate, phoneNumber;
    
    callbackMetadata.forEach(item => {
      if (item.Name === 'Amount') amount = item.Value;
      if (item.Name === 'MpesaReceiptNumber') mpesaReceiptNumber = item.Value;
      if (item.Name === 'TransactionDate') transactionDate = item.Value;
      if (item.Name === 'PhoneNumber') phoneNumber = item.Value;
    });

    // Update booking in Firestore
    if (resultCode === 0) { // Success
      const bookingId = req.body.Body.stk_push_plus_data.orderId;
      
      await admin.firestore().collection('bookings').doc(bookingId).update({
        paymentStatus: 'completed',
        paymentId: mpesaReceiptNumber,
        status: 'accepted',
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log(`✅ Payment successful for booking ${bookingId}`);
    } else {
      console.log(`❌ Payment failed: ${resultDesc}`);
    }

    // Must return 200 to acknowledge receipt
    res.json({ ResultCode: 0 });
  } catch (error) {
    console.error('Callback error:', error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
```

## 📱 Step 3: Frontend Implementation

### Update Payment Screen:

```dart
// lib/screens/marketplace/payment_screen.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

// In _PaymentScreenState class:

final String _backendUrl = 'https://your-backend.com'; // Update this

Future<void> _initiateMpesaPayment() async {
  if (_phoneController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Enter phone number')),
    );
    return;
  }

  setState(() => _isProcessing = true);

  try {
    // Call backend to initiate STK Push
    final response = await http.post(
      Uri.parse('$_backendUrl/api/mpesa/initiate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phoneNumber': _phoneController.text,
        'amount': widget.amount.toStringAsFixed(0),
        'orderId': 'booking_${DateTime.now().millisecondsSinceEpoch}',
        'description': 'Services Marketplace Payment',
      }),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('STK Push sent! Enter PIN on your phone'),
          duration: Duration(seconds: 3),
        ),
      );

      // Start polling for payment status
      _pollPaymentStatus(data['checkoutRequestId']);
    } else {
      throw Exception('Failed to initiate payment: ${response.body}');
    }
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  } finally {
    setState(() => _isProcessing = false);
  }
}

Future<void> _pollPaymentStatus(String checkoutRequestId) async {
  int attempts = 0;
  const maxAttempts = 60; // 5 minutes (every 5 seconds)
  
  while (attempts < maxAttempts) {
    await Future.delayed(const Duration(seconds: 5));
    
    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/api/mpesa/query'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'checkoutRequestId': checkoutRequestId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['ResultCode'] == '0') {
          // Payment successful!
          if (!mounted) return;
          _showPaymentSuccess(data);
          return;
        } else if (data['ResultCode'] != '1031') {
          // 1031 = Still pending
          if (!mounted) return;
          _showPaymentFailed(data['ResultDesc']);
          return;
        }
      }
      attempts++;
    } catch (e) {
      print('Poll error: $e');
      attempts++;
    }
  }
  
  if (mounted) {
    _showPaymentFailed('Payment request timed out');
  }
}

void _showPaymentSuccess(Map<String, dynamic> data) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.darkCard,
      title: const Text('✅ Payment Successful'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amount: \$${widget.amount.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          Text('Receipt: ${data['mpesaReceiptNumber']}'),
          const SizedBox(height: 8),
          Text('Date: ${data['transactionDate']}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void _showPaymentFailed(String reason) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.darkCard,
      title: const Text('❌ Payment Failed'),
      content: Text('Reason: $reason'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}
```

## 🔒 Security Considerations

1. **Never commit credentials** - Use environment variables
2. **Use HTTPS only** - All API calls must be encrypted
3. **Validate callbacks** - Verify signature in callback handler
4. **Rate limiting** - Implement to prevent abuse
5. **Error logging** - Log payment errors for debugging
6. **PCI Compliance** - Don't store card details

## 🧪 Testing

### In Sandbox:
- Use test phone number: `254708374149`
- Test PIN: `12345`
- Amount: Any amount (will be reversed)

### Configuration for Production:
1. Change URLs from `sandbox.safaricom.co.ke` to `api.safaricom.co.ke`
2. Use production credentials
3. Update callback URLs
4. Enable HTTPS
5. Test thoroughly before going live

## 📚 Useful Links

- [Safaricom Daraja API Docs](https://developer.safaricom.co.ke/apis)
- [M-Pesa STK Push Guide](https://developer.safaricom.co.ke/apis/stkpush)
- [M-Pesa Query Status](https://developer.safaricom.co.ke/apis/stkquery)
- [Callback Handler Setup](https://developer.safaricom.co.ke/APIs/MpesaIntegration)

## 🚀 Next Steps

1. Get Daraja credentials from Safaricom
2. Deploy backend with callback endpoint
3. Update `_backendUrl` in payment screen
4. Test with sandbox credentials
5. Deploy to production when ready

---

**Questions?** Refer to the official Safaricom Daraja API documentation or contact Safaricom Developer Support.
