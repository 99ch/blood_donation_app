import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification.dart';
import 'api_service.dart';
import 'auth_service.dart';

/// Service de gestion des notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final ApiService _apiService = ApiService();

  // Stream controller pour les notifications
  final StreamController<List<NotificationModel>> _notificationsController =
      StreamController<List<NotificationModel>>.broadcast();

  // Stream controller pour le badge de notifications non lues
  final StreamController<int> _badgeController =
      StreamController<int>.broadcast();

  // Cache local des notifications
  List<NotificationModel> _notifications = [];
  Timer? _pollingTimer;

  /// Stream des notifications
  Stream<List<NotificationModel>> get notificationsStream =>
      _notificationsController.stream;

  /// Stream du nombre de notifications non lues
  Stream<int> get badgeStream => _badgeController.stream;

  /// Liste actuelle des notifications
  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  /// Nombre de notifications non lues
  int get nombreNonLues => _notifications.where((n) => !n.lue).length;

  /// Initialiser le service
  Future<void> initialiser() async {
    await _chargerNotificationsLocales();
    await _synchroniserNotifications();
    _demarrerPolling();
  }

  /// Démarrer le polling des notifications toutes les 30 secondes
  void _demarrerPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _synchroniserNotifications();
    });
  }

  /// Arrêter le polling
  void arreterPolling() {
    _pollingTimer?.cancel();
  }

  /// Synchroniser avec le serveur
  Future<void> _synchroniserNotifications() async {
    try {
      final token = await AuthService.getAccessToken();
      if (token != null) {
        final nouvelles = await _apiService.getNotifications(token);
        if (nouvelles != null) {
          await _mettreAJourNotifications(nouvelles);
        }
      }
    } catch (e) {
      print('Erreur lors de la synchronisation des notifications: $e');
    }
  }

  /// Mettre à jour la liste des notifications
  Future<void> _mettreAJourNotifications(
      List<Map<String, dynamic>> donnees) async {
    final nouvelles =
        donnees.map((json) => NotificationModel.fromJson(json)).toList();

    // Fusionner avec les notifications existantes
    final Map<int, NotificationModel> notificationsMap = {};

    // Ajouter les existantes
    for (final notif in _notifications) {
      if (notif.id != null) {
        notificationsMap[notif.id!] = notif;
      }
    }

    // Mettre à jour avec les nouvelles
    for (final notif in nouvelles) {
      if (notif.id != null) {
        notificationsMap[notif.id!] = notif;
      }
    }

    // Trier par date de création (plus récente en premier)
    _notifications = notificationsMap.values.toList()
      ..sort((a, b) => b.dateCreation.compareTo(a.dateCreation));

    // Sauvegarder localement
    await _sauvegarderNotificationsLocales();

    // Notifier les listeners
    _notificationsController.add(_notifications);
    _badgeController.add(nombreNonLues);
  }

  /// Charger les notifications depuis le stockage local
  Future<void> _chargerNotificationsLocales() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString('notifications');

      if (json != null) {
        final List<dynamic> liste = jsonDecode(json);
        _notifications = liste
            .map((item) => NotificationModel.fromJson(item))
            .toList()
          ..sort((a, b) => b.dateCreation.compareTo(a.dateCreation));

        _notificationsController.add(_notifications);
        _badgeController.add(nombreNonLues);
      }
    } catch (e) {
      print('Erreur lors du chargement des notifications locales: $e');
    }
  }

  /// Sauvegarder les notifications localement
  Future<void> _sauvegarderNotificationsLocales() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(_notifications.map((n) => n.toJson()).toList());
      await prefs.setString('notifications', json);
    } catch (e) {
      print('Erreur lors de la sauvegarde des notifications locales: $e');
    }
  }

  /// Marquer une notification comme lue
  Future<void> marquerCommeLue(int notificationId) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        print('❌ Token non disponible pour marquer la notification');
        return;
      }

      final success =
          await _apiService.marquerNotificationLue(token, notificationId);

      if (success) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].marquerCommeLue();
          await _sauvegarderNotificationsLocales();

          _notificationsController.add(_notifications);
          _badgeController.add(nombreNonLues);
        }
      }
    } catch (e) {
      print('Erreur lors du marquage de la notification: $e');
    }
  }

  /// Marquer toutes les notifications comme lues
  Future<void> marquerToutesCommeLues() async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        print('❌ Token non disponible pour marquer les notifications');
        return;
      }

      final success = await _apiService.marquerToutesNotificationsLues(token);

      if (success) {
        _notifications =
            _notifications.map((n) => n.marquerCommeLue()).toList();
        await _sauvegarderNotificationsLocales();

        _notificationsController.add(_notifications);
        _badgeController.add(0);
      }
    } catch (e) {
      print('Erreur lors du marquage de toutes les notifications: $e');
    }
  }

  /// Supprimer une notification
  Future<void> supprimerNotification(int notificationId) async {
    try {
      final token = await AuthService.getAccessToken();
      if (token == null) {
        print('❌ Token non disponible pour supprimer la notification');
        return;
      }

      final success =
          await _apiService.supprimerNotification(token, notificationId);

      if (success) {
        _notifications.removeWhere((n) => n.id == notificationId);
        await _sauvegarderNotificationsLocales();

        _notificationsController.add(_notifications);
        _badgeController.add(nombreNonLues);
      }
    } catch (e) {
      print('Erreur lors de la suppression de la notification: $e');
    }
  }

  /// Ajouter une notification locale (pour les tests)
  Future<void> ajouterNotificationLocale(NotificationModel notification) async {
    _notifications.insert(0, notification);
    await _sauvegarderNotificationsLocales();

    _notificationsController.add(_notifications);
    _badgeController.add(nombreNonLues);
  }

  /// Créer une notification de test pour les résultats d'analyse
  Future<void> creerNotificationResultatTest() async {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch,
      titre: 'Résultats d\'analyse disponibles',
      message:
          'Vos résultats d\'analyse du don du 15 janvier sont maintenant disponibles. Consultez-les dans votre profil.',
      type: NotificationModel.typeResultat,
      dateCreation: DateTime.now(),
      donnees: {
        'don_id': 1,
        'analyse_id': 1,
        'resultats': {
          'hemoglobine': '14.5 g/dL',
          'hematocrite': '42%',
          'plaquettes': '250 000/µL',
          'globules_blancs': '7 500/µL',
        }
      },
    );

    await ajouterNotificationLocale(notification);
  }

  /// Créer une notification de rappel
  Future<void> creerNotificationRappelTest() async {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch + 1,
      titre: 'Rappel de don',
      message:
          'N\'oubliez pas votre rendez-vous de don demain à 14h au Centre de Santé.',
      type: NotificationModel.typeRappel,
      dateCreation: DateTime.now().subtract(const Duration(hours: 2)),
    );

    await ajouterNotificationLocale(notification);
  }

  /// Créer une notification urgente
  Future<void> creerNotificationUrgenteTest() async {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch + 2,
      titre: 'Don urgent requis',
      message:
          'Besoin urgent de donneurs O- à l\'hôpital. Votre aide est précieuse !',
      type: NotificationModel.typeUrgent,
      dateCreation: DateTime.now().subtract(const Duration(minutes: 30)),
    );

    await ajouterNotificationLocale(notification);
  }

  /// Nettoyer les ressources
  void dispose() {
    _pollingTimer?.cancel();
    _notificationsController.close();
    _badgeController.close();
  }
}
