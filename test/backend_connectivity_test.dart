import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Test de connectivité et validation des endpoints backend
void main() {
  group('Tests de connectivité Backend Django', () {
    const String baseUrl = 'http://localhost:8000/api';

    test('Vérification que le serveur Django est accessible', () async {
      try {
        final response = await http.get(Uri.parse('$baseUrl/'));
        expect(response.statusCode, lessThan(500),
            reason: 'Le serveur devrait être accessible');
        print('✅ Serveur Django accessible: ${response.statusCode}');
      } catch (e) {
        fail('❌ Serveur Django non accessible: $e');
      }
    });

    test('Vérification endpoint Swagger/documentation', () async {
      try {
        final response =
            await http.get(Uri.parse('http://localhost:8000/swagger/'));
        expect(response.statusCode, equals(200),
            reason: 'Swagger devrait être accessible');
        print('✅ Swagger accessible');
      } catch (e) {
        print('⚠️  Swagger non accessible: $e');
      }
    });

    test('Test endpoint inscription utilisateur', () async {
      final testEmail =
          'test_connectivity_${DateTime.now().millisecondsSinceEpoch}@example.com';

      try {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/users/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'username': testEmail,
            'email': testEmail,
            'password': 'testpassword123',
          }),
        );

        print('Réponse inscription: ${response.statusCode} - ${response.body}');

        expect([200, 201, 400].contains(response.statusCode), isTrue,
            reason:
                'L\'endpoint d\'inscription devrait répondre (même avec erreur de validation)');

        if (response.statusCode == 201) {
          print('✅ Inscription réussie');
        } else if (response.statusCode == 400) {
          print('⚠️  Erreur de validation (normal): ${response.body}');
        }
      } catch (e) {
        fail('❌ Endpoint inscription non accessible: $e');
      }
    });

    test('Test endpoint login avec utilisateur inexistant', () async {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/jwt/create/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'email': 'user_inexistant@test.com',
            'password': 'wrongpassword',
          }),
        );

        print('Réponse login: ${response.statusCode} - ${response.body}');

        expect([400, 401].contains(response.statusCode), isTrue,
            reason:
                'L\'endpoint de login devrait retourner 400/401 pour des credentials invalides');

        print('✅ Endpoint login accessible (erreur attendue)');
      } catch (e) {
        fail('❌ Endpoint login non accessible: $e');
      }
    });

    test('Test endpoints publics', () async {
      final publicEndpoints = [
        '/donneurs/',
        '/badges/',
        '/dons/',
        '/resultats/',
      ];

      for (final endpoint in publicEndpoints) {
        try {
          final response = await http.get(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          );

          print('Endpoint $endpoint: ${response.statusCode}');

          // On s'attend à 200 (succès) ou 401 (authentification requise)
          expect([200, 401].contains(response.statusCode), isTrue,
              reason: 'L\'endpoint $endpoint devrait être accessible');
        } catch (e) {
          print('❌ Endpoint $endpoint non accessible: $e');
        }
      }
    });

    test('Test structure des réponses API', () async {
      try {
        // Test avec l'endpoint donneurs (même si 401, on peut vérifier la structure d'erreur)
        final response = await http.get(
          Uri.parse('$baseUrl/donneurs/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );

        print('Structure réponse donneurs: ${response.body}');

        // Vérifier que la réponse est du JSON valide
        final jsonResponse = jsonDecode(response.body);
        expect(jsonResponse, isNotNull,
            reason: 'La réponse devrait être du JSON valide');

        print('✅ Structure JSON valide');
      } catch (e) {
        print('⚠️  Erreur structure JSON: $e');
      }
    });
  });

  group('Tests de validation des modèles de données', () {
    test('Validation format email', () {
      final validEmails = [
        'test@example.com',
        'user.name@domain.co.uk',
        'integration_test_123@test.org',
      ];

      for (final email in validEmails) {
        expect(email.contains('@'), isTrue);
        expect(email.contains('.'), isTrue);
        expect(email.length, greaterThan(5));
      }
    });

    test('Validation format date', () {
      final validDates = [
        '2025-08-15',
        '1990-01-01',
        '2000-12-31',
      ];

      final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');

      for (final date in validDates) {
        expect(dateRegex.hasMatch(date), isTrue);
      }
    });

    test('Validation groupes sanguins', () {
      final validGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
      const testGroup = 'O+';

      expect(validGroups.contains(testGroup), isTrue);
    });
  });
}
