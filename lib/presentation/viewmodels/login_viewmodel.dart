import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(LoginState());

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  void updateMobile(String value) {
    state = state.copyWith(mobile: value);
  }

  void toggleLoginMethod() {
    state = state.copyWith(
      isEmailLogin: !state.isEmailLogin,
      email: '',
      password: '',
      mobile: '',
    );
  }

  Future<void> login(BuildContext context) async {
    state = state.copyWith(isLoading: true);

    // Simulate login process
    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(isLoading: false);

    // Handle navigation on success
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel();
});

// State
class LoginState {
  final String email;
  final String password;
  final String mobile;
  final bool isEmailLogin;
  final bool isLoading;

  LoginState({
    this.email = '',
    this.password = '',
    this.mobile = '',
    this.isEmailLogin = true,
    this.isLoading = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    String? mobile,
    bool? isEmailLogin,
    bool? isLoading,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      mobile: mobile ?? this.mobile,
      isEmailLogin: isEmailLogin ?? this.isEmailLogin,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
