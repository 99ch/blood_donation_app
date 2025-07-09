import 'package:flutter/material.dart';
import '../presentation/onboarding_three_screen/onboarding_three_screen.dart';
import '../presentation/onboarding_two_screen/onboarding_two_screen.dart';

import '../presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String onboardingThreeScreen = '/onboarding_three_screen';
  static const String onboardingTwoScreen = '/onboarding_two_screen';

  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        onboardingThreeScreen: (context) => OnboardingThreeScreen(),
        onboardingTwoScreen: (context) => OnboardingTwoScreen(),
        appNavigationScreen: (context) => AppNavigationScreen(),
        initialRoute: (context) => AppNavigationScreen()
      };
}
