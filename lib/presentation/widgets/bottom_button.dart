import 'package:flutter/material.dart';
import 'package:marriage_gate/core/constants/app_colors.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final String? imagePath;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double? imageHeight;
  final double? imageWidth;
  final double? fontSize;
  final BoxFit? imageFit;
  final double borderRadius;
  final EdgeInsetsGeometry margin;
  final BorderSide? border;
  const BottomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.imagePath = "",
    this.imageHeight,
    this.imageWidth,
    this.imageFit,
    this.fontSize,
    this.textColor,
    this.height = 48,
    this.borderRadius = 32, // <-- Increase this value for more rounded corners
    this.margin = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final useGradient = backgroundColor == null;
    return Container(
      width: double.infinity,
      height: height,
      margin: margin,
      decoration: useGradient
          ? BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.primary.withOpacity(0.85),
                  AppColors.primary.withOpacity(0.9),
                  AppColors.primary.withOpacity(1),
                  AppColors.primary.withOpacity(0.9),
                  AppColors.primary.withOpacity(0.85),
                  AppColors.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  BorderRadius.circular(borderRadius > 32 ? borderRadius : 32),
            )
          : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          foregroundColor: textColor ?? AppColors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(borderRadius > 32 ? borderRadius : 32),
            side: border ?? BorderSide.none,
          ),
          textStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.normal,
            fontSize: fontSize ?? 16,
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: imagePath != ""
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            if (imagePath != "") ...[
              Image.asset(
                imagePath ?? "",
                width: imageWidth ?? 20,
                height: imageHeight ?? 20,
                fit: imageFit,
              ),
              SizedBox(width: imageWidth ?? 32)
            ],
            Text(text),
          ],
        ),
      ),
    );
  }
}
