import 'package:flutter/material.dart';
import 'package:cryptex_trading/constants/app_colors.dart';
import 'package:cryptex_trading/services/mpesa_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _phoneController = TextEditingController(text: '0793027220');
  final _amountController = TextEditingController(text: '100');
  bool _isLoading = false;
  String? _statusMessage;
  late final MpesaService _mpesaService;

  @override
  void initState() {
    super.initState();
    final baseUrl = kIsWeb ? html.window.location.origin : 'http://localhost:5000';
    _mpesaService = MpesaService(baseUrl: baseUrl);
  }

  Future<void> _initiatePayment() async {
    if (_phoneController.text.isEmpty || _amountController.text.isEmpty) {
      setState(() => _statusMessage = 'Please fill all fields');
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      final result = await _mpesaService.initiateSTKPush(
        phoneNumber: _phoneController.text,
        amount: int.tryParse(_amountController.text) ?? 100,
        accountReference: 'CrypTex',
        transactionDesc: 'Deposit',
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _statusMessage = result['success'] == true
              ? 'STK Push sent! Please check your phone and enter your M-Pesa PIN.'
              : result['message'] ?? 'Payment initiation failed';
        });

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Check your phone for the M-Pesa prompt'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _statusMessage = 'Error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        title: const Text('M-Pesa Payment', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00A86B), Color(0xFF00875A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.phone_android, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('M-Pesa', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Lipa Na M-Pesa', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Phone Number', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: '07XXXXXXXX',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('+254', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                filled: true,
                fillColor: AppColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Amount (KES)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('KES', style: TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                filled: true,
                fillColor: AppColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [100, 500, 1000, 5000].map((amount) => 
                GestureDetector(
                  onTap: () => _amountController.text = amount.toString(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Text('KES $amount', style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ).toList(),
            ),
            const SizedBox(height: 32),
            if (_statusMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(_statusMessage!, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _initiatePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A86B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Pay with M-Pesa',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('How it works:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildStep('1', 'Enter your M-Pesa registered phone number'),
                  _buildStep('2', 'Enter the amount you want to deposit'),
                  _buildStep('3', 'Click "Pay with M-Pesa"'),
                  _buildStep('4', 'Check your phone for the STK push prompt'),
                  _buildStep('5', 'Enter your M-Pesa PIN to complete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(number, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
