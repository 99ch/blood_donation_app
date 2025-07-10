import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/custom_image_view.dart';

class BloodDonationMenuScreen extends StatelessWidget {
  BloodDonationMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.colorFFF3F4,
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: appTheme.whiteCustom,
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildMenuGrid(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentRoute: AppRoutes.bloodDonationMenuScreen,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
      decoration: BoxDecoration(
        color: appTheme.colorFFF2AB,
        borderRadius: BorderRadius.circular(2.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(77),
            offset: Offset(8.h, 8.h),
            blurRadius: 16.h,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Text(
        'Menu',
        style: TextStyleHelper.instance.title20SemiBold.copyWith(height: 1.25),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.h),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16.h,
        mainAxisSpacing: 16.h,
        children: [
          _buildMenuCard(
            context,
            imagePath: ImageConstant.imgVectorRed80045x33,
            title: 'Faire un Don',
            imageWidth: 33.h,
            imageHeight: 45.h,
            onTap: () {
              Navigator.of(context)
                  .pushNamed(AppRoutes.donationCampaignListScreen);
            },
          ),
          _buildMenuCard(
            context,
            imagePath: ImageConstant.imgVectorRed800,
            title: 'Consulter mes résultats d\'analyses',
            imageWidth: 45.h,
            imageHeight: 48.h,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Résultats d\'analyses coming soon')),
              );
            },
          ),
          _buildMenuCard(
            context,
            imagePath: ImageConstant.imgVectorRed80045x28,
            title: 'Centres ou unités de collecte',
            imageWidth: 28.h,
            imageHeight: 45.h,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Centres de collecte coming soon')),
              );
            },
          ),
          _buildMenuCard(
            context,
            imagePath: ImageConstant.imgBloodDonation,
            title: 'Consulter mon compte de sang',
            imageWidth: 34.h,
            imageHeight: 33.h,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Compte de sang coming soon')),
              );
            },
          ),
          _buildMenuCard(
            context,
            imagePath: ImageConstant.imgDonationBoxWithClothes,
            title: 'Ma carte de donneur',
            imageWidth: 57.h,
            imageHeight: 58.h,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Carte de donneur coming soon')),
              );
            },
          ),
          _buildCampaignMenuCard(context),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String imagePath,
    required String title,
    required double imageWidth,
    required double imageHeight,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: appTheme.whiteCustom,
          borderRadius: BorderRadius.circular(6.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.blackCustom.withAlpha(64),
              offset: Offset(0, 4.h),
              blurRadius: 4.h,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
              imagePath: imagePath,
              width: imageWidth,
              height: imageHeight,
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style:
                  TextStyleHelper.instance.body13Regular.copyWith(height: 1.15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignMenuCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.donationCampaignListScreen);
      },
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: appTheme.whiteCustom,
          borderRadius: BorderRadius.circular(6.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.blackCustom.withAlpha(64),
              offset: Offset(0, 4.h),
              blurRadius: 4.h,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 43.h,
              height: 43.h,
              child: Stack(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgVectorRed80043x43,
                    width: 43.h,
                    height: 43.h,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgVector43x43,
                      width: 43.h,
                      height: 43.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Prochaine campagne de don de sang',
              textAlign: TextAlign.center,
              style:
                  TextStyleHelper.instance.body13Regular.copyWith(height: 1.15),
            ),
          ],
        ),
      ),
    );
  }
}
