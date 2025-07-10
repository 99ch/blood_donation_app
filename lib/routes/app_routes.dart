import 'package:flutter/material.dart';
import '../presentation/onboarding_three_screen/onboarding_three_screen.dart';
import '../presentation/onboarding_two_screen/onboarding_two_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/onboarding_screen/onboarding_screen.dart';


class AppRoutes {
  static const String onboardingThreeScreen = '/onboarding_three_screen';
  static const String onboardingTwoScreen = '/onboarding_two_screen';
  static const String authenticationScreen = '/authentication_screen';
  static const String onboardingScreen = '/onboarding_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        onboardingThreeScreen: (context) => OnboardingThreeScreen(),
        onboardingTwoScreen: (context) => OnboardingTwoScreen(),
        authenticationScreen: (context) => AuthenticationScreen(),
        onboardingScreen: (context) => OnboardingScreen(),
        initialRoute: (context) => OnboardingTwoScreen()
      };
}
