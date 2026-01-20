import 'package:flutter/material.dart';

class AppUser {
  final String uid;
  final String email;
  final String role;
  final String username;
  final String userImage;

  const AppUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.username,
    required this.userImage,
  });
}

class UserProvider extends ChangeNotifier {
  AppUser? _user;

  AppUser? get getUser => _user;

  void setUser(AppUser user) {
    _user = user;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    // Stubbed login: accept admin@example.com / admin123 as admin.
    if (email.toLowerCase() == 'admin@example.com' && password == 'admin123') {
      _user = const AppUser(
        uid: 'admin-uid',
        email: 'admin@example.com',
        role: 'admin',
        username: 'Admin User',
        userImage: '',
      );
      notifyListeners();
      return null;
    }
    return 'Invalid admin credentials';
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }
}

