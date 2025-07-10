import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * CustomTextInput - A reusable text input field component with customizable styling
 * 
 * Features:
 * - Customizable hint text and validation
 * - Consistent styling with shadow and rounded corners
 * - Focus states with custom border colors
 * - Responsive design using SizeUtils
 * - Support for different input types
 * 
 * @param controller - TextEditingController for managing input text
 * @param hintText - Placeholder text displayed when field is empty
 * @param isRequired - Whether the field is required for validation
 * @param validator - Custom validation function
 * @param textInputType - Type of keyboard to display
 * @param enabled - Whether the input field is enabled
 */
class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    Key? key,
    this.controller,
    this.hintText,
    this.isRequired,
    this.validator,
    this.textInputType,
    this.enabled,
  }) : super(key: key);

  /// Controller for managing the text input
  final TextEditingController? controller;

  /// Hint text displayed as placeholder
  final String? hintText;

  /// Whether the field is required for validation
  final bool? isRequired;

  /// Custom validation function
  final String? Function(String?)? validator;

  /// Type of keyboard to display
  final TextInputType? textInputType;

  /// Whether the input field is enabled
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61.h,
      decoration: BoxDecoration(
        color: appTheme.colorFFD9D9,
        borderRadius: BorderRadius.circular(5.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 4.h,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType ?? TextInputType.text,
        enabled: enabled ?? true,
        validator: validator ?? (isRequired == true ? _defaultValidator : null),
        style:
            TextStyleHelper.instance.body15RegularLexend.copyWith(height: 1.27),
        decoration: InputDecoration(
          hintText: hintText ?? "Enter text",
          hintStyle: TextStyleHelper.instance.body15RegularLexend
              .copyWith(color: appTheme.colorFF9A9A, height: 1.27),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 21.h,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.h),
            borderSide: BorderSide(
              color: appTheme.colorFFF2AB,
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

  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}
