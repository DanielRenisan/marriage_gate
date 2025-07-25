import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:marriage_gate/presentation/widgets/customer_appbar.dart';
import 'package:marriage_gate/core/constants/app_colors.dart';
import 'package:marriage_gate/presentation/widgets/bottom_button.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/image_assets.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';
import '../../data/models/api_response.dart';
import '../widgets/error_popup.dart';

class SignUpScreenNew extends StatefulWidget {
  const SignUpScreenNew({super.key});

  @override
  State<SignUpScreenNew> createState() => _SignUpScreenNewState();
}

class _SignUpScreenNewState extends State<SignUpScreenNew> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State variables
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validation methods
  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name is required';
    } else if (value.length < 2) {
      return 'First name must be at least 2 characters';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name is required';
    } else if (value.length < 2) {
      return 'Last name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }

    final cleanMobile = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanMobile.length < 10 || cleanMobile.length > 15) {
      return 'Enter a valid mobile number';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8 || value.length > 12) {
      return 'Password must be 8 to 12 characters long';
    }

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
    final hasNumber = RegExp(r'[0-9]').hasMatch(value);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    if (!hasUppercase || !hasLowercase || !hasNumber || !hasSpecialChar) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Submit form
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print("Submitting signup form");

      // Format mobile number with country code if not already formatted
      String formattedMobile = _mobileController.text.trim();
      if (!formattedMobile.startsWith('+')) {
        formattedMobile =
            '+94${formattedMobile.startsWith('0') ? formattedMobile.substring(1) : formattedMobile}';
      }

      // Create API client
      final apiClient = ApiClient();

      // Prepare request data
      final data = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'loginType': ApiConstants.loginTypeEmail,
        'phoneNumber': formattedMobile,
      };

      print("Sending signup request with data: $data");
      print("API endpoint: ${ApiConstants.baseUrl}${ApiConstants.register}");

      // Make API request
      final response = await apiClient.post(ApiConstants.register, data: data);

      print("Signup response: $response");

      // Check if there was an error
      if (response.isError) {
        print("Error in response: ${response.error?.detail}");

        setState(() {
          _isLoading = false;
          _errorMessage = response.error?.detail;
        });

        // Show error popup
        ErrorPopup.show(
          context,
          response.error ??
              ApiError(
                title: 'Error',
                detail: 'An error occurred during signup',
                statusCode: 400,
              ),
        );

        return;
      }

      // Handle success
      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to profile screen
      Future.delayed(Duration(seconds: 2), () {
        GoRouter.of(context).go('/profile');
      });
    } catch (error) {
      print("Error during signup: $error");

      // Handle error
      String errorMessage = error.toString();
      ApiError apiError;

      // Extract more user-friendly error message if possible
      if (errorMessage.contains('email-already-in-use') ||
          errorMessage.contains('email already exists')) {
        errorMessage =
            'This email is already registered. Please use a different email or try logging in.';
        apiError = ApiError(
          title: 'Registration Error',
          detail: errorMessage,
          statusCode: 400,
        );
      } else if (errorMessage.contains('weak-password')) {
        errorMessage = 'Please choose a stronger password.';
        apiError = ApiError(
          title: 'Invalid Password',
          detail:
              'Password must be 8 to 12 characters long, contain at least one uppercase letter, one number, and one special character.',
          statusCode: 400,
        );
      } else if (errorMessage.contains('invalid-email')) {
        errorMessage = 'Please enter a valid email address.';
        apiError = ApiError(
          title: 'Invalid Email',
          detail: errorMessage,
          statusCode: 400,
        );
      } else {
        apiError = ApiError(
          title: 'Error',
          detail: errorMessage,
          statusCode: 500,
        );
      }

      setState(() {
        _isLoading = false;
        _errorMessage = errorMessage;
      });

      // Show error popup
      ErrorPopup.show(context, apiError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomerAppBar(title: 'Sign Up'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                child: Lottie.asset(
                  JsonAssets.SIGN_UP,
                  height: 260,
                  fit: BoxFit.contain,
                ),
              ),

              // First Name Field
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: _validateFirstName,
              ),
              const SizedBox(height: 16),

              // Last Name Field
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: _validateLastName,
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),

              // Mobile Field
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: _validateMobile,
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 24),

              // Error Display
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: AppColors.error, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: BottomButton(
          text: 'Sign Up',
          onPressed: _isLoading ? () {} : _submit,
          backgroundColor: AppColors.primary,
          textColor: AppColors.white,
          borderRadius: 32,
          margin: EdgeInsets.zero,
        ),
      ),
    );
  }
}
