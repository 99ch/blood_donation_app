import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

class CustomBottomNavigation extends StatelessWidget {
  final String currentRoute;

  const CustomBottomNavigation({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: appTheme.whiteCustom, boxShadow: [
          BoxShadow(
              color: appTheme.blackCustom.withAlpha(25),
              offset: Offset(0, -2.h),
              blurRadius: 8.h,
              spreadRadius: 0),
        ]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              height: 3.h,
              width: 37.h,
              margin: EdgeInsets.only(top: 8.h, bottom: 4.h),
              decoration: BoxDecoration(
                  color: appTheme.colorFF8808,
                  borderRadius: BorderRadius.circular(1.5.h))),
          Container(
              height: 16.h,
              width: 292.h,
              margin: EdgeInsets.symmetric(horizontal: 40.h),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavItem(context,
                        icon: ImageConstant.imgVectorRed900,
                        isActive:
                            currentRoute == AppRoutes.bloodDonationMenuScreen,
                        onTap: () => _navigateToScreen(
                            context, AppRoutes.bloodDonationMenuScreen)),
                    _buildNavItem(context,
                        icon: ImageConstant.imgVectorGray600,
                        isActive: false, onTap: () {
                      // Handle appointments navigation
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Rendez-vous coming soon')));
                    }),
                    _buildNavItem(context,
                        icon: ImageConstant.imgVectorGray60016x15,
                        isActive: false, onTap: () {
                      // Handle notifications navigation
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Notifications coming soon')));
                    }),
                    _buildNavItem(context,
                        icon: ImageConstant.imgVector16x15,
                        isActive: false, onTap: () {
                      // Handle profile navigation
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Profile coming soon')));
                    }),
                  ])),
          Container(
              height: 12.h,
              width: 304.h,
              margin: EdgeInsets.only(
                  top: 8.h, left: 36.h, right: 35.h, bottom: 16.h),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavLabel('Accueil',
                        isActive:
                            currentRoute == AppRoutes.bloodDonationMenuScreen,
                        onTap: () => _navigateToScreen(
                            context, AppRoutes.bloodDonationMenuScreen)),
                    _buildNavLabel('Rendez-vous', isActive: false, onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Rendez-vous coming soon')));
                    }),
                    _buildNavLabel('Notifications', isActive: false, onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Notifications coming soon')));
                    }),
                    _buildNavLabel('Profile', isActive: false, onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Profile coming soon')));
                    }),
                  ])),
        ]));
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: CustomImageView(imagePath: icon, height: 16.h, width: 15.h));
  }

  Widget _buildNavLabel(
    String label, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Text(label,
            style: isActive
                ? TextStyleHelper.instance.label8SemiBold.copyWith(height: 1.25)
                : TextStyleHelper.instance.label8Regular
                    .copyWith(height: 1.25)));
  }

  void _navigateToScreen(BuildContext context, String routeName) {
    if (currentRoute != routeName) {
      Navigator.of(context).pushReplacementNamed(routeName);
    }
  }
}
