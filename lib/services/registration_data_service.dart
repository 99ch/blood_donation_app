/// Service pour gérer les données temporaires de l'inscription
/// Stocke l'email et les informations nécessaires entre les étapes d'inscription
class RegistrationDataService {
  static final RegistrationDataService _instance =
      RegistrationDataService._internal();
  factory RegistrationDataService() => _instance;
  RegistrationDataService._internal();

  // Données temporaires de l'inscription
  String? _userEmail;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _donneurData;

  // Getters
  String? get userEmail => _userEmail;
  Map<String, dynamic>? get userData => _userData;
  Map<String, dynamic>? get donneurData => _donneurData;

  /// Stocker les données après l'inscription complète
  void setRegistrationData({
    required String email,
    Map<String, dynamic>? user,
    Map<String, dynamic>? donneur,
  }) {
    _userEmail = email;
    _userData = user;
    _donneurData = donneur;
    print('📝 Données d\'inscription stockées pour: $email');
  }

  /// Récupérer l'email pour compléter le profil
  String? getEmailForProfile() {
    return _userEmail;
  }

  /// Nettoyer les données après utilisation
  void clearRegistrationData() {
    _userEmail = null;
    _userData = null;
    _donneurData = null;
    print('🧹 Données d\'inscription nettoyées');
  }

  /// Vérifier si des données d'inscription sont disponibles
  bool hasRegistrationData() {
    return _userEmail != null;
  }
}
