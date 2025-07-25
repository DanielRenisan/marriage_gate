import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/image_assets.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/bottom_button.dart';
import '../widgets/common_text_input.dart';
import '../widgets/customer_appbar.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

    return Scaffold(
      appBar: const CustomerAppBar(
        title: 'Login',
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Container(
                    child: Lottie.asset(
                      JsonAssets.LOGIN,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                  CommonTextInput(
                    labelText: 'Mobile Number',
                    hintText: 'Enter your mobile number',
                    inputType: InputType.phone,
                    onChanged: viewModel.updateMobile,
                  ),
                  const SizedBox(height: 16),
                  CommonTextInput(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    inputType: InputType.password,
                    onChanged: viewModel.updatePassword,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(
                          child: Divider(
                        color: AppColors.kDarkText,
                        endIndent: 8,
                        indent: 16,
                      )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'OR LOGIN WITH',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        color: AppColors.kDarkText,
                        endIndent: 16,
                        indent: 8,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _logInWithWidget(PngAssets.EMAIL),
                      SizedBox(width: 24),
                      _logInWithWidget(PngAssets.GOOGLE),
                      SizedBox(width: 24),
                      _logInWithWidget(PngAssets.FACEBOOK),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          context.push('/signup');
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomButton(
        text: 'Login',
        onPressed: () => viewModel.login(context),
      ),
    );
  }

  Widget _logInWithWidget(String? imagePath, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: AppColors.textSecondary.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Image.asset(imagePath ?? ""),
      ),
    );
  }

  // void _showEmailLoginDialog(BuildContext context, LoginViewModel viewModel) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           bottom: MediaQuery.of(context).viewInsets.bottom,
  //         ),
  //         child: Container(
  //           padding: const EdgeInsets.all(24),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Text(
  //                 'Login with Email',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 24),
  //               CommonTextInput(
  //                 labelText: 'Email',
  //                 hintText: 'Enter your email',
  //                 inputType: InputType.email,
  //                 onChanged: viewModel.updateEmail,
  //               ),
  //               const SizedBox(height: 16),
  //               CommonTextInput(
  //                 labelText: 'Password',
  //                 hintText: 'Enter your password',
  //                 inputType: InputType.password,
  //                 onChanged: viewModel.updatePassword,
  //               ),
  //               const SizedBox(height: 24),
  //               BottomButton(
  //                 text: 'Continue',
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   viewModel.login(context);
  //                 },
  //               ),
  //               const SizedBox(height: 16),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
