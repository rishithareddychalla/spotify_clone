import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone/api_services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/shared_utils.dart';

class LoginState {
  final bool isLoading;
  final String? token;
  final String errorMessage;

  LoginState({this.isLoading = false, this.token, this.errorMessage = ''});

  LoginState copyWith({bool? isLoading, String? token, String? errorMessage}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  final ApiService _apiService;

  LoginNotifier(this._apiService) : super(LoginState());

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: '', token: null);

    try {
      final token = await _apiService.login(username, password);
      state = state.copyWith(isLoading: false, token: token, errorMessage: '');
      log('Login successful, token: $token');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        token: null,
        errorMessage: e.toString(),
      );
      log('Login failed: $e');
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      await SharedPreferencesUtil.clearPreferences();
      state = state.copyWith(isLoading: false, token: null, errorMessage: '');
      log('Logout successful');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to logout: $e',
      );
      log('Logout failed: $e');
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ApiService());
});
