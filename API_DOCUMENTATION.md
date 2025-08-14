# 📡 Documentation API - Blood Donation App

## Vue d'ensemble

L'application Blood Donation App communique avec un backend Django REST Framework. Cette documentation présente tous les endpoints disponibles et leur utilisation.

## 🔧 Configuration de Base

- **URL de Base** : `http://127.0.0.1:8000/api` (développement) - Configurable via fichier .env ou écran de configuration API
- **Format** : JSON
- **Authentification** : JWT (JSON Web Tokens) avec refresh automatique
- **Version API** : v1
- **Headers par défaut** : `Content-Type: application/json`, `Accept: application/json`

## 🔐 Authentification

### Inscription unifiée (Recommandé)

```http
POST /register/complete/
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "motdepasse123",
  "nom": "Dupont",
  "prenoms": "Jean",
  "telephone": "+33123456789",
  "date_de_naissance": "1990-01-15",
  "pays": "benin"
}
```

**Réponse (201 Created)**

```json
{
  "success": true,
  "user": {
    "id": 1,
    "email": "user@example.com",
    "first_name": "Jean",
    "last_name": "Dupont"
  },
  "donneur": {
    "id": 1,
    "nom": "Dupont",
    "prenoms": "Jean",
    "email": "user@example.com",
    "telephone": "+33123456789",
    "date_de_naissance": "1990-01-15",
    "pays": "benin"
  },
  "message": "Inscription complète réussie"
}
```

### Inscription d'un utilisateur (Classique)

```http
POST /auth/users/
Content-Type: application/json

{
  "username": "user@example.com",
  "email": "user@example.com",
  "password": "motdepasse123"
}
```

**Réponse (201 Created)**

```json
{
  "id": 1,
  "username": "user@example.com",
  "email": "user@example.com",
  "first_name": "Jean",
  "last_name": "Dupont",
  "date_joined": "2025-07-29T10:00:00Z"
}
```

### Connexion (Obtenir un token JWT)

```http
POST /auth/jwt/create/
Content-Type: application/json

{
  "username": "user@example.com",
  "password": "motdepasse123"
}
```

**Réponse (200 OK)**

```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

### Rafraîchir le token

```http
POST /auth/jwt/refresh/
Content-Type: application/json

