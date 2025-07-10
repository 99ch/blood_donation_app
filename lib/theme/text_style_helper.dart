import 'package:flutter/material.dart';
import 'theme_helper.dart'; // utilisé uniquement pour LightCodeColors

/// A helper class for managing text styles in the application
class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  /// ✅ Remplace ThemeHelper par une instance directe
  final LightCodeColors appTheme = LightCodeColors();

  // Headline Styles

  TextStyle get headline24Bold => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: appTheme.colorFF0F0B,
      );

  TextStyle get headline24BoldManrope => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        fontFamily: 'Manrope',
        color: appTheme.colorFF0F0B,
      );

  TextStyle get headline25 => TextStyle(
        fontSize: 25,
        color: appTheme.color7F4444,
      );

  // Title Styles

  TextStyle get title20RegularRoboto => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
        color: appTheme.blackCustom,
      );

  TextStyle get title20 => TextStyle(
        fontSize: 20,
        color: appTheme.blackCustom,
      );

  TextStyle get title20Lexend => TextStyle(
        fontSize: 20,
        fontFamily: 'Lexend',
        color: appTheme.colorFF4444,
      );

  TextStyle get title16 => TextStyle(
        fontSize: 16,
        color: appTheme.whiteCustom,
      );

  // Body Styles

  TextStyle get body14Regular => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: appTheme.colorFF0F0B,
      );

  TextStyle get body14RegularManrope => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Manrope',
        color: appTheme.colorFF0F0B,
      );

  TextStyle get body13RegularManrope => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        fontFamily: 'Manrope',
        color: appTheme.colorFF0F0B,
      );

  TextStyle get body13Regular => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: appTheme.colorFF0F0B,
      );

  // Other Styles

  TextStyle get textStyle7 => TextStyle(
        fontSize: 7,
        color: appTheme.blackCustom,
      );
}
