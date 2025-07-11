import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_navigation.dart';
import './widgets/achievement_badge_widget.dart';
import './widgets/donation_milestone_widget.dart';
import './widgets/donor_card_widget.dart';
import './widgets/emergency_contact_widget.dart';

class DigitalDonorCard extends StatefulWidget {
  const DigitalDonorCard({super.key});

  @override
  State<DigitalDonorCard> createState() => _DigitalDonorCardState();
}

class _DigitalDonorCardState extends State<DigitalDonorCard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _qrData = '';

  // Mock user data - in real app, this would come from a data source
  final Map<String, dynamic> _userData = {
    'fullName': 'John Doe',
    'bloodType': 'O+',
    'donorId': 'BD2024-001234',
    'totalDonations': 15,
    'photoUrl': 'https://via.placeholder.com/150',
    'registrationDate': '2022-01-15',
    'lastDonation': '2024-06-15',
    'nextEligibleDate': '2024-08-15',
    'phoneNumber': '+1 (555) 123-4567',
    'emergencyContact': 'Jane Doe - +1 (555) 987-6543',
    'medicalNotes': 'No known allergies',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _generateQRCode();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateQRCode() {
    // Generate QR code data with user information
    final qrData = {
      'donorId': _userData['donorId'],
      'fullName': _userData['fullName'],
      'bloodType': _userData['bloodType'],
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    setState(() {
      _qrData = qrData.toString();
    });
  }

  void _shareAchievements() {
    // Mock sharing functionality
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Achievements shared successfully!'),
        backgroundColor: appTheme.primaryPink,
      ),
    );
  }

  void _downloadCard() {
    // Mock download functionality
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Card downloaded successfully!'),
        backgroundColor: appTheme.primaryPink,
      ),
    );
  }

  void _reportLostCard() {
    // Mock report functionality
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Lost Card'),
        content: const Text(
            'Are you sure you want to report this card as lost or stolen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                      'Card reported as lost. A new card will be issued.'),
                  backgroundColor: appTheme.primaryRed,
                ),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.lightPink,
      appBar: AppBar(
        backgroundColor: appTheme.darkRed,
        title: Text(
          'Digital Donor Card',
          style: TextStyleHelper.instance.title20SemiBold,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appTheme.whiteCustom),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: appTheme.whiteCustom),
            onPressed: _generateQRCode,
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: appTheme.whiteCustom),
            onSelected: (value) {
              switch (value) {
                case 'share':
                  _shareAchievements();
                  break;
                case 'download':
                  _downloadCard();
                  break;
                case 'report':
                  _reportLostCard();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, color: appTheme.darkRed),
                    const SizedBox(width: 8),
                    const Text('Share Achievements'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download, color: appTheme.darkRed),
                    const SizedBox(width: 8),
                    const Text('Download Card'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.report, color: appTheme.primaryRed),
                    const SizedBox(width: 8),
                    const Text('Report Lost/Stolen'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Main Donor Card
          Container(
            margin: const EdgeInsets.all(16),
            child: DonorCardWidget(
              userData: _userData,
              qrData: _qrData,
              onRegenerateQR: _generateQRCode,
            ),
          ),

          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
            child: TabBar(
              controller: _tabController,
              labelColor: appTheme.darkRed,
              unselectedLabelColor: appTheme.colorFF5050,
              indicator: BoxDecoration(
                color: appTheme.primaryPink,
                borderRadius: BorderRadius.circular(12),
              ),
              tabs: const [
                Tab(text: 'Milestones'),
                Tab(text: 'Emergency'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Milestones Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Donation Milestones
                      DonationMilestoneWidget(
                        totalDonations: _userData['totalDonations'],
                        nextEligibleDate: _userData['nextEligibleDate'],
                        lastDonation: _userData['lastDonation'],
                      ),

                      const SizedBox(height: 16),

                      // Achievement Badges
                      AchievementBadgeWidget(
                        totalDonations: _userData['totalDonations'],
                        registrationDate: _userData['registrationDate'],
                      ),
                    ],
                  ),
                ),

                // Emergency Contact Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: EmergencyContactWidget(
                    phoneNumber: _userData['phoneNumber'],
                    emergencyContact: _userData['emergencyContact'],
                    medicalNotes: _userData['medicalNotes'],
                    bloodType: _userData['bloodType'],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRoutes.digitalDonorCard,
      ),
    );
  }
}
