import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marriage_gate/core/constants/app_colors.dart';
import 'package:lottie/lottie.dart';
import 'package:marriage_gate/core/constants/image_assets.dart';
import 'package:marriage_gate/presentation/widgets/bottom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marriage_gate/presentation/viewmodels/welcome_viewModel.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final welcomeViewModel = ref.read(welcomeViewModelProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Image.asset(
                PngAssets.MARRIAGE_GATE_LOGO,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Lottie.asset(
                          JsonAssets.SPLASH_SCREEN,
                          width: 360,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Column(
                        children: [
                          const Text(
                            "Find exactly the",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Sriracha',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Right partner for you",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Sriracha',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: AppColors.primary,
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
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomButton(
              text: 'Get Started',
              onPressed: () {
                welcomeViewModel.showGetStartedSheet(context);
              },
              textColor: AppColors.white,
              borderRadius: 16,
              margin: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),
            BottomButton(
              text: 'Already have an account? Login',
              onPressed: () {
                context.go('/login');
              },
              backgroundColor: AppColors.white,
              textColor: AppColors.primary,
              borderRadius: 16,
              margin: EdgeInsets.zero,
              border: const BorderSide(color: AppColors.primary, width: 1),
            ),
          ],
        ),
      ),
    );
  }
}
