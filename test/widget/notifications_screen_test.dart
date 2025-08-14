import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import des fichiers à tester
import 'package:Donation/screens/notifications_screen/notifications_screen.dart';
import 'package:Donation/services/notification_service.dart';
import 'package:Donation/models/notification.dart';

void main() {
  group('NotificationsScreen Tests', () {
    testWidgets('Affichage de l\'écran des notifications',
        (WidgetTester tester) async {
      // Construire le widget
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationsScreen(),
        ),
      );

      // Vérifier l'état initial
      expect(find.byType(NotificationsScreen), findsOneWidget);

      // Attendre le rendu initial
      await tester.pump();

      print('✅ Écran des notifications affiché');
    });

    testWidgets('Test de la structure de l\'écran',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationsScreen(),
        ),
      );

      await tester.pump();

      // Vérifier la structure de base
      expect(find.byType(Scaffold), findsOneWidget);

      print('✅ Structure de l\'écran des notifications validée');
    });

    test('Test du modèle NotificationModel', () {
      final notification = NotificationModel(
        id: 1,
        titre: 'Test Notification',
        message: 'Message de test',
        type: NotificationModel.typeInscription,
        dateCreation: DateTime.now(),
        lue: false,
      );

      // Tests des propriétés
      expect(notification.id, equals(1));
      expect(notification.titre, equals('Test Notification'));
      expect(notification.message, equals('Message de test'));
      expect(notification.type, equals(NotificationModel.typeInscription));
      expect(notification.lue, isFalse);

      // Test des getters calculés
      expect(notification.icone, equals('✅')); // Icône pour inscription
      expect(notification.couleur, equals('#4CAF50')); // Couleur verte
      expect(notification.estRecente, isTrue); // Créée maintenant

      print('✅ Modèle NotificationModel testé');
    });

    test('Test des types de notifications', () {
      final types = [
        NotificationModel.typeInscription,
        NotificationModel.typeRappel,
        NotificationModel.typeResultat,
        NotificationModel.typeUrgent,
        NotificationModel.typeInformation,
      ];

      for (final type in types) {
        final notification = NotificationModel(
          titre: 'Test $type',
          message: 'Message pour $type',
          type: type,
          dateCreation: DateTime.now(),
        );

        expect(notification.type, equals(type));
        expect(notification.icone, isNotEmpty);
        expect(notification.couleur, isNotEmpty);
      }

      print('✅ Types de notifications testés');
    });

    test('Test du formatage du temps écoulé', () {
      final maintenant = DateTime.now();

      final testCases = [
        {
          'date': maintenant.subtract(const Duration(minutes: 30)),
          'description': '30 minutes',
        },
        {
          'date': maintenant.subtract(const Duration(hours: 2)),
          'description': '2 heures',
        },
        {
          'date': maintenant.subtract(const Duration(days: 1)),
          'description': '1 jour',
        },
        {
          'date': maintenant.subtract(const Duration(days: 3)),
          'description': '3 jours',
        },
      ];

      for (final testCase in testCases) {
        final notification = NotificationModel(
          titre: 'Test',
          message: 'Message',
          type: NotificationModel.typeInformation,
          dateCreation: testCase['date'] as DateTime,
        );

        final tempsEcoule = notification.tempsEcoule;
        expect(tempsEcoule, contains('Il y a'));
        print('✅ Temps écoulé pour ${testCase['description']}: $tempsEcoule');
      }

      print('✅ Formatage des temps écoulés testé');
    });

    test('Test de marquage comme lue', () {
      final notification = NotificationModel(
        id: 1,
        titre: 'Test',
        message: 'Message',
        type: NotificationModel.typeInscription,
        dateCreation: DateTime.now(),
        lue: false,
      );

      expect(notification.lue, isFalse);

      final notificationLue = notification.marquerCommeLue();
      expect(notificationLue.lue, isTrue);
      expect(notificationLue.id, equals(notification.id));
      expect(notificationLue.titre, equals(notification.titre));

      print('✅ Marquage comme lue testé');
    });

    test('Test de sérialisation JSON', () {
      final notification = NotificationModel(
        id: 1,
        titre: 'Test JSON',
        message: 'Message JSON',
        type: NotificationModel.typeResultat,
        dateCreation: DateTime(2025, 8, 1, 12, 0, 0),
        lue: true,
        donId: 123,
      );

      // Test toJson
      final json = notification.toJson();
      expect(json['id'], equals(1));
      expect(json['titre'], equals('Test JSON'));
      expect(json['type'], equals(NotificationModel.typeResultat));
      expect(json['lue'], isTrue);
      expect(json['don_id'], equals(123));

      // Test fromJson
      final notificationFromJson = NotificationModel.fromJson(json);
      expect(notificationFromJson.id, equals(notification.id));
      expect(notificationFromJson.titre, equals(notification.titre));
      expect(notificationFromJson.type, equals(notification.type));
      expect(notificationFromJson.lue, equals(notification.lue));

      print('✅ Sérialisation JSON testée');
    });
  });

  group('Tests d\'intégration NotificationService', () {
    test('Test d\'initialisation du service', () {
      final service = NotificationService();

      expect(service, isNotNull);
      expect(service.notifications, isNotNull);
      expect(service.notificationsStream, isNotNull);
      expect(service.badgeStream, isNotNull);

      print('✅ Service de notifications initialisé');
    });

    test('Test du comptage des notifications non lues', () {
      final notifications = [
        NotificationModel(
          titre: 'Non lue 1',
          message: 'Message 1',
          type: NotificationModel.typeInscription,
          dateCreation: DateTime.now(),
          lue: false,
        ),
        NotificationModel(
          titre: 'Lue',
          message: 'Message 2',
          type: NotificationModel.typeRappel,
          dateCreation: DateTime.now(),
          lue: true,
        ),
        NotificationModel(
          titre: 'Non lue 2',
          message: 'Message 3',
          type: NotificationModel.typeUrgent,
          dateCreation: DateTime.now(),
          lue: false,
        ),
      ];

      final nonLues = notifications.where((n) => !n.lue).length;
      expect(nonLues, equals(2));

      print('✅ Comptage des notifications non lues: $nonLues/3');
    });
  });

  group('Tests de performance et edge cases', () {
    test('Test avec un nombre modéré de notifications', () {
      const nombreNotifications =
          50; // Réduit pour éviter les problèmes de performance
      final notifications = List.generate(nombreNotifications, (index) {
        return NotificationModel(
          id: index,
          titre: 'Notification $index',
          message: 'Message $index',
          type: index % 2 == 0
              ? NotificationModel.typeInscription
              : NotificationModel.typeRappel,
          dateCreation: DateTime.now().subtract(Duration(hours: index)),
          lue: index % 3 == 0,
        );
      });

      expect(notifications.length, equals(nombreNotifications));

      final nonLues = notifications.where((n) => !n.lue).length;
      expect(nonLues, greaterThan(0));

      print(
          '✅ Test de performance: $nombreNotifications notifications, $nonLues non lues');
    });

    test('Test avec des données invalides', () {
      // Test avec titre vide
      expect(() {
        NotificationModel(
          titre: '',
          message: 'Message',
          type: NotificationModel.typeInformation,
          dateCreation: DateTime.now(),
        );
      }, isNot(throwsException)); // Autorisé mais pas recommandé

      // Test avec type invalide
      final notificationTypeInvalide = NotificationModel(
        titre: 'Test',
        message: 'Message',
        type: 'type_inexistant',
        dateCreation: DateTime.now(),
      );

      expect(notificationTypeInvalide.icone, equals('📢')); // Icône par défaut
      expect(notificationTypeInvalide.couleur,
          equals('#6B7280')); // Couleur par défaut

      print('✅ Gestion des données invalides testée');
    });
  });
}

