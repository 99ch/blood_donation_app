import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

class CampaignCardWidget extends StatelessWidget {
  final String title;
  final String date;
  final String iconPath;
  final VoidCallback? onTap;

  const CampaignCardWidget({
    Key? key,
    required this.title,
    required this.date,
    required this.iconPath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 93.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: appTheme.whiteCustom,
          borderRadius: BorderRadius.circular(24.h),
        ),
        padding: EdgeInsets.all(12.h),
        child: Row(
          children: [
            Container(
              height: 83.h,
              width: 83.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19.h),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF5ED2D2),
                    appTheme.colorFF5ED2,
                  ],
                ),
              ),
              child: CustomImageView(
                imagePath: iconPath,
                height: 83.h,
                width: 83.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 24.h),
            Expanded(
              child: Container(
                height: 49.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyleHelper.instance.title18Regular
                          .copyWith(height: 1.22),
                    ),
                    Text(
                      date,
                      style: TextStyleHelper.instance.title18Regular
                          .copyWith(color: appTheme.colorFFF2AB, height: 1.22),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
