/// Modèle de données pour un badge de donneur
class Badge {
  final int? id;
  final String nom;
  final String description;
  final String type;
  final String? iconUrl;
  final String? couleur;
  final int seuil;
  final DateTime? dateObtention;
  final int? donneurId;
  final bool obtenu;
  final DateTime? dateCreation;

  const Badge({
    this.id,
    required this.nom,
    required this.description,
    required this.type,
    this.iconUrl,
    this.couleur,
    required this.seuil,
    this.dateObtention,
    this.donneurId,
    this.obtenu = false,
    this.dateCreation,
  });

  /// Créer un Badge à partir d'un Map JSON
  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as int?,
      nom: json['nom'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      iconUrl: json['icon_url'] as String?,
      couleur: json['couleur'] as String?,
      seuil: json['seuil'] as int,
      dateObtention: json['date_obtention'] != null
          ? DateTime.parse(json['date_obtention'])
          : null,
      donneurId: json['donneur_id'] as int?,
      obtenu: json['obtenu'] as bool? ?? false,
      dateCreation: json['date_creation'] != null
          ? DateTime.parse(json['date_creation'])
          : null,
    );
  }

  /// Convertir en Map JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nom': nom,
      'description': description,
      'type': type,
      if (iconUrl != null) 'icon_url': iconUrl,
      if (couleur != null) 'couleur': couleur,
      'seuil': seuil,
      if (dateObtention != null)
        'date_obtention': dateObtention!.toIso8601String(),
      if (donneurId != null) 'donneur_id': donneurId,
      'obtenu': obtenu,
      if (dateCreation != null)
        'date_creation': dateCreation!.toIso8601String(),
    };
  }

  /// Icône par défaut selon le type de badge
  String get iconeParDefaut {
    switch (type.toLowerCase()) {
      case 'first_donation':
        return '🎉';
      case 'regular_donor':
        return '⭐';
      case 'hero_donor':
        return '🦸';
      case 'champion_donor':
        return '🏆';
      case 'life_saver':
        return '❤️';
      default:
        return '🏅';
    }
  }

  /// Couleur par défaut selon le type de badge
  String get couleurParDefaut {
    switch (type.toLowerCase()) {
      case 'first_donation':
        return '#4CAF50'; // Vert
      case 'regular_donor':
        return '#2196F3'; // Bleu
      case 'hero_donor':
        return '#FF9800'; // Orange
      case 'champion_donor':
        return '#9C27B0'; // Violet
      case 'life_saver':
        return '#F44336'; // Rouge
      default:
        return '#9E9E9E'; // Gris
    }
  }

  /// Nom traduit du badge
  String get nomTraduit {
    switch (type.toLowerCase()) {
      case 'first_donation':
        return 'Premier Don';
      case 'regular_donor':
        return 'Donneur Régulier';
      case 'hero_donor':
        return 'Donneur Héros';
      case 'champion_donor':
        return 'Champion';
      case 'life_saver':
        return 'Sauveur de Vie';
      default:
        return nom;
    }
  }

  /// Message de félicitations pour l'obtention du badge
  String get messageFelicitations {
    return 'Félicitations ! Vous avez obtenu le badge "$nomTraduit" !';
  }

  /// Niveau de prestige du badge (1-5)
  int get niveauPrestige {
    switch (type.toLowerCase()) {
      case 'first_donation':
        return 1;
      case 'regular_donor':
        return 2;
      case 'hero_donor':
        return 3;
      case 'champion_donor':
        return 4;
      case 'life_saver':
        return 5;
      default:
        return 1;
    }
  }

  /// Vérifie si le badge peut être obtenu avec le nombre de dons donné
  bool peutEtreObtenu(int nombreDons) {
    return nombreDons >= seuil;
  }

  /// Progression vers l'obtention du badge (0.0 à 1.0)
  double progression(int nombreDons) {
    if (nombreDons >= seuil) return 1.0;
    return (nombreDons / seuil).clamp(0.0, 1.0);
  }

  /// Nombre de dons restants pour obtenir le badge
  int donsRestants(int nombreDons) {
    return (seuil - nombreDons).clamp(0, seuil);
  }

  /// Message de progression vers le badge
  String messageProgression(int nombreDons) {
    if (obtenu) return 'Badge obtenu !';
    if (nombreDons >= seuil) return 'Badge prêt à être débloqué !';

    final restants = donsRestants(nombreDons);
    if (restants == 1) {
      return 'Plus qu\'un don pour obtenir ce badge !';
    }
    return 'Encore $restants dons pour obtenir ce badge.';
  }

  /// Copier avec des modifications
  Badge copyWith({
    int? id,
    String? nom,
    String? description,
    String? type,
    String? iconUrl,
    String? couleur,
    int? seuil,
    DateTime? dateObtention,
    int? donneurId,
    bool? obtenu,
    DateTime? dateCreation,
  }) {
    return Badge(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      type: type ?? this.type,
      iconUrl: iconUrl ?? this.iconUrl,
      couleur: couleur ?? this.couleur,
      seuil: seuil ?? this.seuil,
      dateObtention: dateObtention ?? this.dateObtention,
      donneurId: donneurId ?? this.donneurId,
      obtenu: obtenu ?? this.obtenu,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }

  @override
  String toString() {
    return 'Badge(id: $id, nom: $nom, type: $type, obtenu: $obtenu)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Badge &&
        other.id == id &&
        other.type == type &&
        other.donneurId == donneurId;
  }

  @override
  int get hashCode {
    return Object.hash(id, type, donneurId);
  }
}

/// Liste des badges par défaut du système
class DefaultBadges {
  static const List<Map<String, dynamic>> badges = [
    {
      'nom': 'Premier Don',
      'description': 'Félicitations pour votre premier don de sang !',
      'type': 'first_donation',
      'seuil': 1,
      'couleur': '#4CAF50',
    },
    {
      'nom': 'Donneur Régulier',
      'description': 'Merci pour vos 5 dons, vous êtes un donneur régulier !',
      'type': 'regular_donor',
      'seuil': 5,
      'couleur': '#2196F3',
    },
    {
      'nom': 'Donneur Héros',
      'description': 'Avec 10 dons, vous êtes un véritable héros !',
      'type': 'hero_donor',
      'seuil': 10,
      'couleur': '#FF9800',
    },
    {
      'nom': 'Champion',
      'description': '25 dons ! Vous êtes un champion du don de sang !',
      'type': 'champion_donor',
      'seuil': 25,
      'couleur': '#9C27B0',
    },
    {
      'nom': 'Sauveur de Vie',
      'description': '50 dons ! Vous avez sauvé de nombreuses vies !',
      'type': 'life_saver',
      'seuil': 50,
      'couleur': '#F44336',
    },
  ];

  /// Obtenir tous les badges par défaut
  static List<Badge> get all {
    return badges.map((badgeData) => Badge.fromJson(badgeData)).toList();
  }

  /// Obtenir un badge par son type
  static Badge? getByType(String type) {
    final badgeData = badges.firstWhere(
      (badge) => badge['type'] == type,
      orElse: () => <String, dynamic>{},
    );

    if (badgeData.isEmpty) return null;
    return Badge.fromJson(badgeData);
  }
}
