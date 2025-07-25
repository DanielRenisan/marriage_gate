import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marriage_gate/core/constants/app_colors.dart';

class CustomerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final double elevation;

  const CustomerAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true, // Always center the title
      backgroundColor: backgroundColor ?? AppColors.white,
      elevation: elevation,
      actions: actions,
      leading: leading ??
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