{
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

### Profil utilisateur actuel

```http
GET /auth/users/me/
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...
```

### Complétion du profil donneur

```http
POST /profile/complete/
Content-Type: application/json

{
  "email": "user@example.com",
  "groupe_sanguin": "O+",
  "localisation": "Paris",
  "poids": 70.5,
  "taille": 1750
}
```

## 👤 Gestion des Donneurs

### Liste des donneurs

```http
GET /donneurs/
Authorization: Bearer {token}
```

**Réponse (200 OK)**

```json
[
  {
    "id": 1,
    "user": 1,
    "nom": "Dupont",
    "prenoms": "Jean",
    "email": "jean.dupont@email.com",
    "telephone": "+33123456789",
    "date_de_naissance": "1990-01-15",
    "groupe_sanguin": "O+",
    "localisation": "Paris",
    "poids": 70.5,
    "taille": 1750,
    "pays": "benin",
    "nb_dons": 5,
    "litres_donnes": 2.5,
    "is_verified": true,
    "date_creation": "2025-01-01T10:00:00Z",
    "date_modification": "2025-07-29T10:00:00Z"
  }
]
```

### Créer un donneur

```http
POST /donneurs/
Authorization: Bearer {token}
Content-Type: application/json

{
  "nom": "Martin",
  "prenoms": "Marie",
  "email": "marie.martin@email.com",
  "telephone": "+33987654321",
  "date_de_naissance": "1985-03-20",
  "groupe_sanguin": "A+",
  "localisation": "Lyon",
  "poids": 65.0,
  "taille": 1650,
  "pays": "benin"
}
```

### Détails d'un donneur

```http
GET /donneurs/{id}/
Authorization: Bearer {token}
```

### Modifier un donneur

```http
PUT /donneurs/{id}/
Authorization: Bearer {token}
Content-Type: application/json

{
  "nom": "Martin",
  "prenoms": "Marie-Claire",
  "telephone": "+33987654322",
  "groupe_sanguin": "A+",
  "poids": 66.0
}
```

### Rechercher un donneur par nom

```http
GET /donneurs/by_nom_prenom/?nom=Martin&prenoms=Marie&date_de_naissance=1985-03-20
Authorization: Bearer {token}
```

### Enregistrer un don

```http
POST /donneurs/{id}/enregistrer_don/
Authorization: Bearer {token}
Content-Type: application/json

{
  "litres_donnes": 0.5
}
```

### Supprimer un donneur

```http
DELETE /donneurs/{id}/
Authorization: Bearer {token}
```

## 🏆 Système de Badges

### Liste des badges

```http
GET /badges/
Authorization: Bearer {token}
```

**Réponse (200 OK)**

```json
[
  {
    "id": 1,
    "nom": "Premier Don",
    "description": "Félicitations pour votre premier don !",
    "type": "first_donation",
    "seuil": 1,
    "couleur": "#4CAF50",
    "date_obtention": "2025-01-15T10:00:00Z",
    "donneur_id": 1,
    "obtenu": true
  }
]
```

### Créer/Attribuer un badge

```http
POST /badges/
Authorization: Bearer {token}
Content-Type: application/json

{
  "donneur": 1,
  "type": "regular_donor"
}
```

### Badges d'un donneur spécifique

```http
GET /donneurs/{donneur_id}/badges/
Authorization: Bearer {token}
```

## 📊 Résultats d'Analyses

### Liste des résultats

```http
GET /resultats/
Authorization: Bearer {token}
```

**Réponse (200 OK)**

```json
[
  {
    "id": 1,
    "donneur_id": 1,
    "date_analyse": "2025-07-20",
    "type_analyse": "Sérologie complète",
    "resultats": {
      "hiv": "négatif",
      "hepatite_b": "négatif",
      "hepatite_c": "négatif",
      "syphilis": "négatif"
    },
    "fichier_pdf": "http://localhost:8000/media/resultats/analyse_1.pdf",
    "date_creation": "2025-07-20T14:30:00Z"
  }
]
```

### Ajouter un résultat d'analyse

```http
POST /resultats/{donneur_id}/ajouter_resultat/
Authorization: Bearer {token}
Content-Type: multipart/form-data

fichier_pdf: [fichier PDF]
```

### Vérifier une analyse (Staff uniquement)

```http
POST /resultats/{analyse_id}/verifier_analyse/
Authorization: Bearer {token}
```

### Envoyer les résultats vérifiés par email

```http
POST /resultats/envoyer_resultats_verifies/
Authorization: Bearer {token}
```

## 🎯 Campagnes de Don

### Liste des campagnes

```http
GET /campagnes/
```

**Réponse (200 OK)**

```json
[
  {
    "id": 1,
    "titre": "Collecte Universitaire",
    "description": "Collecte organisée à l'université",
    "date": "2025-08-15",
    "lieu": "Campus Universitaire - Amphi A",
    "heures": "9h00 - 17h00",
    "objectif": 50,
    "participants_actuels": 23,
    "organisateur": "AB-PROJECT EE",
    "urgence": "normale",
    "types_sanguins_recherches": "O+,O-,A+",
    "active": true
  }
]
```

### Créer une campagne

```http
POST /campagnes/
Authorization: Bearer {token}
Content-Type: application/json

{
  "titre": "Urgence Plaquettes",
  "description": "Collecte urgente de plaquettes",
  "date": "2025-08-02",
  "lieu": "Hôpital Central",
  "heures": "8h00 - 20h00",
  "objectif": 30,
  "organisateur": "Hôpital Central",
  "urgence": "haute"
}
```

### Campagnes urgentes

```http
GET /campagnes/urgentes/
```

### S'inscrire à une campagne

```http
POST /campagnes/{id}/inscrire/
Authorization: Bearer {token}
```

## 🏥 Centres de Collecte

### Liste des centres

```http
GET /centres/
```

**Réponse (200 OK)**

```json
[
  {
    "id": 1,
    "nom": "Centre de Don Central",
    "adresse": "123 Rue de la Santé, Paris 75001",
    "telephone": "+33 1 42 34 56 78",
    "email": "contact@centre-don.fr",
    "heures_ouverture": "Lun-Ven: 8h-18h, Sam: 9h-15h",
    "latitude": 48.8566,
    "longitude": 2.3522,
    "services": ["Don de sang", "Don de plasma", "Don de plaquettes"],
    "active": true
  }
]
```

### Détails d'un centre

```http
GET /centres/{id}/
```

## 💉 Gestion des Dons

### Liste des dons

```http
GET /dons/
Authorization: Bearer {token}
```

### Créer un don

```http
POST /dons/
Authorization: Bearer {token}
Content-Type: application/json

{
  "donneur": 1,
  "campagne": 1,
  "date_don": "2025-08-15",
  "litres_donnes": 0.5
}
```

## 📱 Notifications

### Liste des notifications utilisateur

```http
GET /notifications/
Authorization: Bearer {token}
```

**Réponse (200 OK)**

```json
{
  "results": [
    {
      "id": 1,
      "titre": "Nouvelle campagne urgente",
      "message": "Une campagne urgente a été créée près de chez vous.",
      "type": "urgent",
      "lue": false,
      "date_creation": "2025-08-01T10:00:00Z",
      "donnees": {
        "campagne_id": 5
      }
    }
  ]
}
```

### Marquer une notification comme lue

```http
PATCH /notifications/{id}/marquer_lue/
Authorization: Bearer {token}
Content-Type: application/json

{
  "lue": true
}
```

### Marquer toutes les notifications comme lues

```http
POST /notifications/marquer_toutes_lues/
Authorization: Bearer {token}
```

### Supprimer une notification

```http
DELETE /notifications/{id}/
Authorization: Bearer {token}
```

## 📊 Statistiques

### Statistiques générales

```http
GET /statistiques/
Authorization: Bearer {token}
```

**Réponse (200 OK)**

```json
{
  "total_donneurs": 1250,
  "total_dons": 4580,
  "campagnes_actives": 12,
  "urgences_en_cours": 3,
  "dons_ce_mois": 287,
  "nouveaux_donneurs_ce_mois": 45
}
```

### Statistiques d'un donneur

```http
GET /donneurs/{id}/statistiques/
Authorization: Bearer {token}
```

## 🔍 Recherche et Filtres

### Rechercher des donneurs

```http
GET /donneurs/?nom=jean&groupe_sanguin=O+&localisation=Paris
Authorization: Bearer {token}
```

### Filtrer les campagnes

```http
GET /campagnes/?urgence=haute&date_debut=2025-08-01&date_fin=2025-08-31
```

### Centres proches d'une position

```http
GET /centres/proches/?latitude=48.8566&longitude=2.3522
```

## 📄 Pagination

La plupart des endpoints supportent la pagination :

```http
GET /donneurs/?page=2&page_size=20
```

**Réponse avec pagination**

```json
{
  "count": 100,
  "next": "http://localhost:8000/api/donneurs/?page=3",
  "previous": "http://localhost:8000/api/donneurs/?page=1",
  "results": [...]
}
```

## ⚠️ Codes d'Erreur

| Code | Description           |
| ---- | --------------------- |
| 200  | Succès                |
| 201  | Créé avec succès      |
| 400  | Requête invalide      |
| 401  | Non authentifié       |
| 403  | Accès interdit        |
| 404  | Ressource non trouvée |
| 429  | Trop de requêtes      |
| 500  | Erreur serveur        |

## 🔒 Sécurité

### Headers requis

```http
Authorization: Bearer {jwt_token}
Content-Type: application/json
X-API-Version: v1
```

### Limites de taux

- **Authentification** : 5 tentatives/minute
- **API générale** : 1000 requêtes/heure
- **Upload de fichiers** : 10 fichiers/minute

## 🧪 Environnements

### Développement

- URL : `http://127.0.0.1:8000/api` (configurable)
- Documentation : `http://127.0.0.1:8000/swagger/`
- Configuration : Via fichier `.env` ou écran de configuration API dans l'app

### Test/Staging

- URL : `https://staging-api.blood-donation.com/api`
- Documentation : `https://staging-api.blood-donation.com/swagger/`

### Production

- URL : `https://api.blood-donation.com/api`
- Documentation : `https://api.blood-donation.com/swagger/`

## 📲 Configuration de l'App Mobile

### Changement d'URL API

L'application Flutter permet de configurer l'URL API de plusieurs façons :

1. **Via l'écran de configuration** : Accessible depuis l'authentification
2. **Via le fichier .env** :
   ```
   API_BASE_URL=http://127.0.0.1:8000/api
   ENVIRONMENT=development
   ENABLE_LOGGING=true
   ```

### URLs prédéfinies disponibles

- **Local Django** : `http://localhost:8000/api`
- **Local Django (IP)** : `http://127.0.0.1:8000/api`
- **Staging** : `https://staging-api.blooddonation.com/api`
- **Production** : `https://api.blooddonation.com/api`

## 🔄 Fonctionnalités Avancées

### Logging automatique

L'application Flutter inclut un système de logging automatique pour toutes les requêtes API :
- ✅ Succès : `API Success: POST http://127.0.0.1:8000/api/auth/jwt/create/`
- ❌ Erreurs : `API Error: GET http://127.0.0.1:8000/api/donneurs/ - Status Code: 401`

### Gestion automatique des tokens

- Rafraîchissement automatique des tokens JWT avant expiration
- Stockage sécurisé avec SharedPreferences
- Redirection automatique vers la connexion si le token expire

### Validation des formulaires

- Validation côté client avant envoi
- Messages d'erreur localisés
- Gestion des erreurs réseau avec retry automatique

---

_Cette documentation est maintenue à jour avec chaque version de l'API. Dernière mise à jour : Août 2025_
