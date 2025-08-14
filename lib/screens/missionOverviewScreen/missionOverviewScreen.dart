import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_button.dart';

/// Écran de présentation de la mission de don de sang
class MissionOverviewScreen extends StatelessWidget {
  const MissionOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.white,
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 32.h),
          child: Column(
            children: [
              Expanded(
                child: _buildMainContent(),
              ),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  /// Boutons de navigation (seulement Suivant)
  Widget _buildNavigationButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.h),
      child: Builder(
        builder: (context) => CustomButton(
          text: 'Suivant',
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.welcomeScreen),
        ),
      ),
    );
  }

  /// Contenu principal de l'écran
  Widget _buildMainContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildMainIllustration(),
          SizedBox(height: 48.h),
          _buildMainHeading(),
          SizedBox(height: 16.h),
          _buildDescriptionText(),
          SizedBox(height: 48.h),
          _buildPageIndicator(),
        ],
      ),
    );
  }

  /// Illustration principale représentant le don de sang
  Widget _buildMainIllustration() {
    return Semantics(
      label: 'Illustration représentant le don de sang',
      child: CustomImageView(
        imagePath: ImageConstant.imgXmlid1,
        height: 200.h,
        width: 280.h,
        fit: BoxFit.contain,
      ),
    );
  }

  /// Titre principal de l'écran
  Widget _buildMainHeading() {
    return Text(
      'Sauvez des vies',
      style: TextStyleHelper.instance.headline24BoldManrope,
      textAlign: TextAlign.center,
    );
  }

  /// Description de la mission de don de sang
  Widget _buildDescriptionText() {
    return Text(
      'Votre don de sang peut sauver jusqu\'à 3 vies. Rejoignez notre mission pour aider ceux qui en ont besoin.',
      style: TextStyleHelper.instance.body13RegularManrope.copyWith(
        color: appTheme.gray400,
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      margin: EdgeInsets.only(top: 64.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 8.h,
            width: 8.h,
            decoration: BoxDecoration(
              color: appTheme.gray300,
              borderRadius: BorderRadius.circular(4.h),
            ),
          ),
          SizedBox(width: 8.h),
          Container(
            height: 8.h,
            width: 24.h,
            decoration: BoxDecoration(
              color: appTheme.colorFFF871,
              borderRadius: BorderRadius.circular(12.h),
            ),
          ),
          SizedBox(width: 8.h),
          Container(
            height: 8.h,
            width: 8.h,
            decoration: BoxDecoration(
              color: appTheme.gray300,
              borderRadius: BorderRadius.circular(4.h),
            ),
          ),
        ],
      ),
    );
  }
}
