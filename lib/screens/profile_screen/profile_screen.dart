import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/modern_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _donneurData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await AuthService.getValidAccessToken();
      if (token == null) {
        throw Exception('Utilisateur non authentifié');
      }

      final currentUser = await _apiService.getCurrentUser(token);
      if (currentUser != null) {
        setState(() {
          _userData = currentUser['user'];
          _donneurData = currentUser['donneur'];
          _isLoading = false;
        });
      } else {
        throw Exception('Impossible de récupérer les données utilisateur');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String _calculateYearsSinceDonation() {
    if (_donneurData == null || _donneurData!['date_creation'] == null) {
      return 'récemment';
    }

    try {
      final dateCreation = DateTime.parse(_donneurData!['date_creation']);
      final now = DateTime.now();
      final difference = now.difference(dateCreation);
      final years = (difference.inDays / 365).floor();

      if (years == 0) {
        final months = (difference.inDays / 30).floor();
        return months <= 1 ? 'récemment' : '$months mois';
      } else if (years == 1) {
        return '1 an';
      } else {
        return '$years ans';
      }
    } catch (e) {
      return 'récemment';
    }
  }

  String? _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;

    try {
      final date = DateTime.parse(dateString);
      final months = [
        'janvier',
        'février',
        'mars',
        'avril',
        'mai',
        'juin',
        'juillet',
        'août',
        'septembre',
        'octobre',
        'novembre',
        'décembre'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getLastDonationDate() {
    if (_donneurData == null || _donneurData!['dernier_don'] == null) {
      return 'Aucun don enregistré';
    }

    return _formatDate(_donneurData!['dernier_don']) ?? 'Date inconnue';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      // Header supprimé
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : _errorMessage != null
                ? _buildErrorState()
                : _buildProfileContent(context),
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRoutes.profileScreen,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(appTheme.colorFF8808),
          ),
          SizedBox(height: 16.h),
          Text(
            'Chargement du profil...',
            style: TextStyleHelper.instance.body16Regular,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.h,
            color: appTheme.colorFF4444,
          ),
          SizedBox(height: 16.h),
          Text(
            'Erreur de chargement',
            style: TextStyleHelper.instance.headline16Bold,
          ),
          SizedBox(height: 8.h),
          Text(
            _errorMessage!,
            style: TextStyleHelper.instance.body14Regular,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _loadUserData,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: _buildProfileContent(context),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 20.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mon Profil',
                style: TextStyleHelper.instance.headline24BoldManrope.copyWith(
                  color: appTheme.colorFF8808,
                  fontSize: 28.fSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                width: 40.h,
                height: 40.h,
                decoration: BoxDecoration(
                  color: appTheme.colorFF8808.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.h),
                ),
                child: Icon(
                  Icons.edit,
                  color: appTheme.colorFF8808,
                  size: 20.h,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildProfileAvatar(),
          SizedBox(height: 16.h),
          Text(
            '${_userData?['first_name'] ?? ''} ${_userData?['last_name'] ?? ''}',
            style: TextStyleHelper.instance.headline24BoldManrope.copyWith(
              color: appTheme.colorFF0F0B,
              fontSize: 22.fSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _donneurData != null
                ? 'Donneur depuis ${_calculateYearsSinceDonation()}'
                : 'Nouveau donneur',
            style: TextStyleHelper.instance.body16Regular.copyWith(
              color: appTheme.colorFF7373,
              fontSize: 16.fSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        Container(
          width: 100.h,
          height: 100.h,
          decoration: BoxDecoration(
            color: appTheme.colorFF8808.withOpacity(0.1),
            borderRadius: BorderRadius.circular(50.h),
            border: Border.all(
              color: appTheme.colorFF8808.withOpacity(0.2),
              width: 3.h,
            ),
          ),
          child: Icon(
            Icons.person,
            color: appTheme.colorFF8808,
            size: 50.h,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 30.h,
            height: 30.h,
            decoration: BoxDecoration(
              color: appTheme.colorFF8808,
              borderRadius: BorderRadius.circular(15.h),
              border: Border.all(
                color: appTheme.whiteCustom,
                width: 2.h,
              ),
            ),
            child: Icon(
              Icons.camera_alt,
              color: appTheme.whiteCustom,
              size: 16.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          _buildProfileHeader(),
          SizedBox(height: 24.h),
          _buildStatsSection(),
          SizedBox(height: 24.h),
          _buildPersonalInfoSection(),
          SizedBox(height: 24.h),
          _buildMedicalInfoSection(),
          SizedBox(height: 24.h),
          _buildActionsSection(context),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          _buildProfileAvatar(),
          SizedBox(height: 16.h),
          Text(
            '${_userData?['first_name'] ?? ''} ${_userData?['last_name'] ?? ''}',
            style: TextStyleHelper.instance.headline24BoldManrope.copyWith(
              color: appTheme.colorFF0F0B,
              fontSize: 22.fSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _donneurData != null
                ? 'Donneur depuis ${_calculateYearsSinceDonation()}'
                : 'Nouveau donneur',
            style: TextStyleHelper.instance.body16Regular.copyWith(
              color: appTheme.colorFF7373,
              fontSize: 16.fSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: appTheme.colorFF8808.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.h),
        border: Border.all(
          color: appTheme.colorFF8808.withOpacity(0.1),
          width: 1.h,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mes Statistiques',
            style: TextStyleHelper.instance.title18SemiBold.copyWith(
              color: appTheme.colorFF0F0B,
              fontSize: 18.fSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('${_donneurData?['nb_dons'] ?? 0}',
                    'Dons effectués', Icons.favorite),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: _buildStatCard(
                    '${(_donneurData?['litres_donnes'] ?? 0.0).toStringAsFixed(1)}L',
                    'Volume donné',
                    Icons.water_drop),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('${_donneurData?['badges']?.length ?? 0}',
                    'Badges obtenus', Icons.stars),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: _buildStatCard(
                    _donneurData?['statut'] == 'actif' ? '100%' : '0%',
                    'Statut',
                    Icons.verified),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: appTheme.colorFF8808,
            size: 24.h,
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyleHelper.instance.headline24BoldManrope.copyWith(
              color: appTheme.colorFF8808,
              fontSize: 20.fSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyleHelper.instance.body12Regular.copyWith(
              color: appTheme.colorFF7373,
              fontSize: 12.fSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSection(
      'Informations Personnelles',
      [
        _buildInfoTile(
            Icons.email, 'Email', _userData?['email'] ?? 'Non renseigné'),
        _buildInfoTile(Icons.phone, 'Téléphone',
            _donneurData?['telephone'] ?? 'Non renseigné'),
        _buildInfoTile(Icons.cake, 'Date de naissance',
            _formatDate(_donneurData?['date_de_naissance']) ?? 'Non renseigné'),
        _buildInfoTile(Icons.location_on, 'Adresse',
            _donneurData?['adresse'] ?? 'Non renseigné'),
      ],
    );
  }

  Widget _buildMedicalInfoSection() {
    return _buildSection(
      'Informations Médicales',
      [
        _buildInfoTile(Icons.bloodtype, 'Groupe sanguin',
            _donneurData?['groupe_sanguin'] ?? 'Non renseigné'),
        _buildInfoTile(
            Icons.monitor_weight,
            'Poids',
            _donneurData?['poids'] != null
                ? '${_donneurData!['poids']} kg'
                : 'Non renseigné'),
        _buildInfoTile(
            Icons.height,
            'Taille',
            _donneurData?['taille'] != null
                ? '${(_donneurData!['taille'] / 100).toStringAsFixed(2)}m'
                : 'Non renseigné'),
        _buildInfoTile(
            Icons.medical_services, 'Dernier don', _getLastDonationDate()),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyleHelper.instance.title18SemiBold.copyWith(
              color: appTheme.colorFF0F0B,
              fontSize: 18.fSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: appTheme.colorFF8808.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.h),
            ),
            child: Icon(
              icon,
              color: appTheme.colorFF8808,
              size: 20.h,
            ),
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyleHelper.instance.body14Regular.copyWith(
                    color: appTheme.colorFF9A9A,
                    fontSize: 14.fSize,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyleHelper.instance.body16Regular.copyWith(
                    color: appTheme.colorFF0F0B,
                    fontSize: 16.fSize,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: appTheme.colorFF9A9A,
            size: 16.h,
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(
          context,
          Icons.settings,
          'Paramètres',
          'Gérer vos préférences',
          () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ouvrir les paramètres')),
          ),
        ),
        SizedBox(height: 12.h),
        _buildActionButton(
          context,
          Icons.help_outline,
          'Aide et Support',
          'Obtenez de l\'aide',
          () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ouvrir l\'aide')),
          ),
        ),
        SizedBox(height: 12.h),
        _buildActionButton(
          context,
          Icons.logout,
          'Déconnexion',
          'Se déconnecter de l\'application',
          () => _showLogoutDialog(context),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: appTheme.whiteCustom,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.blackCustom.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.h,
              height: 40.h,
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.red.withOpacity(0.1)
                    : appTheme.colorFF8808.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.h),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : appTheme.colorFF8808,
                size: 20.h,
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyleHelper.instance.body16SemiBold.copyWith(
                      color: isDestructive ? Colors.red : appTheme.colorFF0F0B,
                      fontSize: 16.fSize,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyleHelper.instance.body14Regular.copyWith(
                      color: appTheme.colorFF7373,
                      fontSize: 14.fSize,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: appTheme.colorFF9A9A,
              size: 16.h,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.authenticationScreen);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Déconnecter'),
            ),
          ],
        );
      },
    );
  }
}
