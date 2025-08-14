/// Modèle de données pour les notifications
class NotificationModel {
  final int? id;
  final String titre;
  final String message;
  final String type;
  final bool lue;
  final DateTime dateCreation;
  final Map<String, dynamic>? donnees;
  final int? donId;
  final int? analyseId;

  const NotificationModel({
    this.id,
    required this.titre,
    required this.message,
    required this.type,
    this.lue = false,
    required this.dateCreation,
    this.donnees,
    this.donId,
    this.analyseId,
  });

  /// Créer une NotificationModel à partir d'un Map JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int?,
      titre: json['titre'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      lue: json['lue'] as bool? ?? false,
      dateCreation: DateTime.parse(json['date_creation']),
      donnees: json['donnees'] as Map<String, dynamic>?,
      donId: json['don_id'] as int?,
      analyseId: json['analyse_id'] as int?,
    );
  }

  /// Convertir en Map JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'titre': titre,
      'message': message,
      'type': type,
      'lue': lue,
      'date_creation': dateCreation.toIso8601String(),
      if (donnees != null) 'donnees': donnees,
      if (donId != null) 'don_id': donId,
      if (analyseId != null) 'analyse_id': analyseId,
    };
  }

  /// Types de notifications prédéfinis
  static const String typeInscription = 'inscription';
  static const String typeRappel = 'rappel';
  static const String typeResultat = 'resultat';
  static const String typeUrgent = 'urgent';
  static const String typeInformation = 'information';

  /// Obtenir l'icône selon le type
  String get icone {
    switch (type) {
      case typeInscription:
        return '✅';
      case typeRappel:
        return '⏰';
      case typeResultat:
        return '📊';
      case typeUrgent:
        return '🚨';
      case typeInformation:
        return 'ℹ️';
      default:
        return '📢';
    }
  }

  /// Obtenir la couleur selon le type
  String get couleur {
    switch (type) {
      case typeInscription:
        return '#4CAF50'; // Vert
      case typeRappel:
        return '#FF9800'; // Orange
      case typeResultat:
        return '#2196F3'; // Bleu
      case typeUrgent:
        return '#F44336'; // Rouge
      case typeInformation:
        return '#9E9E9E'; // Gris
      default:
        return '#6B7280'; // Gris foncé
    }
  }

  /// Message de temps écoulé depuis la création
  String get tempsEcoule {
    final maintenant = DateTime.now();
    final difference = maintenant.difference(dateCreation);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inDays < 30) {
      final semaines = (difference.inDays / 7).floor();
      return 'Il y a $semaines semaine${semaines > 1 ? 's' : ''}';
    } else {
      final mois = (difference.inDays / 30).floor();
      return 'Il y a $mois mois';
    }
  }

  /// Vérifier si la notification est récente (moins de 24h)
  bool get estRecente {
    final maintenant = DateTime.now();
    return maintenant.difference(dateCreation).inHours < 24;
  }

  /// Copier avec des modifications
  NotificationModel copyWith({
    int? id,
    String? titre,
    String? message,
    String? type,
    bool? lue,
    DateTime? dateCreation,
    Map<String, dynamic>? donnees,
    int? donId,
    int? analyseId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      message: message ?? this.message,
      type: type ?? this.type,
      lue: lue ?? this.lue,
      dateCreation: dateCreation ?? this.dateCreation,
      donnees: donnees ?? this.donnees,
      donId: donId ?? this.donId,
      analyseId: analyseId ?? this.analyseId,
    );
  }

  /// Marquer comme lue
  NotificationModel marquerCommeLue() {
    return copyWith(lue: true);
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, titre: $titre, type: $type, lue: $lue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel &&
        other.id == id &&
        other.titre == titre &&
        other.dateCreation == dateCreation;
  }

  @override
  int get hashCode {
    return Object.hash(id, titre, dateCreation);
  }
}
