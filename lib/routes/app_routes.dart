import 'package:flutter/material.dart';
import '../presentation/gettingStartedScreen/onboarding_three_screen.dart';
import '../presentation/missionOverviewScreen/onboarding_two_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/welcomeScreen/onboarding_screen.dart';
import '../presentation/account_registration_screen/account_registration_screen.dart';
import '../presentation/donorProfileSetupScreen/donorProfileSetupScreen.dart';
import '../presentation/blood_donation_menu_screen/blood_donation_menu_screen.dart';
import '../presentation/donation_campaign_list_screen/donation_campaign_list_screen.dart';
import '../presentation/test_results_history_page/test_results_history_page.dart';
import '../presentation/blood_collection_centers_locator/blood_collection_centers_locator.dart';
import '../presentation/digital_donor_card/digital_donor_card.dart';
import '../presentation/badges_management_screen/badges_management_screen.dart';
import '../presentation/create_donor_screen/create_donor_screen.dart';
import '../presentation/donors_list_screen/donors_list_screen.dart';
import '../presentation/debug/api_debug_screen.dart';

class AppRoutes {
  static const String onboardingThreeScreen = '/onboarding_three_screen';
  static const String onboardingTwoScreen = '/onboarding_two_screen';
  static const String authenticationScreen = '/authentication_screen';
  static const String onboardingScreen = '/onboarding_screen';
  static const String accountRegistrationScreen =
      '/account_registration_screen';
  static const String onboardingSevenEnhancedBloodDonationProfileSetup =
      '/onboarding-seven-enhanced-blood-donation-profile-setup';
  static const String bloodDonationMenuScreen = '/blood_donation_menu_screen';
  static const String donationCampaignListScreen =
      '/donation_campaign_list_screen';
  static const String testResultsHistoryPage = '/test-results-history-page';
  static const String bloodCollectionCentersLocator =
      '/blood-collection-centers-locator';
  static const String digitalDonorCard = '/digital-donor-card';
  static const String badgesManagementScreen = '/badges-management-screen';
  static const String createDonorScreen = '/create-donor-screen';
  static const String donorsListScreen = '/donors_list_screen';
  static const String apiDebugScreen = '/api-debug-screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        onboardingThreeScreen: (context) => OnboardingThreeScreen(),
        onboardingTwoScreen: (context) => OnboardingTwoScreen(),
        authenticationScreen: (context) => AuthenticationScreen(),
        onboardingScreen: (context) => OnboardingScreen(),
        accountRegistrationScreen: (context) => AccountRegistrationScreen(),
        onboardingSevenEnhancedBloodDonationProfileSetup: (context) =>
            OnboardingSevenEnhancedBloodDonationProfileSetup(),
        bloodDonationMenuScreen: (context) => BloodDonationMenuScreen(),
        donationCampaignListScreen: (context) => DonationCampaignListScreen(),
        testResultsHistoryPage: (context) => const TestResultsHistoryPage(),
        bloodCollectionCentersLocator: (context) =>
            const BloodCollectionCentersLocator(),
        digitalDonorCard: (context) => const DigitalDonorCard(),
        badgesManagementScreen: (context) => const BadgesManagementScreen(),
        createDonorScreen: (context) => const CreateDonorScreen(),
        donorsListScreen: (context) => const DonorsListScreen(),
        apiDebugScreen: (context) => const ApiDebugScreen(),
        initialRoute: (context) => OnboardingTwoScreen()
      };
}
