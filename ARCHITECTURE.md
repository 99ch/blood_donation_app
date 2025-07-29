# 🏗️ Architecture du Projet - Blood Donation App

## Vue d'ensemble de l'Architecture

L'application Blood Donation App suit une architecture modulaire basée sur le pattern **Feature-First** avec une séparation claire des responsabilités. Cette approche facilite la maintenance, les tests et l'évolutivité du code.

## 📊 Diagramme d'Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
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

### 1. **Presentation Layer** (`lib/presentation/`)

Cette couche gère l'interface utilisateur et les interactions. Elle est organisée par fonctionnalités :

#### Fonctionnalités Principales :

##### 🔐 **Authentication & Onboarding**

- `welcomeScreen/onboarding_screen.dart` - Écran d'accueil
- `missionOverviewScreen/onboarding_two_screen.dart` - Présentation de la mission
- `gettingStartedScreen/onboarding_three_screen.dart` - Introduction à l'app
- `authentication_screen/authentication_screen.dart` - Connexion utilisateur
- `account_registration_screen/account_registration_screen.dart` - Inscription

##### 👤 **Profile Management**

- `donorProfileSetupScreen/donorProfileSetupScreen.dart` - Configuration du profil donneur
- `digital_donor_card/digital_donor_card.dart` - Carte numérique du donneur

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

### 2. **Business Layer** (`lib/services/`)

Cette couche contient la logique métier et les services :

#### `api_service.dart` - Service API Principal

```dart
class ApiService {
  // Configuration
  static const String baseUrl = 'http://localhost:8000/api';

  // Authentification
  Future<String?> login(String username, String password)
  Future<Map<String, dynamic>?> register(...)
  Future<Map<String, dynamic>?> getCurrentDonor(String token)

  // Gestion des Donneurs
  Future<List<dynamic>?> getDonneurs(String token)
  Future<bool> createDonneur(String token, Map<String, dynamic> donneur)

  // Système de Badges
  Future<List<dynamic>?> getBadges(String token)
  Future<bool> genererBadge(String token, int donneurId)

  // Résultats d'Analyses
  Future<List<dynamic>?> getResultatsAnalyse(String token)
  Future<bool> ajouterResultatAnalyse(String token, int donneurId, dynamic fichierPdf)

  // Centres et Campagnes (Mock Data)
  Future<List<dynamic>?> getCenters()
  Future<List<dynamic>?> getCampagnes()
}
```

### 3. **Core Layer** (`lib/core/`)

Contient les utilitaires et configurations partagés :

