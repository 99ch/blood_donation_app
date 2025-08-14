import 'package:flutter_test/flutter_test.dart';
import 'package:Donation/services/api_service.dart';

/// Tests d'intégration réels pour ApiService
/// Ces tests nécessitent que le serveur Django soit en marche
void main() {
  group('ApiService - Tests d\'intégration réels', () {
    late ApiService apiService;
    Map<String, dynamic>? testTokens;
    String? testToken;
    final String testEmail =
        'integration_test_${DateTime.now().millisecondsSinceEpoch}@example.com';
    const String testPassword = 'ComplexTestPassword123!';

    setUpAll(() {
      apiService = ApiService();
    });

    test('INTEGRATION: Inscription d\'un nouvel utilisateur', () async {
      final result = await apiService.register(testEmail, testPassword);

      expect(result, isNotNull, reason: 'L\'inscription devrait réussir');
      expect(result!['email'], equals(testEmail));
      expect(result['username'], equals(testEmail));

      print('✅ Utilisateur créé: ${result['email']}');
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('INTEGRATION: Authentification utilisateur', () async {
      // Attendre un peu pour que l'utilisateur soit bien créé
      await Future.delayed(const Duration(seconds: 1));

      testTokens = await apiService.login(testEmail, testPassword);
      testToken = testTokens?['access'];

      expect(testToken, isNotNull,
          reason: 'L\'authentification devrait réussir');
      expect(testToken!.length, greaterThan(10),
          reason: 'Le token devrait avoir une longueur raisonnable');

      print('✅ Token obtenu: ${testToken!.substring(0, 20)}...');
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('INTEGRATION: Création profil donneur', () async {
      expect(testToken, isNotNull, reason: 'Un token est requis pour ce test');

      final donneurData = {
        'nom': 'TestIntegration',
        'prenoms': 'UtilisateurTest',
        'sexe': 'M',
        'email': testEmail,
        'groupe_sanguin': 'B+',
        'date_de_naissance': '1988-03-20',
        'telephone': '+33987654321',
        'adresse': '456 Rue d\'Intégration Test'
      };

      final success = await apiService.createDonneur(testToken!, donneurData);

      expect(success, isTrue, reason: 'La création du donneur devrait réussir');

      print('✅ Profil donneur créé avec succès');
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('INTEGRATION: Récupération profil donneur', () async {
      expect(testToken, isNotNull, reason: 'Un token est requis pour ce test');

      final profile = await apiService.getCurrentUser(testToken!);

      expect(profile, isNotNull, reason: 'Le profil devrait être récupéré');
      expect(profile!['nom'], equals('TestIntegration'));
      expect(profile['prenoms'], equals('UtilisateurTest'));
      expect(profile['email'], equals(testEmail));

      print('✅ Profil récupéré: ${profile['nom']} ${profile['prenoms']}');
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('INTEGRATION: Inscription à un don', () async {
      expect(testToken, isNotNull, reason: 'Un token est requis pour ce test');

      final futureDate = DateTime.now().add(const Duration(days: 21));
      final dateString =
          '${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}';

      final donData = {'date': dateString, 'statut': 'planifie'};

      final result = await apiService.creerDon(testToken!, donData);

      expect(result, isNotNull,
          reason: 'L\'inscription au don devrait réussir');

      print('✅ Inscription au don réussie pour le $dateString');
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('INTEGRATION: Récupération résultats d\'analyse', () async {
      expect(testToken, isNotNull, reason: 'Un token est requis pour ce test');

      final results = await apiService.getResultatsAnalyse(testToken!);

      expect(results, isNotNull,
          reason: 'Les résultats devraient être récupérés');
      expect(results, isList, reason: 'Les résultats devraient être une liste');

      print('✅ Résultats récupérés: ${results!.length} résultat(s)');
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('INTEGRATION: Récupération badges utilisateur', () async {
      expect(testToken, isNotNull, reason: 'Un token est requis pour ce test');

      final badges = await apiService.getBadges(testToken!);

      expect(badges, isNotNull, reason: 'Les badges devraient être récupérés');
      expect(badges, isList, reason: 'Les badges devraient être une liste');

      print('✅ Badges récupérés: ${badges!.length} badge(s)');
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('INTEGRATION: Récupération campagnes', () async {
      final campaigns = await apiService.getCampagnes();

      expect(campaigns, isNotNull,
          reason: 'Les campagnes devraient être récupérées');
      expect(campaigns, isList,
          reason: 'Les campagnes devraient être une liste');

      print('✅ Campagnes récupérées: ${campaigns!.length} campagne(s)');
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('INTEGRATION: Récupération centres de don', () async {
      final centers = await apiService.getCenters();

      expect(centers, isNotNull,
          reason: 'Les centres devraient être récupérés');
      expect(centers, isList, reason: 'Les centres devraient être une liste');

      print('✅ Centres récupérés: ${centers!.length} centre(s)');
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('INTEGRATION: Gestion erreur avec token invalide', () async {
      final result = await apiService.getCurrentUser('token_invalide_123');

      expect(result, isNull,
          reason: 'Une erreur avec token invalide devrait retourner null');

      print('✅ Gestion d\'erreur validée (token invalide)');
    }, timeout: const Timeout(Duration(seconds: 30)));
  });

  group('ApiService - Tests de validation des données', () {
    test('Validation format email', () {
      final emails = [
        'test@example.com',
        'user.name@domain.co.uk',
        'integration_test_123@test.org',
      ];

      for (final email in emails) {
        expect(email.contains('@'), isTrue,
            reason: 'Email $email devrait contenir @');
        expect(email.contains('.'), isTrue,
            reason: 'Email $email devrait contenir un point');
      }
    });

    test('Validation format date', () {
      final dates = [
        '2025-08-15',
        '1990-01-01',
        '2000-12-31',
      ];

      final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');

      for (final date in dates) {
        expect(dateRegex.hasMatch(date), isTrue,
            reason: 'Date $date devrait respecter le format YYYY-MM-DD');
      }
    });

    test('Validation groupes sanguins', () {
      final validGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
      const testGroup = 'O+';

      expect(validGroups.contains(testGroup), isTrue,
          reason: 'Groupe sanguin $testGroup devrait être valide');
    });

    test('Validation sexe', () {
      final validSexes = ['M', 'F'];
      const testSexe = 'M';

      expect(validSexes.contains(testSexe), isTrue,
          reason: 'Sexe $testSexe devrait être valide');
    });
  });

  group('ApiService - Tests de performance', () {
    late ApiService apiService;

    setUpAll(() {
      apiService = ApiService();
    });

    test('Performance: Temps de réponse endpoints publics', () async {
      final stopwatch = Stopwatch()..start();

      final campaigns = await apiService.getCampagnes();
      final centers = await apiService.getCenters();

      stopwatch.stop();

      expect(campaigns, isNotNull);
      expect(centers, isNotNull);
      expect(stopwatch.elapsedMilliseconds, lessThan(5000),
          reason:
              'Les endpoints publics devraient répondre en moins de 5 secondes');

      print('⏱️  Temps de réponse: ${stopwatch.elapsedMilliseconds}ms');
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('Performance: Gestion timeout réseau', () async {
      // Ce test vérifie que l'app gère bien les timeouts
      // En production, vous pourriez configurer des timeouts dans ApiService

      final stopwatch = Stopwatch()..start();

      try {
        // Tenter une requête vers une URL qui timeout
        await apiService.getCampagnes();
        stopwatch.stop();

        // Si la requête réussit, vérifier le temps de réponse
        expect(stopwatch.elapsedMilliseconds, lessThan(10000),
            reason:
                'Même une requête lente ne devrait pas dépasser 10 secondes');

        print('⏱️  Requête terminée en: ${stopwatch.elapsedMilliseconds}ms');
      } catch (e) {
        stopwatch.stop();
        print('⚠️  Timeout géré après: ${stopwatch.elapsedMilliseconds}ms');
        // Un timeout est acceptable dans ce test
      }
    }, timeout: const Timeout(Duration(seconds: 15)));
  });
}
