import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';

/// Écran d'accueil présentant la mission de don de sang
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: _buildMainContent(context),
              ),
              _buildNextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Contenu principal avec illustration et texte
  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIllustration(),
          SizedBox(height: 48.h),
          _buildTitle(),
          SizedBox(height: 16.h),
          _buildDescription(),
          SizedBox(height: 48.h),
          _buildPageIndicators(),
        ],
      ),
    );
  }

  /// Illustration principale
  Widget _buildIllustration() {
    return Semantics(
      label:
          'Illustration représentant des personnes tenant une boîte de charité',
      child: CustomImageView(
        imagePath: ImageConstant.imgPeopleHoldingACharityBox,
        height: 280.h,
        width: 240.h,
        fit: BoxFit.contain,
      ),
    );
  }

  /// Titre principal de l'écran
  Widget _buildTitle() {
    return Text(
      'Rejoignez notre communauté',
      style: TextStyleHelper.instance.headline24Bold,
      textAlign: TextAlign.center,
    );
  }

  /// Description de la mission
  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Text(
        'Participez à sauver des vies en donnant votre sang. Chaque don compte et peut faire la différence.',
        style: TextStyleHelper.instance.body13Regular.copyWith(
          color: appTheme.gray400,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Indicateurs de progression dans l'onboarding
  Widget _buildPageIndicators() {
    const int currentPage = 2; // Troisième page
    const int totalPages = 3;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.h),
          height: 8.h,
          width: isActive ? 24.h : 8.h,
          decoration: BoxDecoration(
            color: isActive ? appTheme.colorFFFFC8 : appTheme.gray300,
            borderRadius: BorderRadius.circular(4.h),
          ),
        );
      }),
    );
  }

  /// Bouton pour passer à l'écran suivant
  Widget _buildNextButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.h),
      child: CustomButton(
        text: 'Commencer',
        onPressed: () => _handleNext(context),
      ),
    );
  }

  /// Gestion de la navigation vers l'écran suivant
  void _handleNext(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.authenticationScreen);
  }
}
