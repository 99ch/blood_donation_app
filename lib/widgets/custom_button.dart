import 'package:flutter/material.dart';

import '../core/app_export.dart';

/// CustomButton - Un bouton personnalisable avec support pour variantes `elevated` et `outlined`.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = CustomButtonVariant.elevated,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.isFullWidth = false,
    this.isEnabled = true,
    this.buttonStyle,
    this.buttonTextStyle,
  });

  final String text;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;
  final bool isFullWidth;
  final bool isEnabled;
  final ButtonStyle? buttonStyle;
  final TextStyle? buttonTextStyle;

  @override
  Widget build(BuildContext context) {
    final buttonWidth = isFullWidth ? double.infinity : (width ?? 335.h);
    final buttonHeight = height ?? 44.h;
    final radius = borderRadius ?? 8.h;

    final effectiveTextStyle = TextStyle(
      fontSize: fontSize ?? 14.fSize,
      fontWeight: fontWeight ?? FontWeight.w600,
      fontFamily: 'Manrope',
      height: 1.43,
      color: textColor,
    );

    if (variant == CustomButtonVariant.outlined) {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor ?? appTheme.whiteCustom,
            foregroundColor: textColor ?? appTheme.blackCustom,
            side: BorderSide(
              color: borderColor ?? appTheme.blackCustom,
              width: 1.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            text,
            style: TextStyleHelper.instance.textStyle6.copyWith(
              color: textColor ?? appTheme.blackCustom,
            ),
          ),
        ),
      );
    }

    // Elevated variant
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? (backgroundColor ?? appTheme.colorFF8808)
              : appTheme.colorFF8808.withAlpha(128),
          foregroundColor: isEnabled
              ? (textColor ?? appTheme.whiteCustom)
              : appTheme.whiteCustom.withAlpha(128),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(WidgetState.hovered)) {
                return appTheme.colorFF6606;
              }
              if (states.contains(WidgetState.pressed)) {
                return appTheme.colorFF6606.withAlpha(204);
              }
              return null;
            },
          ),
        ),
        child: Text(
          text,
          style: effectiveTextStyle.copyWith(
            color: isEnabled
                ? (textColor ?? appTheme.whiteCustom)
                : appTheme.whiteCustom.withAlpha(128),
          ),
        ),
      ),
    );
  }
}

enum CustomButtonVariant {
  elevated,
  outlined,
}
