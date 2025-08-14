# 🔄 Documentation CI/CD - Blood Donation App

## Vue d'ensemble

Ce projet utilise **GitHub Actions** pour un système de CI/CD complet, automatisant les tests, builds, releases et déploiements. La configuration est optimisée pour GitHub Pro et inclut tous les workflows nécessaires pour un développement professionnel.

## 📁 Structure des Workflows

```
.github/
├── workflows/
│   ├── ci.yml                    # Tests et qualité de code
│   ├── build-android.yml         # Builds Android (APK/AAB)
│   ├── build-ios.yml            # Builds iOS (IPA)
│   ├── release.yml               # Releases automatiques
│   ├── deploy.yml                # Déploiements vers les stores
│   └── dependabot.yml            # Auto-merge Dependabot
└── dependabot.yml                # Configuration Dependabot
```

## 🔄 Workflows Détaillés

### 1. CI - Tests & Code Quality (`ci.yml`)

**Déclencheurs** : Push/PR sur `main`, `develop`, `api`

**Jobs** :
- ✅ **Test** : Tests unitaires, intégration, coverage
- 🔍 **Quality** : Formatage, analyse statique, dépendances
- 🔒 **Security** : Audit de sécurité, scan de données sensibles
- 🏗️ **Build Validation** : Compilation APK/Web pour validation

**Fonctionnalités** :
- Tests avec coverage uploadé vers Codecov
- Validation du formatage de code
- Détection de données sensibles
- Builds de validation (debug)

```yaml
# Exemple de déclenchement
on:
  push:
    branches: [ main, develop, api ]
  pull_request:
    branches: [ main, develop ]
```

### 2. Build Android (`build-android.yml`)

**Déclencheurs** : Push sur `main`, tags `v*`, workflow manuel

**Stratégie de matrice** : `debug` et `release`

**Fonctionnalités** :
- Configuration automatique d'environnement (.env)
- Build APK et AAB (release)
- Tests sur émulateur Android (PR uniquement)
- Upload d'artefacts avec rétention configurée
- Préparation pour Google Play Console

**Variables d'environnement par build** :
- **Debug** : `API_BASE_URL=http://127.0.0.1:8000/api`, logging activé
- **Release** : `API_BASE_URL=https://api.blooddonation.com/api`, logging désactivé

### 3. Build iOS (`build-ios.yml`)

**Déclencheurs** : Push sur `main`, tags `v*`, workflow manuel

**Stratégie de matrice** : `debug` et `release`

**Fonctionnalités** :
- Configuration CocoaPods automatique
- Support de la signature de code (à configurer)
- Tests sur simulateur iOS (PR uniquement)
- Builds optimisés pour App Store
- Préparation pour TestFlight/App Store

**Note** : Les builds de release nécessitent la configuration des certificats iOS.

### 4. Release Automatique (`release.yml`)

**Déclencheurs** : Tags `v*`, releases publiées, workflow manuel

**Pipeline complet** :
1. **Validation pré-release** : Tests complets, mise à jour version
2. **Build Android release** : APK + AAB signés
3. **Build iOS release** : IPA (avec signature configurée)
4. **Création GitHub Release** : Notes automatiques, assets
5. **Notifications post-release** : Résumé et prochaines étapes

**Fonctionnalités avancées** :
- Génération automatique des notes de release
- Numérotation de build automatique
- Validation complète avant release
- Upload des artefacts vers GitHub Releases

### 5. Déploiement Stores (`deploy.yml`)

**Déclencheur** : Workflow manuel uniquement (sécurité)

**Targets supportés** :
- Google Play (Internal/Alpha/Beta/Production)
- App Store (TestFlight/Production)
- Firebase App Distribution
- All Stores (déploiement complet)

**Fonctionnalités** :
- Validation des assets de release
- Déploiement conditionnel par target
- Intégration Google Play Console API
- Support App Store Connect API
- Notifications post-déploiement

### 6. Dependabot Auto-merge (`dependabot.yml`)

**Déclencheurs** : PRs Dependabot

**Critères d'auto-merge** :
- Patch updates pour dépendances directes
- Toutes les mises à jour pour dépendances indirectes
- Mises à jour de sécurité (toujours)

**Processus** :
1. Tests automatiques
2. Évaluation des critères
3. Approbation + auto-merge si éligible
4. Commentaire si review manuelle requise

## 🔐 Secrets GitHub Requis

### Secrets de Base
```
CODECOV_TOKEN              # Token Codecov pour coverage
GITHUB_TOKEN              # Token GitHub (automatique)
```

### Secrets Android
```
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON    # Service account Google Play
KEYSTORE_FILE                       # Keystore Android (base64)
KEYSTORE_PASSWORD                   # Mot de passe keystore
KEY_ALIAS                          # Alias de la clé
KEY_PASSWORD                       # Mot de passe de la clé
```

