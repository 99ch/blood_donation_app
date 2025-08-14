# 🏗️ Architecture du Projet - Blood Donation App

## Vue d'ensemble de l'Architecture

L'application Blood Donation App suit une architecture modulaire basée sur le pattern **Feature-First** avec une séparation claire des responsabilités. Cette approche facilite la maintenance, les tests et l'évolutivité du code.

## 📊 Diagramme d'Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    SCREENS LAYER                       │
├─────────────────────────────────────────────────────────────┤
│  Screens  │  Widgets  │  Routes  │  Theme  │  Controllers   │
├─────────────────────────────────────────────────────────────┤
│                     BUSINESS LAYER                          │
├─────────────────────────────────────────────────────────────┤
│           Services  │  Models  │  Repositories              │
├─────────────────────────────────────────────────────────────┤
│                      DATA LAYER                             │
├─────────────────────────────────────────────────────────────┤
│     API Client  │  Local Storage  │  Network Manager        │
└─────────────────────────────────────────────────────────────┘
```

## 🔧 Couches de l'Architecture

### 1. **Screens Layer** (`lib/screens/`)

Cette couche gère l'interface utilisateur et les interactions. Elle est organisée par fonctionnalités :

#### Fonctionnalités Principales :

##### 🔐 **Authentication & Onboarding**

- `welcomeScreen/onboarding_screen.dart` - Écran d'accueil
- `missionOverviewScreen/onboarding_two_screen.dart` - Présentation de la mission
- `gettingStartedScreen/onboarding_three_screen.dart` - Introduction à l'app
- `authentication_screen/authentication_screen.dart` - Connexion utilisateur
- `account_registration_screen/account_registration_screen.dart` - Inscription

##### 👤 **Profile Management**

- `donorProfileSetupScreen/donorProfileSetupScreen.dart` - Configuration du profil donneur (legacy)
- `blood_donation_profile_setup/blood_donation_profile_setup.dart` - Configuration avancée du profil
- `digital_donor_card/digital_donor_card.dart` - Carte numérique du donneur
- `profile_screen/profile_screen.dart` - Gestion du profil utilisateur
- `api_config_screen/api_config_screen.dart` - Configuration de l'URL API

##### 🏥 **Blood Donation Management**

- `blood_donation_menu_screen/blood_donation_menu_screen.dart` - Menu principal des dons
- `donors_list_screen/donors_list_screen.dart` - Liste des donneurs
- `create_donor_screen/create_donor_screen.dart` - Création de nouveaux donneurs

##### 🎯 **Campaigns & Centers**

- `donation_campaign_list_screen/donation_campaign_list_screen.dart` - Liste des campagnes
- `blood_collection_centers_locator/blood_collection_centers_locator.dart` - Localisation des centres

##### 🏆 **Tracking & Rewards**

- `badges_management_screen/badges_management_screen.dart` - Gestion des badges
- `test_results_history_page/test_results_history_page.dart` - Historique des tests
- `blood_volume_visualization/blood_volume_screen.dart` - Visualisation des dons

##### 📱 **Communication & Services**

- `notifications_screen/notifications_screen.dart` - Gestion des notifications
- `appointments_screen/appointments_screen.dart` - Gestion des rendez-vous

### 2. **Business Layer** (`lib/services/`)

Cette couche contient la logique métier et les services :

#### Services principaux

**`api_service.dart`** - Service API Principal avec endpoints complets

```dart
class ApiService {
  // Configuration dynamique via AppConfig
  static String get baseUrl => AppConfig.apiBaseUrl;
  static Map<String, String> get defaultHeaders => AppConfig.defaultHeaders;

  // Authentification avancée
  Future<Map<String, dynamic>?> login(String email, String password)
  Future<Map<String, dynamic>?> registerUnified({...})  // Inscription complète
  static Future<Map<String, dynamic>> refreshToken(String refreshToken)
  Future<Map<String, dynamic>?> getCurrentUser(String token)
  Future<Map<String, dynamic>?> completeProfile({...})

