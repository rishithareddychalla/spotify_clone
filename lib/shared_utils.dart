import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static SharedPreferences? _prefs;

  // Ensures the instance is initialized
  static Future<SharedPreferences> get _instance async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    log('SharedPreferences initialized');
    return _prefs!;
  }

  // Initialize manually (optional if using _instance getter fallback)
  static Future<void> init() async {
    log('🔹 Initializing SharedPreferences...');
    _prefs = await SharedPreferences.getInstance();
    log(
      _prefs == null
          ? '❌ SharedPreferences failed to initialize!'
          : '✅ SharedPreferences initialized successfully!',
    );
  }

  // Set a string
  static Future<bool> setString(String key, String value) async {
    final prefs = await _instance;
    log('Setting $key: $value');
    return prefs.setString(key, value);
  }

  // Get a string
  static Future<String> getString(String key) async {
    final prefs = await _instance;
    final value = prefs.getString(key) ?? "";
    log('Retrieved $key: $value');
    return value;
  }

  // Remove a value
  static Future<void> removeValue(String key) async {
    final prefs = await _instance;
    log('Removing $key');
    await prefs.remove(key);
  }

  // Clear all preferences
  static Future<void> clearPreferences() async {
    final prefs = await _instance;
    log('Clearing all preferences');
    await prefs.clear();
  }

  // Save auth token
  static Future<void> saveAuthToken(String token) async {
    log('Saving Auth Token: $token');
    await setString('auth_token', token);
    final savedToken = await getString('auth_token');
    log('Verified Saved Auth Token: $savedToken');
  }

  // Retrieve auth token
  static Future<String?> getAuthToken() async {
    String token = await getString('auth_token');
    log('Retrieved Auth Token: $token');
    return token.isNotEmpty ? token : null;
  }
}
