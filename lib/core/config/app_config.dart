/// Configuration des environnements de l'application
///
/// Ce fichier centralise les configurations pour différents environnements
/// (développement, test, production) en utilisant les variables d'environnement
library;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  /// Initialise la configuration en chargeant le fichier .env
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }

  /// URL de base de l'API selon l'environnement
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8000/api';

  /// Clé pour l'encryption des données locales
  static String get encryptionKey =>
      dotenv.env['ENCRYPTION_KEY'] ?? 'blood_donation_app_key';

  /// Configuration pour les logs
  static bool get enableLogging =>
      dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';

  /// Configuration pour les analytics
  static bool get enableAnalytics =>
      dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';

  /// Timeout pour les requêtes API (en secondes)
  static int get apiTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30') ?? 30;

  /// Version de l'API
  static String get apiVersion => dotenv.env['API_VERSION'] ?? 'v1';

  /// URL complète avec version
  static String get fullApiUrl => apiBaseUrl;

  /// Configuration selon l'environnement actuel
  static bool get isProduction => apiBaseUrl.contains('https://');
  static bool get isDevelopment =>
      apiBaseUrl.contains('127.0.0.1') || apiBaseUrl.contains('localhost');
  static bool get isStaging => apiBaseUrl.contains('staging');

  /// Environnement actuel
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';

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
  static int get maxFileSize =>
      int.tryParse(dotenv.env['MAX_FILE_SIZE'] ?? '10485760') ??
      10485760; // 10 MB
  static List<String> get allowedImageFormats =>
      (dotenv.env['ALLOWED_IMAGE_FORMATS'] ?? 'jpg,jpeg,png').split(',');
  static List<String> get allowedDocumentFormats =>
      (dotenv.env['ALLOWED_DOCUMENT_FORMATS'] ?? 'pdf,doc,docx').split(',');

  /// Messages d'erreur standardisés
  static const String networkErrorMessage = 'Erreur de connexion réseau';
  static const String serverErrorMessage = 'Erreur serveur, veuillez réessayer';
  static const String timeoutErrorMessage = 'Délai d\'attente dépassé';
  static const String unauthorizedErrorMessage =
      'Session expirée, veuillez vous reconnecter';

  /// Configuration des notifications
  static String get firebaseServerKey =>
      dotenv.env['FIREBASE_SERVER_KEY'] ?? '';

  /// Configuration des cartes (si utilisées)
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

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
