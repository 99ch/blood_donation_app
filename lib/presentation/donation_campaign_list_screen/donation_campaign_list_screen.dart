import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/custom_image_view.dart';
import './widgets/campaign_card_widget.dart';

class DonationCampaignListScreen extends StatelessWidget {
  const DonationCampaignListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      body: SingleChildScrollView(
        child: Container(
          width: 375.h,
          child: Column(
            children: [
              _buildHeader(context),
              _buildCampaignInfoRow(context),
              _buildHeroSection(context),
              _buildPageIndicator(context),
              _buildSectionTitle(context),
              _buildCampaignCards(context),
              SizedBox(height: 20.h), // Add spacing before bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentRoute: AppRoutes.donationCampaignListScreen,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 73.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: appTheme.colorFFF2AB,
        borderRadius: BorderRadius.circular(2.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(77),
            offset: Offset(8.h, 8.h),
            blurRadius: 16.h,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 17.h,
              width: 14.h,
              margin: EdgeInsets.only(right: 24.h),
              child: Stack(
                children: [
                  Positioned(
                    top: 9.h,
                    left: 0,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgVector,
                      height: 2.h,
                      width: 14.h,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgArrowleft,
                      height: 17.h,
                      width: 7.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            'Faire un don',
            style:
                TextStyleHelper.instance.title20SemiBold.copyWith(height: 1.25),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignInfoRow(BuildContext context) {
    return Container(
      height: 18.h,
      width: double.infinity,
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '4 campagnes par ans',
            style:
                TextStyleHelper.instance.body14SemiBold.copyWith(height: 1.29),
          ),
          Text(
            'Bientôt',
            style:
                TextStyleHelper.instance.body12Regular.copyWith(height: 1.33),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: 108.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
      decoration: BoxDecoration(
        color: appTheme.blackCustom,
        borderRadius: BorderRadius.circular(4.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.colorFF8888,
            offset: Offset(0, 4.h),
            blurRadius: 10.h,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8.h,
            left: 8.h,
            child: Container(
              height: 21.h,
              width: 55.h,
              decoration: BoxDecoration(
                color: appTheme.colorFFF2AB,
                borderRadius: BorderRadius.circular(4.h),
              ),
              child: Center(
                child: Text(
                  'Bientôt',
                  style: TextStyleHelper.instance.label10Regular
                      .copyWith(height: 1.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    return Container(
      height: 4.h,
      width: 32.h,
      margin: EdgeInsets.only(top: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8.h,
            height: 4.h,
            decoration: BoxDecoration(
              color: appTheme.grey300,
              borderRadius: BorderRadius.circular(2.h),
            ),
          ),
          SizedBox(width: 4.h),
          Container(
            width: 8.h,
            height: 4.h,
            decoration: BoxDecoration(
              color: appTheme.colorFFFF57,
              borderRadius: BorderRadius.circular(2.h),
            ),
          ),
          SizedBox(width: 4.h),
          Container(
            width: 8.h,
            height: 4.h,
            decoration: BoxDecoration(
              color: appTheme.grey300,
              borderRadius: BorderRadius.circular(2.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 24.h),
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Text(
        'NOS CAMPAGNES',
        style: TextStyleHelper.instance.title22SemiBold.copyWith(height: 1.18),
      ),
    );
  }

  Widget _buildCampaignCards(BuildContext context) {
    List<Map<String, dynamic>> campaigns = [
      {
        'title': 'Première campagne',
        'date': '10 Juin 2025',
        'iconPath': ImageConstant.imgDna,
      },
      {
        'title': 'Première campagne',
        'date': '10 Juin 2025',
        'iconPath': ImageConstant.imgDna,
      },
      {
        'title': 'Première campagne',
        'date': '10 Juin 2025',
        'iconPath': ImageConstant.imgDna,
      },
      {
        'title': 'Première campagne',
        'date': '10 Juin 2025',
        'iconPath': ImageConstant.imgDna,
      },
    ];

    return Container(
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: campaigns.map((campaign) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: CampaignCardWidget(
              title: campaign['title'],
              date: campaign['date'],
              iconPath: campaign['iconPath'],
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Campaign details coming soon')),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