  // Gestion complète des Donneurs
  Future<List<dynamic>?> getDonneurs(String token)
  Future<Map<String, dynamic>?> createDonneur(...)
  Future<Map<String, dynamic>?> updateDonneur(...)
  Future<List<dynamic>?> searchDonneurByName(...)
  Future<bool> enregistrerDon(String token, int donneurId, double litres)

  // Système de Badges et Récompenses
  Future<List<dynamic>?> getBadges(String token)
  Future<dynamic> genererBadge(String token, int donneurId)  // Support PDF

  // Gestion des Analyses Médicales
  Future<List<dynamic>?> getResultatsAnalyse(String token)
  Future<Map<String, dynamic>?> ajouterResultatAnalyse(...)
  Future<bool> verifierAnalyse(...)  // Staff uniquement
  Future<Map<String, dynamic>?> envoyerResultatsVerifies(String token)

  // Campagnes et Centres
  Future<List<dynamic>?> getCampagnes()
  Future<List<dynamic>?> getCampagnesUrgentes()
  Future<bool> inscrireCampagne(String token, int campagneId)
  Future<List<dynamic>?> getCentres()
  Future<List<dynamic>?> getCentresProches(double latitude, double longitude)

  // Système de Notifications
  Future<List<Map<String, dynamic>>?> getNotifications(String token)
  Future<bool> marquerNotificationLue(...)
  Future<bool> marquerToutesNotificationsLues(String token)
  Future<bool> supprimerNotification(...)
}
```

**`auth_service.dart`** - Service d'authentification JWT avancé

```dart
class AuthService {
  // Gestion des sessions
  static Future<bool> isLoggedIn()
  static Future<bool> login(String email, String password)
  static Future<String?> getValidAccessToken()  // Auto-refresh
  static Future<bool> refreshAccessToken()
  static Future<void> logout()
  
  // Navigation intelligente
  static Future<String> getInitialRoute()  // Détermine la route selon l'état auth
  
  // Gestion des données utilisateur
  static Future<Map<String, dynamic>?> getUserData()
  static Future<Map<String, dynamic>?> getDonorData()
  static Future<int?> getDonorId()
  static Future<bool> hasDonorProfile()
  static Future<bool> isStaff()
}
```

**Services additionnels :**

- **`notification_service.dart`** : Gestion des notifications push
- **`registration_data_service.dart`** : Service de données d'inscription
- **`api_test_service.dart`** : Service de tests et debugging API

### 3. **Core Layer** (`lib/core/`)

Contient les utilitaires et configurations partagés :

#### `config/app_config.dart` - Configuration des environnements

```dart
class AppConfig {
  static Future<void> initialize() async => await dotenv.load(fileName: '.env');
  
  // Configuration dynamique
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8000/api';
  static bool get enableLogging => dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-API-Version': apiVersion,
  };
  
  // Détection d'environnement
  static bool get isProduction => apiBaseUrl.contains('https://');
  static bool get isDevelopment => apiBaseUrl.contains('127.0.0.1') || apiBaseUrl.contains('localhost');
}
```

#### `navigation_helper.dart` - Helper de navigation et protection des routes

```dart
class NavigationHelper {
  static Future<String> getInitialRoute() async {
    // Détermine la route initiale selon l'état d'authentification
  }
  
  static bool isProtectedRoute(String routeName) {
    // Vérifie si une route nécessite une authentification
  }
}
```

**Autres composants :**

- **app_export.dart** : Centralise les imports
- **constants/app_constants.dart** : Constantes globales
- **utils/** : Fonctions utilitaires communes (image_constant, size_utils)

### 4. **UI Components** (`lib/widgets/`)

Composants réutilisables pour assurer la cohérence de l'interface :

#### Composants de base
- **custom_button.dart** : Boutons standardisés avec styles cohérents
- **custom_text_input.dart** : Champs de saisie avec validation intégrée
- **custom_image_view.dart** : Gestion optimisée des images avec cache
- **custom_input_field.dart** : Champs d'entrée spécialisés
- **custom_bottom_navigation.dart** : Navigation par onglets

#### Composants avancés
- **modern_app_bar.dart** : Barre d'application moderne et responsive
- **auth_guard.dart** : Composant de protection des routes avec `ProtectedRoute`
- **state_wrapper.dart** : Wrapper pour la gestion d'état globale

#### Protection des routes

Le système `auth_guard.dart` implémente un système de protection automatique :

```dart
class ProtectedRoute extends StatelessWidget {
  final String routeName;
  final Widget child;
  
