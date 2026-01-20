import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProvider extends ChangeNotifier {
  int totalProducts = 0;
  int totalOrders = 0;
  int totalUsers = 0;
  double totalRevenue = 0.0;

  Future<void> fetchDashboardData() async {
    // Stubbed totals; replace with Firestore queries as needed.
    totalProducts = 24;
    totalOrders = 312;
    totalUsers = 1280;
    totalRevenue = 48230.75;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchRecentOrders({int limit = 5}) async {
    return List.generate(limit, (i) {
      return {
        'orderId': 'ORD-${1000 + i}',
        'totalPrice': 49.99 + i,
        'customerName': 'Customer ${i + 1}',
        'customerEmail': 'user${i + 1}@mail.com',
        'shippingAddress': '123 Main St, City',
        'status': 'Completed',
      };
    });
  }

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    return List.generate(12, (i) {
      return {
        'username': 'User ${i + 1}',
        'email': 'user${i + 1}@mail.com',
        'role': i % 4 == 0 ? 'admin' : 'user',
        'userImage': '',
      };
    });
  }
}

