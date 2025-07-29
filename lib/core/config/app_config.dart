/// Configuration des environnements de l'application
///
/// Ce fichier centralise les configurations pour différents environnements
/// (développement, test, production)

class AppConfig {
  /// URL de base de l'API selon l'environnement
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000/api', // Développement local
  );

  /// Clé pour l'encryption des données locales
  static const String encryptionKey = String.fromEnvironment(
    'ENCRYPTION_KEY',
    defaultValue: 'blood_donation_app_key',
  );

  /// Configuration pour les logs
  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );

  /// Configuration pour les analytics
  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false, // Désactivé par défaut en développement
  );

  /// Timeout pour les requêtes API (en secondes)
  static const int apiTimeout = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 30,
  );

  /// Version de l'API
  static const String apiVersion = 'v1';

  /// URL complète avec version
  static String get fullApiUrl => '$apiBaseUrl';

  /// Configuration selon l'environnement actuel
  static bool get isProduction => apiBaseUrl.contains('https://');
  static bool get isDevelopment => apiBaseUrl.contains('localhost');
  static bool get isStaging => apiBaseUrl.contains('staging');

  /// Headers par défaut pour les requêtes API
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-Version': apiVersion,
      };

  /// Configuration des SharedPreferences keys
  static const String userTokenKey = 'user_auth_token';
  static const String userDataKey = 'user_data';
  static const String appSettingsKey = 'app_settings';
  static const String onboardingCompletedKey = 'onboarding_completed';

  /// Configuration des timeouts et délais
  static const Duration splashScreenDuration = Duration(seconds: 3);
  static const Duration tokenRefreshInterval = Duration(minutes: 55);
  static const Duration cacheValidityDuration = Duration(hours: 1);

  /// Configuration des fichiers et uploads
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png'];
  static const List<String> allowedDocumentFormats = ['pdf', 'doc', 'docx'];

  /// Messages d'erreur standardisés
  static const String networkErrorMessage = 'Erreur de connexion réseau';
  static const String serverErrorMessage = 'Erreur serveur, veuillez réessayer';
  static const String timeoutErrorMessage = 'Délai d\'attente dépassé';
  static const String unauthorizedErrorMessage =
      'Session expirée, veuillez vous reconnecter';

  /// Configuration des notifications
  static const String firebaseServerKey = String.fromEnvironment(
    'FIREBASE_SERVER_KEY',
    defaultValue: '',
  );

  /// Configuration des cartes (si utilisées)
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  /// Validation de la configuration
  static bool validateConfig() {
    if (apiBaseUrl.isEmpty) return false;
    if (isProduction && !apiBaseUrl.startsWith('https://')) return false;
    return true;
  }

  /// Debug info pour le développement
  static Map<String, dynamic> get debugInfo => {
        'apiBaseUrl': apiBaseUrl,
        'isProduction': isProduction,
        'isDevelopment': isDevelopment,
        'isStaging': isStaging,
        'enableLogging': enableLogging,
        'enableAnalytics': enableAnalytics,
        'apiTimeout': apiTimeout,
      };
}

/// Enum pour les différents environnements
enum Environment {
  development,
  staging,
  production,
}

/// Extension pour obtenir l'environnement actuel
extension EnvironmentExtension on Environment {
  static Environment get current {
    if (AppConfig.isProduction) return Environment.production;
    if (AppConfig.isStaging) return Environment.staging;
    return Environment.development;
  }

  String get name {
    switch (this) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }

  String get displayName {
    switch (this) {
      case Environment.development:
        return 'Développement';
      case Environment.staging:
        return 'Test';
      case Environment.production:
        return 'Production';
    }
  }
}
