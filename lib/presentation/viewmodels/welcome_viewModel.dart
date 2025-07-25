import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marriage_gate/core/constants/app_colors.dart';
import 'package:marriage_gate/core/constants/app_text_theme.dart';

import '../../core/constants/image_assets.dart';
import '../widgets/bottom_button.dart';

final welcomeViewModelProvider =
    Provider<WelcomeViewModel>((ref) => WelcomeViewModel());

class WelcomeViewModel {
  void showGetStartedSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomButton(
              fontSize: 14,
              imagePath: PngAssets.EMAIL,
              text: "Sign Up with Email",
              onPressed: () {
                context.push('/signup');
              },
              textColor: AppColors.textPrimary,
              backgroundColor: AppColors.white,
              border: const BorderSide(color: AppColors.kDarkText, width: 1),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            BottomButton(
              fontSize: 14,
              imagePath: PngAssets.PHONE,
              text: "Sign Up with Mobile",
              onPressed: () {},
              textColor: AppColors.textPrimary,
              backgroundColor: AppColors.white,
              border: const BorderSide(color: AppColors.kDarkText, width: 1),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            BottomButton(
              fontSize: 14,
              imagePath: PngAssets.GOOGLE,
              text: "Sign Up with Google",
              onPressed: () {},
              textColor: AppColors.textPrimary,
              backgroundColor: AppColors.white,
              border: const BorderSide(color: AppColors.kDarkText, width: 1),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            BottomButton(
              fontSize: 14,
              imagePath: PngAssets.FACEBOOK,
              text: "Sign Up with Facebook",
              onPressed: () {},
              textColor: AppColors.textPrimary,
              backgroundColor: AppColors.white,
              border: const BorderSide(color: AppColors.kDarkText, width: 1),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account ?",
                  style: AppTextTheme.textTheme.bodyMedium,
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all()),
                  child: Text("Login"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
