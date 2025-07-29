import 'package:flutter/material.dart';
import '../core/app_export.dart';

class CustomButtonStyles {
  // Primary button style with filled background
  static ButtonStyle get fillPrimary => ElevatedButton.styleFrom(
    backgroundColor: appTheme.primaryPink,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.h),
    ),
  );

  // Secondary button style with outlined border
  static ButtonStyle get outlinePrimary => OutlinedButton.styleFrom(
    foregroundColor: appTheme.primaryPink,
    side: BorderSide(color: appTheme.primaryPink, width: 2),
    padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.h),
    ),
  );

  // Disabled button style
  static ButtonStyle get disabled => ElevatedButton.styleFrom(
    backgroundColor: appTheme.colorFF9A9A,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.h),
    ),
  );
}
