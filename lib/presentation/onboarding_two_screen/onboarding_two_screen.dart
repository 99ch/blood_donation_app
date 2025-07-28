import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../core/utils/image_constant.dart';
import '../../routes/app_routes.dart';
import '../../theme/text_style_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';

class OnboardingTwoScreen extends StatelessWidget {
  OnboardingTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      body: SafeArea(
        child: SizedBox(
          height: 766.h,
          width: 375.h,
          child: Column(
            children: [
              _buildHeader(context),
              _buildMainIllustration(),
              _buildMainHeading(),
              _buildDescriptionText(),
              _buildPageIndicator(),
              Spacer(),
              _buildNextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20.h,
        left: 32.h,
        right: 32.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start
      ),
    );
  }

  Widget _buildMainIllustration() {
    return Container(
      margin: EdgeInsets.only(top: 64.h),
      child: CustomImageView(
        imagePath: ImageConstant.imgXmlid1,
        height: 225.h,
        width: 309.h,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildMainHeading() {
    return Container(
      margin: EdgeInsets.only(top: 64.h),
      padding: EdgeInsets.symmetric(horizontal: 32.h),
      width: double.infinity,
      child: Text(
        'Donner du sang',
        style: TextStyleHelper.instance.headline24BoldManrope,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDescriptionText() {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 32.h),
      child: Text(
        'sed quia non numquam eius modi tempora labore et dolore magnam aliquam.',
        style: TextStyleHelper.instance.body13RegularManrope,
        textAlign: TextAlign.center,
      ),
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
              color: appTheme.colorFFD1D5,
              borderRadius: BorderRadius.circular(4.h),
            ),
          ),
          SizedBox(width: 8.h),
          Container(
            height: 8.h,
            width: 8.h,
            decoration: BoxDecoration(
              color: appTheme.colorFFD1D5,
              borderRadius: BorderRadius.circular(4.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 20.h,
        right: 20.h,
        bottom: 24.h,
      ),
      child: CustomButton(
        text: 'Suivant',
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.onboardingThreeScreen);
        },
      ),
    );
  }
}