# 🔧 Guide d'Intégration Backend-Frontend

## Vue d'ensemble de l'intégration

Cette documentation explique comment configurer et utiliser l'application Flutter avec l'API Django REST pour le système de gestion des dons de sang.

## 📋 Prérequis

### Backend Django

- Python 3.8+
- Django 4.2.21
- Django REST Framework
- Base de données configurée (SQLite par défaut)
- Redis pour Celery (optionnel)

### Frontend Flutter

- Flutter SDK 3.6.0+
- Dart 3.0+
- Android Studio / VS Code
- Émulateur ou appareil physique

## 🚀 Configuration rapide

### 1. Démarrer le backend Django

```bash
cd /path/to/don-de-sang
python -m venv venv
source venv/bin/activate  # Sur macOS/Linux
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

L'API sera disponible sur `http://127.0.0.1:8000/api/`

### 2. Configurer l'application Flutter

```bash
cd /path/to/blood_donation_app
flutter pub get
flutter run
```

### 3. Configuration de l'URL API

L'application Flutter offre plusieurs méthodes pour configurer l'URL API :

#### Méthode 1 : Écran de configuration API (Recommandé)
1. Ouvrir l'application Flutter
2. Naviguer vers l'écran de configuration API
3. Choisir parmi les URLs prédéfinies ou saisir une URL personnalisée
4. Tester la connexion avec le bouton "Tester la connexion"
5. Sauvegarder les paramètres

#### Méthode 2 : Fichier .env
1. Créer/éditer le fichier `.env` à la racine du projet Flutter
2. Ajouter : `API_BASE_URL=http://127.0.0.1:8000/api`
3. Redémarrer l'application

#### URLs prédéfinies disponibles :
- **Local Django** : `http://localhost:8000/api`
- **Local Django (IP)** : `http://127.0.0.1:8000/api`
- **Staging** : `https://staging-api.blooddonation.com/api`
- **Production** : `https://api.blooddonation.com/api`

## 🔗 Endpoints mappés

### Authentification

| Flutter Method        | Django Endpoint              | Description                  |
| --------------------- | ---------------------------- | ---------------------------- |
| `login()`             | `POST /auth/jwt/create/`     | Connexion utilisateur        |
| `register()`          | `POST /auth/users/`          | Inscription utilisateur      |
| `registerUnified()`   | `POST /register/complete/`   | Inscription unifiée complète |
| `refreshToken()`      | `POST /auth/jwt/refresh/`    | Rafraîchissement token       |
| `getCurrentUser()`    | `GET /auth/users/me/`        | Profil utilisateur           |
| `completeProfile()`   | `POST /profile/complete/`    | Complétion profil donneur    |

### Gestion des Donneurs

| Flutter Method          | Django Endpoint                        | Description        |
| ----------------------- | -------------------------------------- | ------------------ |
| `getDonneurs()`         | `GET /donneurs/`                       | Liste des donneurs |
| `createDonneur()`       | `POST /donneurs/`                      | Créer un donneur   |
| `updateDonneur()`       | `PUT /donneurs/{id}/`                  | Modifier un donneur|
| `searchDonneurByName()` | `GET /donneurs/by_nom_prenom/`         | Recherche par nom  |
| `enregistrerDon()`      | `POST /donneurs/{id}/enregistrer_don/` | Enregistrer un don |

### Gestion des Dons

| Flutter Method | Django Endpoint | Description    |
| -------------- | --------------- | -------------- |
| `getDons()`    | `GET /dons/`    | Liste des dons |
| `creerDon()`   | `POST /dons/`   | Créer un don   |
| `createDon()`  | `POST /dons/`   | Créer un don (alias) |

### Résultats d'Analyse

| Flutter Method               | Django Endpoint                               | Description         |
| ---------------------------- | --------------------------------------------- | ------------------- |
| `getResultatsAnalyse()`      | `GET /resultats/`                             | Liste des résultats |
| `ajouterResultatAnalyse()`   | `POST /resultats/{id}/ajouter_resultat/`      | Ajouter résultat    |
| `verifierAnalyse()`          | `POST /resultats/{id}/verifier_analyse/`      | Vérifier résultat   |
| `envoyerResultatsVerifies()` | `POST /resultats/envoyer_resultats_verifies/` | Envoyer par email   |

### Gestion des Badges

| Flutter Method   | Django Endpoint | Description      |
| ---------------- | --------------- | ---------------- |
| `getBadges()`    | `GET /badges/`  | Liste des badges |
| `genererBadge()` | `POST /badges/` | Générer un badge (PDF/JSON) |

## 📱 Modèles de données alignés

### Modèle Donor (Flutter) ↔ Donneur (Django)

```dart
// Flutter
class Donor {
  final int? id;
  final int? user;                 // → user (ForeignKey)
  final String nom;                // → nom
  final String prenoms;            // → prenoms
  final String email;              // → email
  final String telephone;          // → telephone
  final DateTime dateNaissance;    // → date_de_naissance
  final String? groupeSanguin;     // → groupe_sanguin
  final String? localisation;      // → localisation
  final double? poids;             // → poids
  final double? taille;            // → taille
  final String pays;               // → pays
  final int nbDons;                // → nb_dons
  final double litresDonnes;       // → litres_donnes
  final bool isVerified;           // → is_verified
}
```

