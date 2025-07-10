import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../core/utils/image_constant.dart';
import '../../routes/app_routes.dart';
import '../../theme/text_style_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      body: SafeArea(
        child: Container(
          height: 766.h,
          width: 375.h,
          child: Column(
            children: [
              _buildHeader(context),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(
        top: 20.h,
        left: 20.h,
        right: 20.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Arriere',
              style: TextStyleHelper.instance.body14Regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        children: [
          SizedBox(height: 64.h),
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

  Widget _buildIllustration() {
    return CustomImageView(
      imagePath: ImageConstant.imgPeopleHoldingACharityBox,
      height: 351.h,
      width: 289.h,
      fit: BoxFit.contain,
    );
  }

  Widget _buildTitle() {
    return Container(
      width: double.maxFinite,
      child: Text(
        'Connecter à la communauté',
        style: TextStyleHelper.instance.headline24Bold,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Text(
        'sed quia non numquam eius modi tempora labore et dolore magnam aliquam.',
        style: TextStyleHelper.instance.body13Regular,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 16.h,
          width: 16.h,
          decoration: BoxDecoration(
            color: appTheme.colorFFFFC8,
            borderRadius: BorderRadius.circular(8.h),
          ),
        ),
        SizedBox(width: 16.h),
        Container(
          height: 16.h,
          width: 16.h,
          decoration: BoxDecoration(
            color: appTheme.colorFFFFC8,
            borderRadius: BorderRadius.circular(8.h),
          ),
        ),
        SizedBox(width: 16.h),
        Container(
          height: 16.h,
          width: 32.h,
          decoration: BoxDecoration(
            color: appTheme.colorFFF998,
            borderRadius: BorderRadius.circular(8.h),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 24.h,
      ),
      child: CustomButton(
        text: 'Suivant',
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.authenticationScreen);
        },
      ),
    );
  }
}