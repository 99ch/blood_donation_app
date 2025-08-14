import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';

/// Écran de démarrage - Premier écran du processus d'onboarding
class GettingStartedScreen extends StatelessWidget {
  const GettingStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteCustom,
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 32.h),
          child: Column(
            children: [
              Expanded(
                child: _buildMainContent(),
              ),
              _buildBottomAction(),
            ],
          ),
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
          _buildBloodBagIllustration(),
          SizedBox(height: 48.h),
          _buildHeadingText(),
          SizedBox(height: 16.h),
          _buildDescriptionText(),
          SizedBox(height: 48.h),
          _buildPageIndicator(),
        ],
      ),
    );
  }

  /// Illustration principale - Sac de sang
  Widget _buildBloodBagIllustration() {
    return Semantics(
      label: 'Illustration d\'un sac de sang représentant le don',
      child: CustomImageView(
        imagePath: ImageConstant.imgBloogBag,
        height: 240.h,
        width: 160.h,
        fit: BoxFit.contain,
      ),
    );
  }

  /// Titre principal de l'écran
  Widget _buildHeadingText() {
    return Text(
      'Commencez votre mission',
      style: TextStyleHelper.instance.headline24BoldManrope,
      textAlign: TextAlign.center,
    );
  }

  /// Description motivante du don de sang
  Widget _buildDescriptionText() {
    return Text(
      'Rejoignez des milliers de personnes qui donnent leur sang pour sauver des vies. Chaque don compte.',
      style: TextStyleHelper.instance.body13RegularManrope.copyWith(
        color: appTheme.gray400,
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Indicateur de page (pagination dots)
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Page active (étendue) - Première page
        Container(
          width: 24.h,
          height: 8.h,
          decoration: BoxDecoration(
            color: appTheme.primaryRed,
            borderRadius: BorderRadius.circular(4.h),
          ),
        ),
        SizedBox(width: 8.h),
        // Page inactive
        Container(
          width: 8.h,
          height: 8.h,
          decoration: BoxDecoration(
            color: appTheme.gray300,
            borderRadius: BorderRadius.circular(4.h),
          ),
        ),
        SizedBox(width: 8.h),
        // Page inactive
        Container(
          width: 8.h,
          height: 8.h,
          decoration: BoxDecoration(
            color: appTheme.gray300,
            borderRadius: BorderRadius.circular(4.h),
          ),
        ),
      ],
    );
  }

  /// Action en bas de l'écran (bouton Suivant)
  Widget _buildBottomAction() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.h),
      child: Builder(
        builder: (context) => CustomButton(
          text: 'Suivant',
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.missionOverviewScreen);
          },
        ),
      ),
    );
  }
}
