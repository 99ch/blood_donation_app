# 🩸 Blood Donation App

Une application mobile Flutter complète pour la gestion des dons de sang, développée pour connecter les donneurs, les centres de collecte et les organisateurs de campagnes.

## 📱 Aperçu

Cette application facilite le processus de don de sang en offrant une plateforme centralisée pour :

- L'inscription et l'authentification des donneurs
- La gestion des profils de donneurs
- La localisation des centres de collecte
- Le suivi des campagnes de don
- La gestion des badges et récompenses
- Le suivi de l'historique des tests et résultats

## ✨ Fonctionnalités

### 🔐 Authentification & Inscription

- Inscription sécurisée avec validation des données
- Connexion via email/mot de passe
- Gestion des sessions utilisateur

### 👤 Gestion des Profils

- Profil détaillé du donneur
- Informations médicales et groupe sanguin
- Historique des dons

### 🏥 Centres de Collecte

- Localisation des centres proches
- Informations détaillées (horaires, services, contact)
- Navigation intégrée

### 🎯 Campagnes de Don

- Liste des campagnes actives
- Participation aux campagnes
- Notifications d'urgence

### 🏆 Système de Badges

- Badges de récompense pour les donneurs réguliers
- Suivi des accomplissements
- Motivation gamifiée

### 📊 Suivi Médical

- Historique des tests sanguins
- Résultats d'analyses
- Carnet de santé numérique

## 🏗️ Architecture du Projet

Le projet suit une architecture modulaire organisée selon les bonnes pratiques Flutter :

```
lib/
├── core/                       # Configuration et utilitaires centraux
│   ├── app_export.dart        # Exports globaux
│   └── utils/                 # Utilitaires partagés
├── presentation/              # Couche de présentation (UI)
│   ├── account_registration_screen/
│   ├── authentication_screen/
│   ├── badges_management_screen/
│   ├── blood_collection_centers_locator/
│   ├── blood_donation_menu_screen/
│   ├── create_donor_screen/
│   ├── digital_donor_card/
│   ├── donation_campaign_list_screen/
│   ├── donorProfileSetupScreen/
│   ├── donors_list_screen/
│   ├── gettingStartedScreen/
│   ├── missionOverviewScreen/
│   ├── test_results_history_page/
│   └── welcomeScreen/
├── routes/                    # Gestion de la navigation
│   └── app_routes.dart
├── services/                  # Services et logique métier
│   └── api_service.dart       # Service API REST
├── theme/                     # Thème et styles
├── widgets/                   # Composants réutilisables
│   ├── custom_button.dart
│   ├── custom_image_view.dart
│   └── custom_text_input.dart
└── main.dart                  # Point d'entrée de l'application
```

### 📁 Description des Dossiers

#### `core/`

- **app_export.dart** : Centralise tous les imports nécessaires
- **utils/** : Fonctions utilitaires et helpers

#### `presentation/`

Contient tous les écrans de l'application, organisés par fonctionnalité :

- **Onboarding** : Écrans d'accueil et présentation
- **Authentication** : Connexion et inscription
- **Profile Management** : Gestion des profils donneurs
- **Centers & Campaigns** : Localisation et campagnes
- **Medical Tracking** : Suivi médical et badges

#### `services/`

- **api_service.dart** : Gestion des appels API REST
  - Authentification JWT
  - CRUD des donneurs
  - Gestion des badges
  - Suivi des campagnes

#### `widgets/`

Composants UI réutilisables :

- **CustomButton** : Boutons personnalisés
- **CustomTextInput** : Champs de saisie
- **CustomImageView** : Gestion des images

#### `routes/`

- **app_routes.dart** : Configuration de la navigation

## 🚀 Installation et Configuration

### Prérequis

- Flutter 3.6.0 ou supérieur
- Dart SDK compatible
- Android Studio / VS Code
- Appareil Android/iOS ou émulateur

### Installation

1. **Cloner le repository**

```bash
git clone https://github.com/99ch/blood_donation_app.git
cd blood_donation_app
```

2. **Installer les dépendances**

```bash
flutter pub get
```

3. **Configuration de l'API**
   Modifier l'URL de base dans `lib/services/api_service.dart` :

```dart
static const String baseUrl = 'https://votre-api.com/api';
```

4. **Lancer l'application**

```bash
flutter run
```

## 📦 Dépendances Principales

### Production

- **flutter_svg** : Gestion des images SVG
- **cached_network_image** : Cache d'images réseau
- **shared_preferences** : Stockage local
- **connectivity_plus** : Vérification de la connectivité
- **qr_flutter** : Génération de QR codes
- **url_launcher** : Ouverture d'URLs
- **http** : Requêtes HTTP

### Développement

- **flutter_test** : Tests unitaires
- **flutter_lints** : Linting du code
- **flutter_native_splash** : Écran de démarrage
- **flutter_launcher_icons** : Icônes d'application

## 🎨 Ressources

### Polices

- **Manrope** : Police principale (Regular, SemiBold, Bold)
- **Lexend** : Police alternative (Regular)

### Assets

- **icons/** : Icônes de l'application
- **images/** : Images et illustrations
- **fonts/** : Fichiers de polices

## 🔧 Configuration API

L'application communique avec un backend Django REST Framework via le service `ApiService`. Les endpoints principaux :

- `POST /auth/jwt/create/` : Authentification
- `POST /auth/users/` : Inscription
- `GET /auth/users/me/` : Profil utilisateur
- `GET|POST /donneurs/` : Gestion des donneurs
- `GET|POST /badges/` : Système de badges
- `GET /resultats/` : Résultats d'analyses

## 🔒 Sécurité

- Authentification JWT
- Validation des entrées utilisateur
- Gestion sécurisée des tokens
- Chiffrement des communications HTTPS

## 🧪 Tests

```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter drive --target=test_driver/app.dart
```

## 📱 Builds de Production

### Android

```bash
flutter build apk --release
# ou
flutter build appbundle --release
```

### iOS

```bash
flutter build ipa --release
```

## 🤝 Contribution

1. Fork le projet
2. Créer une branche pour votre feature (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Équipe

- **Développeur Principal** : [99ch](https://github.com/99ch)
- **Organisation** : AB-PROJECT EE

## 📞 Support

Pour toute question ou support :

- Créer une issue sur GitHub
- Contacter l'équipe de développement

---

_Développé avec ❤️ pour faciliter les dons de sang et sauver des vies._
