import 'package:flutter/material.dart';

// Global theme accessors
String _appTheme = "lightCode";
LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
class ThemeHelper {
  // A map of custom color themes supported by the app
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

  // A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  /// Changes the app theme
  void changeTheme(String newTheme) {
    _appTheme = newTheme;
  }

  /// Returns the custom colors for the current theme
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
    );
  }

  LightCodeColors themeColor() => _getThemeColors();
  ThemeData themeData() => _getThemeData();
}

/// Standard color scheme
class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light();
}

/// Full palette of custom app colors
class LightCodeColors {
  // App Base Colors
  Color get black => const Color(0xFF1E1E1E);
  Color get white => const Color(0xFFFFFFFF);
  Color get pink200 => const Color(0xFFFBCFE8);
  Color get pink400 => const Color(0xFFF472B6);
  Color get red400 => const Color(0xFFF87171);
  Color get gray300 => const Color(0xFFD1D5DB);
  Color get gray50 => const Color(0xFFF9FAFB);
  Color get gray400 => const Color(0xFF9CA3AF);

  // Material Standard Colors
  Color get whiteCustom => Colors.white;
  Color get blackCustom => Colors.black;
  Color get transparentCustom => Colors.transparent;
  Color get greyCustom => Colors.grey;
  Color get redCustom => Colors.red;

  // Combined Colors from both themes
  Color get colorFF0F0B => const Color(0xFF0F0B03);
  Color get colorFFFBCF => const Color(0xFFFBCFE8);
  Color get colorFFF48F => const Color(0xFFF48FB1);
  Color get colorFFF871 => const Color(0xFFF87171);
  Color get colorFFD1D5 => const Color(0xFFD1D5DB);
  Color get colorFF8808 => const Color(0xFF880808);
  Color get color7F4444 => const Color(0x7F444444);
  Color get colorFF90BC => const Color(0xFF90BCFE);
  Color get color99ECEC => const Color(0x99ECECEC);
  Color get colorCC0061 => const Color(0xCC0061CB);
  Color get colorC90202 => const Color(0xC9020202);
  Color get colorFFFFC8 => const Color(0xFFFFC8C8);
  Color get colorFFF998 => const Color(0xFFF99898);
  Color get colorFF6606 => const Color(0xFF660606);
  Color get colorFFD9D9 => const Color(0xFFD9D9D9);
  Color get colorFF9A9A => const Color(0xFF9A9A9A);
  Color get colorFF4444 => const Color(0xFF444444);
  Color get colorFFF2AB => const Color(0xFFF2ABC9);
  Color get colorFFFF37 => const Color(0xFFFF3737);
  Color get colorFF7373 => const Color(0xFF737373);
  Color get colorFF0000 => const Color(0xFF000000); // Attention, ce code couleur est noir
  Color get colorFFF3F4 => const Color(0xFFF3F4F6);
  Color get colorFF5050 => const Color(0xFF505050);
  Color get colorFFFF57 => const Color(0xFFFF576D);
  Color get colorFF8888 => const Color(0xFF888888);
  Color get colorFFFAFA => const Color(0xFFFAFAFA);
  Color get colorFF002A => const Color(0xFF002A20);
  Color get colorFF6C6B => const Color(0xFF6C6B6B);
  Color get colorFF5ED2 => const Color(0xFF5ED2D2);
  Color get colorFF5ED22 => const Color(0xFF5ED2B6);
  Color get colorFF90BCFE => const Color(0xFF90BCFE); // Déjà existant

  // Greys
  Color get grey100 => Colors.grey.shade100;
  Color get grey200 => Colors.grey.shade200;
  Color get grey300Shade => Colors.grey.shade300;// renommé pour éviter conflit
  Color get grey300 => Colors.grey.shade300;



  // Primary Red and Pink Colors
  Color get primaryRed => const Color(0xFFDC2626); // Bright red
  Color get primaryPink => const Color(0xFFEC4899); // Bright pink
  Color get lightPink => const Color(0xFFFCE7F3); // Light pink background
  Color get lightRed => const Color(0xFFFEE2E2); // Light red background
  Color get darkRed => const Color(0xFF991B1B); // Dark red for text
  Color get darkPink => const Color(0xFFBE185D); // Dark pink for text

}
