import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const themeStatus = "THEME_STATUS";
  bool _darkTheme = true;
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  bool get getIsDarkTHeme => _darkTheme;
  bool get isInitialized => _isInitialized;

  ThemeProvider() {
    _initializeAsync();
  }

  void _initializeAsync() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _darkTheme = _prefs.getBool(themeStatus) ?? true;
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error initializing theme: $e');
      _isInitialized = true;
    }
  }

  void setDarkTheme(bool value) {
    if (_darkTheme == value) return; // Prevent unnecessary updates

    _darkTheme = value;
    notifyListeners();

    // Save asynchronously in background (don't await)
    _saveTheme(value);
  }

  Future<void> _saveTheme(bool value) async {
    try {
      if (_isInitialized) {
        await _prefs.setBool(themeStatus, value);
      }
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  Future<bool> getTheme() async {
    if (!_isInitialized) {
      try {
        _prefs = await SharedPreferences.getInstance();
        _darkTheme = _prefs.getBool(themeStatus) ?? true;
        _isInitialized = true;
        notifyListeners();
      } catch (e) {
        print('Error getting theme: $e');
      }
    }
    return _darkTheme;
  }
}
