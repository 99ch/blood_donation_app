import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_navigation.dart';
import './widgets/center_list_view_widget.dart';
import './widgets/map_view_widget.dart';
import './widgets/search_filter_widget.dart';

class BloodCollectionCentersLocator extends StatefulWidget {
  const BloodCollectionCentersLocator({super.key});

  @override
  State<BloodCollectionCentersLocator> createState() =>
      _BloodCollectionCentersLocatorState();
}

class _BloodCollectionCentersLocatorState
    extends State<BloodCollectionCentersLocator> with TickerProviderStateMixin {
  bool _isMapView = true;
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedCenterType = 'All';
  String _selectedHours = 'All';

  final List<Map<String, dynamic>> _centers = [
    {
      'name': 'City Medical Center',
      'address': '123 Main Street, Downtown',
      'phone': '(555) 123-4567',
      'type': 'Hospital',
      'waitTime': '15 min',
      'availableSlots': 5,
      'rating': 4.5,
      'reviews': 128,
      'hours': '8:00 AM - 8:00 PM',
      'parking': true,
      'services': ['Whole Blood', 'Platelets', 'Plasma'],
      'lat': 40.7128,
      'lng': -74.0060,
      'distance': '0.5 miles',
      'isOpen': true
    },
    {
      'name': 'Red Cross Mobile Unit',
      'address': '456 Oak Avenue, Midtown',
      'phone': '(555) 987-6543',
      'type': 'Mobile Unit',
      'waitTime': '5 min',
      'availableSlots': 12,
      'rating': 4.8,
      'reviews': 89,
      'hours': '10:00 AM - 6:00 PM',
      'parking': true,
      'services': ['Whole Blood', 'Platelets'],
      'lat': 40.7589,
      'lng': -73.9851,
      'distance': '1.2 miles',
      'isOpen': true
    },
    {
      'name': 'Community Health Center',
      'address': '789 Pine Street, Uptown',
      'phone': '(555) 456-7890',
      'type': 'Clinic',
      'waitTime': '25 min',
      'availableSlots': 3,
      'rating': 4.2,
      'reviews': 67,
      'hours': '9:00 AM - 5:00 PM',
      'parking': false,
      'services': ['Whole Blood', 'Plasma'],
      'lat': 40.7831,
      'lng': -73.9712,
      'distance': '2.1 miles',
      'isOpen': false
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search and toggle
            Container(
              padding: EdgeInsets.all(16.h),
              decoration:
                  BoxDecoration(color: theme.colorScheme.surface, boxShadow: [
                BoxShadow(
                    color: Colors.grey.withAlpha(26),
                    blurRadius: 4,
                    offset: const Offset(0, 2)),
              ]),
              child: Column(
                children: [
                  // Header with back button and title
                  Row(children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: theme.colorScheme.onSurface),
                        onPressed: () => Navigator.pop(context)),
                    Expanded(
                        child: Text('Find Blood Centers',
                            style: TextStyle(
                                fontSize: 20.fSize,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface))),
                    // View toggle
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.h),
                          border: Border.all(color: Colors.grey[300]!)),
                      child: TabBar(
                          controller: _tabController,
                          labelColor: theme.colorScheme.onPrimary,
                          unselectedLabelColor: Colors.grey[600],
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.h),
                              color: theme.colorScheme.primary),
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            Tab(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  const Icon(Icons.map),
                                  SizedBox(width: 4.h),
                                  Text('Map',
                                      style: TextStyle(fontSize: 12.fSize)),
                                ])),
                            Tab(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  const Icon(Icons.list),
                                  SizedBox(width: 4.h),
                                  Text('List',
                                      style: TextStyle(fontSize: 12.fSize)),
                                ])),
                          ],
                          onTap: (index) {
                            setState(() {
                              _isMapView = index == 0;
                            });
                          }),
                    ),
                  ]),
                  SizedBox(height: 16.h),
                  // Search and filter
                  SearchFilterWidget(
                      searchQuery: _searchQuery,
                      selectedCenterType: _selectedCenterType,
                      selectedHours: _selectedHours,
                      onSearchChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                      onCenterTypeChanged: (type) {
                        setState(() {
                          _selectedCenterType = type;
                        });
                      },
                      onHoursChanged: (hours) {
                        setState(() {
                          _selectedHours = hours;
                        });
                      }),
                ],
              ),
            ),
            // Main content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Map view
                  MapViewWidget(
                      centers: _getFilteredCenters(),
                      onCenterTapped: _showCenterDetails),
                  // List view
                  CenterListViewWidget(
                      centers: _getFilteredCenters(),
                      onCenterTapped: _showCenterDetails,
                      onNavigateTapped: _navigateToCenter,
                      onFavoriteTapped: _toggleFavorite),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _getCurrentLocation,
          backgroundColor: theme.colorScheme.primary,
          child: Icon(Icons.my_location, color: theme.colorScheme.onPrimary)),
      bottomNavigationBar: const CustomBottomNavigation(
          currentRoute: AppRoutes.bloodCollectionCentersLocator),
    );
  }

  List<Map<String, dynamic>> _getFilteredCenters() {
    List<Map<String, dynamic>> filtered = _centers;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((center) {
        return center['name']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            center['address']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Filter by center type
    if (_selectedCenterType != 'All') {
      filtered = filtered.where((center) {
        return center['type'] == _selectedCenterType;
      }).toList();
    }

    // Filter by hours
    if (_selectedHours == 'Open Now') {
      filtered = filtered.where((center) {
        return center['isOpen'] == true;
      }).toList();
    }

    return filtered;
  }

  void _showCenterDetails(Map<String, dynamic> center) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.h))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                      child: Container(
                          width: 40.h,
                          height: 4.h,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2.h)))),
                  SizedBox(height: 16.h),
                  // Center name and rating
                  Row(children: [
                    Expanded(
                        child: Text(center['name'],
                            style: TextStyle(
                                fontSize: 20.fSize,
                                fontWeight: FontWeight.w600))),
                    Row(children: [
                      const Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 4.h),
                      Text('${center['rating']} (${center['reviews']})',
                          style: TextStyle(fontSize: 14.fSize)),
                    ]),
                  ]),
                  SizedBox(height: 16.h),
                  // Expanded details
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(Icons.location_on, center['address']),
                          _buildDetailRow(Icons.phone, center['phone']),
                          _buildDetailRow(Icons.access_time, center['hours']),
                          _buildDetailRow(Icons.timer,
                              'Current wait: ${center['waitTime']}'),
                          _buildDetailRow(Icons.event_available,
                              '${center['availableSlots']} slots available'),
                          _buildDetailRow(
                              Icons.local_parking,
                              center['parking']
                                  ? 'Parking available'
                                  : 'No parking'),
                          SizedBox(height: 16.h),
                          // Services
                          Text('Available Services',
                              style: TextStyle(
                                  fontSize: 16.fSize,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 8.h),
                          Wrap(
                              spacing: 8.h,
                              children:
                                  center['services'].map<Widget>((service) {
                                return Chip(
                                    label: Text(service),
                                    backgroundColor:
                                        theme.colorScheme.primary.withAlpha(26),
                                    labelStyle: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontSize: 12.fSize));
                              }).toList()),
                          SizedBox(height: 16.h),
                          // Action buttons
                          Row(children: [
                            Expanded(
                                child: ElevatedButton.icon(
                                    onPressed: () => _navigateToCenter(center),
                                    icon: const Icon(Icons.directions),
                                    label: const Text('Navigate'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                        foregroundColor:
                                            theme.colorScheme.onPrimary))),
                            SizedBox(width: 12.h),
                            Expanded(
                                child: OutlinedButton.icon(
                                    onPressed: () => _callCenter(center),
                                    icon: const Icon(Icons.call),
                                    label: const Text('Call'))),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(children: [
        Icon(icon, color: theme.colorScheme.primary),
        SizedBox(width: 12.h),
        Expanded(child: Text(text, style: TextStyle(fontSize: 14.fSize))),
      ]),
    );
  }

  void _navigateToCenter(Map<String, dynamic> center) {
    // Implement navigation to center
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening navigation to ${center['name']}')));
  }

  void _callCenter(Map<String, dynamic> center) {
    // Implement phone call
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Calling ${center['phone']}')));
  }

  void _toggleFavorite(Map<String, dynamic> center) {
    // Implement favorite toggle
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${center['name']} added to favorites')));
  }

  void _getCurrentLocation() {
    // Implement GPS location
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Finding your location...')));
  }
}
