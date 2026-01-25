import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../shared/models/user_model.dart';

final class AuthCore {
  static final AuthCore _instance = AuthCore._internal();

  factory AuthCore() => _instance;

  AuthCore._internal();

  // Keys for SharedPreferences
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  // Stream controllers for reactive state management
  final _authStateController = StreamController<bool>.broadcast();
  final _userStateController = StreamController<UserModel?>.broadcast();

  UserModel? _currentUser;
  String? _authToken;

  /// Stream of authentication state changes
  /// Emits true when user is authenticated, false otherwise
  Stream<bool> authChanges() {
    return _authStateController.stream;
  }

  /// Stream of user data changes
  /// Emits UserModel when user is logged in, null when logged out
  Stream<UserModel?> userChanges() {
    return _userStateController.stream;
  }

  /// Initialize auth state from storage
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    // Load token
    _authToken = prefs.getString(_tokenKey);

    // Load user data
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        _currentUser = UserModel.fromJson(jsonDecode(userJson));
      } catch (e) {
        // Clear invalid data
        await _clearStorage();
      }
    }

    // Emit initial state
    _authStateController.add(_authToken != null);
    _userStateController.add(_currentUser);
  }

  /// Set the current authenticated user and token
  Future<void> setUser(UserModel user, String token) async {
    _currentUser = user;
    _authToken = token;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setString(_tokenKey, token);

    _authStateController.add(true);
    _userStateController.add(user);
  }

  /// Logout the current user and clear stored data
  Future<void> logout() async {
    await _clearStorage();

    _currentUser = null;
    _authToken = null;

    _authStateController.add(false);
    _userStateController.add(null);
  }

  /// Get the current authenticated user
  Future<UserModel?> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    // Try to load from storage
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson != null) {
      try {
        _currentUser = UserModel.fromJson(jsonDecode(userJson));
        return _currentUser;
      } catch (e) {
        await _clearStorage();
      }
    }

    return null;
  }

  /// Get the current auth token
  Future<String?> getToken() async {
    if (_authToken != null) {
      return _authToken;
    }

    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(_tokenKey);
    return _authToken;
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await getToken() != null;
  }

  /// Clear all stored authentication data
  Future<void> _clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  /// Dispose stream controllers
  void dispose() {
    _authStateController.close();
    _userStateController.close();
  }
}
