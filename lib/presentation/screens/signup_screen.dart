// Updated SignUp Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:marriage_gate/presentation/widgets/customer_appbar.dart';
import 'package:marriage_gate/presentation/viewmodels/signup_viewModel.dart';
import 'package:marriage_gate/core/constants/app_colors.dart';
import 'package:marriage_gate/presentation/widgets/bottom_button.dart';
import 'package:marriage_gate/presentation/widgets/common_text_input.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/image_assets.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create a form key for validation
    final formKey = GlobalKey<FormState>();

    // Use the global provider and pass context to it
    final authRepository = ref.watch(authRepositoryProvider);

    // Initialize the view model with context only once
    final viewModel = ref.read(signupViewModelProvider.notifier);

    // Set context for navigation if not already set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setContext(context);
    });

    // Use Consumer to isolate state changes
    final state = ref.watch(signupViewModelProvider);

    return Scaffold(
      appBar: const CustomerAppBar(title: 'Sign Up'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: Form(
          key: formKey,
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
              CommonTextInput(
                labelText: 'First Name',
                inputType: InputType.name,
                onChanged: viewModel.setFirstName,
                prefixIcon: const Icon(Icons.person_outline),
                errorText: state.fieldErrors['firstName'],
              ),
              const SizedBox(height: 10),

              // Last Name Field
              CommonTextInput(
                labelText: 'Last Name',
                inputType: InputType.name,
                onChanged: viewModel.setLastName,
                prefixIcon: const Icon(Icons.person_outline),
                errorText: state.fieldErrors['lastName'],
              ),
              const SizedBox(height: 10),

              // Email Field
              CommonTextInput(
                labelText: 'Email',
                inputType: InputType.email,
                onChanged: viewModel.setEmail,
                prefixIcon: const Icon(Icons.email_outlined),
                errorText: state.fieldErrors['email'],
              ),
              const SizedBox(height: 10),
              CommonTextInput(
                labelText: 'Mobile Number',
                inputType: InputType.phone,
                onChanged: viewModel.setMobile,
                height: 60,
                prefixIcon: const Icon(Icons.phone_outlined),
                errorText: state.fieldErrors['mobile'],
              ),
              const SizedBox(height: 10),
              // Password Field
              CommonTextInput(
                labelText: 'Password',
                inputType: InputType.password,
                onChanged: viewModel.setPassword,
                prefixIcon: const Icon(Icons.lock_outline),
                errorText: state.fieldErrors['password'],
              ),
              const SizedBox(height: 10),

              // Confirm Password Field
              CommonTextInput(
                labelText: 'Confirm Password',
                inputType: InputType.password,
                onChanged: viewModel.setConfirmPassword,
                prefixIcon: const Icon(Icons.lock_outline),
                errorText: state.fieldErrors['confirmPassword'],
                validator: (value) {
                  if (value != null && value != state.password) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Error Display
              if (state.error != null)
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
                          state.error!,
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
          onPressed: state.isLoading
              ? () {}
              : () {
                  print("Sign Up button pressed");
                  // Manually validate fields first
                  viewModel.validateFields();
                  // Then submit if there are no validation errors
                  if (viewModel.validateFields()) {
                    print("Validation passed, submitting form");
                    viewModel.submit();
                  } else {
                    print("Validation failed, not submitting");
                  }
                },
          backgroundColor: AppColors.primary,
          textColor: AppColors.white,
          borderRadius: 32,
          margin: EdgeInsets.zero,
        ),
      ),
    );
  }
}
