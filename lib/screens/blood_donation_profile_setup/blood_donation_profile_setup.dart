import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/modern_app_bar.dart';
import './widgets/blood_group_selector.dart';
import './widgets/location_dropdown.dart';
import './widgets/measurement_slider.dart';

/// Écran de configuration du profil donateur
///
/// Permet aux utilisateurs de compléter leur profil avec :
/// - Groupe sanguin
/// - Localisation
/// - Informations physiques (poids, taille)
class BloodDonationProfileSetupScreen extends StatefulWidget {
  const BloodDonationProfileSetupScreen({super.key});

  @override
  State<BloodDonationProfileSetupScreen> createState() =>
      _BloodDonationProfileSetupScreenState();
}

class _BloodDonationProfileSetupScreenState
    extends State<BloodDonationProfileSetupScreen>
    with TickerProviderStateMixin {
  // Variables d'état du formulaire
  String selectedBloodType = 'A+';
  String selectedLocation = 'Cotonou';
  double selectedWeight = 70.0;
  double selectedHeight = 175.0; // en cm
  bool _isLoading = false;

  // Contrôleurs d'animation
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  /// Initialise les animations d'entrée de l'écran
  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Démarrer les animations
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteCustom,
        appBar: ModernAppBar(
          title: 'Profil Donateur',
          subtitle: 'Complétez votre profil médical',
        ),
        body: AnimatedBuilder(
          animation: Listenable.merge([_slideController, _fadeController]),
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildContent(),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Contenu principal de l'écran
  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          _buildBloodGroupSection(),
          _buildLocationSection(),
          _buildMeasurementSection(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// Section de sélection du groupe sanguin
  Widget _buildBloodGroupSection() {
    return Container(
      margin: EdgeInsets.only(top: 32.h),
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.bloodtype,
            title: 'Groupe sanguin*',
          ),
          SizedBox(height: 16.h),
          BloodGroupSelector(
            selectedBloodType: selectedBloodType,
            onBloodTypeSelected: (bloodType) {
              setState(() {
                selectedBloodType = bloodType;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Section de sélection de la localisation
  Widget _buildLocationSection() {
    return Container(
      margin: EdgeInsets.only(top: 24.h),
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.location_on,
            title: 'Localisation*',
          ),
          SizedBox(height: 16.h),
          LocationDropdown(
            selectedLocation: selectedLocation,
            onLocationSelected: (location) {
              setState(() {
                selectedLocation = location;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Section des mesures physiques (poids et taille)
  Widget _buildMeasurementSection() {
    return Container(
      margin: EdgeInsets.only(top: 24.h),
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.monitor_weight,
            title: 'Informations physiques*',
          ),
          SizedBox(height: 16.h),
          MeasurementSlider(
            label: 'Poids',
            value: selectedWeight,
            min: 45.0,
            max: 120.0,
            unit: 'kg',
            icon: Icons.fitness_center,
            onChanged: (value) {
              setState(() {
                selectedWeight = value;
              });
            },
          ),
          SizedBox(height: 16.h),
          MeasurementSlider(
            label: 'Taille',
            value: selectedHeight,
            min: 140.0,
            max: 220.0,
            unit: 'cm',
            icon: Icons.height,
            onChanged: (value) {
              setState(() {
                selectedHeight = value;
              });
            },
          ),
        ],
      ),
    );
  }

  /// En-tête de section avec icône et titre
  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.gray50,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: appTheme.gray300,
          width: 1.h,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: appTheme.primaryRed,
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: Icon(
              icon,
              color: appTheme.white,
              size: 20.h,
            ),
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: Text(
              title,
              style: TextStyleHelper.instance.body14RegularManrope.copyWith(
                color: appTheme.gray400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Boutons d'action (Continuer et Retour)
  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.fromLTRB(24.h, 32.h, 24.h, 24.h),
      child: Column(
        children: [
          CustomButton(
            text: _isLoading ? 'Sauvegarde...' : 'Continuer',
            onPressed: _isLoading ? null : _handleContinue,
            variant: CustomButtonVariant.elevated,
            backgroundColor: appTheme.primaryRed,
            textColor: appTheme.white,
            isFullWidth: true,
            height: 56.h,
            fontSize: 16.fSize,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'Retour',
            onPressed: () => Navigator.pop(context),
            variant: CustomButtonVariant.outlined,
            backgroundColor: appTheme.white,
            textColor: appTheme.primaryRed,
            borderColor: appTheme.primaryRed,
            isFullWidth: true,
            height: 56.h,
            fontSize: 16.fSize,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  /// Gestionnaire du bouton Continuer
  void _handleContinue() {
    _saveProfileData();
  }

  /// Sauvegarde les données du profil via l'API
  Future<void> _saveProfileData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        throw Exception('Utilisateur non authentifié');
      }

      final api = ApiService();

      // Récupérer l'utilisateur connecté
      final currentUser = await api.getCurrentUser(token);
      if (currentUser?['donneur'] == null) {
        throw Exception('Profil donneur introuvable');
      }

      final donneurId = currentUser!['donneur']['id'];

      // Préparer les données du profil
      final profileData = {
        'groupe_sanguin': selectedBloodType,
        'localisation': selectedLocation,
        'poids': selectedWeight,
        'taille': selectedHeight, // Déjà en cm
      };

      // Mettre à jour le profil
      final success = await api.updateDonneur(token, donneurId, profileData);

      if (success != null) {
        if (mounted) {
          _showSuccessDialog();
        }
      } else {
        throw Exception('Erreur lors de la sauvegarde');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: appTheme.primaryRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Affiche le dialogue de succès
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildSuccessDialog(),
    );
  }

  /// Construction du dialogue de succès
  Widget _buildSuccessDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(32.h),
        decoration: BoxDecoration(
          color: appTheme.white,
          borderRadius: BorderRadius.circular(16.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.gray400.withOpacity(0.2),
              offset: Offset(0, 8.h),
              blurRadius: 24.h,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.h,
              height: 80.h,
              decoration: BoxDecoration(
                color: appTheme.primaryRed,
                borderRadius: BorderRadius.circular(40.h),
              ),
              child: Icon(
                Icons.check,
                color: appTheme.white,
                size: 48.h,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Profil créé avec succès !',
              textAlign: TextAlign.center,
              style: TextStyleHelper.instance.body14RegularManrope.copyWith(
                color: appTheme.gray400,
                fontSize: 18.fSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Votre profil donateur a été configuré.\nVous pouvez maintenant explorer les campagnes.',
              textAlign: TextAlign.center,
              style: TextStyleHelper.instance.body13RegularManrope.copyWith(
                color: appTheme.gray400,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),
            CustomButton(
              text: 'Continuer',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.donationCampaignListScreen,
                );
              },
              variant: CustomButtonVariant.elevated,
              backgroundColor: appTheme.primaryRed,
              textColor: appTheme.white,
              isFullWidth: true,
              height: 48.h,
              fontSize: 16.fSize,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
