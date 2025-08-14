/// Modèle pour un don de sang - Aligné avec l'API Django
class Don {
  final int? id;
  final int donneurId;
  final DateTime date;
  final double quantite; // en litres, par défaut 0.45
  final String statut; // absent, present

  const Don({
    this.id,
    required this.donneurId,
    required this.date,
    this.quantite = 0.45,
    this.statut = 'absent',
  });

  /// Créer un Don à partir d'un Map JSON
  factory Don.fromJson(Map<String, dynamic> json) {
    return Don(
      id: json['id'] as int?,
      donneurId: json['donneur'] as int,
      date: DateTime.parse(json['date']),
      quantite: (json['quantite'] as num?)?.toDouble() ?? 0.45,
      statut: json['statut'] as String? ?? 'absent',
    );
  }

  /// Convertir en Map JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'donneur': donneurId,
      'date': date.toIso8601String().split('T')[0],
      'quantite': quantite,
      'statut': statut,
    };
  }

  /// Vérifier si le don a été effectué
  bool get aEteEffectue => statut == 'present';

  /// Vérifier si le don a été manqué
  bool get aEteManque => statut == 'absent';

  /// Copier avec des modifications
  Don copyWith({
    int? id,
    int? donneurId,
    DateTime? date,
    double? quantite,
    String? statut,
  }) {
    return Don(
      id: id ?? this.id,
      donneurId: donneurId ?? this.donneurId,
      date: date ?? this.date,
      quantite: quantite ?? this.quantite,
      statut: statut ?? this.statut,
    );
  }

  @override
  String toString() {
    return 'Don(id: $id, donneurId: $donneurId, date: $date, statut: $statut)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Don &&
        other.id == id &&
        other.donneurId == donneurId &&
        other.date == date;
  }

  @override
  int get hashCode {
    return Object.hash(id, donneurId, date);
  }

  /// Statuts possibles pour un don
  static const List<String> statutsDisponibles = ['absent', 'present'];
}
