import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

class CampaignCardWidget extends StatelessWidget {
  final String title;
  final String date;
  final String lieu;
  final String description;
  final String urgence;
  final int objectif;
  final int participants;
  final String iconPath;
  final VoidCallback? onTap;

  const CampaignCardWidget({
    Key? key,
    required this.title,
    required this.date,
    this.lieu = '',
    this.description = '',
    this.urgence = 'normale',
    this.objectif = 0,
    this.participants = 0,
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
          border: urgence == 'haute' 
            ? Border.all(color: appTheme.primaryRed, width: 2)
            : null,
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
                  colors: urgence == 'haute' 
                    ? [appTheme.primaryRed, appTheme.colorFF5050]
                    : [Color(0xFF5ED2D2), appTheme.colorFF5ED2],
                ),
              ),
              child: Stack(
                children: [
                  CustomImageView(
                    imagePath: iconPath,
                    height: 83.h,
                    width: 83.h,
                    fit: BoxFit.cover,
                  ),
                  if (urgence == 'haute')
                    Positioned(
                      top: 4.h,
                      right: 4.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: appTheme.whiteCustom,
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                        child: Text(
                          'URGENT',
                          style: TextStyle(
                            fontSize: 8.fSize,
                            color: appTheme.primaryRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 24.h),
            Expanded(
              child: Container(
                height: 83.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Titre et lieu
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyleHelper.instance.title16SemiBold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (lieu.isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            lieu,
                            style: TextStyleHelper.instance.body12Regular.copyWith(
                              color: appTheme.colorFF5050,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                    
                    // Date
                    Text(
                      date,
                      style: TextStyleHelper.instance.body14SemiBold.copyWith(
                        color: appTheme.primaryPink,
                      ),
                    ),
                    
                    // Progression si objectif défini
                    if (objectif > 0) ...[
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: participants / objectif,
                              backgroundColor: appTheme.lightPink.withAlpha(128),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                urgence == 'haute' ? appTheme.primaryRed : appTheme.primaryPink,
                              ),
                              minHeight: 4.h,
                            ),
                          ),
                          SizedBox(width: 8.h),
                          Text(
                            '$participants/$objectif',
                            style: TextStyle(
                              fontSize: 10.fSize,
                              color: appTheme.colorFF5050,
                            ),
                          ),
                        ],
                      ),
                    ],
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
