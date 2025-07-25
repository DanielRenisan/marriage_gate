// Updated SignUp ViewModel
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

class SignupState {
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String password;
  final String confirmPassword;
  final String? error;
  final bool isLoading;
  final Map<String, String?> fieldErrors;
  final bool isSignupSuccessful;

  SignupState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.mobile = '',
    this.password = '',
    this.confirmPassword = '',
    this.error,
    this.isLoading = false,
    this.fieldErrors = const {},
    this.isSignupSuccessful = false,
  });

  SignupState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? password,
    String? confirmPassword,
    String? error,
    bool? isLoading,
    Map<String, String?>? fieldErrors,
    bool? isSignupSuccessful,
  }) {
    return SignupState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      error: error,
      isLoading: isLoading ?? this.isLoading,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      isSignupSuccessful: isSignupSuccessful ?? this.isSignupSuccessful,
    );
  }
}

class SignupViewModel extends StateNotifier<SignupState> {
  final AuthRepository _authRepository;
  BuildContext? _context;

  SignupViewModel(this._authRepository, [this._context]) : super(SignupState());

  // Method to set context after initialization
  void setContext(BuildContext context) {
    _context = context;
  }

  void setFirstName(String value) {
    state = state.copyWith(
      firstName: value,
      error: null,
      fieldErrors: _removeFieldError('firstName'),
    );
  }

  void setLastName(String value) {
    state = state.copyWith(
      lastName: value,
      error: null,
      fieldErrors: _removeFieldError('lastName'),
    );
  }

  void setEmail(String value) {
    state = state.copyWith(
      email: value,
      error: null,
      fieldErrors: _removeFieldError('email'),
    );
  }

  void setMobile(String value) {
    state = state.copyWith(
      mobile: value,
      error: null,
      fieldErrors: _removeFieldError('mobile'),
    );
  }

  void setPassword(String value) {
    state = state.copyWith(
      password: value,
      error: null,
      fieldErrors: _removeFieldError('password'),
    );
  }

  void setConfirmPassword(String value) {
    state = state.copyWith(
      confirmPassword: value,
      error: null,
      fieldErrors: _removeFieldError('confirmPassword'),
    );
  }

  Future<void> signInWithGoogle() async {
    if (_context == null) return;
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _authRepository.signInWithGoogle();
      state = state.copyWith(isLoading: false, isSignupSuccessful: true);

      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text('Signed in with Google successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(Duration(seconds: 2), () {
        GoRouter.of(_context!).go('/profile');
      });
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text('Google sign-in failed: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Map<String, String?> _removeFieldError(String fieldName) {
    final newFieldErrors = Map<String, String?>.from(state.fieldErrors);
    newFieldErrors.remove(fieldName);
    return newFieldErrors;
  }

  Map<String, String?> _setFieldError(String fieldName, String error) {
    final newFieldErrors = Map<String, String?>.from(state.fieldErrors);
    newFieldErrors[fieldName] = error;
    return newFieldErrors;
  }

