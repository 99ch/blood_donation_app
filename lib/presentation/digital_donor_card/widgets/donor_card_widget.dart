import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

class DonorCardWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String qrData;
  final VoidCallback onRegenerateQR;

  const DonorCardWidget({
    super.key,
    required this.userData,
    required this.qrData,
    required this.onRegenerateQR,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appTheme.colorFF002A,
            appTheme.colorFF8808,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(51),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Holographic background pattern
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    appTheme.whiteCustom.withAlpha(26),
                    appTheme.transparentCustom,
                    appTheme.whiteCustom.withAlpha(13),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with logo and title
                Row(
                  children: [
                    Container(
                      width: 40.h,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: appTheme.whiteCustom,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.bloodtype,
                        color: appTheme.colorFF8808,
                        size: 24.h,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BLOOD DONOR CARD',
                            style: TextStyleHelper.instance.title20SemiBold
                                .copyWith(fontSize: 14.fSize),
                          ),
                          Text(
                            'Official Digital ID',
                            style: TextStyleHelper.instance.body12Regular
                                .copyWith(color: appTheme.whiteCustom),
                          ),
                        ],
                      ),
                    ),
                    // Certification badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: appTheme.colorFF5ED2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'VERIFIED',
                        style: TextStyleHelper.instance.label8SemiBold
                            .copyWith(color: appTheme.whiteCustom),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Main card content
                Row(
                  children: [
                    // User photo and info
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User photo
                          Container(
                            width: 60.h,
                            height: 60.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: appTheme.whiteCustom,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: CustomImageView(
                                imagePath: userData['photoUrl'],
                                fit: BoxFit.cover,
                                placeHolder: ImageConstant.imgImageNotFound,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // User name
                          Text(
                            userData['fullName'] ?? '',
                            style: TextStyleHelper.instance.title18Regular
                                .copyWith(
                              color: appTheme.whiteCustom,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Donor ID
                          Text(
                            'ID: ${userData['donorId'] ?? ''}',
                            style: TextStyleHelper.instance.body12Regular
                                .copyWith(color: appTheme.whiteCustom),
                          ),
                        ],
                      ),
                    ),

                    // Blood type and QR code
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          // Blood type
                          Container(
                            width: 60.h,
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: appTheme.whiteCustom,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                userData['bloodType'] ?? '',
                                style: TextStyleHelper.instance.title22SemiBold
                                    .copyWith(
                                  color: appTheme.colorFF8808,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // QR Code
                          if (qrData.isNotEmpty)
                            Container(
                              width: 50.h,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: appTheme.whiteCustom,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: QrImageView(
                                data: qrData,
                                version: QrVersions.auto,
                                size: 50.h,
                                backgroundColor: appTheme.whiteCustom,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Footer with donation count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Donations: ${userData['totalDonations'] ?? 0}',
                      style: TextStyleHelper.instance.body13Regular
                          .copyWith(color: appTheme.whiteCustom),
                    ),
                    Text(
                      'Valid until: ${DateTime.now().year + 1}',
                      style: TextStyleHelper.instance.body12Regular
                          .copyWith(color: appTheme.whiteCustom),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
