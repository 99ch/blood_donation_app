/// Modèle de données pour un donneur de sang - Aligné avec l'API Django
class Donor {
  final int? id;
  final int? user; // Relation avec User Django
  final String nom;
  final String prenoms;
  final String email; // Requis dans Django
  final String telephone; // Requis dans Django
  final DateTime dateNaissance; // Requis dans Django (date_de_naissance)
  final String? groupeSanguin; // groupe_sanguin dans Django
  final String? localisation; // Nouveau champ Django
  final double? poids; // Nouveau champ Django
  final double? taille; // Nouveau champ Django
  final String pays; // Requis dans Django avec choix
  final int nbDons; // nb_dons dans Django
  final double litresDonnes; // litres_donnes dans Django
  final bool isVerified; // is_verified dans Django

  const Donor({
    this.id,
    this.user,
    required this.nom,
    required this.prenoms,
    required this.email,
    required this.telephone,
    required this.dateNaissance,
    this.groupeSanguin,
    this.localisation,
    this.poids,
    this.taille,
    this.pays = 'benin', // Valeur par défaut Django
    this.nbDons = 0,
    this.litresDonnes = 0.0,
    this.isVerified = false,
  });

  /// Créer un Donor à partir d'un Map JSON - Compatible avec l'API Django
  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      id: json['id'] as int?,
      user: json['user'] as int?,
      nom: json['nom'] as String,
      prenoms: json['prenoms'] as String,
      email: json['email'] as String,
      telephone: json['telephone'] as String,
      dateNaissance: DateTime.parse(json['date_de_naissance']),
      groupeSanguin: json['groupe_sanguin'] as String?,
      localisation: json['localisation'] as String?,
      poids: (json['poids'] as num?)?.toDouble(),
      taille: (json['taille'] as num?)?.toDouble(),
      pays: json['pays'] as String? ?? 'benin',
      nbDons: json['nb_dons'] as int? ?? 0,
      litresDonnes: (json['litres_donnes'] as num?)?.toDouble() ?? 0.0,
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }

  /// Convertir en Map JSON - Compatible avec l'API Django
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (user != null) 'user': user,
      'nom': nom,
      'prenoms': prenoms,
      'email': email,
      'telephone': telephone,
      'date_de_naissance': dateNaissance.toIso8601String().split('T')[0],
      if (groupeSanguin != null) 'groupe_sanguin': groupeSanguin,
      if (localisation != null) 'localisation': localisation,
      if (poids != null) 'poids': poids,
      if (taille != null) 'taille': taille,
      'pays': pays,
      'nb_dons': nbDons,
      'litres_donnes': litresDonnes,
      'is_verified': isVerified,
    };
  }

  /// Nom complet du donneur
  String get nomComplet => '$prenoms $nom';

  /// Âge du donneur (approximatif)
  int get age {
    final now = DateTime.now();
    int age = now.year - dateNaissance.year;
    if (now.month < dateNaissance.month ||
        (now.month == dateNaissance.month && now.day < dateNaissance.day)) {
      age--;
    }
    return age;
  }

  /// Vérifie si le donneur peut faire un don (basé sur l'âge minimum)
  bool get peutDonner {
    return age >= 18 && isVerified;
  }

  /// Statut du donneur
  String get statut {
    if (!isVerified) return 'Non vérifié';
    if (age < 18) return 'Trop jeune';
    return 'Éligible';
  }

  /// Niveau de badge basé sur le nombre de dons
  String get niveauBadge {
    if (nbDons >= 50) return 'Sauveur de Vie';
    if (nbDons >= 25) return 'Champion';
    if (nbDons >= 10) return 'Donneur Héros';
    if (nbDons >= 5) return 'Donneur Régulier';
    if (nbDons >= 1) return 'Premier Don';
    return 'Nouveau';
  }

  /// Copier avec des modifications
  Donor copyWith({
    int? id,
    int? user,
    String? nom,
    String? prenoms,
    String? email,
    String? telephone,
    DateTime? dateNaissance,
    String? groupeSanguin,
    String? localisation,
    double? poids,
    double? taille,
    String? pays,
    int? nbDons,
    double? litresDonnes,
    bool? isVerified,
  }) {
    return Donor(
      id: id ?? this.id,
      user: user ?? this.user,
      nom: nom ?? this.nom,
      prenoms: prenoms ?? this.prenoms,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      groupeSanguin: groupeSanguin ?? this.groupeSanguin,
      localisation: localisation ?? this.localisation,
      poids: poids ?? this.poids,
      taille: taille ?? this.taille,
      pays: pays ?? this.pays,
      nbDons: nbDons ?? this.nbDons,
      litresDonnes: litresDonnes ?? this.litresDonnes,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  String toString() {
    return 'Donor(id: $id, nom: $nomComplet, email: $email, groupeSanguin: $groupeSanguin)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Donor &&
        other.id == id &&
        other.nom == nom &&
        other.prenoms == prenoms;
  }

  @override
  int get hashCode {
    return Object.hash(id, nom, prenoms);
  }

  /// Liste des groupes sanguins disponibles (correspondant aux choix Django)
  static const List<String> groupesSanguins = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  /// Liste des pays disponibles (correspondant aux choix Django)
  static const List<String> paysDisponibles = ['france', 'benin'];

  /// Validation du format de téléphone (correspondant au regex Django)
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?1?\d{9,15}$');
    return phoneRegex.hasMatch(phone);
  }

  /// Validation de l'âge minimum (18 ans comme dans Django)
  static bool isValidAge(DateTime dateNaissance) {
    final now = DateTime.now();
    final age = now.year - dateNaissance.year;
    return age >= 18;
  }
}
