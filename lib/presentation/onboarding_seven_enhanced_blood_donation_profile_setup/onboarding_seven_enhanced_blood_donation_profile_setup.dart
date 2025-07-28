import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import './widgets/blood_group_selector.dart';
import './widgets/location_dropdown.dart';
import './widgets/measurement_slider.dart';

/// Onboarding Seven - Enhanced Blood Donation Profile Setup Screen
///
/// An advanced mobile profile setup screen with enhanced interactivity
/// Features clickable blood group selector, dropdown location field,
/// and interactive sliders for weight and height measurements
class OnboardingSevenEnhancedBloodDonationProfileSetup extends StatefulWidget {
  const OnboardingSevenEnhancedBloodDonationProfileSetup({Key? key})
      : super(key: key);

  @override
  State<OnboardingSevenEnhancedBloodDonationProfileSetup> createState() =>
      _OnboardingSevenEnhancedBloodDonationProfileSetupState();
}

class _OnboardingSevenEnhancedBloodDonationProfileSetupState
    extends State<OnboardingSevenEnhancedBloodDonationProfileSetup>
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
    return Column(
      children: [
        _buildHeaderSection(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBloodGroupSection(),
                _buildLocationSection(),
                _buildMeasurementSection(),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      height: 137.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: appTheme.colorFFF2AB,
        borderRadius: BorderRadius.circular(2.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            offset: Offset(8.h, 8.h),
            blurRadius: 16.h,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 32.h,
            left: 24.h,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  color: appTheme.whiteCustom.withAlpha(51),
                  borderRadius: BorderRadius.circular(8.h),
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: appTheme.blackCustom,
                  size: 16.h,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Profil Donateur',
                  style:
                      TextStyleHelper.instance.headline25RegularLexend.copyWith(
                    color: appTheme.blackCustom,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Complétez votre profil',
                  style: TextStyleHelper.instance.body15RegularLexend.copyWith(
                    color: appTheme.blackCustom.withAlpha(179),
                    fontSize: 12.fSize,
                  ),
                ),
              ],
            ),
          ),
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

  void _handleContinue() {
    // Show success animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildSuccessDialog(),
    );
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
              'Votre profil donateur a été configuré.\nVous pouvez maintenant continuer.',
              textAlign: TextAlign.center,
              style: TextStyleHelper.instance.body15RegularLexend.copyWith(
                color: appTheme.colorFF7373,
                fontSize: 14.fSize,
              ),
            ),
            SizedBox(height: 24.h),
            CustomButton(
              text: 'Continuer',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(AppRoutes.bloodDonationMenuScreen);
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
