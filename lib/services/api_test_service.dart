import 'package:http/http.dart' as http;
import 'dart:convert';

/// Service de test pour vérifier la connectivité avec le backend
class ApiTestService {
  static const String baseUrl = 'http://localhost:8000/api';

  /// Test de connectivité basique
  static Future<bool> testConnection() async {
    try {
      print('🔍 Test de connectivité avec $baseUrl...');

      // Test simple avec un GET sur l'endpoint de base
      final response = await http.get(
        Uri.parse('$baseUrl/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 10));

      print('📊 Réponse du serveur: ${response.statusCode}');
      print('📄 Corps de la réponse: ${response.body}');

      return response.statusCode < 500; // Accepter même 404, mais pas 500+
    } catch (e) {
      print('❌ Erreur de connexion: $e');
      return false;
    }
  }

  /// Test spécifique pour l'endpoint d'authentification
  static Future<bool> testAuthEndpoint() async {
    try {
      print('🔐 Test de l\'endpoint d\'authentification...');

      final response = await http.get(
        Uri.parse('$baseUrl/auth/jwt/create/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 10));

      print('📊 Réponse GET auth: ${response.statusCode}');
      print('📄 Headers: ${response.headers}');

      // L'endpoint auth devrait répondre, même avec une méthode incorrecte
      return response.statusCode < 500;
    } catch (e) {
      print('❌ Erreur sur l\'endpoint auth: $e');
      return false;
    }
  }

  /// Test de login avec des credentials de test
  static Future<bool> testLogin() async {
    try {
      print('🧪 Test de login...');

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/jwt/create/'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(
                {'username': 'test@test.com', 'password': 'testpassword123'}),
          )
          .timeout(Duration(seconds: 10));

      print('📊 Réponse login: ${response.statusCode}');
      print('📄 Corps: ${response.body}');

      // Même si les credentials sont faux, on veut voir si l'endpoint répond
      return response.statusCode == 200 ||
          response.statusCode == 400 ||
          response.statusCode == 401;
    } catch (e) {
      print('❌ Erreur lors du test de login: $e');
      return false;
    }
  }

  /// Exécute tous les tests de connectivité
  static Future<Map<String, bool>> runAllTests() async {
    print('🚀 Démarrage des tests de connectivité API...\n');

    final results = <String, bool>{};

    results['connection'] = await testConnection();
    await Future.delayed(Duration(milliseconds: 500));

    results['auth_endpoint'] = await testAuthEndpoint();
    await Future.delayed(Duration(milliseconds: 500));

    results['login_test'] = await testLogin();

    print('\n📋 Résultats des tests:');
    results.forEach((test, success) {
      final status = success ? '✅' : '❌';
      print('$status $test: ${success ? 'RÉUSSI' : 'ÉCHOUÉ'}');
    });

    final allPassed = results.values.every((result) => result);
    print(
        '\n🎯 Résultat global: ${allPassed ? '✅ TOUS LES TESTS RÉUSSIS' : '❌ CERTAINS TESTS ONT ÉCHOUÉ'}');

    return results;
  }
}
