import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api'; // À adapter en prod

  // Connexion : retourne le token JWT
  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/jwt/create/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access'];
    }
    return null;
  }

  // Liste des donneurs (GET)
  Future<List<dynamic>?> getDonneurs(String token) async {
    final url = Uri.parse('$baseUrl/donneurs/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // Créer un donneur (POST)
  Future<bool> createDonneur(String token, Map<String, dynamic> donneur) async {
    final url = Uri.parse('$baseUrl/donneurs/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(donneur),
    );

    return response.statusCode == 201;
  }

  // Inscription utilisateur (POST)
  Future<Map<String, dynamic>?> register(String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/users/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // Récupérer les infos du donneur connecté (GET)
  Future<Map<String, dynamic>?> getCurrentDonor(String token) async {
    final url = Uri.parse('$baseUrl/auth/users/me/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // Récupérer les résultats d'analyse (GET)
  Future<List<dynamic>?> getResultatsAnalyse(String token) async {
    final url = Uri.parse('$baseUrl/resultats/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // Ajouter un résultat d'analyse pour un donneur (POST)
  Future<bool> ajouterResultatAnalyse(String token, int donneurId, dynamic fichierPdf) async {
    final url = Uri.parse('$baseUrl/donneurs/$donneurId/ajouter_resultat/');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    
    if (fichierPdf != null) {
      request.files.add(await http.MultipartFile.fromPath('fichier_pdf', fichierPdf));
    }
    
    final response = await request.send();
    return response.statusCode == 201;
  }

  // Récupérer les badges (GET)
  Future<List<dynamic>?> getBadges(String token) async {
    final url = Uri.parse('$baseUrl/badges/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // Générer un badge pour un donneur (POST)
  Future<bool> genererBadge(String token, int donneurId) async {
    final url = Uri.parse('$baseUrl/badges/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'donneur': donneurId}),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Récupérer la liste des centres de collecte (GET) - Données mockées pour l'instant
  Future<List<dynamic>?> getCenters() async {
    // Simule un appel API - à remplacer par une vraie API plus tard
    await Future.delayed(Duration(milliseconds: 500));
    return [
      {
        'id': 1,
        'nom': 'Centre de Don Central',
        'adresse': '123 Rue de la Santé, Paris 75001',
        'telephone': '+33 1 42 34 56 78',
        'heures_ouverture': 'Lun-Ven: 8h-18h, Sam: 9h-15h',
        'latitude': 48.8566,
        'longitude': 2.3522,
        'services': ['Don de sang', 'Don de plasma', 'Don de plaquettes']
      },
      {
        'id': 2,
        'nom': 'Hôpital Saint-Antoine',
        'adresse': '184 Rue du Faubourg Saint-Antoine, Paris 75012',
        'telephone': '+33 1 49 28 20 00',
        'heures_ouverture': 'Lun-Ven: 7h30-17h30',
        'latitude': 48.8503,
        'longitude': 2.3896,
        'services': ['Don de sang', 'Don de plaquettes']
      }
    ];
  }

  // Récupérer les campagnes de don (GET) - Données mockées pour l'instant
  Future<List<dynamic>?> getCampagnes() async {
    // Simule un appel API - à remplacer par une vraie API plus tard
    await Future.delayed(Duration(milliseconds: 500));
    return [
      {
        'id': 1,
        'titre': 'Collecte Universitaire',
        'description': 'Collecte de sang organisée à l\'université avec l\'association étudiante',
        'date': '2025-08-15',
        'lieu': 'Campus Universitaire - Amphi A',
        'heures': '9h00 - 17h00',
        'objectif': 50,
        'participants_actuels': 23,
        'organisateur': 'AB-PROJECT EE',
        'urgence': 'normale'
      },
      {
        'id': 2,
        'titre': 'Urgence Plaquettes',
        'description': 'Collecte urgente de plaquettes pour les patients en oncologie',
        'date': '2025-08-02',
        'lieu': 'Hôpital Central - Salle de don',
        'heures': '8h00 - 20h00',
        'objectif': 30,
        'participants_actuels': 12,
        'organisateur': 'Hôpital Central',
        'urgence': 'haute'
      }
    ];
  }

  static String encodeJson(Map<String, dynamic> data) {
    return jsonEncode(data);
  }
}