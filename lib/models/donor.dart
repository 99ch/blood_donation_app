/// Modèle de données pour un donneur de sang
class Donor {
  final int? id;
  final String nom;
  final String prenoms;
  final String? email;
  final String? telephone;
  final DateTime? dateNaissance;
  final String? sexe;
  final String? groupeSanguin;
  final String? adresse;
  final String? ville;
  final String? pays;
  final String? profession;
  final String? situationMatrimoniale;
  final String? personneContact;
  final String? telephoneContact;
  final bool? eligibleDon;
  final DateTime? dernierDon;
  final int nombreDons;
  final DateTime? dateCreation;
  final DateTime? dateModification;

  const Donor({
    this.id,
    required this.nom,
    required this.prenoms,
    this.email,
    this.telephone,
    this.dateNaissance,
    this.sexe,
    this.groupeSanguin,
    this.adresse,
    this.ville,
    this.pays,
    this.profession,
    this.situationMatrimoniale,
    this.personneContact,
    this.telephoneContact,
    this.eligibleDon,
    this.dernierDon,
    this.nombreDons = 0,
    this.dateCreation,
    this.dateModification,
  });

  /// Créer un Donor à partir d'un Map JSON
  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      id: json['id'] as int?,
      nom: json['nom'] as String,
      prenoms: json['prenoms'] as String,
      email: json['email'] as String?,
      telephone: json['telephone'] as String?,
      dateNaissance: json['date_naissance'] != null
          ? DateTime.parse(json['date_naissance'])
          : null,
      sexe: json['sexe'] as String?,
      groupeSanguin: json['groupe_sanguin'] as String?,
      adresse: json['adresse'] as String?,
      ville: json['ville'] as String?,
      pays: json['pays'] as String?,
      profession: json['profession'] as String?,
      situationMatrimoniale: json['situation_matrimoniale'] as String?,
      personneContact: json['personne_contact'] as String?,
      telephoneContact: json['telephone_contact'] as String?,
      eligibleDon: json['eligible_don'] as bool?,
      dernierDon: json['dernier_don'] != null
          ? DateTime.parse(json['dernier_don'])
          : null,
      nombreDons: json['nombre_dons'] as int? ?? 0,
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
      'nom': nom,
      'prenoms': prenoms,
      if (email != null) 'email': email,
      if (telephone != null) 'telephone': telephone,
      if (dateNaissance != null)
        'date_naissance': dateNaissance!.toIso8601String().split('T')[0],
      if (sexe != null) 'sexe': sexe,
      if (groupeSanguin != null) 'groupe_sanguin': groupeSanguin,
      if (adresse != null) 'adresse': adresse,
      if (ville != null) 'ville': ville,
      if (pays != null) 'pays': pays,
      if (profession != null) 'profession': profession,
      if (situationMatrimoniale != null)
        'situation_matrimoniale': situationMatrimoniale,
      if (personneContact != null) 'personne_contact': personneContact,
      if (telephoneContact != null) 'telephone_contact': telephoneContact,
      if (eligibleDon != null) 'eligible_don': eligibleDon,
      if (dernierDon != null)
        'dernier_don': dernierDon!.toIso8601String().split('T')[0],
      'nombre_dons': nombreDons,
      if (dateCreation != null)
        'date_creation': dateCreation!.toIso8601String(),
      if (dateModification != null)
        'date_modification': dateModification!.toIso8601String(),
    };
  }

  /// Nom complet du donneur
  String get nomComplet => '$prenoms $nom';

  /// Âge du donneur (approximatif)
  int? get age {
    if (dateNaissance == null) return null;
    final now = DateTime.now();
    int age = now.year - dateNaissance!.year;
    if (now.month < dateNaissance!.month ||
        (now.month == dateNaissance!.month && now.day < dateNaissance!.day)) {
      age--;
    }
    return age;
  }

  /// Vérifie si le donneur peut faire un don (délai minimum)
  bool get peutDonner {
    if (eligibleDon == false) return false;
    if (dernierDon == null) return true;

    // Délai minimum de 8 semaines entre les dons pour les hommes
    // et 12 semaines pour les femmes
    final delaiMinimum = sexe == 'F' ? 12 : 8;
    final prochainDonPossible =
        dernierDon!.add(Duration(days: delaiMinimum * 7));

    return DateTime.now().isAfter(prochainDonPossible);
  }

  /// Date du prochain don possible
  DateTime? get prochainDonPossible {
    if (dernierDon == null) return null;
    final delaiMinimum = sexe == 'F' ? 12 : 8;
    return dernierDon!.add(Duration(days: delaiMinimum * 7));
  }

  /// Statut du donneur
  String get statut {
    if (eligibleDon == false) return 'Non éligible';
    if (peutDonner) return 'Disponible';
    return 'En attente';
  }

  /// Niveau de badge basé sur le nombre de dons
  String get niveauBadge {
    if (nombreDons >= 50) return 'Sauveur de Vie';
    if (nombreDons >= 25) return 'Champion';
    if (nombreDons >= 10) return 'Donneur Héros';
    if (nombreDons >= 5) return 'Donneur Régulier';
    if (nombreDons >= 1) return 'Premier Don';
    return 'Nouveau';
  }

  /// Copier avec des modifications
  Donor copyWith({
    int? id,
    String? nom,
    String? prenoms,
    String? email,
    String? telephone,
    DateTime? dateNaissance,
    String? sexe,
    String? groupeSanguin,
    String? adresse,
    String? ville,
    String? pays,
    String? profession,
    String? situationMatrimoniale,
    String? personneContact,
    String? telephoneContact,
    bool? eligibleDon,
    DateTime? dernierDon,
    int? nombreDons,
    DateTime? dateCreation,
    DateTime? dateModification,
  }) {
    return Donor(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenoms: prenoms ?? this.prenoms,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      sexe: sexe ?? this.sexe,
      groupeSanguin: groupeSanguin ?? this.groupeSanguin,
      adresse: adresse ?? this.adresse,
      ville: ville ?? this.ville,
      pays: pays ?? this.pays,
      profession: profession ?? this.profession,
      situationMatrimoniale:
          situationMatrimoniale ?? this.situationMatrimoniale,
      personneContact: personneContact ?? this.personneContact,
      telephoneContact: telephoneContact ?? this.telephoneContact,
      eligibleDon: eligibleDon ?? this.eligibleDon,
      dernierDon: dernierDon ?? this.dernierDon,
      nombreDons: nombreDons ?? this.nombreDons,
      dateCreation: dateCreation ?? this.dateCreation,
      dateModification: dateModification ?? this.dateModification,
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
}
