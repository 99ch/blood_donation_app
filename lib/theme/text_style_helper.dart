import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A helper class for managing text styles in the application
class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  final appTheme = ThemeHelper().themeColor(); // ✅ Theme Colors

  // Headline Styles
  TextStyle get headline24Bold => TextStyle(
        fontSize: 24.fSize,
        fontWeight: FontWeight.w700,
        color: appTheme.colorFF0F0B,
      );

  TextStyle get headline24BoldManrope => TextStyle(
        fontSize: 24.fSize,
        fontWeight: FontWeight.w700,
        fontFamily: 'Manrope',
        color: appTheme.colorFF0F0B,
      );

  TextStyle get headline25 => TextStyle(
        fontSize: 25.fSize,
        color: appTheme.color7F4444,
      );

  TextStyle get headline25RegularLexend => TextStyle(
        fontSize: 25.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Lexend',
        color: appTheme.colorFF4444,
      );

  TextStyle get headline35RegularLexend => TextStyle(
        fontSize: 35.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Lexend',
        color: appTheme.colorFF4444,
      );

  // Title Styles
  TextStyle get title20 => TextStyle(
        fontSize: 20.fSize,
        color: appTheme.blackCustom,
      );

  TextStyle get title20Lexend => TextStyle(
        fontSize: 20.fSize,
        fontFamily: 'Lexend',
        color: appTheme.colorFF4444,
      );

  TextStyle get title20RegularRoboto => TextStyle(
        fontSize: 20.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      );

  TextStyle get title16 => TextStyle(
        fontSize: 16.fSize,
        color: appTheme.whiteCustom,
      );

  // Body Styles
  TextStyle get body14Regular => TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
        color: appTheme.colorFF0F0B,
      );

  TextStyle get body14RegularManrope => TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Manrope',
        color: appTheme.colorFF0F0B,
      );

  TextStyle get body13RegularManrope => TextStyle(
        fontSize: 13.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Manrope',
        color: appTheme.colorFF0F0B,
      );

  TextStyle get body13Regular => TextStyle(
        fontSize: 13.fSize,
        fontWeight: FontWeight.w400,
        color: appTheme.colorFF0F0B,
      );

  TextStyle get body15 => TextStyle(
        fontSize: 15.fSize,
        color: appTheme.colorFF9A9A,
      );

  TextStyle get body15RegularLexend => TextStyle(
        fontSize: 15.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Lexend',
        color: appTheme.colorFF0000,
      );

  // Other Styles
  TextStyle get textStyle6 => TextStyle();

  TextStyle get textStyle7 => TextStyle();
}
