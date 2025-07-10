import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * CustomButton - A flexible and reusable button component
 * 
 * This component provides a customizable button with various styling options
 * including background color, text color, dimensions, and border radius.
 * 
 * @param text - The text to display on the button
 * @param onPressed - Callback function when button is pressed
 * @param backgroundColor - Background color of the button
 * @param textColor - Color of the button text
 * @param width - Width of the button
 * @param height - Height of the button
 * @param borderRadius - Border radius of the button
 * @param fontSize - Font size of the button text
 * @param fontWeight - Font weight of the button text
 * @param isEnabled - Whether the button is enabled or disabled
 */
class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.isEnabled = true,
  }) : super(key: key);

  /// The text to display on the button
  final String text;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Background color of the button
  final Color? backgroundColor;

  /// Color of the button text
  final Color? textColor;

  /// Width of the button
  final double? width;

  /// Height of the button
  final double? height;

  /// Border radius of the button
  final double? borderRadius;

  /// Font size of the button text
  final double? fontSize;

  /// Font weight of the button text
  final FontWeight? fontWeight;

  /// Whether the button is enabled or disabled
  final bool isEnabled;

@override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 335.h,
      height: height ?? 44.h,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? appTheme.colorFF8808,
          foregroundColor: textColor ?? appTheme.whiteCustom,
          disabledBackgroundColor: appTheme.colorFF8808.withAlpha(128),
          disabledForegroundColor: appTheme.whiteCustom.withAlpha(128),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.h),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return appTheme
                    .colorFF6606; // Modified: Added missing space in return statement
              }
              if (states.contains(WidgetState.pressed)) {
                return appTheme.colorFF6606.withAlpha(
                    204); // Modified: Added missing space in return statement
              }
              return null;
            },
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize ?? 14.fSize,
            fontWeight: fontWeight ?? FontWeight.w600,
            fontFamily: 'Manrope',
            height: 1.43, // 20px / 14px = 1.43
          ),
        ),
      ),
    );
  }
}
