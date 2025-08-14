import 'package:flutter/material.dart';
import '../screens/gettingStartedScreen/gettingStartedScreen.dart';
import '../screens/missionOverviewScreen/missionOverviewScreen.dart';
import '../screens/authentication_screen/authentication_screen.dart';
import '../screens/welcomeScreen/welcomeScreen.dart';
import '../screens/account_registration_screen/account_registration_screen.dart';
import '../screens/donorProfileSetupScreen/donorProfileSetupScreen.dart';
import '../screens/blood_donation_menu_screen/blood_donation_menu_screen.dart';
import '../screens/donation_campaign_list_screen/donation_campaign_list_screen.dart';
import '../screens/test_results_history_page/test_results_history_page.dart';
import '../screens/blood_collection_centers_locator/blood_collection_centers_locator.dart';
import '../screens/digital_donor_card/digital_donor_card.dart';
import '../screens/badges_management_screen/badges_management_screen.dart';
import '../screens/create_donor_screen/create_donor_screen.dart';
import '../screens/notifications_screen/notifications_screen.dart';
import '../screens/appointments_screen/appointments_screen.dart';
import '../screens/profile_screen/profile_screen.dart';
import '../screens/blood_volume_visualization/blood_volume_screen.dart';

class AppRoutes {
  static const String gettingStartedScreen = '/onboarding_three_screen';
  static const String missionOverviewScreen = '/onboarding_two_screen';
  static const String authenticationScreen = '/authentication_screen';
  static const String welcomeScreen = '/onboarding_screen';
  static const String accountRegistrationScreen =
      '/account_registration_screen';
  static const String bloodDonationProfileSetup =
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
  static const String notificationsScreen = '/notifications_screen';
  static const String appointmentsScreen = '/appointments_screen';
  static const String profileScreen = '/profile_screen';
  static const String bloodVolumeVisualizationScreen =
      '/blood_volume_visualization_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        gettingStartedScreen: (context) => const GettingStartedScreen(),
        missionOverviewScreen: (context) => const MissionOverviewScreen(),
        authenticationScreen: (context) => const AuthenticationScreen(),
        welcomeScreen: (context) => const WelcomeScreen(),
        accountRegistrationScreen: (context) =>
            const AccountRegistrationScreen(),
        bloodDonationProfileSetup: (context) =>
            const BloodDonationProfileSetup(),
        bloodDonationMenuScreen: (context) => const BloodDonationMenuScreen(),
        donationCampaignListScreen: (context) =>
            const DonationCampaignListScreen(),
        testResultsHistoryPage: (context) => const TestResultsHistoryPage(),
        bloodCollectionCentersLocator: (context) =>
            const BloodCollectionCentersLocator(),
        digitalDonorCard: (context) => const DigitalDonorCard(),
        badgesManagementScreen: (context) => const BadgesManagementScreen(),
        createDonorScreen: (context) => const CreateDonorScreen(),
        notificationsScreen: (context) => const NotificationsScreen(),
        appointmentsScreen: (context) => const AppointmentsScreen(),
        profileScreen: (context) => const ProfileScreen(),
        bloodVolumeVisualizationScreen: (context) =>
            const BloodVolumeVisualizationScreen(),
        initialRoute: (context) => const GettingStartedScreen()
      };
}
