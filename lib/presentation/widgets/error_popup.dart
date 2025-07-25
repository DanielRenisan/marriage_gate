import 'package:flutter/material.dart';
import 'package:marriage_gate/core/constants/app_colors.dart';
import 'package:marriage_gate/data/models/api_response.dart';

class ErrorPopup extends StatelessWidget {
  final ApiError error;
  final VoidCallback? onDismiss;

  const ErrorPopup({
    super.key,
    required this.error,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 8),
          Text(
            error.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            error.detail,
            style: const TextStyle(fontSize: 16),
          ),
          if (error.statusCode != 0) ...[
            const SizedBox(height: 8),
            Text(
              'Status Code: ${error.statusCode}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onDismiss != null) {
              onDismiss!();
            }
          },
          child: const Text('OK'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  // Helper method to show the error popup
  static void show(BuildContext context, ApiError error,
      {VoidCallback? onDismiss}) {
    showDialog(
      context: context,
      builder: (context) => ErrorPopup(
        error: error,
        onDismiss: onDismiss,
      ),
    );
  }

  // Helper method to show error from ApiResponse
  static void showFromResponse(BuildContext context, ApiResponse response,
      {VoidCallback? onDismiss}) {
    if (response.isError && response.error != null) {
      show(context, response.error!, onDismiss: onDismiss);
    }
  }

  // Helper method to show a generic error message
  static void showGeneric(BuildContext context, String message,
      {VoidCallback? onDismiss}) {
    show(
      context,
      ApiError(
        title: 'Error',
        detail: message,
        statusCode: 0,
      ),
      onDismiss: onDismiss,
    );
  }
}