### Secrets iOS
```
IOS_CERTIFICATE_BASE64             # Certificat iOS (base64)
IOS_CERTIFICATE_PASSWORD           # Mot de passe certificat
IOS_PROVISIONING_PROFILE_BASE64    # Profil de provisioning
APP_STORE_CONNECT_API_KEY_ID       # ID clé App Store Connect
APP_STORE_CONNECT_ISSUER_ID        # Issuer ID ASC
APP_STORE_CONNECT_API_KEY_CONTENT  # Contenu clé .p8 (base64)
KEYCHAIN_PASSWORD                  # Mot de passe keychain temporaire
```

### Secrets Firebase/Notifications
```
FIREBASE_APP_ID                    # ID app Firebase
FIREBASE_TOKEN                     # Token Firebase CLI
SLACK_WEBHOOK_URL                  # URL webhook Slack (optionnel)
```

## 🚀 Guide d'Utilisation

### Développement Quotidien

1. **Push/PR vers develop** → Déclenchement automatique de CI
2. **Tests échouent** → Fix et re-push
3. **PR approuvée** → Merge vers main

### Création d'une Release

```bash
# Méthode 1: Tag git
git tag v1.2.0
git push origin v1.2.0

# Méthode 2: Workflow manuel
# GitHub → Actions → Release → Run workflow
# Spécifier version et type (patch/minor/major)
```

### Déploiement en Production

```bash
# GitHub → Actions → Deploy to Stores → Run workflow
# Sélectionner:
# - Target: google-play-production / app-store-production / all-stores
# - Version tag: v1.2.0
# - Release notes: Description du déploiement
```

## 📊 Monitoring et Métriques

### Dashboards Disponibles
- **GitHub Actions** : Historique des runs, durées, success rate
- **Codecov** : Coverage des tests, évolution
- **Artifact Storage** : Utilisation de l'espace

### Métriques Clés
- ✅ **Success Rate** : % de builds réussis
- ⏱️ **Build Time** : Durée moyenne des workflows
- 🧪 **Test Coverage** : Pourcentage de code couvert
- 📦 **Artifact Size** : Taille des APK/IPA

## 🛠️ Configuration et Maintenance

### Variables d'Environnement

| Environnement | API_BASE_URL | ENABLE_LOGGING |
|--------------|-------------|----------------|
| Development | `http://127.0.0.1:8000/api` | `true` |
| Test | `http://127.0.0.1:8000/api` | `true` |
| Staging | `https://staging-api.blooddonation.com/api` | `true` |
| Production | `https://api.blooddonation.com/api` | `false` |

### Branches et Stratégie

```
main           # Production, releases uniquement
develop        # Développement principal, CI complet
feature/*      # Fonctionnalités, CI sur PR
hotfix/*       # Corrections urgentes
api            # Intégration API, CI complet
```

### Rétention des Artefacts

| Type | Durée | Usage |
|------|-------|-------|
| Debug builds | 7 jours | Tests et validation |
| Test results | 7 jours | Debugging |
| Release APK/AAB | 90 jours | Distribution |
| Release IPA | 90 jours | App Store |
| Coverage reports | 30 jours | Métriques |

## 🚨 Troubleshooting

### Problèmes Courants

**Build Android échoue** :
```bash
# Vérifier la configuration Java
# Logs: "Setup Java JDK" step
# Solution: Vérifier gradle.properties et build.gradle
```

**Tests iOS échouent** :
```bash
# Vérifier CocoaPods
# Logs: "Setup CocoaPods" step
# Solution: Nettoyer ios/Podfile.lock
```

**Déploiement échoue** :
```bash
# Vérifier les secrets GitHub
# Logs: API authentication steps
# Solution: Renouveler tokens/certificats
```

### Commandes de Debug

```bash
# Vérifier les workflows localement
act -j test  # Simuler le job "test"

# Analyser les logs
gh run list --workflow=ci.yml
gh run view RUN_ID --log

# Télécharger les artefacts
gh run download RUN_ID
```

## 📈 Optimisations et Améliorations

### Performances
- ✅ Cache Flutter/Gradle/CocoaPods configuré
- ✅ Builds en parallèle avec matrix strategy
- ✅ Timeout configurés pour éviter les blocages
- 🔄 Possible : Cache Docker pour builds plus rapides

### Sécurité
- ✅ Secrets centralisés et chiffrés
- ✅ Scan automatique des dépendances
- ✅ Validation des permissions
- 🔄 Possible : Scan SAST/DAST intégré

### Notifications
- ✅ Résumés détaillés dans GitHub
- ✅ Artefacts avec métriques
- 🔄 Possible : Intégration Slack/Discord/Email

## 🔄 Évolutions Futures

### À Court Terme
1. **Configuration signature iOS** complète
2. **Intégration Google Play Console API** active
3. **Tests E2E** sur vrais devices
4. **Notifications Slack/Discord**

### À Moyen Terme
1. **Deployment staging automatique**
2. **A/B Testing integration**
3. **Performance monitoring** intégré
4. **Auto-rollback** en cas de problème

### À Long Terme
1. **Multi-environment matrix**
2. **Progressive deployment**
3. **ML-based test optimization**
4. **Infrastructure as Code** complet

---

**Dernière mise à jour** : Août 2025  
**Version CI/CD** : 1.0.0  
**Compatibilité** : GitHub Pro, Flutter 3.6.0+