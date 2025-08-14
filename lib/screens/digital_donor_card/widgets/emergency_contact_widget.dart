import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';

class EmergencyContactWidget extends StatelessWidget {
  final String phoneNumber;
  final String emergencyContact;
  final String medicalNotes;
  final String bloodType;

  const EmergencyContactWidget({
    super.key,
    required this.phoneNumber,
    required this.emergencyContact,
    required this.medicalNotes,
    required this.bloodType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Emergency Contact Information
        _buildContactCard(
          title: 'Emergency Contact',
          content: emergencyContact,
          icon: Icons.contact_emergency,
          color: appTheme.colorFFFF57,
          onTap: () => _makeCall(emergencyContact.split(' - ').last),
        ),

        const SizedBox(height: 16),

        // Personal Contact
        _buildContactCard(
          title: 'Personal Contact',
          content: phoneNumber,
          icon: Icons.phone,
          color: appTheme.colorFF5ED2,
          onTap: () => _makeCall(phoneNumber),
        ),

        const SizedBox(height: 16),

        // Medical Information
        _buildMedicalCard(),

        const SizedBox(height: 16),

        // Emergency Services
        _buildEmergencyServices(),
      ],
    );
  }

  Widget _buildContactCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyleHelper.instance.body12Regular,
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyleHelper.instance.body14SemiBold.copyWith(
                    color: appTheme.colorFF002A,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: Icon(
              Icons.call,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_information,
                color: appTheme.colorFF8808,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Medical Information',
                style: TextStyleHelper.instance.title18Regular.copyWith(
                  color: appTheme.colorFF002A,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Blood Type
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: appTheme.colorFF8808,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    bloodType,
                    style: TextStyleHelper.instance.body14SemiBold.copyWith(
                      color: appTheme.whiteCustom,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Blood Type',
                style: TextStyleHelper.instance.body14SemiBold.copyWith(
                  color: appTheme.colorFF002A,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Medical Notes
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: appTheme.gray50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Notes',
                  style: TextStyleHelper.instance.body12Regular,
                ),
                const SizedBox(height: 4),
                Text(
                  medicalNotes,
                  style: TextStyleHelper.instance.body13Regular.copyWith(
                    color: appTheme.colorFF002A,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyServices() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emergency,
                color: appTheme.colorFFFF57,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Emergency Services',
                style: TextStyleHelper.instance.title18Regular.copyWith(
                  color: appTheme.colorFF002A,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Emergency service buttons
          Row(
            children: [
              Expanded(
                child: _buildEmergencyButton(
                  'Call 911',
                  Icons.local_hospital,
                  () => _makeCall('911'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEmergencyButton(
                  'Blood Bank',
                  Icons.bloodtype,
                  () => _makeCall('1-800-BLOOD'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton(
      String title, IconData icon, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: appTheme.colorFFFF57,
        foregroundColor: appTheme.whiteCustom,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyleHelper.instance.body12Regular.copyWith(
              color: appTheme.whiteCustom,
            ),
          ),
        ],
      ),
    );
  }

  void _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }
}