- **app_export.dart** : Centralise les imports
- **utils/** : Fonctions utilitaires communes

### 4. **UI Components** (`lib/widgets/`)

Composants réutilisables pour assurer la cohérence de l'interface :

- **custom_button.dart** : Boutons standardisés
- **custom_text_input.dart** : Champs de saisie avec validation
- **custom_image_view.dart** : Gestion optimisée des images
- **custom_input_field.dart** : Champs d'entrée spécialisés
- **custom_bottom_navigation.dart** : Navigation par onglets

### 5. **Navigation** (`lib/routes/`)

Gestion centralisée de la navigation :

```dart
class AppRoutes {
  // Routes définies
  static const String onboardingScreen = '/onboarding_screen';
  static const String authenticationScreen = '/authentication_screen';
  static const String bloodDonationMenuScreen = '/blood_donation_menu_screen';
  // ... autres routes

  // Configuration des routes
  static Map<String, WidgetBuilder> get routes => { ... };
}
```

## 🔄 Flux de Données

### 1. **Authentification Flow**

```
User Input → Authentication Screen → API Service → JWT Token → Local Storage
                                                     ↓
                              Navigation to Main Menu ← Token Validation
```

### 2. **Data Flow Pattern**

```
UI Widget → Controller/State → Service → API/Local Storage
    ↑                                           ↓
    └── Update UI ← Process Response ← Return Data
```

## 🗂️ Structure Détaillée des Dossiers

```
lib/
├── core/
│   ├── app_export.dart           # Exports centralisés
│   ├── config/
│   │   └── app_config.dart       # Configuration des environnements
│   ├── constants/
│   │   └── app_constants.dart    # Constantes globales
│   └── utils/
│       ├── image_constant.dart   # Constantes d'images
│       └── size_utils.dart       # Utilitaires de taille
│
├── presentation/
│   ├── welcomeScreen/
│   │   └── onboarding_screen.dart
│   ├── missionOverviewScreen/
│   │   └── onboarding_two_screen.dart
│   ├── gettingStartedScreen/
│   │   └── onboarding_three_screen.dart
│   ├── authentication_screen/
│   │   └── authentication_screen.dart
│   ├── account_registration_screen/
│   │   └── account_registration_screen.dart
│   ├── donorProfileSetupScreen/
│   │   ├── donorProfileSetupScreen.dart
│   │   └── widgets/
│   ├── blood_donation_menu_screen/
│   │   └── blood_donation_menu_screen.dart
│   ├── donors_list_screen/
│   │   └── donors_list_screen.dart
│   ├── create_donor_screen/
│   │   └── create_donor_screen.dart
│   ├── donation_campaign_list_screen/
│   │   ├── donation_campaign_list_screen.dart
│   │   └── widgets/
│   ├── blood_collection_centers_locator/
│   │   ├── blood_collection_centers_locator.dart
│   │   └── widgets/
│   ├── badges_management_screen/
│   │   ├── badges_management_screen.dart
│   │   └── widgets/
│   ├── test_results_history_page/
│   │   ├── test_results_history_page.dart
│   │   └── widgets/
│   └── digital_donor_card/
│       ├── digital_donor_card.dart
│       └── widgets/
│
├── services/
│   └── api_service.dart          # Service API principal
│
├── models/
│   ├── user.dart                 # Modèle utilisateur
│   ├── donor.dart                # Modèle donneur
│   ├── campaign.dart             # Modèle campagne
│   ├── badge.dart                # Modèle badge
│   └── models.dart               # Export centralisé
│
├── widgets/
│   ├── custom_button.dart
│   ├── custom_text_input.dart
│   ├── custom_image_view.dart
│   ├── custom_input_field.dart
│   └── custom_bottom_navigation.dart
│
├── theme/
│   ├── theme_helper.dart         # Thème principal
│   ├── text_style_helper.dart    # Styles de texte
│   └── custom_button_styles.dart # Styles de boutons
│
└── routes/
    └── app_routes.dart           # Configuration des routes
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
- Services pour l'état global

## 🔐 Sécurité et Bonnes Pratiques

### 1. **Authentification**

- Tokens JWT stockés de manière sécurisée
- Validation côté client et serveur
- Gestion de l'expiration des tokens

### 2. **Validation des Données**

- Validation des formulaires
- Sanitisation des entrées utilisateur
- Gestion des erreurs réseau

### 3. **Performance**

- Images mises en cache
- Lazy loading des données
- Optimisation des requêtes API

## 🧪 Architecture de Test

```
test/
├── unit/
│   ├── services/
│   │   └── api_service_test.dart
│   └── widgets/
│       └── custom_button_test.dart
│
├── integration/
│   ├── authentication_flow_test.dart
│   └── donor_registration_test.dart
│
└── widget/
    ├── screens/
    │   └── authentication_screen_test.dart
    └── widgets/
        └── custom_text_input_test.dart
```

## 🔄 CI/CD et Déploiement

### Pipeline de Développement

1. **Development** → Développement local
2. **Testing** → Tests automatisés
3. **Staging** → Tests d'intégration
4. **Production** → Déploiement final

### Environnements

```dart
// Configuration par environnement
class Config {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000/api'
  );
}
```

## 📈 Évolutivité et Maintenance

### 1. **Ajout de Nouvelles Fonctionnalités**

- Créer un nouveau dossier dans `presentation/`
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

---

Cette architecture modulaire garantit une base solide pour le développement, la maintenance et l'évolution future de l'application Blood Donation App.
