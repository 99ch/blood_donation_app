/// Constantes globales de l'application Blood Donation App
library;

class AppConstants {
  // Private constructor pour empêcher l'instanciation
  AppConstants._();

  /// Informations de l'application
  static const String appName = 'Blood Donation App';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appDescription =
      'Application de don de sang - AB Project-ee';

  /// URLs et endpoints
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String supportEmail = 'support@abproject-ee.com';
  static const String helpUrl = 'https://example.com/help';

  /// Formats de date et heure
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = 'yyyy-MM-dd HH:mm:ss';

  /// Limites et validations
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 100;
  static const int maxDescriptionLength = 500;

  /// Groupes sanguins
  static const List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  /// Pays supportés
  static const List<String> supportedCountries = [
    'Bénin',
    'France',
    'Sénégal',
    'Côte d\'Ivoire',
    'Burkina Faso',
    'Mali',
    'Niger',
    'Togo',
    'Ghana',
    'Nigeria',
  ];

  /// Types de badges
  static const Map<String, String> badgeTypes = {
    'first_donation': 'Premier Don',
    'regular_donor': 'Donneur Régulier',
    'hero_donor': 'Donneur Héros',
    'champion_donor': 'Champion',
    'life_saver': 'Sauveur de Vie',
  };

  /// Niveaux de badges (nombre de dons requis)
  static const Map<String, int> badgeLevels = {
    'first_donation': 1,
    'regular_donor': 5,
    'hero_donor': 10,
    'champion_donor': 25,
    'life_saver': 50,
  };

  /// États des campagnes
  static const List<String> campaignStatuses = [
    'active',
    'completed',
    'cancelled',
    'upcoming',
  ];

  /// Niveaux d'urgence
  static const Map<String, String> urgencyLevels = {
    'low': 'Faible',
    'normal': 'Normale',
    'high': 'Haute',
    'critical': 'Critique',
  };

  /// Types de notifications
  static const Map<String, String> notificationTypes = {
    'campaign_reminder': 'Rappel de campagne',
    'test_result': 'Résultat d\'analyse',
    'badge_earned': 'Badge obtenu',
    'urgent_request': 'Demande urgente',
    'appointment_reminder': 'Rappel de rendez-vous',
  };

  /// Messages de validation
  static const String requiredFieldMessage = 'Ce champ est obligatoire';
  static const String invalidEmailMessage = 'Adresse email invalide';
  static const String passwordTooShortMessage =
      'Le mot de passe doit contenir au moins 8 caractères';
  static const String passwordsNotMatchMessage =
      'Les mots de passe ne correspondent pas';
  static const String invalidPhoneMessage = 'Numéro de téléphone invalide';

  /// Messages de succès
  static const String registrationSuccessMessage = 'Inscription réussie !';
  static const String loginSuccessMessage = 'Connexion réussie !';
  static const String donorCreatedMessage = 'Donneur ajouté avec succès !';
  static const String profileUpdatedMessage = 'Profil mis à jour avec succès !';
  static const String badgeEarnedMessage =
      'Félicitations ! Vous avez obtenu un nouveau badge !';

  /// Messages d'erreur
  static const String genericErrorMessage = 'Une erreur est survenue';
  static const String networkErrorMessage = 'Erreur de connexion réseau';
  static const String serverErrorMessage = 'Erreur serveur';
  static const String timeoutErrorMessage = 'Délai d\'attente dépassé';
  static const String unauthorizedMessage = 'Accès non autorisé';
  static const String notFoundMessage = 'Ressource non trouvée';
  static const String validationErrorMessage = 'Données invalides';

  /// Configuration de l'interface
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 8.0;
  static const double buttonBorderRadius = 5.0;
  static const double cardBorderRadius = 12.0;

  /// Durées d'animation
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  /// Délais et timeouts
  static const Duration splashDelay = Duration(seconds: 3);
  static const Duration autoLogoutDelay = Duration(minutes: 30);
  static const Duration cacheExpiry = Duration(hours: 24);
  static const Duration retryDelay = Duration(seconds: 3);

  /// Limites de pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  /// Configuration des images
  static const double maxImageSize = 5.0; // MB
  static const int imageQuality = 85; // %
  static const double thumbnailSize = 150.0; // pixels

  /// Types de fichiers acceptés
  static const List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> documentExtensions = ['pdf', 'doc', 'docx', 'txt'];

  /// Configuration des cartes
  static const double defaultZoom = 15.0;
  static const double minZoom = 10.0;
  static const double maxZoom = 20.0;

  /// Expressions régulières
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[1-9]\d{1,14}$';
  static const String nameRegex = r'^[a-zA-ZÀ-ÿ\s]{2,50}$';

  /// Configuration des couleurs par défaut (hex)
  static const String primaryColorHex = '#FF8808';
  static const String secondaryColorHex = '#FFF2AB';
  static const String errorColorHex = '#F44336';
  static const String successColorHex = '#4CAF50';
  static const String warningColorHex = '#FF9800';
  static const String infoColorHex = '#2196F3';

  /// Configuration du stockage local
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String settingsKey = 'app_settings';
  static const String cacheKey = 'cache_data';

  /// Version de l'API supportée
  static const String minApiVersion = '1.0.0';
  static const String currentApiVersion = '1.0.0';

  /// Configuration des logs
  static const bool enableDebugLogs = true;
  static const bool enableInfoLogs = true;
  static const bool enableErrorLogs = true;
  static const int maxLogEntries = 1000;

  /// Fonctions utilitaires
  static bool isValidEmail(String email) {
    return RegExp(emailRegex).hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(phoneRegex).hasMatch(phone);
  }

  static bool isValidName(String name) {
    return RegExp(nameRegex).hasMatch(name);
  }

  static bool isValidPassword(String password) {
    return password.length >= minPasswordLength &&
        password.length <= maxPasswordLength;
  }
}
