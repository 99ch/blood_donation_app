import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class MapViewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> centers;
  final Function(Map<String, dynamic>) onCenterTapped;

  const MapViewWidget({
    super.key,
    required this.centers,
    required this.onCenterTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(children: [
          // Map placeholder (would be replaced with actual map widget)
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.blue[100]!,
                    Colors.blue[200]!,
                  ])),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Icon(Icons.map, color: Colors.blue[400]),
                    const SizedBox(height: 8),
                    Text('Interactive Map View',
                        style: TextStyle(
                            fontSize: 18.fSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700])),
                    const SizedBox(height: 4),
                    Text('Map integration would show here',
                        style: TextStyle(
                            fontSize: 14.fSize, color: Colors.blue[600])),
                  ]))),
          // Map pins overlay
          ...centers.asMap().entries.map((entry) {
            final index = entry.key;
            final center = entry.value;
            return Positioned(
                left: 50.h + (index * 80.h),
                top: 100,
                child: GestureDetector(
                    onTap: () => onCenterTapped(center),
                    child: Container(
                        padding: EdgeInsets.all(8.h),
                        decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(20.h),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withAlpha(51),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2)),
                            ]),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.location_on,
                              color: theme.colorScheme.onPrimary),
                          if (center['waitTime'] != null)
                            Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.h, vertical: 2),
                                decoration: BoxDecoration(
                                    color: theme.colorScheme.onPrimary,
                                    borderRadius: BorderRadius.circular(8.h)),
                                child: Text(center['waitTime'],
                                    style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontSize: 10.fSize,
                                        fontWeight: FontWeight.w500))),
                        ]))));
          }),
        ]));
  }
}