  // Vérifie automatiquement l'authentification
  // Redirige vers login si non connecté
  // Gère les états de chargement
}
```

### 5. **Navigation** (`lib/routes/`)

Gestion centralisée de la navigation avec protection automatique :

```dart
class AppRoutes {
  // Routes d'onboarding
  static const String gettingStartedScreen = '/onboarding_three_screen';
  static const String missionOverviewScreen = '/onboarding_two_screen';
  static const String welcomeScreen = '/onboarding_screen';
  
  // Routes d'authentification
  static const String authenticationScreen = '/authentication_screen';
  static const String accountRegistrationScreen = '/account_registration_screen';
  
  // Routes principales (protégées)
  static const String bloodDonationMenuScreen = '/blood_donation_menu_screen';
  static const String digitalDonorCard = '/digital-donor-card';
  static const String profileScreen = '/profile_screen';
  static const String notificationsScreen = '/notifications_screen';
  
  // Routes de configuration
  static const String bloodDonationProfileSetup = '/onboarding-seven-enhanced-blood-donation-profile-setup';
  static const String apiConfigScreen = '/api-config-screen';

  // Configuration avec protection sélective
  static Map<String, WidgetBuilder> get routes => { ... };
}
```

#### Système de navigation intelligent

L'application utilise un système de navigation intelligent qui :

1. **Détermine automatiquement la route initiale** selon l'état d'authentification
2. **Protège sélectivement les routes** qui nécessitent une authentification  
3. **Gère les redirections automatiques** vers la page de connexion
4. **Maintient l'état de navigation** pendant les transitions

## 🔄 Flux de Données

### 1. **Authentification Flow Avancé**

```
User Input → Authentication Screen → API Service → JWT Tokens (Access + Refresh)
                                                     ↓
                              SharedPreferences ← Token Storage ← Validation
                                     ↓
                         NavigationHelper.getInitialRoute() ← AuthService.isLoggedIn()
                                     ↓
                    Main Menu (if authenticated) / Onboarding (if not)
```

### 2. **Auto-Refresh Token Flow**

```
API Request → AuthService.getValidAccessToken() → Token Validation
                                ↓
                         Token Expired?
                                ↓
           Yes: RefreshToken API → New Access Token → Continue Request
           No: Use Current Token → Continue Request
```

### 3. **Data Flow Pattern avec Protection**

```
UI Widget → ProtectedRoute → AuthService → API Service → Backend
    ↑                                           ↓
    └── Update UI ← Process Response ← Authentication Check
```

### 4. **Configuration Flow**

```
App Start → AppConfig.initialize() → .env File → API Base URL
                                      ↓
                         ApiConfigScreen → User Override → SharedPreferences
                                      ↓
                         Dynamic API URL → All API Calls
