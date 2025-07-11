import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class TestResultCardWidget extends StatelessWidget {
  final Map<String, dynamic> testResult;
  final VoidCallback onTap;

  const TestResultCardWidget({
    super.key,
    required this.testResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.h)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.h),
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with date and status
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Test Date: ${testResult['date']}',
                    style: TextStyle(
                        fontSize: 16.fSize, fontWeight: FontWeight.w600)),
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                    decoration: BoxDecoration(
                        color: testResult['statusColor'].withAlpha(26),
                        borderRadius: BorderRadius.circular(8.h)),
                    child: Text(testResult['status'],
                        style: TextStyle(
                            color: testResult['statusColor'],
                            fontSize: 12.fSize,
                            fontWeight: FontWeight.w500))),
              ]),
              SizedBox(height: 12.h),
              // Blood type and hemoglobin
              Row(children: [
                _buildInfoItem('Blood Type', testResult['bloodType']),
                SizedBox(width: 24.h),
                _buildInfoItem(
                    'Hemoglobin', '${testResult['hemoglobin']} g/dL'),
              ]),
              SizedBox(height: 12.h),
              // Next donation date
              Row(children: [
                Icon(Icons.calendar_today,
                    size: 16.h, color: theme.colorScheme.primary),
                SizedBox(width: 8.h),
                Text('Next eligible: ${testResult['nextDonationDate']}',
                    style: TextStyle(
                        fontSize: 14.fSize, color: theme.colorScheme.primary)),
              ]),
              SizedBox(height: 12.h),
              // Expand indicator
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Tap for details',
                    style:
                        TextStyle(fontSize: 12.fSize, color: Colors.grey[600])),
                Icon(Icons.expand_more, size: 16.h, color: Colors.grey[600]),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12.fSize, color: Colors.grey[600])),
        SizedBox(height: 4.h),
        Text(value,
            style: TextStyle(fontSize: 14.fSize, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
