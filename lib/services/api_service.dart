import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';

class ApiService {
  // Configuration de l'URL de base depuis AppConfig (fichier .env)
  static String get baseUrl => AppConfig.apiBaseUrl;

  // Headers par défaut depuis AppConfig
  static Map<String, String> get defaultHeaders => AppConfig.defaultHeaders;

  // Méthode pour logger les erreurs
  static void _logError(
      String method, String url, int statusCode, String body) {
    print('❌ API Error: $method $url');
    print('Status Code: $statusCode');
    print('Response: $body');
  }

  // Méthode pour logger les succès
  static void _logSuccess(String method, String url, int statusCode) {
    print('✅ API Success: $method $url');
    print('Status Code: $statusCode');
  }

  // === AUTHENTIFICATION ===

  /// Connexion : retourne les tokens JWT
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/jwt/create/');
      print('🔐 Tentative de connexion: $url');

      final response = await http.post(
        url,
        headers: defaultHeaders,
        body: jsonEncode({
          'username': email,
          'password': password
        }), // Djoser utilise username
      );

      if (response.statusCode == 200) {
        _logSuccess('POST', url.toString(), response.statusCode);
        final data = jsonDecode(response.body);
        return {
          'access': data['access'],
          'refresh': data['refresh'],
        };
      } else {
        _logError('POST', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur réseau lors de la connexion: $e');
      return null;
    }
  }

