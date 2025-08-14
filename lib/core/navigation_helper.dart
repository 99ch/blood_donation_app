import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';

/// Helper pour la navigation contextuelle et la gestion des routes
class NavigationHelper {
  /// Navigue vers le menu principal en supprimant toutes les routes précédentes
  static void goToMenu(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.bloodDonationMenuScreen,
      (route) => false,
    );
  }

  /// Navigue vers l'authentification en supprimant toutes les routes précédentes
  static void goToAuth(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.authenticationScreen,
      (route) => false,
    );
  }

  /// Navigue vers l'onboarding en supprimant toutes les routes précédentes
  static void goToOnboarding(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.gettingStartedScreen,
      (route) => false,
    );
  }

  /// Déconnecte l'utilisateur et redirige vers l'onboarding
  static Future<void> logout(BuildContext context) async {
    await AuthService.logout();
    goToOnboarding(context);
  }

  /// Retourne vers l'écran précédent avec gestion d'erreur
  static void goBack(BuildContext context, {String? fallbackRoute}) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else if (fallbackRoute != null) {
      Navigator.of(context).pushReplacementNamed(fallbackRoute);
    } else {
      goToMenu(context);
    }
  }

  /// Navigue vers une route en remplaçant la route actuelle
  static void replaceTo(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  /// Navigue vers une route avec des arguments
  static void navigateWithArguments(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  /// Vérifie si l'utilisateur est authentifié avant de naviguer
  static Future<void> navigateIfAuthenticated(
      BuildContext context, String routeName,
      {Object? arguments}) async {
    final isAuthenticated = await AuthService.isLoggedIn();

    if (isAuthenticated) {
      if (arguments != null) {
        Navigator.of(context).pushNamed(routeName, arguments: arguments);
      } else {
        Navigator.of(context).pushNamed(routeName);
      }
    } else {
      goToAuth(context);
    }
  }

  /// Affiche une boîte de dialogue de confirmation avant la navigation
  static Future<void> navigateWithConfirmation(
    BuildContext context,
    String routeName, {
    required String title,
    required String message,
    String confirmText = 'Continuer',
    String cancelText = 'Annuler',
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Navigator.of(context).pushNamed(routeName);
    }
  }

  /// Détermine la route initiale selon l'état d'authentification
  static Future<String> getInitialRoute() async {
    return await AuthService.getInitialRoute();
  }

  /// Routes qui nécessitent une authentification
  static const List<String> protectedRoutes = [
    AppRoutes.bloodDonationMenuScreen,
    AppRoutes.appointmentsScreen,
    AppRoutes.notificationsScreen,
    AppRoutes.profileScreen,
    AppRoutes.donationCampaignListScreen,
    AppRoutes.testResultsHistoryPage,
    AppRoutes.digitalDonorCard,
    AppRoutes.badgesManagementScreen,
    // Note: createDonorScreen retiré car c'est l'écran d'inscription (public)
  ];

  /// Vérifie si une route nécessite une authentification
  static bool isProtectedRoute(String routeName) {
    return protectedRoutes.contains(routeName);
  }

  /// Affiche un message d'erreur dans la navigation
  static void showNavigationError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Affiche un message de succès dans la navigation
  static void showNavigationSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