## 🔒 Authentification JWT

### Configuration actuelle

- **Type** : Bearer Token
- **Header** : `Authorization: Bearer {token}`
- **Expiration** : Configurable côté Django
- **Refresh** : Automatique avant expiration

### Flux d'authentification

1. Utilisateur se connecte → Reçoit `access` + `refresh` tokens
2. Stockage sécurisé avec `SharedPreferences`
3. Validation automatique avant chaque requête
4. Rafraîchissement automatique si nécessaire
5. Redirection vers login si échec

## 🛠️ Services créés/améliorés

### 1. ApiService amélioré

- **Fichier** : `lib/services/api_service.dart`
- **Améliorations** :
  - Configuration dynamique via `AppConfig.apiBaseUrl`
  - Gestion complète des erreurs avec logging automatique
  - Support des uploads de fichiers multipart
  - Méthodes pour tous les endpoints Django
  - Auto-refresh des tokens JWT
  - Support de l'inscription unifiée (`registerUnified`)

### 2. AuthService refactorisé

- **Fichier** : `lib/services/auth_service.dart`
- **Fonctionnalités** :
  - Gestion intelligente des sessions JWT
  - Auto-refresh automatique des tokens avant expiration
  - Cache des données utilisateur et donneur
  - Détection du statut staff/admin
  - Navigation intelligente selon l'état d'authentification
  - Méthodes utilitaires (`getDonorId`, `hasDonorProfile`)

### 3. Services additionnels

- **NotificationService** : `lib/services/notification_service.dart`
- **RegistrationDataService** : `lib/services/registration_data_service.dart`
- **ApiTestService** : `lib/services/api_test_service.dart`

### 4. Modèles mis à jour

- **Donor** : `lib/models/donor.dart` (legacy) + `lib/models/donor_updated.dart`
- **NotificationModel** : `lib/models/notification.dart` (nouveau)
- **ResultatAnalyse** : `lib/models/resultat_analyse.dart`
- **Don** : `lib/models/don.dart`

## 🎯 Points d'attention

### 1. Configuration CORS (Django)

Assurez-vous que Django autorise les requêtes depuis l'app mobile :

```python
# settings.py
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
]

CORS_ALLOW_ALL_ORIGINS = True  # Pour le développement uniquement
```

### 2. Gestion des erreurs réseau

```dart
// Exemple de gestion dans Flutter
try {
  final result = await apiService.getDonneurs(token);
  if (result != null) {
    // Succès
  } else {
    // Erreur API
  }
} catch (e) {
  // Erreur réseau/exception
}
```

### 3. Upload de fichiers

Pour les résultats d'analyse PDF :

```dart
await apiService.ajouterResultatAnalyse(token, donneurId, filePath);
```

## 🧪 Tests et débogage

### 1. Écran de debug API

- Accessible depuis l'écran de connexion
- Teste tous les endpoints
- Affiche les réponses détaillées

### 2. Configuration d'URL dynamique

- Écran dédié pour changer l'URL API
- Presets pour différents environnements
- Test de connexion intégré

### 3. Logs détaillés

```
✅ API Success: POST http://localhost:8000/api/auth/jwt/create/
Status Code: 200

❌ API Error: GET http://localhost:8000/api/donneurs/
Status Code: 401
Response: {"detail":"Authentication credentials were not provided."}
```

## 🔄 Workflow de développement

### 1. Développement backend

```bash
# Terminal 1 - Django
cd don-de-sang
python manage.py runserver

# Terminal 2 - Celery (optionnel)
celery -A don_de_sang worker --loglevel=info
```

### 2. Développement frontend

```bash
# Terminal 3 - Flutter
cd blood_donation_app
flutter run
```

### 3. Tests d'intégration

1. Créer un compte utilisateur
2. Créer un profil donneur
3. Tester les fonctionnalités CRUD
4. Vérifier la synchronisation des données

## 📚 Documentation supplémentaire

- **API Django** : `http://localhost:8000/swagger/`
- **Architecture Flutter** : `ARCHITECTURE.md`
- **Documentation API** : `API_DOCUMENTATION.md`

## 🐛 Résolution des problèmes courants

### Erreur "Connection refused"

- Vérifier que Django fonctionne sur `localhost:8000`
- Contrôler l'URL API dans l'app Flutter
- S'assurer que l'émulateur peut accéder à localhost

### Erreur 401 Unauthorized

- Vérifier la validité du token JWT
- Contrôler le format de l'header Authorization
- Tester la connexion utilisateur

### Erreur CORS

- Configurer `django-cors-headers`
- Ajouter l'origine de l'app mobile
- Vérifier les headers de requête

## 📈 Prochaines améliorations

1. **Tests automatisés** d'intégration
2. **Configuration d'environnement** (dev/staging/prod)
3. **Gestion offline** avec synchronisation
4. **Push notifications** pour les campagnes urgentes
5. **Géolocalisation** pour les centres proches
6. **Graphiques et statistiques** temps réel

---
