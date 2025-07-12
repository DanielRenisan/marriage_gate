import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_provider.dart' as auth;

class LoginViewModel {
  final String email;
  final String password;
  final bool showPassword;
  final bool isLoading;
  final String? emailError;
  final String? passwordError;
  final String? errorMessage;

  const LoginViewModel({
    this.email = '',
    this.password = '',
    this.showPassword = false,
    this.isLoading = false,
    this.emailError,
    this.passwordError,
    this.errorMessage,
  });

  LoginViewModel copyWith({
    String? email,
    String? password,
    bool? showPassword,
    bool? isLoading,
    String? emailError,
    String? passwordError,
    String? errorMessage,
  }) {
    return LoginViewModel(
      email: email ?? this.email,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
      isLoading: isLoading ?? this.isLoading,
      emailError: emailError,
      passwordError: passwordError,
      errorMessage: errorMessage,
    );
  }
}

class LoginViewModelNotifier extends StateNotifier<LoginViewModel> {
  final Ref ref;
  LoginViewModelNotifier(this.ref) : super(const LoginViewModel());

  void onEmailChanged(String value) {
    state = state.copyWith(email: value, emailError: null, errorMessage: null);
  }

  void onPasswordChanged(String value) {
    state = state.copyWith(password: value, passwordError: null, errorMessage: null);
  }

  void toggleShowPassword() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  Future<void> onLogin() async {
    if (state.email.isEmpty || !state.email.contains('@')) {
      state = state.copyWith(emailError: 'Enter a valid email');
      return;
    }
    if (state.password.length < 6) {
      state = state.copyWith(passwordError: 'Password too short');
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // For demo: always succeed and navigate
      await Future.delayed(const Duration(milliseconds: 500));
      ref.read(auth.authProvider.notifier).state = AuthState.authenticated;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Login failed: ${e.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void onForgotPassword() {
    state = state.copyWith(errorMessage: 'Forgot password not implemented');
  }
}

final loginViewModelProvider = StateNotifierProvider<LoginViewModelNotifier, LoginViewModel>((ref) {
  return LoginViewModelNotifier(ref);
}); 