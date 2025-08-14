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
      height: 320.h, // Further increased height to prevent overflow
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appTheme.colorFF002A,
            appTheme.colorFF8808,
          ],
        ),
        borderRadius: BorderRadius.circular(16.h),
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
            padding: EdgeInsets.all(16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    if (userData['donneur']?['is_verified'] ??
                        userData['is_verified'] ??
                        false)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: appTheme.colorFF5ED2,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'VÉRIFIÉ',
                          style: TextStyleHelper.instance.label8SemiBold
                              .copyWith(color: appTheme.whiteCustom),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Main card content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User info column
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User photo and blood type in same row
                          Row(
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
                              SizedBox(width: 16.h),
                              // Blood type
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'GROUPE SANGUIN',
                                    style: TextStyleHelper
                                        .instance.body12Regular
                                        .copyWith(color: appTheme.whiteCustom),
                                  ),
                                  Text(
                                    userData['donneur']?['groupe_sanguin'] ??
                                        '',
                                    style: TextStyleHelper
                                        .instance.title22SemiBold
                                        .copyWith(
                                      color: appTheme.whiteCustom,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 12.h),

                          // User info
                          Text(
                            '${userData['donneur']?['prenoms'] ?? userData['prenoms'] ?? userData['first_name'] ?? ''} ${userData['donneur']?['nom'] ?? userData['nom'] ?? userData['last_name'] ?? ''}'
                                .trim(),
                            style:
                                TextStyleHelper.instance.body16Regular.copyWith(
                              color: appTheme.whiteCustom,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'ID: ${userData['donneur']?['id'] ?? userData['id'] ?? ''}',
                                  style: TextStyleHelper.instance.body12Regular
                                      .copyWith(color: appTheme.whiteCustom),
                                ),
                              ),
                              Text(
                                'Tel: ${userData['donneur']?['telephone'] ?? userData['telephone'] ?? 'Non renseigné'}',
                                style: TextStyleHelper.instance.body12Regular
                                    .copyWith(color: appTheme.whiteCustom),
                              ),
                            ],
                          ),

                          if (userData['donneur']?['date_inscription'] !=
                                  null ||
                              userData['date_joined'] != null) ...[
                            SizedBox(height: 6.h),
                            Text(
                              'Membre depuis: ${DateTime.parse(userData['donneur']?['date_inscription'] ?? userData['date_joined']).year}',
                              style: TextStyleHelper.instance.body12Regular
                                  .copyWith(color: appTheme.whiteCustom),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // QR code
                    if (qrData.isNotEmpty)
                      Container(
                        width: 80.h,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: appTheme.whiteCustom,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 80.h,
                          backgroundColor: appTheme.whiteCustom,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Footer with donation info
                Column(
                  children: [
                    Divider(
                      color: appTheme.whiteCustom.withOpacity(0.3),
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: appTheme.whiteCustom,
                                  size: 16.h,
                                ),
                                SizedBox(width: 4.h),
                                Text(
                                  'Dons: ${userData['donneur']?['nb_dons'] ?? userData['nb_dons'] ?? 0}',
                                  style: TextStyleHelper.instance.body13Regular
                                      .copyWith(color: appTheme.whiteCustom),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Volume total: ${(userData['donneur']?['litres_donnes'] ?? userData['litres_donnes'] ?? 0.0).toStringAsFixed(1)} L',
                              style: TextStyleHelper.instance.body12Regular
                                  .copyWith(color: appTheme.whiteCustom),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'VALIDÉ',
                              style: TextStyleHelper.instance.body12SemiBold
                                  .copyWith(
                                color: appTheme.whiteCustom,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              'Jusqu\'à ${DateTime.now().year + 1}',
                              style: TextStyleHelper.instance.body12Regular
                                  .copyWith(color: appTheme.whiteCustom),
                            ),
                          ],
                        ),
                      ],
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
