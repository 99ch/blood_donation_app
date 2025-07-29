/// Modèle de données pour un utilisateur
class User {
  final int? id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final DateTime? dateJoined;
  final bool isActive;

  const User({
    this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.dateJoined,
    this.isActive = true,
  });

  /// Créer un User à partir d'un Map JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      dateJoined: json['date_joined'] != null
          ? DateTime.parse(json['date_joined'])
          : null,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  /// Convertir en Map JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (dateJoined != null) 'date_joined': dateJoined!.toIso8601String(),
      'is_active': isActive,
    };
  }

  /// Nom complet de l'utilisateur
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return firstName ?? lastName ?? username;
  }

  /// Copier avec des modifications
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    DateTime? dateJoined,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateJoined: dateJoined ?? this.dateJoined,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, fullName: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.username == username &&
        other.email == email;
  }

  @override
  int get hashCode {
    return Object.hash(id, username, email);
  }
}
