import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * CustomInputField - A reusable input field component with email support, shadow effects, and validation
 * 
 * @param controller - TextEditingController for managing input text
 * @param hintText - Placeholder text displayed when field is empty
 * @param keyboardType - Type of keyboard to display (email, text, etc.)
 * @param validator - Function to validate input text
 * @param isRequired - Whether the field is required for form submission
 * @param onChanged - Callback function triggered when text changes
 * @param enabled - Whether the input field is enabled for interaction
 */
class CustomInputField extends StatelessWidget {
  const CustomInputField({
    Key? key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.isRequired,
    this.onChanged,
    this.enabled,
    this.obscureText = false,
  }) : super(key: key);

  /// Controller for managing the input text
  final TextEditingController? controller;

  /// Placeholder text shown when field is empty
  final String? hintText;

  /// Type of keyboard to display
  final TextInputType? keyboardType;

  /// Function to validate the input
  final String? Function(String?)? validator;

  /// Whether the field is required
  final bool? isRequired;

  /// Callback when text changes
  final Function(String)? onChanged;

  /// Whether the field is enabled
  final bool? enabled;

  /// Whether to obscure the text (for passwords)
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 324.h,
      height: 61.h,
      decoration: BoxDecoration(
        color: appTheme.colorFFD9D9,
        borderRadius: BorderRadius.circular(5.h),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF9A9A9A).withAlpha(64),
            offset: Offset(8.h, 8.h),
            blurRadius: 16.h,
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.emailAddress,
        validator: validator,
        onChanged: onChanged,
        enabled: enabled ?? true,
        obscureText: obscureText,
        style: TextStyleHelper.instance.title20Lexend.copyWith(height: 1.25),
        decoration: InputDecoration(
          hintText: hintText ?? "example@gmail.com",
          hintStyle: TextStyleHelper.instance.title20Lexend
              .copyWith(color: Color(0xFF444444).withAlpha(128), height: 1.25),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.h),
            borderSide: BorderSide(
              color: appTheme.colorFF8808,
              width: 2.h,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.h),
            borderSide: BorderSide(
              color: appTheme.redCustom,
              width: 2.h,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.h),
            borderSide: BorderSide(
              color: appTheme.redCustom,
              width: 2.h,
            ),
          ),
        ),
      ),
    );
  }
}
