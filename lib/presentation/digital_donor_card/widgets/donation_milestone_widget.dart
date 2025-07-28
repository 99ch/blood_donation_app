import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class DonationMilestoneWidget extends StatelessWidget {
  final int totalDonations;
  final String nextEligibleDate;
  final String lastDonation;

  const DonationMilestoneWidget({
    super.key,
    required this.totalDonations,
    required this.nextEligibleDate,
    required this.lastDonation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: appTheme.whiteCustom,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: appTheme.blackCustom.withAlpha(26),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Donation Milestones',
              style: TextStyleHelper.instance.title18Regular.copyWith(
                  color: appTheme.colorFF002A, fontWeight: FontWeight.w600)),

          const SizedBox(height: 16),

          // Progress to next milestone
          _buildMilestoneProgress(),

          const SizedBox(height: 16),

          // Donation statistics
          Row(children: [
            Expanded(
                child: _buildStatCard(
                    'Total Donations',
                    totalDonations.toString(),
                    Icons.bloodtype,
                    appTheme.colorFF8808)),
            const SizedBox(width: 12),
            Expanded(
                child: _buildStatCard(
                    'Lives Saved',
                    (totalDonations * 3).toString(),
                    Icons.favorite,
                    appTheme.colorFFFF57)),
          ]),

          const SizedBox(height: 16),

          // Next eligible date
          Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: appTheme.colorFF5ED2.withAlpha(26),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                Icon(Icons.calendar_today,
                    color: appTheme.colorFF5ED2, size: 20),
                const SizedBox(width: 8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Next Eligible Date',
                      style: TextStyleHelper.instance.body12Regular),
                  Text(nextEligibleDate,
                      style: TextStyleHelper.instance.body14SemiBold
                          .copyWith(color: appTheme.colorFF002A)),
                ]),
              ])),

          const SizedBox(height: 12),

          // Last donation
          Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: appTheme.gray50,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                Icon(Icons.history, color: appTheme.colorFF5050, size: 20),
                const SizedBox(width: 8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Last Donation',
                      style: TextStyleHelper.instance.body12Regular),
                  Text(lastDonation,
                      style: TextStyleHelper.instance.body14SemiBold
                          .copyWith(color: appTheme.colorFF002A)),
                ]),
              ])),
        ]));
  }

  Widget _buildMilestoneProgress() {
    final nextMilestone = ((totalDonations ~/ 5) + 1) * 5;
    final progress = totalDonations / nextMilestone;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Progress to $nextMilestone donations',
            style: TextStyleHelper.instance.body13Regular),
        Text('$totalDonations / $nextMilestone',
            style: TextStyleHelper.instance.body14SemiBold
                .copyWith(color: appTheme.colorFF002A)),
      ]),
      const SizedBox(height: 8),
      LinearProgressIndicator(
          value: progress,
          valueColor: AlwaysStoppedAnimation<Color>(appTheme.colorFF5ED2),
          minHeight: 8),
    ]);
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: color.withAlpha(26), borderRadius: BorderRadius.circular(8)),
        child: Column(children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyleHelper.instance.title18Regular
                  .copyWith(color: color, fontWeight: FontWeight.bold)),
          Text(title,
              style: TextStyleHelper.instance.body12Regular,
              textAlign: TextAlign.center),
        ]));
  }
}
