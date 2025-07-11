import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class CenterListViewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> centers;
  final Function(Map<String, dynamic>) onCenterTapped;
  final Function(Map<String, dynamic>) onNavigateTapped;
  final Function(Map<String, dynamic>) onFavoriteTapped;

  const CenterListViewWidget({
    super.key,
    required this.centers,
    required this.onCenterTapped,
    required this.onNavigateTapped,
    required this.onFavoriteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(16.h),
        itemCount: centers.length,
        itemBuilder: (context, index) {
          final center = centers[index];
          return Card(
              margin: const EdgeInsets.only(),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.h)),
              child: InkWell(
                  onTap: () => onCenterTapped(center),
                  borderRadius: BorderRadius.circular(12.h),
                  child: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row
                            Row(children: [
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(center['name'],
                                        style: TextStyle(
                                            fontSize: 16.fSize,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(),
                                    Text(center['address'],
                                        style: TextStyle(
                                            fontSize: 14.fSize,
                                            color: Colors.grey[600])),
                                  ])),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber),
                                      SizedBox(width: 4.h),
                                      Text('${center['rating']}',
                                          style: TextStyle(
                                              fontSize: 14.fSize,
                                              fontWeight: FontWeight.w500)),
                                    ]),
                                    const SizedBox(),
                                    Text(center['distance'],
                                        style: TextStyle(
                                            fontSize: 12.fSize,
                                            color: Colors.grey[600])),
                                  ]),
                            ]),
                            const SizedBox(),
                            // Status indicators
                            Row(children: [
                              _buildStatusChip(
                                  center['isOpen'] ? 'Open' : 'Closed',
                                  center['isOpen'] ? Colors.green : Colors.red),
                              SizedBox(width: 8.h),
                              _buildStatusChip(
                                  'Wait: ${center['waitTime']}', Colors.blue),
                              SizedBox(width: 8.h),
                              _buildStatusChip(
                                  '${center['availableSlots']} slots',
                                  Colors.orange),
                            ]),
                            const SizedBox(),
                            // Center type and services
                            Row(children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.h, vertical: 4.h),
                                  decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withAlpha(26),
                                      borderRadius: BorderRadius.circular(8.h)),
                                  child: Text(center['type'],
                                      style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontSize: 12.fSize,
                                          fontWeight: FontWeight.w500))),
                              SizedBox(width: 8.h),
                              if (center['parking'])
                                const Icon(Icons.local_parking,
                                    color: Colors.green),
                            ]),
                            const SizedBox(),
                            // Action buttons
                            Row(children: [
                              Expanded(
                                  child: OutlinedButton.icon(
                                      onPressed: () => onNavigateTapped(center),
                                      icon: const Icon(Icons.directions),
                                      label: const Text('Navigate'),
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              theme.colorScheme.primary,
                                          side: BorderSide(
                                              color:
                                                  theme.colorScheme.primary)))),
                              SizedBox(width: 8.h),
                              IconButton(
                                  onPressed: () => onFavoriteTapped(center),
                                  icon: Icon(Icons.favorite_border,
                                      color: theme.colorScheme.primary)),
                            ]),
                          ]))));
        });
  }

  Widget _buildStatusChip(String text, Color color) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
        decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(8.h)),
        child: Text(text,
            style: TextStyle(
                color: color,
                fontSize: 12.fSize,
                fontWeight: FontWeight.w500)));
  }
}
