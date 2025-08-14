import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../services/api_service.dart';
import '../../services/registration_data_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/modern_app_bar.dart';
import 'widgets/blood_group_selector.dart';
import 'widgets/location_dropdown.dart';
import 'widgets/measurement_slider.dart';

/// Onboarding Seven - Enhanced Blood Donation Profile Setup Screen
///
/// An advanced mobile profile setup screen with enhanced interactivity
/// Features clickable blood group selector, dropdown location field,
/// and interactive sliders for weight and height measurements
class BloodDonationProfileSetup extends StatefulWidget {
  const BloodDonationProfileSetup({super.key});

  @override
  State<BloodDonationProfileSetup> createState() =>
      _BloodDonationProfileSetupState();
}

class _BloodDonationProfileSetupState extends State<BloodDonationProfileSetup>
    with TickerProviderStateMixin {
  String selectedBloodType = 'A+';
  String selectedLocation = 'Cotonou';
  double selectedWeight = 70.0;
  double selectedHeight = 1750.0; // in mm

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      appBar: ModernAppBar(
        title: 'Profil Donateur',
        subtitle: 'Complétez votre profil',
      ),
      body: SafeArea(
        child: AnimatedBuilder(
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

  Widget _buildContent() {
    return SingleChildScrollView(
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

  Widget _buildBloodGroupSection() {
    return Container(
      margin: EdgeInsets.only(top: 32.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.bloodtype,
            title: 'Groupe sanguin*',
          ),
          SizedBox(height: 20.h),
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

  Widget _buildLocationSection() {
    return Container(
      margin: EdgeInsets.only(top: 32.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.location_on,
            title: 'Localisation*',
          ),
          SizedBox(height: 20.h),
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

  Widget _buildMeasurementSection() {
    return Container(
      margin: EdgeInsets.only(top: 32.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.straighten,
            title: 'Informations physiques*',
          ),
          SizedBox(height: 20.h),
          MeasurementSlider(
            label: 'Poids',
            value: selectedWeight,
            min: 45.0,
            max: 120.0,
            unit: 'KGS',
            icon: Icons.fitness_center,
            onChanged: (value) {
              setState(() {
                selectedWeight = value;
              });
            },
          ),
          SizedBox(height: 24.h),
          MeasurementSlider(
            label: 'Taille',
            value: selectedHeight,
            min: 1400.0,
            max: 2200.0,
            unit: 'mm',
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

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.colorFFF2AB.withAlpha(26),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: appTheme.colorFFF2AB.withAlpha(77),
          width: 1.h,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: appTheme.colorFFF2AB,
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: Icon(
              icon,
              color: appTheme.whiteCustom,
              size: 20.h,
            ),
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: Text(
              title,
              style: TextStyleHelper.instance.headline25RegularLexend.copyWith(
                color: appTheme.colorFF4444,
                fontSize: 18.fSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.h, 32.h, 16.h, 20.h),
      child: Column(
        children: [
          CustomButton(
            text: 'Continuer',
            onPressed: _handleContinue,
            variant: CustomButtonVariant.elevated,
            backgroundColor: appTheme.colorFF8808,
            textColor: appTheme.whiteCustom,
            isFullWidth: true,
            height: 56.h,
            fontSize: 16.fSize,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 16.h),
          CustomButton(
            text: 'Retour',
            onPressed: () {
              Navigator.of(context).pop();
            },
            variant: CustomButtonVariant.outlined,
            backgroundColor: appTheme.whiteCustom,
            textColor: appTheme.colorFF8808,
            borderColor: appTheme.colorFF8808,
            isFullWidth: true,
            height: 56.h,
            fontSize: 16.fSize,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  void _handleContinue() async {
    // Vérifier que nous avons les données d'inscription
    final registrationService = RegistrationDataService();
    final email = registrationService.getEmailForProfile();

    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Erreur: Données d\'inscription manquantes'),
          backgroundColor: appTheme.primaryRed,
        ),
      );
      return;
    }

    // Envoyer les données du profil au backend
    try {
      final api = ApiService();
      final result = await api.completeProfile(
        email: email,
        groupeSanguin: selectedBloodType,
        localisation: selectedLocation,
        poids: selectedWeight,
        taille: selectedHeight, // déjà en mm
      );

      if (result != null && result['success'] == true) {
        // Nettoyer les données temporaires
        registrationService.clearRegistrationData();

        // Show success animation
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => _buildSuccessDialog(),
        );
      } else {
        final errorMessage =
            result?['error'] ?? 'Erreur lors de la mise à jour du profil';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: appTheme.primaryRed,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur réseau: $e'),
          backgroundColor: appTheme.primaryRed,
        ),
      );
    }
  }

  Widget _buildSuccessDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(32.h),
        decoration: BoxDecoration(
          color: appTheme.whiteCustom,
          borderRadius: BorderRadius.circular(16.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.blackCustom.withAlpha(51),
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
                color: appTheme.colorFF8808,
                borderRadius: BorderRadius.circular(40.h),
              ),
              child: Icon(
                Icons.check,
                color: appTheme.whiteCustom,
                size: 48.h,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Profil créé avec succès!',
              textAlign: TextAlign.center,
              style: TextStyleHelper.instance.headline25RegularLexend.copyWith(
                color: appTheme.colorFF4444,
                fontSize: 20.fSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Votre profil donateur a été configuré.\nConnectez-vous maintenant pour accéder à votre espace.',
              textAlign: TextAlign.center,
              style: TextStyleHelper.instance.body15RegularLexend.copyWith(
                color: appTheme.colorFF7373,
                fontSize: 14.fSize,
              ),
            ),
            SizedBox(height: 24.h),
            CustomButton(
              text: 'Se connecter',
              onPressed: () {
                Navigator.of(context).pop();
                // Rediriger vers la page d'authentification
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.authenticationScreen,
                  (route) => false,
                );
              },
              variant: CustomButtonVariant.elevated,
              backgroundColor: appTheme.colorFF8808,
              textColor: appTheme.whiteCustom,
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
