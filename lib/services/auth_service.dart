import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/api_service.dart';

/// Service de gestion de l'authentification et des sessions amélioré
class AuthService {
  static const String _tokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';
  static const String _donorKey = 'donor_data';

  // Instance singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Vérifie si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      print('🔐 AuthService.isLoggedIn: Token présent = ${token != null}');

      if (token == null || token.isEmpty) {
        print('❌ AuthService.isLoggedIn: Pas de token');
        return false;
      }

      // Pour le moment, on considère que si on a un token, on est connecté
      // Dans un vrai environnement, il faudrait valider le token côté serveur
      print('✅ AuthService.isLoggedIn: Token trouvé, utilisateur connecté');
      return true;
    } catch (e) {
      print('❌ Erreur vérification connexion: $e');
      return false;
    }
  }

  /// Valide un token JWT
  static Future<bool> _validateToken(String token) async {
    try {
      // Décoder le JWT pour vérifier l'expiration
      final parts = token.split('.');
      if (parts.length != 3) return false;

      final payload = json
          .decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));

      final exp = payload['exp'];
      if (exp == null) return false;

      final expiration = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      // Si le token expire dans moins de 5 minutes, essayer de le rafraîchir
      if (expiration.difference(now).inMinutes < 5) {
        return await refreshAccessToken();
      }

      return now.isBefore(expiration);
    } catch (e) {
      print('Erreur validation token: $e');
      return false;
    }
  }

  /// Connecter un utilisateur
  static Future<bool> login(String email, String password) async {
    try {
      print('🔐 AuthService.login: Tentative de connexion pour $email');

      final apiService = ApiService();
      final result = await apiService.login(email, password);

      print('🔐 AuthService.login: Résultat API = ${result != null}');

      if (result != null && result['access'] != null) {
        print('🔐 AuthService.login: Tokens reçus, sauvegarde...');

        final success = await saveTokens(
          accessToken: result['access'],
          refreshToken: result['refresh'] ?? '',
        );

        print('🔐 AuthService.login: Sauvegarde tokens = $success');

        if (success) {
          // Récupérer les informations utilisateur
          await _loadUserData(result['access']);
          print('✅ AuthService.login: Connexion réussie');
          return true;
        }
      }

      print('❌ AuthService.login: Échec de la connexion');
      return false;
    } catch (e) {
      print('❌ Erreur lors de la connexion: $e');
      return false;
    }
  }

  /// Inscrire un nouvel utilisateur
  static Future<bool> register(String email, String password) async {
    try {
      final apiService = ApiService();
      final result = await apiService.register(email, password);

      if (result != null) {
        // Après inscription, connecter automatiquement
        return await login(email, password);
      }

      return false;
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      return false;
    }
  }

  /// Charger les données utilisateur après connexion
  static Future<void> _loadUserData(String token) async {
    try {
      final apiService = ApiService();
      final userData = await apiService.getCurrentUser(token);

      if (userData != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, json.encode(userData));
      }

      // Essayer de récupérer les données de donneur
      final donorData = await apiService.getDonneurs(token);
      if (donorData != null && donorData.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_donorKey, json.encode(donorData.first));
      }
    } catch (e) {
      print('Erreur lors du chargement des données utilisateur: $e');
    }
  }

  /// Stocke les tokens d'authentification
  static Future<bool> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      print('🔐 AuthService.saveTokens: Sauvegarde des tokens...');

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_tokenKey, accessToken);
      await prefs.setString(_refreshTokenKey, refreshToken);

      // Vérifier que la sauvegarde a fonctionné
      final savedToken = prefs.getString(_tokenKey);
      final success = savedToken == accessToken;

      print(
          '🔐 AuthService.saveTokens: Token sauvegardé = ${savedToken != null}');
      print('🔐 AuthService.saveTokens: Succès = $success');

      return success;
    } catch (e) {
      print('❌ Erreur sauvegarde tokens: $e');
      return false;
    }
  }

  /// Récupère le token d'accès
  static Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Erreur récupération token: $e');
      return null;
    }
  }

  /// Récupère le token de rafraîchissement
  static Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (e) {
      print('Erreur récupération refresh token: $e');
      return null;
    }
  }

  /// Récupère les données utilisateur stockées
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);

      if (userData != null) {
        return json.decode(userData);
      }
      return null;
    } catch (e) {
      print('Erreur récupération données utilisateur: $e');
      return null;
    }
  }

  /// Récupère les données de donneur stockées
  static Future<Map<String, dynamic>?> getDonorData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final donorData = prefs.getString(_donorKey);

      if (donorData != null) {
        return json.decode(donorData);
      }
      return null;
    } catch (e) {
      print('Erreur récupération données donneur: $e');
      return null;
    }
  }

  /// Rafraîchit le token d'accès
  static Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      final response = await ApiService.refreshToken(refreshToken);

      if (response['success'] == true) {
        final tokens = response['data'];
        await saveTokens(
          accessToken: tokens['access'],
          refreshToken: tokens['refresh'] ?? refreshToken,
        );
        return true;
      }

      return false;
    } catch (e) {
      print('Erreur rafraîchissement token: $e');
      return false;
    }
  }

  /// Déconnecte l'utilisateur
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_userKey);
      await prefs.remove(_donorKey);
    } catch (e) {
      print('Erreur déconnexion: $e');
    }
  }

  /// Détermine la route initiale selon l'état d'authentification
  static Future<String> getInitialRoute() async {
    final isAuthenticated = await isLoggedIn();

    if (isAuthenticated) {
      return '/blood_donation_menu_screen';
    } else {
      return '/onboarding_three_screen'; // GettingStartedScreen - Premier écran d'onboarding
    }
  }

  /// Vérifie et rafraîchit automatiquement le token si nécessaire
  static Future<String?> getValidAccessToken() async {
    final token = await getAccessToken();
    if (token == null) return null;

    if (await _validateToken(token)) {
      return token;
    }

    // Token expiré, essayer de le rafraîchir
    if (await refreshAccessToken()) {
      return await getAccessToken();
    }

    return null;
  }

  /// Vérifie si l'utilisateur est staff/admin
  static Future<bool> isStaff() async {
    final userData = await getUserData();
    return userData?['is_staff'] == true;
  }

  /// Vérifie si l'utilisateur a un profil donneur complet
  static Future<bool> hasDonorProfile() async {
    final donorData = await getDonorData();
    return donorData != null && donorData['id'] != null;
  }

  /// Met à jour les données de donneur dans le cache
  static Future<void> updateDonorData(Map<String, dynamic> donorData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_donorKey, json.encode(donorData));
    } catch (e) {
      print('Erreur mise à jour données donneur: $e');
    }
  }

  /// Récupère l'ID du donneur connecté
  static Future<int?> getDonorId() async {
    final donorData = await getDonorData();
    return donorData?['id'] as int?;
  }

  /// Récupère l'ID de l'utilisateur connecté
  static Future<int?> getUserId() async {
    final userData = await getUserData();
    return userData?['id'] as int?;
  }
}