  /// Inscription utilisateur
  Future<Map<String, dynamic>?> register(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/users/');
      print('📝 Tentative d\'inscription: $url');

      final response = await http.post(
        url,
        headers: defaultHeaders,
        body: jsonEncode({
          'username':
              email, // Djoser nécessite username même si LOGIN_FIELD = email
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        _logSuccess('POST', url.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('POST', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur réseau lors de l\'inscription: $e');
      return null;
    }
  }

  /// Rafraîchir le token JWT
  static Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final url = Uri.parse('$baseUrl/auth/jwt/refresh/');
      print('🔄 Rafraîchissement du token: $url');

      final response = await http.post(
        url,
        headers: defaultHeaders,
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        _logSuccess('POST', url.toString(), response.statusCode);
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        _logError('POST', url.toString(), response.statusCode, response.body);
        return {
          'success': false,
          'error': 'Échec du rafraîchissement du token',
        };
      }
    } catch (e) {
      print('❌ Erreur réseau lors du rafraîchissement: $e');
      return {
        'success': false,
        'error': 'Erreur réseau: $e',
      };
    }
  }

  /// Inscription unifiée via endpoint backend unifié
  ///
  /// Utilise l'endpoint /api/register/complete/ qui :
  /// 1. Crée le compte utilisateur
  /// 2. Crée automatiquement le profil donneur
  /// 3. Lie l'utilisateur au donneur
  /// 4. Retourne les données complètes
  Future<Map<String, dynamic>?> registerUnified({
    required String email,
    required String password,
    required String nom,
    required String prenoms,
    required String telephone,
    required String dateNaissance,
    String pays = 'benin',
  }) async {
    try {
      print('🔄 Inscription unifiée pour: $email');

      // Utiliser le nouvel endpoint d'inscription complète
      final registrationData = {
        'email': email,
        'password': password,
        'nom': nom,
        'prenoms': prenoms,
        'telephone': telephone,
        'date_de_naissance': dateNaissance,
        'pays': pays,
      };

      final registrationUrl = Uri.parse('$baseUrl/register/complete/');
      final registrationResponse = await http.post(
        registrationUrl,
        headers: defaultHeaders,
        body: jsonEncode(registrationData),
      );

      if (registrationResponse.statusCode != 201) {
        print('❌ Erreur inscription complète: ${registrationResponse.body}');
        final errorData = jsonDecode(registrationResponse.body);
        throw Exception(errorData['error'] ?? 'Erreur lors de l\'inscription');
      }

      print('✅ Inscription complète réussie');
      final registrationResult = jsonDecode(registrationResponse.body);

      // Étape 2: Se connecter pour obtenir les tokens
      final loginResult = await login(email, password);
      if (loginResult == null) {
        throw Exception('Erreur lors de la connexion automatique');
      }
      print('✅ Connexion automatique réussie');

      // Retourner toutes les données nécessaires
      return {
        'success': true,
        'user': registrationResult['user'],
        'donneur': registrationResult['donneur'],
        'tokens': loginResult,
        'message': 'Inscription complète réussie',
      };
    } catch (e) {
      print('❌ Erreur lors de l\'inscription unifiée: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Inscription unifiée : Crée le user et le donneur en une seule opération
  ///
  /// Cette méthode gère le processus complet d'inscription :
  /// 1. Crée le compte utilisateur
  /// 2. Se connecte automatiquement
  /// 3. Crée le profil donneur associé
  /// 4. Retourne les tokens et les données complètes
  ///
  /// @deprecated Utiliser registerUnified() à la place
  Future<Map<String, dynamic>?> registerComplete({
    required String email,
    required String password,
    required String nom,
    required String prenoms,
    required String telephone,
    required String dateNaissance,
    String pays = 'benin',
  }) async {
    // Rediriger vers la nouvelle méthode unifiée
    return registerUnified(
      email: email,
      password: password,
      nom: nom,
      prenoms: prenoms,
      telephone: telephone,
      dateNaissance: dateNaissance,
      pays: pays,
    );
  }

  /// Récupérer les infos de l'utilisateur connecté
  Future<Map<String, dynamic>?> getCurrentUser(String token) async {
    try {
      // Utiliser l'endpoint des donneurs pour récupérer les informations du donneur connecté
      final url = Uri.parse('$baseUrl/donneurs/');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _logSuccess('GET', url.toString(), response.statusCode);
        final data = jsonDecode(response.body);

        // Si c'est une liste, prendre le premier élément (donneur connecté)
        if (data is List && data.isNotEmpty) {
          final donneur = data.firstWhere(
            (d) => d is Map<String, dynamic> && d['email'] != null,
            orElse: () => data.first,
          );
          if (donneur is Map<String, dynamic>) {
            return {
              'user': {
                'first_name': donneur['nom'] ?? '',
                'last_name': donneur['prenoms'] ?? '',
                'email': donneur['email'] ?? '',
              },
              'donneur': donneur,
            };
          }
        } else if (data is Map) {
          // Si c'est directement un objet donneur
          return {
            'user': {
              'first_name': data['nom'] ?? '',
              'last_name': data['prenom'] ?? '',
              'email': data['user']?['email'] ?? data['email'] ?? '',
            },
            'donneur': data,
          };
        }
        return null;
      } else {
        _logError('GET', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'utilisateur: $e');
      return null;
    }
  }

  // === GESTION DES DONNEURS ===

  /// Liste des donneurs
  Future<List<dynamic>?> getDonneurs(String token) async {
    try {
      final url = Uri.parse('$baseUrl/donneurs/');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _logSuccess('GET', url.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('GET', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des donneurs: $e');
      return null;
    }
  }

  /// Créer un donneur
  Future<Map<String, dynamic>?> createDonneur(
      String token, Map<String, dynamic> donneur) async {
    try {
      final url = Uri.parse('$baseUrl/donneurs/');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(donneur),
      );

      if (response.statusCode == 201) {
        _logSuccess('POST', url.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('POST', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la création du donneur: $e');
      return null;
    }
  }

  /// Compléter le profil d'un donneur avec les informations du profil
  /// (groupe sanguin, localisation, poids, taille)
  Future<Map<String, dynamic>?> completeProfile({
    required String email,
    required String groupeSanguin,
    required String localisation,
    required double poids,
    required double taille, // en mm
  }) async {
    try {
      final url = Uri.parse('$baseUrl/profile/complete/');
      print('🏥 Complétion du profil pour: $email');

      final profileData = {
        'email': email,
        'groupe_sanguin': groupeSanguin,
        'localisation': localisation,
        'poids': poids,
        'taille': taille,
      };

      final response = await http.post(
        url,
        headers: defaultHeaders,
        body: jsonEncode(profileData),
      );

      if (response.statusCode == 200) {
        _logSuccess('POST', url.toString(), response.statusCode);
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        _logError('POST', url.toString(), response.statusCode, response.body);
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error':
              errorData['error'] ?? 'Erreur lors de la mise à jour du profil',
        };
      }
    } catch (e) {
      print('❌ Erreur lors de la complétion du profil: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>?> updateDonneur(
      String token, int donneurId, Map<String, dynamic> donneurData) async {
    try {
      final url = Uri.parse('$baseUrl/donneurs/$donneurId/');
      print('📝 Mise à jour du donneur $donneurId: $url');
      print('Données: $donneurData');

      final response = await http.put(
        url,
        headers: {
          ...defaultHeaders,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(donneurData),
      );

      if (response.statusCode == 200) {
        _logSuccess('PUT', url.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('PUT', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la mise à jour du donneur: $e');
      return null;
    }
  }

  /// Rechercher un donneur par nom et prénom
  Future<List<dynamic>?> searchDonneurByName(String token,
      {String? nom, String? prenoms, String? dateNaissance}) async {
    try {
      final queryParams = <String, String>{};
      if (nom != null) queryParams['nom'] = nom;
      if (prenoms != null) queryParams['prenoms'] = prenoms;
      if (dateNaissance != null) {
        queryParams['date_de_naissance'] = dateNaissance;
      }

      final uri = Uri.parse('$baseUrl/donneurs/by_nom_prenom/')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _logSuccess('GET', uri.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('GET', uri.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la recherche du donneur: $e');
      return null;
    }
  }

  /// Enregistrer un don pour un donneur
  Future<bool> enregistrerDon(
      String token, int donneurId, double litres) async {
    try {
      final url = Uri.parse('$baseUrl/donneurs/$donneurId/enregistrer_don/');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'litres_donnes': litres,
        }),
      );

      if (response.statusCode == 200) {
        _logSuccess('POST', url.toString(), response.statusCode);
        return true;
      } else {
        _logError('POST', url.toString(), response.statusCode, response.body);
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de l\'enregistrement du don: $e');
      return false;
    }
  }

  // === GESTION DES DONS ===

  /// Récupérer la liste des dons
  Future<List<dynamic>?> getDons(String token) async {
    try {
      final url = Uri.parse('$baseUrl/dons/');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _logSuccess('GET', url.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('GET', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des dons: $e');
      return null;
    }
  }

  /// Créer un nouveau don
  Future<Map<String, dynamic>?> creerDon(
      String token, Map<String, dynamic> don) async {
    try {
      final url = Uri.parse('$baseUrl/dons/');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(don),
      );

      if (response.statusCode == 201) {
        _logSuccess('POST', url.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('POST', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la création du don: $e');
      return null;
    }
  }

  // === GESTION DES ANALYSES ===

  /// Récupérer les résultats d'analyse
  Future<List<dynamic>?> getResultatsAnalyse(String token) async {
    try {
      final url = Uri.parse('$baseUrl/resultats/');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _logSuccess('GET', url.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('GET', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des résultats: $e');
      return null;
    }
  }

  /// Ajouter un résultat d'analyse pour un donneur
  Future<Map<String, dynamic>?> ajouterResultatAnalyse(
      String token, int donneurId, String filePath) async {
    try {
      final url = Uri.parse('$baseUrl/resultats/$donneurId/ajouter_resultat/');
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';

      // Ajouter le fichier PDF
      request.files
          .add(await http.MultipartFile.fromPath('fichier_pdf', filePath));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        _logSuccess('POST', url.toString(), response.statusCode);
        return jsonDecode(responseBody);
      } else {
        _logError('POST', url.toString(), response.statusCode, responseBody);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de l\'ajout du résultat d\'analyse: $e');
      return null;
    }
  }

  /// Vérifier une analyse (nécessite des droits staff)
  Future<bool> verifierAnalyse(String token, int analyseId) async {
    try {
      final url = Uri.parse('$baseUrl/resultats/$analyseId/verifier_analyse/');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _logSuccess('POST', url.toString(), response.statusCode);
        return true;
      } else {
        _logError('POST', url.toString(), response.statusCode, response.body);
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de la vérification de l\'analyse: $e');
      return false;
    }
  }

  /// Envoyer tous les résultats vérifiés par email
  Future<Map<String, dynamic>?> envoyerResultatsVerifies(String token) async {
    try {
      final url = Uri.parse('$baseUrl/resultats/envoyer_resultats_verifies/');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _logSuccess('POST', url.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('POST', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de l\'envoi des résultats: $e');
      return null;
    }
  }

  // === GESTION DES BADGES ===

  /// Récupérer les badges
  Future<List<dynamic>?> getBadges(String token) async {
    try {
      final url = Uri.parse('$baseUrl/badges/');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _logSuccess('GET', url.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('GET', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des badges: $e');
      return null;
    }
  }

  /// Générer un badge pour un donneur
  Future<dynamic> genererBadge(String token, int donneurId) async {
    try {
      final url = Uri.parse('$baseUrl/badges/');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'donneur': donneurId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logSuccess('POST', url.toString(), response.statusCode);

        // Si c'est un PDF, retourner les bytes
        if (response.headers['content-type']?.contains('application/pdf') ==
            true) {
          return response.bodyBytes;
        }

        // Sinon, retourner le JSON
        return jsonDecode(response.body);
      } else {
        _logError('POST', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la génération du badge: $e');
      return null;
    }
  }

  // === DONNÉES MOCKÉES (en attendant implémentation complète) ===

  /// Récupérer les centres de collecte
  /// Récupérer les campagnes de don
  /// Récupérer toutes les campagnes
  Future<List<dynamic>?> getCampagnes() async {
    try {
      final url = Uri.parse('$baseUrl/campagnes/');
      print('📅 Récupération des campagnes: $url');

      final response = await http.get(url, headers: defaultHeaders);

      if (response.statusCode == 200) {
        _logSuccess('GET', url.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('GET', url.toString(), response.statusCode, response.body);
        // Retourner une liste vide au lieu de données mockées
        // L'administrateur doit créer les campagnes via le backend
        return [];
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des campagnes: $e');
      // Retourner une liste vide en cas d'erreur
      return [];
    }
  }

  /// Récupérer les campagnes urgentes
  Future<List<dynamic>?> getCampagnesUrgentes() async {
    try {
      final url = Uri.parse('$baseUrl/campagnes/urgentes/');
      print('🚨 Récupération des campagnes urgentes: $url');

      final response = await http.get(url, headers: defaultHeaders);

      if (response.statusCode == 200) {
        _logSuccess('GET', url.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('GET', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des campagnes urgentes: $e');
      return null;
    }
  }

  /// S'inscrire à une campagne
  Future<bool> inscrireCampagne(String token, int campagneId) async {
    try {
      final url = Uri.parse('$baseUrl/campagnes/$campagneId/inscrire/');
      print('📝 Inscription à la campagne $campagneId: $url');

      final response = await http.post(
        url,
        headers: {
          ...defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 201) {
        _logSuccess('POST', url.toString(), response.statusCode);
        return true;
      } else {
        _logError('POST', url.toString(), response.statusCode, response.body);
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de l\'inscription à la campagne: $e');
      return false;
    }
  }

  /// Récupérer les centres de don
  Future<List<dynamic>?> getCenters() async {
    try {
      // Pour l'instant, les centres ne sont pas implémentés dans le backend
      // Retournons des données mockées
      await Future.delayed(
          const Duration(milliseconds: 100)); // Simule latence réseau

      return [
        {
          'id': 1,
          'nom': 'Centre Hospitalier Universitaire',
          'adresse': '123 Avenue de la Santé',
          'ville': 'Paris',
          'code_postal': '75013',
          'telephone': '+33 1 42 34 56 78',
          'horaires': 'Lun-Ven: 8h-18h, Sam: 9h-16h',
          'latitude': 48.8566,
          'longitude': 2.3522
        },
        {
          'id': 2,
          'nom': 'Maison du Don',
          'adresse': '456 Rue de la Solidarité',
          'ville': 'Lyon',
          'code_postal': '69001',
          'telephone': '+33 4 78 90 12 34',
          'horaires': 'Lun-Sam: 9h-17h',
          'latitude': 45.7640,
          'longitude': 4.8357
        }
      ];
    } catch (e) {
      print('❌ Erreur lors de la récupération des centres: $e');
      return null;
    }
  }

  // === CENTRES DE DON ===

  /// Récupérer tous les centres de don
  Future<List<dynamic>?> getCentres() async {
    try {
      final url = Uri.parse('$baseUrl/centres/');
      print('🏥 Récupération des centres: $url');

      final response = await http.get(url, headers: defaultHeaders);

      if (response.statusCode == 200) {
        _logSuccess('GET', url.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('GET', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des centres: $e');
      return null;
    }
  }

  /// Récupérer les centres proches d'une position
  Future<List<dynamic>?> getCentresProches(
      double latitude, double longitude) async {
    try {
      final url = Uri.parse(
          '$baseUrl/centres/proches/?latitude=$latitude&longitude=$longitude');
      print('📍 Récupération des centres proches: $url');

      final response = await http.get(url, headers: defaultHeaders);

      if (response.statusCode == 200) {
        _logSuccess('GET', url.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('GET', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des centres proches: $e');
      return null;
    }
  }

  // === DONS ===

  /// Créer un don (inscription à une campagne)
  Future<Map<String, dynamic>?> createDon(
      String token, Map<String, dynamic> donData) async {
    try {
      final url = Uri.parse('$baseUrl/dons/');
      print('💉 Création d\'un don: $url');
      print('Données: $donData');

      final response = await http.post(
        url,
        headers: {
          ...defaultHeaders,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(donData),
      );

      if (response.statusCode == 201) {
        _logSuccess('POST', url.toString(), response.statusCode);
        return jsonDecode(response.body);
      } else {
        _logError('POST', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la création du don: $e');
      return null;
    }
  }

  // === NOTIFICATIONS ===

  /// Récupérer toutes les notifications du donneur
  Future<List<Map<String, dynamic>>?> getNotifications(String token) async {
    try {
      final url = Uri.parse('$baseUrl/notifications/');
      print('📢 Récupération des notifications: $url');

      final response = await http.get(
        url,
        headers: {
          ...defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _logSuccess('GET', url.toString(), response.statusCode);
        final data = jsonDecode(response.body);
        if (data['results'] != null) {
          return List<Map<String, dynamic>>.from(data['results']);
        } else {
          return List<Map<String, dynamic>>.from(data);
        }
      } else {
        _logError('GET', url.toString(), response.statusCode, response.body);
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des notifications: $e');
      return null;
    }
  }

  /// Marquer une notification comme lue
  Future<bool> marquerNotificationLue(String token, int notificationId) async {
    try {
      final url =
          Uri.parse('$baseUrl/notifications/$notificationId/marquer_lue/');
      print('✓ Marquage notification comme lue: $url');

      final response = await http.patch(
        url,
        headers: {
          ...defaultHeaders,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'lue': true}),
      );

      if (response.statusCode == 200) {
        _logSuccess('PATCH', url.toString(), response.statusCode);
        return true;
      } else {
        _logError('PATCH', url.toString(), response.statusCode, response.body);
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors du marquage de la notification: $e');
      return false;
    }
  }

  /// Marquer toutes les notifications comme lues
  Future<bool> marquerToutesNotificationsLues(String token) async {
    try {
      final url = Uri.parse('$baseUrl/notifications/marquer_toutes_lues/');
      print('✓ Marquage de toutes les notifications comme lues: $url');

      final response = await http.post(
        url,
        headers: {
          ...defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _logSuccess('POST', url.toString(), response.statusCode);
        return true;
      } else {
        _logError('POST', url.toString(), response.statusCode, response.body);
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors du marquage des notifications: $e');
      return false;
    }
  }

  /// Supprimer une notification
  Future<bool> supprimerNotification(String token, int notificationId) async {
    try {
      final url = Uri.parse('$baseUrl/notifications/$notificationId/');
      print('🗑️ Suppression de la notification: $url');

      final response = await http.delete(
        url,
        headers: {
          ...defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        _logSuccess('DELETE', url.toString(), response.statusCode);
        return true;
      } else {
        _logError('DELETE', url.toString(), response.statusCode, response.body);
        return false;
      }
    } catch (e) {
      print('❌ Erreur lors de la suppression de la notification: $e');
      return false;
    }
  }
}
