import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class BadgeCardWidget extends StatelessWidget {
  final Map<String, dynamic> badge;
  final bool isAdmin;
  final VoidCallback onDownload;
  final VoidCallback onShare;

  const BadgeCardWidget({
    Key? key,
    required this.badge,
    required this.isAdmin,
    required this.onDownload,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec icône et titre
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  color: appTheme.primaryPink.withAlpha(51),
                  borderRadius: BorderRadius.circular(8.h),
                ),
                child: Icon(
                  Icons.card_membership,
                  color: appTheme.darkRed,
                  size: 24.h,
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Badge Donneur',
                      style: TextStyleHelper.instance.title16SemiBold,
                    ),
                    if (badge['donneur'] != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        '${badge['donneur']['nom']} ${badge['donneur']['prenoms']}',
                        style: TextStyleHelper.instance.body14Regular.copyWith(
                          color: appTheme.colorFF5050,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                decoration: BoxDecoration(
                  color: appTheme.primaryPink,
                  borderRadius: BorderRadius.circular(12.h),
                ),
                child: Text(
                  'Actif',
                  style: TextStyleHelper.instance.body12Regular.copyWith(
                    color: appTheme.whiteCustom,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Informations du badge
          Container(
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              color: appTheme.lightPink.withAlpha(128),
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  'Date de création',
                  _formatDate(badge['created_at']),
                  Icons.calendar_today,
                ),
                if (badge['file'] != null) ...[
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    'Fichier',
                    'PDF disponible',
                    Icons.picture_as_pdf,
                  ),
                ],
                if (badge['donneur'] != null) ...[
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    'Nombre de dons',
                    '${badge['donneur']['nb_dons'] ?? 0}',
                    Icons.bloodtype,
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDownload,
                  icon: Icon(Icons.download, size: 18.h),
                  label: Text('Télécharger'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: appTheme.darkRed,
                    side: BorderSide(color: appTheme.darkRed),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onShare,
                  icon: Icon(Icons.share, size: 18.h),
                  label: Text('Partager'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primaryPink,
                    foregroundColor: appTheme.whiteCustom,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.h,
          color: appTheme.darkRed,
        ),
        SizedBox(width: 8.h),
        Text(
          '$label: ',
          style: TextStyleHelper.instance.body12Regular.copyWith(
            color: appTheme.colorFF5050,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyleHelper.instance.body12SemiBold,
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Non défini';
    
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