```

## 🗂️ Structure Détaillée des Dossiers (Mise à jour)

```
lib/
├── core/
│   ├── app_export.dart           # Exports centralisés
│   ├── config/
│   │   └── app_config.dart       # Configuration des environnements avec .env
│   ├── constants/
│   │   └── app_constants.dart    # Constantes globales
│   ├── navigation_helper.dart    # Helper de navigation et protection des routes
│   └── utils/
│       ├── image_constant.dart   # Constantes d'images
│       └── size_utils.dart       # Utilitaires de taille
│
├── screens/
│   ├── welcomeScreen/            # Onboarding initial
│   ├── missionOverviewScreen/    # Présentation de la mission
│   ├── gettingStartedScreen/     # Introduction à l'app
│   ├── authentication_screen/    # Connexion utilisateur
│   ├── account_registration_screen/ # Inscription utilisateur
│   ├── api_config_screen/        # Configuration de l'URL API
│   ├── appointments_screen/      # Gestion des rendez-vous
│   ├── blood_donation_profile_setup/ # Configuration du profil donneur avancé
│   ├── blood_volume_visualization/   # Visualisation des dons
│   ├── donorProfileSetupScreen/  # Configuration du profil donneur (legacy)
│   ├── blood_donation_menu_screen/   # Menu principal
│   ├── create_donor_screen/      # Création de nouveaux donneurs
│   ├── donation_campaign_list_screen/ # Gestion des campagnes
│   ├── blood_collection_centers_locator/ # Localisation des centres
│   ├── badges_management_screen/ # Gestion des badges et récompenses
│   ├── test_results_history_page/ # Historique des analyses
│   ├── digital_donor_card/       # Carte numérique du donneur
│   ├── notifications_screen/     # Gestion des notifications
│   └── profile_screen/           # Profil utilisateur
│
├── services/
│   ├── api_service.dart          # Service API principal avec tous les endpoints
│   ├── auth_service.dart         # Service d'authentification JWT
│   ├── notification_service.dart # Service de notifications push
│   ├── registration_data_service.dart # Service de données d'inscription
│   └── api_test_service.dart     # Service de tests API
│
├── models/
│   ├── user.dart                 # Modèle utilisateur
│   ├── donor.dart                # Modèle donneur (legacy)
│   ├── donor_updated.dart        # Modèle donneur mis à jour
│   ├── campaign.dart             # Modèle campagne
│   ├── badge.dart                # Modèle badge
│   ├── notification.dart         # Modèle notification
│   ├── don.dart                  # Modèle don
│   ├── resultat_analyse.dart     # Modèle résultat d'analyse
│   └── models.dart               # Export centralisé
│
├── widgets/
│   ├── custom_button.dart
│   ├── custom_text_input.dart
│   ├── custom_image_view.dart
│   ├── custom_input_field.dart
│   ├── custom_bottom_navigation.dart
│   ├── modern_app_bar.dart       # Barre d'application moderne
│   ├── auth_guard.dart           # Protection des routes
│   └── state_wrapper.dart        # Wrapper de gestion d'état
│
├── theme/
│   ├── theme_helper.dart         # Thème principal
│   ├── text_style_helper.dart    # Styles de texte
│   └── custom_button_styles.dart # Styles de boutons
│
└── routes/
    └── app_routes.dart           # Configuration complète des routes
```

## 🎯 Patterns et Principes Utilisés

### 1. **Feature-First Architecture**

- Organisation par fonctionnalités plutôt que par type de fichier
- Facilite la maintenance et l'évolution

### 2. **Separation of Concerns**

- UI séparée de la logique métier
- Services dédiés pour chaque responsabilité

### 3. **Reusable Components**

- Widgets personnalisés réutilisables
- Styles et thèmes centralisés

### 4. **Stateful Management**

- Utilisation de `StatefulWidget` pour la gestion d'état locale
- Services singletons pour l'état global (AuthService)
- `SharedPreferences` pour la persistance des données
- Cache intelligent pour les données utilisateur

### 5. **Configuration Dynamique**

- Support complet des fichiers `.env` pour la configuration
- Configuration API modifiable à l'exécution
- Détection automatique d'environnement (dev/staging/prod)
- URLs prédéfinies pour faciliter les tests

### 6. **Gestion d'Erreurs Robuste**

- Logging automatique de toutes les requêtes API
- Gestion des erreurs réseau avec retry automatique
- Messages d'erreur localisés et contextuels
- Validation des données côté client avant envoi

## 🔐 Sécurité et Bonnes Pratiques

### 1. **Authentification Avancée**

- Tokens JWT avec refresh automatique avant expiration
- Stockage sécurisé avec `SharedPreferences`
- Validation côté client et serveur
- Détection automatique de l'expiration
- Gestion des sessions utilisateur persistantes
- Protection automatique des routes sensibles

### 2. **Validation et Sécurité**

- Validation des formulaires avec messages d'erreur contextuels
- Sanitisation des entrées utilisateur
- Gestion robuste des erreurs réseau avec retry
- Validation des tokens JWT côté client
- Protection contre les attaques CSRF
- Chiffrement des communications HTTPS

### 3. **Performance et Optimisation**

- Images mises en cache avec `cached_network_image`
- Lazy loading des données avec pagination
- Cache intelligent des données utilisateur
- Optimisation des requêtes API avec dédoublonnage
- Compression automatique des images
- Gestion efficace de la mémoire

## 🧪 Architecture de Test (Mise à jour)

```
test/
├── api_integration_test.dart        # Tests d'intégration API complète
├── backend_connectivity_test.dart   # Tests de connectivité backend
├── integration_complete_test.dart   # Tests d'intégration complets
├── validation_simple_test.dart      # Tests de validation simples
├── widget_test.dart                # Tests de widgets de base
│
├── integration/
│   └── campaign_registration_test.dart # Tests d'inscription aux campagnes
│
├── validation/
│   └── user_story_validation_test.dart # Validation des user stories
│
└── widget/
    ├── donation_campaign_screen_test.dart # Tests écran campagnes
    └── notifications_screen_test.dart     # Tests écran notifications
