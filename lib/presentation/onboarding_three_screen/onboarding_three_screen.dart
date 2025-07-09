import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';

class OnboardingThreeScreen extends StatelessWidget {
  OnboardingThreeScreen({Key? key}) : super(key: key);

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
              _buildBottomAction(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
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
              'arriere',
              style:
                  TextStyleHelper.instance.body14Regular.copyWith(height: 1.25),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBloodBagIllustration(context),
          SizedBox(height: 64.h),
          _buildHeadingText(context),
          SizedBox(height: 16.h),
          _buildDescriptionText(context),
          SizedBox(height: 48.h),
          _buildPageIndicator(context),
        ],
      ),
    );
  }

  Widget _buildBloodBagIllustration(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 48.h),
      child: CustomImageView(
        imagePath: ImageConstant.imgBloogBag,
        height: 280.h,
        width: 193.h,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildHeadingText(BuildContext context) {
    return Text(
      'Sauver la vie',
      style: TextStyleHelper.instance.headline24Bold.copyWith(height: 1.33),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescriptionText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Text(
        'sed quia non numquam eius modi tempora labore et dolore magnam aliquam.',
        style: TextStyleHelper.instance.body14Regular.copyWith(height: 1.21),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8.h,
          height: 8.h,
          decoration: BoxDecoration(
            color: appTheme.colorFFFBCF,
            borderRadius: BorderRadius.circular(4.h),
          ),
        ),
        SizedBox(width: 8.h),
        Container(
          width: 24.h,
          height: 8.h,
          decoration: BoxDecoration(
            color: appTheme.colorFFF48F,
            borderRadius: BorderRadius.circular(4.h),
          ),
        ),
        SizedBox(width: 8.h),
        Container(
          width: 8.h,
          height: 8.h,
          decoration: BoxDecoration(
            color: appTheme.colorFFFBCF,
            borderRadius: BorderRadius.circular(4.h),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 32.h,
      ),
      child: CustomButton(
        text: 'Suivant',
        onPressed: () {
          _handleNextStep(context);
        },
      ),
    );
  }

  void _handleNextStep(BuildContext context) {
    // Handle navigation to next onboarding screen
    print('Proceeding to next onboarding step');
  }
}
