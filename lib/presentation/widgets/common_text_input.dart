// common_text_input.dart
import 'package:flutter/material.dart';

enum InputType {
  text,
  email,
  password,
  phone,
  name,
}

class CommonTextInput extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final InputType inputType;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final double height;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final TextEditingController? controller;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? prefixIconSize;
  final double? labelTextSize;
  final double? hintTextSize;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;

  const CommonTextInput({
    super.key,
    required this.labelText,
    this.hintText,
    required this.inputType,
    required this.onChanged,
    this.validator,
    this.initialValue,
    this.height = 56.0,
    this.contentPadding,
    this.enabled = true,
    this.controller,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconSize = 16.0,
    this.labelTextSize = 14.0,
    this.hintTextSize = 12.0,
    this.labelStyle,
    this.hintStyle,
  });

  @override
  State<CommonTextInput> createState() => _CommonTextInputState();
}

class _CommonTextInputState extends State<CommonTextInput> {
  bool _obscureText = true;
  late TextEditingController _controller;
  String? _currentError;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  TextInputType _getKeyboardType() {
    switch (widget.inputType) {
      case InputType.email:
        return TextInputType.emailAddress;
      case InputType.phone:
        return TextInputType.phone;
      case InputType.password:
        return TextInputType.visiblePassword;
      case InputType.name:
      case InputType.text:
      default:
        return TextInputType.text;
    }
  }

  bool _isObscureText() {
    return widget.inputType == InputType.password && _obscureText;
  }

  Widget? _getSuffixIcon() {
    if (widget.inputType == InputType.password) {
      return IconTheme(
        data: IconThemeData(size: widget.prefixIconSize),
        child: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
            size: 20.0,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      );
    }
    return widget.suffixIcon != null
        ? IconTheme(
            data: IconThemeData(size: widget.prefixIconSize),
            child: widget.suffixIcon!,
          )
        : null;
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return '${widget.labelText} is required';
    }

    switch (widget.inputType) {
      case InputType.email:
        if (!_isValidEmail(value)) {
          return 'Enter a valid email address';
        }
        break;
      case InputType.phone:
        if (!_isValidPhone(value)) {
          return 'Enter a valid phone number';
        }
        break;
      case InputType.password:
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        break;
      case InputType.name:
        if (value.length < 2) {
          return 'Name must be at least 2 characters';
        }
        break;
      case InputType.text:
        // Basic text validation can be added here
        break;
    }

    // Custom validator if provided
    if (widget.validator != null) {
      return widget.validator!(value);
    }

    return null;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextFormField(
        controller: _controller,
        keyboardType: _getKeyboardType(),
        obscureText: _isObscureText(),
        enabled: widget.enabled,
        onChanged: (value) {
          // Clear error when user starts typing
          if (_currentError != null) {
            setState(() {
              _currentError = null;
            });
          }
          widget.onChanged(value);
        },
        onFieldSubmitted: (value) {
          // Validate on submit
          final error = _validateInput(value);
          if (error != null) {
            setState(() {
              _currentError = error;
            });
          }
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          errorText: widget.errorText ?? _currentError,
          labelStyle: widget.labelStyle ??
              TextStyle(
                fontSize: widget.labelTextSize ?? 16.0,
                color: Colors.grey.shade700,
              ),
          hintStyle: widget.hintStyle ??
              TextStyle(
                fontSize: widget.hintTextSize ?? 14.0,
                color: Colors.grey.shade500,
              ),
          prefixIcon: widget.prefixIcon != null
              ? IconTheme(
                  data: IconThemeData(size: widget.prefixIconSize ?? 20.0),
                  child: widget.prefixIcon!,
                )
              : null,
          suffixIcon: _getSuffixIcon(),
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

// Extension method to validate specific field types
extension InputValidation on String {
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }
}