```

### Types de tests implémentés

1. **Tests d'intégration API** : Validation complète des endpoints
2. **Tests de connectivité** : Vérification des connexions backend
3. **Tests de validation** : Vérification des user stories
4. **Tests de widgets** : Tests unitaires des composants UI
5. **Tests d'intégration** : Tests de flux complets utilisateur

## 🔄 CI/CD et Déploiement

### Pipeline de Développement

1. **Development** → Développement local
2. **Testing** → Tests automatisés
3. **Staging** → Tests d'intégration
4. **Production** → Déploiement final

### Environnements

```dart
// Configuration par environnement avec AppConfig
class AppConfig {
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }
  
  static String get apiBaseUrl => 
    dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8000/api';
  
  static bool get isProduction => apiBaseUrl.contains('https://');
  static bool get isDevelopment => 
    apiBaseUrl.contains('127.0.0.1') || apiBaseUrl.contains('localhost');
  
  // Configuration dynamique disponible
  static Map<String, String> presetUrls = {
    'Local Django': 'http://localhost:8000/api',
    'Local Django (IP)': 'http://127.0.0.1:8000/api',
    'Staging': 'https://staging-api.blooddonation.com/api',
    'Production': 'https://api.blooddonation.com/api',
  };
}
```

## 📈 Évolutivité et Maintenance

### 1. **Ajout de Nouvelles Fonctionnalités**

- Créer un nouveau dossier dans `screens/`
- Ajouter les services nécessaires
- Mettre à jour les routes

### 2. **Modifications de l'API**

- Centralisation dans `api_service.dart`
- Gestion de la rétrocompatibilité
- Tests d'intégration

### 3. **Performance Monitoring**

- Métriques de performance
- Monitoring des erreurs
- Analytics utilisateur

## 🆕 Nouvelles Fonctionnalités Ajoutées

### Configuration API Dynamique
- **Écran de configuration API** : Interface utilisateur pour modifier l'URL API
- **URLs prédéfinies** : Presets pour développement, staging, production
- **Test de connexion** : Validation de la connectivité API
- **Persistence** : Sauvegarde automatique des préférences

### Système de Notifications Push
- **Modèle NotificationModel** : Structure complète pour les notifications
- **Types de notifications** : Inscription, rappel, résultat, urgent, information
- **Gestion avancée** : Marquage comme lue, suppression, actions en masse
- **Interface utilisateur** : Écran dédié avec badges visuels

### Gestion Avancée des Profils
- **Configuration complète** : Setup avancé du profil donneur
- **Visualisation des dons** : Écran de visualisation du volume de sang donné
- **Rendez-vous** : Gestion des appointments de don
- **Profil utilisateur** : Interface de gestion du profil personnel

### Services Améliorés
- **AuthService refactorisé** : Gestion intelligente des sessions JWT
- **API Service étendu** : Support complet des endpoints backend
- **Services auxiliaires** : Notification, registration data, API testing

---