/// Classe d'assistance pour les tests de notifications
class NotificationTestHelper {
  static NotificationModel createTestNotification({
    int? id,
    required String titre,
    required String message,
    required String type,
    DateTime? dateCreation,
    bool lue = false,
    int? donId,
    int? analyseId,
  }) {
    return NotificationModel(
      id: id,
      titre: titre,
      message: message,
      type: type,
      dateCreation: dateCreation ?? DateTime.now(),
      lue: lue,
      donId: donId,
      analyseId: analyseId,
    );
  }

  static List<NotificationModel> createTestNotificationList() {
    return [
      createTestNotification(
        id: 1,
        titre: 'Inscription confirmée',
        message: 'Votre inscription à la campagne "Don Campus" a été confirmée',
        type: NotificationModel.typeInscription,
        dateCreation: DateTime.now().subtract(const Duration(hours: 1)),
        donId: 123,
      ),
      createTestNotification(
        id: 2,
        titre: 'Rappel de rendez-vous',
        message: 'N\'oubliez pas votre rendez-vous demain à 14h',
        type: NotificationModel.typeRappel,
        dateCreation: DateTime.now().subtract(const Duration(hours: 12)),
        lue: true,
      ),
      createTestNotification(
        id: 3,
        titre: 'Résultats disponibles',
        message: 'Vos résultats d\'analyse sont disponibles',
        type: NotificationModel.typeResultat,
        dateCreation: DateTime.now().subtract(const Duration(days: 2)),
        analyseId: 456,
      ),
      createTestNotification(
        id: 4,
        titre: 'Urgence - Besoin de donneurs O-',
        message: 'Nous avons un besoin urgent de donneurs O- dans votre région',
        type: NotificationModel.typeUrgent,
        dateCreation: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  static void validateNotificationIntegrity(NotificationModel notification) {
    expect(notification.titre, isNotEmpty);
    expect(notification.message, isNotEmpty);
    expect(notification.type, isNotEmpty);
    expect(notification.dateCreation, isNotNull);
    expect(notification.icone, isNotEmpty);
    expect(notification.couleur, isNotEmpty);
    expect(notification.tempsEcoule, isNotEmpty);
  }

  static Map<String, int> analyzeNotificationTypes(
      List<NotificationModel> notifications) {
    final analysis = <String, int>{};

    for (final notification in notifications) {
      analysis[notification.type] = (analysis[notification.type] ?? 0) + 1;
    }

    return analysis;
  }

  static void printNotificationSummary(List<NotificationModel> notifications) {
    print('\n📊 RÉSUMÉ DES NOTIFICATIONS:');
    print('=' * 50);
    print('Total: ${notifications.length}');

    final nonLues = notifications.where((n) => !n.lue).length;
    print('Non lues: $nonLues');
    print('Lues: ${notifications.length - nonLues}');

    final analysis = analyzeNotificationTypes(notifications);
    print('\nRépartition par type:');
    analysis.forEach((type, count) {
      print('  $type: $count');
    });

    final recentes = notifications.where((n) => n.estRecente).length;
    print('\nRécentes (24h): $recentes');

    print('=' * 50);
  }
}
