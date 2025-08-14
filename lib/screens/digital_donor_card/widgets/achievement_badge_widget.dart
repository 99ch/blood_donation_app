import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AchievementBadgeWidget extends StatelessWidget {
  final int totalDonations;
  final String registrationDate;

  const AchievementBadgeWidget({
    super.key,
    required this.totalDonations,
    required this.registrationDate,
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
          Text('Achievement Badges',
              style: TextStyleHelper.instance.title18Regular.copyWith(
                  color: appTheme.colorFF002A, fontWeight: FontWeight.w600)),

          const SizedBox(height: 16),

          // Achievement badges grid
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8),
              itemCount: _getAchievements().length,
              itemBuilder: (context, index) {
                final achievement = _getAchievements()[index];
                return _buildAchievementBadge(achievement);
              }),
        ]));
  }

  List<Map<String, dynamic>> _getAchievements() {
    List<Map<String, dynamic>> achievements = [];

    // First donation badge
    achievements.add({
      'title': 'First Drop',
      'description': 'First donation',
      'icon': Icons.water_drop,
      'color': appTheme.colorFF5ED2,
      'earned': true,
    });

    // Regular donor badges
    if (totalDonations >= 5) {
      achievements.add({
        'title': 'Regular Donor',
        'description': '5+ donations',
        'icon': Icons.star,
        'color': appTheme.colorFF8808,
        'earned': true,
      });
    }

    if (totalDonations >= 10) {
      achievements.add({
        'title': 'Hero',
        'description': '10+ donations',
        'icon': Icons.shield,
        'color': appTheme.colorFFFF57,
        'earned': true,
      });
    }

    if (totalDonations >= 15) {
      achievements.add({
        'title': 'Life Saver',
        'description': '15+ donations',
        'icon': Icons.favorite,
        'color': appTheme.colorFF002A,
        'earned': true,
      });
    }

    // Loyalty badge (donated for more than 1 year)
    final registrationYear =
        DateTime.tryParse(registrationDate)?.year ?? DateTime.now().year;
    if (DateTime.now().year - registrationYear >= 1) {
      achievements.add({
        'title': 'Loyal Donor',
        'description': '1+ year active',
        'icon': Icons.loyalty,
        'color': appTheme.colorFF5ED22,
        'earned': true,
      });
    }

    // Future milestones
    if (totalDonations < 20) {
      achievements.add({
        'title': 'Champion',
        'description': '20 donations',
        'icon': Icons.emoji_events,
        'color': appTheme.colorFF5050,
        'earned': false,
      });
    }

    if (totalDonations < 25) {
      achievements.add({
        'title': 'Legend',
        'description': '25 donations',
        'icon': Icons.stars,
        'color': appTheme.colorFF5050,
        'earned': false,
      });
    }

    return achievements;
  }

  Widget _buildAchievementBadge(Map<String, dynamic> achievement) {
    final isEarned = achievement['earned'] as bool;
    final color = achievement['color'] as Color;

    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isEarned ? color : appTheme.gray300, width: 2)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(achievement['icon'] as IconData,
              size: 24, color: isEarned ? color : appTheme.colorFF5050),
          const SizedBox(height: 4),
          Text(achievement['title'] as String,
              style: TextStyleHelper.instance.body12Regular.copyWith(
                  color: isEarned ? color : appTheme.colorFF5050,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(achievement['description'] as String,
              style: TextStyleHelper.instance.label8Regular.copyWith(
                  color:
                      isEarned ? appTheme.colorFF5050 : appTheme.colorFF8888),
              textAlign: TextAlign.center),
        ]));
  }
}