  bool validateFields() {
    Map<String, String?> errors = {};
    bool isValid = true;

    // First Name validation
    if (state.firstName.trim().isEmpty) {
      errors['firstName'] = "First name is required";
      isValid = false;
    } else if (state.firstName.trim().length < 2) {
      errors['firstName'] = "First name must be at least 2 characters";
      isValid = false;
    }

    // Last Name validation
    if (state.lastName.trim().isEmpty) {
      errors['lastName'] = "Last name is required";
      isValid = false;
    } else if (state.lastName.trim().length < 2) {
      errors['lastName'] = "Last name must be at least 2 characters";
      isValid = false;
    }

    // Email validation
    if (state.email.trim().isEmpty) {
      errors['email'] = "Email is required";
      isValid = false;
    } else if (!_isValidEmail(state.email.trim())) {
      errors['email'] = "Enter a valid email address";
      isValid = false;
    }

    // Mobile validation
    if (state.mobile.trim().isEmpty) {
      errors['mobile'] = "Mobile number is required";
      isValid = false;
    } else if (!_isValidMobile(state.mobile.trim())) {
      errors['mobile'] = "Enter a valid mobile number";
      isValid = false;
    }

    // Password validation
    if (state.password.isEmpty) {
      errors['password'] = "Password is required";
      isValid = false;
    } else if (state.password.length < 8 || state.password.length > 12) {
      errors['password'] = "Password must be 8 to 12 characters long";
      isValid = false;
    } else if (!_isStrongPassword(state.password)) {
      errors['password'] =
          "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character";
      isValid = false;
    }

    // Confirm Password validation
    if (state.confirmPassword.isEmpty) {
      errors['confirmPassword'] = "Please confirm your password";
      isValid = false;
    } else if (state.confirmPassword != state.password) {
      errors['confirmPassword'] = "Passwords do not match";
      isValid = false;
    }

    if (!isValid) {
      state = state.copyWith(
        fieldErrors: errors,
        error: "Please fix the errors above",
      );
    } else {
      state = state.copyWith(
        fieldErrors: {},
        error: null,
      );
    }

    return isValid;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidMobile(String mobile) {
    // Remove all non-digit characters for validation
    final cleanMobile = mobile.replaceAll(RegExp(r'[^\d]'), '');
    // Check if it has 10-15 digits (international format consideration)
    final mobileRegex = RegExp(r'^\d{10,15}$');
    return mobileRegex.hasMatch(cleanMobile);
  }

  bool _isStrongPassword(String password) {
    // Check length (8 to 12 characters)
    if (password.length < 8 || password.length > 12) {
      return false;
    }

    // Check for at least one uppercase letter
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);

    // Check for at least one lowercase letter
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);

    // Check for at least one number
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);

    // Check for at least one special character
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    return hasUppercase && hasLowercase && hasNumber && hasSpecialChar;
  }

  Future<void> submit() async {
    print("Submit method called");
    if (!validateFields()) {
      print("Validation failed");
      return;
    }

    try {
      print("Starting signup process");
      state = state.copyWith(isLoading: true, error: null);

      // Format mobile number with country code if not already formatted
      String formattedMobile = state.mobile.trim();
      if (!formattedMobile.startsWith('+')) {
        // Default to Sri Lanka country code if not specified
        formattedMobile =
            '+94${formattedMobile.startsWith('0') ? formattedMobile.substring(1) : formattedMobile}';
      }

      print("Calling signup API with data:");
      print("First Name: ${state.firstName.trim()}");
      print("Last Name: ${state.lastName.trim()}");
      print("Email: ${state.email.trim()}");
      print("Mobile: $formattedMobile");

      // Call the actual signup method from the repository
      await _authRepository.signUp(
        firstName: state.firstName.trim(),
        lastName: state.lastName.trim(),
        email: state.email.trim(),
        mobile: formattedMobile,
        password: state.password,
      );

      // Update state to indicate successful signup
      state = state.copyWith(
        isLoading: false,
        isSignupSuccessful: true,
      );

      // Show success message and navigate to profile screen if context is available
      if (_context != null) {
        // Show success snackbar
        ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to profile screen after a short delay
        Future.delayed(Duration(seconds: 2), () {
          GoRouter.of(_context!).go('/profile');
        });
      }
    } catch (error) {
      // Handle specific API error messages
      String errorMessage = error.toString();

      // Extract more user-friendly error message if possible
      if (errorMessage.contains('email-already-in-use') ||
          errorMessage.contains('email already exists')) {
        errorMessage =
            'This email is already registered. Please use a different email or try logging in.';
      } else if (errorMessage.contains('weak-password')) {
        errorMessage = 'Please choose a stronger password.';
      } else if (errorMessage.contains('invalid-email')) {
        errorMessage = 'Please enter a valid email address.';
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
    }
  }

  void clearErrors() {
    state = state.copyWith(error: null, fieldErrors: {});
  }

  void reset() {
    state = SignupState();
  }
}

// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

// Provider for SignupViewModel with AuthRepository dependency
final signupViewModelProvider =
    StateNotifierProvider<SignupViewModel, SignupState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignupViewModel(authRepository);
});
