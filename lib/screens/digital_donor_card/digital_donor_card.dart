import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_navigation.dart';
import 'widgets/achievement_badge_widget.dart';
import 'widgets/donation_milestone_widget.dart';
import 'widgets/donor_card_widget.dart';
import 'widgets/emergency_contact_widget.dart';

import '../../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DigitalDonorCard extends StatefulWidget {
  const DigitalDonorCard({super.key});

  @override
  State<DigitalDonorCard> createState() => _DigitalDonorCardState();
}

class _DigitalDonorCardState extends State<DigitalDonorCard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _qrData = '';

  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Utilisateur non authentifié.';
      });
      return;
    }
    final api = ApiService();

    try {
      // Récupérer les informations de l'utilisateur et du donneur
      final user = await api.getCurrentUser(token);
      final donneurs = await api.getDonneurs(token);

      if (user != null) {
        // Enrichir les données utilisateur avec les infos du donneur si disponibles
        Map<String, dynamic> enrichedData = Map.from(user);

        if (donneurs != null && donneurs.isNotEmpty) {
          // Trouver le donneur correspondant à l'utilisateur
          final donneur = donneurs.firstWhere(
            (d) => d['user'] == user['id'],
            orElse: () => null,
          );

          if (donneur != null) {
            enrichedData.addAll({
              'nb_dons': donneur['nb_dons'] ?? 0,
              'litres_donnes': donneur['litres_donnes'] ?? 0.0,
              'groupe_sanguin': donneur['groupe_sanguin'],
              'telephone': donneur['telephone'],
              'is_verified': donneur['is_verified'] ?? false,
            });
          }
        }

        setState(() {
          _userData = enrichedData;
          _isLoading = false;
        });
        _generateQRCode();
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erreur lors du chargement des informations.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur lors du chargement: $e';
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateQRCode() {
    if (_userData == null) return;
    final qrData = {
      'donorId': _userData!['id'] ?? '',
      'fullName':
          '${_userData!['first_name'] ?? ''} ${_userData!['last_name'] ?? ''}'
              .trim(),
      'email': _userData!['email'] ?? '',
      'username': _userData!['username'] ?? '',
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
      appBar: null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _userData == null
                  ? const Center(child: Text('Aucune donnée à afficher.'))
                  : Column(
                      children: [
                        // Main Donor Card
                        Container(
                          margin: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              DonorCardWidget(
                                userData: _userData!,
                                qrData: _qrData,
                                onRegenerateQR: _generateQRCode,
                              ),
                              SizedBox(height: 16.h),
                              // Action buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: _generateQRCode,
                                    icon: Icon(
                                      Icons.refresh,
                                      color: appTheme.colorFF8808,
                                      size: 28.h,
                                    ),
                                    tooltip: 'Reload',
                                  ),
                                  SizedBox(width: 32.h),
                                  IconButton(
                                    onPressed: _downloadCard,
                                    icon: Icon(
                                      Icons.download,
                                      color: appTheme.colorFF8808,
                                      size: 28.h,
                                    ),
                                    tooltip: 'Download',
                                  ),
                                ],
                              ),
                            ],
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
                                      totalDonations:
                                          _userData!['nb_dons'] ?? 0,
                                      nextEligibleDate:
                                          _userData!['next_eligible_date'] ??
                                              'Non disponible',
                                      lastDonation:
                                          _userData!['last_donation'] ??
                                              'Aucun don enregistré',
                                    ),

                                    const SizedBox(height: 16),

                                    // Achievement Badges
                                    AchievementBadgeWidget(
                                      totalDonations:
                                          _userData!['nb_dons'] ?? 0,
                                      registrationDate:
                                          _userData!['date_joined'] ?? '',
                                    ),
                                  ],
                                ),
                              ),

                              // Emergency Contact Tab
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: EmergencyContactWidget(
                                  phoneNumber: _userData!['phone'] ??
                                      _userData!['username'] ??
                                      '',
                                  emergencyContact:
                                      _userData!['emergency_contact'] ??
                                          'Non renseigné',
                                  medicalNotes: _userData!['medical_notes'] ??
                                      'Aucune note médicale',
                                  bloodType: _userData!['blood_type'] ??
                                      'Non renseigné',
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
