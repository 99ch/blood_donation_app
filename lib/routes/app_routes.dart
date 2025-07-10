import 'package:flutter/material.dart';
import '../presentation/onboarding_three_screen/onboarding_three_screen.dart';
import '../presentation/onboarding_two_screen/onboarding_two_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/onboarding_screen/onboarding_screen.dart';
import '../presentation/account_registration_screen/account_registration_screen.dart';
import '../presentation/onboarding_seven_enhanced_blood_donation_profile_setup/onboarding_seven_enhanced_blood_donation_profile_setup.dart';
import '../presentation/blood_donation_menu_screen/blood_donation_menu_screen.dart';
import '../presentation/donation_campaign_list_screen/donation_campaign_list_screen.dart';




class AppRoutes {
  static const String onboardingThreeScreen = '/onboarding_three_screen';
  static const String onboardingTwoScreen = '/onboarding_two_screen';
  static const String authenticationScreen = '/authentication_screen';
  static const String onboardingScreen = '/onboarding_screen';
  static const String accountRegistrationScreen = '/account_registration_screen';
  static const String onboardingSevenEnhancedBloodDonationProfileSetup = '/onboarding-seven-enhanced-blood-donation-profile-setup';
  static const String bloodDonationMenuScreen = '/blood_donation_menu_screen';
  static const String donationCampaignListScreen = '/donation_campaign_list_screen';

      
      

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        onboardingThreeScreen: (context) => OnboardingThreeScreen(),
        onboardingTwoScreen: (context) => OnboardingTwoScreen(),
        authenticationScreen: (context) => AuthenticationScreen(),
        onboardingScreen: (context) => OnboardingScreen(),
        accountRegistrationScreen: (context) => AccountRegistrationScreen(),
        onboardingSevenEnhancedBloodDonationProfileSetup: (context) => OnboardingSevenEnhancedBloodDonationProfileSetup(),
        initialRoute: (context) => OnboardingTwoScreen()
      };
}
