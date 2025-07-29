/// Modèle de données pour une campagne de don
class Campaign {
  final int? id;
  final String titre;
  final String description;
  final DateTime date;
  final String lieu;
  final String heures;
  final int objectif;
  final int participantsActuels;
  final String organisateur;
  final String urgence;
  final String? imageUrl;
  final String? typesSanguinsRecherches;
  final bool active;
  final DateTime? dateCreation;
  final DateTime? dateModification;

  const Campaign({
    this.id,
    required this.titre,
    required this.description,
    required this.date,
    required this.lieu,
    required this.heures,
    required this.objectif,
    this.participantsActuels = 0,
    required this.organisateur,
    this.urgence = 'normale',
    this.imageUrl,
    this.typesSanguinsRecherches,
    this.active = true,
    this.dateCreation,
    this.dateModification,
  });

  /// Créer une Campaign à partir d'un Map JSON
  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] as int?,
      titre: json['titre'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date']),
      lieu: json['lieu'] as String,
      heures: json['heures'] as String,
      objectif: json['objectif'] as int,
      participantsActuels: json['participants_actuels'] as int? ?? 0,
      organisateur: json['organisateur'] as String,
      urgence: json['urgence'] as String? ?? 'normale',
      imageUrl: json['image_url'] as String?,
      typesSanguinsRecherches: json['types_sanguins_recherches'] as String?,
      active: json['active'] as bool? ?? true,
      dateCreation: json['date_creation'] != null
          ? DateTime.parse(json['date_creation'])
          : null,
      dateModification: json['date_modification'] != null
          ? DateTime.parse(json['date_modification'])
          : null,
    );
  }

  /// Convertir en Map JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'titre': titre,
      'description': description,
      'date': date.toIso8601String().split('T')[0],
      'lieu': lieu,
      'heures': heures,
      'objectif': objectif,
      'participants_actuels': participantsActuels,
      'organisateur': organisateur,
      'urgence': urgence,
      if (imageUrl != null) 'image_url': imageUrl,
      if (typesSanguinsRecherches != null)
        'types_sanguins_recherches': typesSanguinsRecherches,
      'active': active,
      if (dateCreation != null)
        'date_creation': dateCreation!.toIso8601String(),
      if (dateModification != null)
        'date_modification': dateModification!.toIso8601String(),
    };
  }

  /// Pourcentage de progression de la campagne
  double get progression {
    if (objectif == 0) return 0.0;
    return (participantsActuels / objectif).clamp(0.0, 1.0);
  }

  /// Pourcentage de progression en tant que chaîne
  String get progressionPourcentage {
    return '${(progression * 100).toInt()}%';
  }

  /// Nombre de participants restants pour atteindre l'objectif
  int get participantsRestants {
    return (objectif - participantsActuels).clamp(0, objectif);
  }

  /// Vérifie si la campagne est terminée (objectif atteint)
  bool get estTerminee => participantsActuels >= objectif;

  /// Vérifie si la campagne est expirée
  bool get estExpiree => DateTime.now().isAfter(date);

  /// Vérifie si la campagne est à venir
  bool get estAVenir => DateTime.now().isBefore(date);

  /// Vérifie si la campagne est en cours aujourd'hui
  bool get estEnCours {
    final maintenant = DateTime.now();
    return maintenant.year == date.year &&
        maintenant.month == date.month &&
        maintenant.day == date.day;
  }

  /// Statut de la campagne
  String get statut {
    if (estExpiree && !estTerminee) return 'Expirée';
    if (estTerminee) return 'Terminée';
    if (estEnCours) return 'En cours';
    if (estAVenir) return 'À venir';
    return 'Active';
  }

  /// Couleur associée au niveau d'urgence
  String get couleurUrgence {
    switch (urgence.toLowerCase()) {
      case 'critique':
        return '#F44336'; // Rouge
      case 'haute':
        return '#FF9800'; // Orange
      case 'normale':
        return '#4CAF50'; // Vert
      case 'faible':
        return '#2196F3'; // Bleu
      default:
        return '#9E9E9E'; // Gris
    }
  }

  /// Icône associée au niveau d'urgence
  String get iconeUrgence {
    switch (urgence.toLowerCase()) {
      case 'critique':
        return '🚨';
      case 'haute':
        return '⚠️';
      case 'normale':
        return '📋';
      case 'faible':
        return 'ℹ️';
      default:
        return '📝';
    }
  }

  /// Jours restants avant la campagne
  int get joursRestants {
    if (estExpiree) return 0;
    return date.difference(DateTime.now()).inDays;
  }

  /// Message de temps restant
  String get tempsRestant {
    if (estExpiree) return 'Expirée';
    if (estEnCours) return 'Aujourd\'hui';
    if (joursRestants == 1) return 'Demain';
    if (joursRestants < 7) return 'Dans $joursRestants jours';
    if (joursRestants < 30)
      return 'Dans ${(joursRestants / 7).floor()} semaines';
    return 'Dans ${(joursRestants / 30).floor()} mois';
  }

  /// Copier avec des modifications
  Campaign copyWith({
    int? id,
    String? titre,
    String? description,
    DateTime? date,
    String? lieu,
    String? heures,
    int? objectif,
    int? participantsActuels,
    String? organisateur,
    String? urgence,
    String? imageUrl,
    String? typesSanguinsRecherches,
    bool? active,
    DateTime? dateCreation,
    DateTime? dateModification,
  }) {
    return Campaign(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      date: date ?? this.date,
      lieu: lieu ?? this.lieu,
      heures: heures ?? this.heures,
      objectif: objectif ?? this.objectif,
      participantsActuels: participantsActuels ?? this.participantsActuels,
      organisateur: organisateur ?? this.organisateur,
      urgence: urgence ?? this.urgence,
      imageUrl: imageUrl ?? this.imageUrl,
      typesSanguinsRecherches:
          typesSanguinsRecherches ?? this.typesSanguinsRecherches,
      active: active ?? this.active,
      dateCreation: dateCreation ?? this.dateCreation,
      dateModification: dateModification ?? this.dateModification,
    );
  }

  @override
  String toString() {
    return 'Campaign(id: $id, titre: $titre, date: $date, statut: $statut)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Campaign &&
        other.id == id &&
        other.titre == titre &&
        other.date == date;
  }

  @override
  int get hashCode {
    return Object.hash(id, titre, date);
  }
}
