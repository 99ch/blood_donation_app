/// Modèle pour les résultats d'analyse - Aligné avec l'API Django
class ResultatAnalyse {
  final int? id;
  final int donneurId;
  final String? fichierPdf; // URL du fichier PDF
  final DateTime dateAjout;
  final String statut; // en attente, verified, resultat transfere
  final int verifications; // Nombre de vérifications
  final List<int>? verificateurIds; // IDs des utilisateurs qui ont vérifié

  const ResultatAnalyse({
    this.id,
    required this.donneurId,
    this.fichierPdf,
    required this.dateAjout,
    this.statut = 'en attente',
    this.verifications = 0,
    this.verificateurIds,
  });

  /// Créer un ResultatAnalyse à partir d'un Map JSON
  factory ResultatAnalyse.fromJson(Map<String, dynamic> json) {
    return ResultatAnalyse(
      id: json['id'] as int?,
      donneurId: json['donneur'] as int,
      fichierPdf: json['fichier_pdf'] as String?,
      dateAjout: DateTime.parse(json['date_ajout']),
      statut: json['statut'] as String? ?? 'en attente',
      verifications: json['verifications'] as int? ?? 0,
      verificateurIds: json['verificateur_ids'] != null
          ? List<int>.from(json['verificateur_ids'])
          : null,
    );
  }

  /// Convertir en Map JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'donneur': donneurId,
      if (fichierPdf != null) 'fichier_pdf': fichierPdf,
      'date_ajout': dateAjout.toIso8601String(),
      'statut': statut,
      'verifications': verifications,
      if (verificateurIds != null) 'verificateur_ids': verificateurIds,
    };
  }

  /// Vérifier si l'analyse est complètement vérifiée (2 vérifications)
  bool get estVerifiee => statut == 'verified' && verifications >= 2;

  /// Vérifier si l'analyse est en attente
  bool get estEnAttente => statut == 'en attente';

  /// Vérifier si le résultat a été transféré
  bool get estTransfere => statut == 'resultat transfere';

  /// Copier avec des modifications
  ResultatAnalyse copyWith({
    int? id,
    int? donneurId,
    String? fichierPdf,
    DateTime? dateAjout,
    String? statut,
    int? verifications,
    List<int>? verificateurIds,
  }) {
    return ResultatAnalyse(
      id: id ?? this.id,
      donneurId: donneurId ?? this.donneurId,
      fichierPdf: fichierPdf ?? this.fichierPdf,
      dateAjout: dateAjout ?? this.dateAjout,
      statut: statut ?? this.statut,
      verifications: verifications ?? this.verifications,
      verificateurIds: verificateurIds ?? this.verificateurIds,
    );
  }

  @override
  String toString() {
    return 'ResultatAnalyse(id: $id, donneurId: $donneurId, statut: $statut)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResultatAnalyse &&
        other.id == id &&
        other.donneurId == donneurId;
  }

  @override
  int get hashCode {
    return Object.hash(id, donneurId);
  }

  /// Statuts possibles pour les analyses
  static const List<String> statutsDisponibles = [
    'en attente',
    'verified',
    'resultat transfere'
  ];
}
