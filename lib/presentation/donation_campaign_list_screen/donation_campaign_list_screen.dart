import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/custom_image_view.dart';
import '../../services/api_service.dart';
import './widgets/campaign_card_widget.dart';

class DonationCampaignListScreen extends StatefulWidget {
  const DonationCampaignListScreen({Key? key}) : super(key: key);

  @override
  State<DonationCampaignListScreen> createState() => _DonationCampaignListScreenState();
}

class _DonationCampaignListScreenState extends State<DonationCampaignListScreen> {
  List<dynamic>? campaigns;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCampaigns();
  }

  Future<void> _fetchCampaigns() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final api = ApiService();
      final result = await api.getCampagnes();
      
      setState(() {
        campaigns = result ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Erreur lors du chargement des campagnes: $e";
        isLoading = false;
        // Utiliser des données de fallback
        campaigns = [
          {
            'id': 1,
            'titre': 'Première campagne',
            'date': '2025-06-10',
            'lieu': 'Campus Universitaire',
            'description': 'Campagne de collecte sur le campus',
          },
          {
            'id': 2,
            'titre': 'Deuxième campagne',
            'date': '2025-08-15',
            'lieu': 'Centre Ville',
            'description': 'Collecte en centre ville',
          },
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                width: 375.h,
                child: Column(
                  children: [
                    _buildHeader(context),
                    _buildCampaignInfoRow(context),
                    _buildHeroSection(context),
                    _buildPageIndicator(context),
                    _buildSectionTitle(context),
                    _buildCampaignCards(context),
                    SizedBox(height: 20.h), // Add spacing before bottom navigation
                  ],
                ),
              ),
            ),
      bottomNavigationBar: CustomBottomNavigation(
        currentRoute: AppRoutes.donationCampaignListScreen,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 73.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: appTheme.colorFFF2AB,
        borderRadius: BorderRadius.circular(2.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(77),
            offset: Offset(8.h, 8.h),
            blurRadius: 16.h,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 17.h,
              width: 14.h,
              margin: EdgeInsets.only(right: 24.h),
              child: Stack(
                children: [
                  Positioned(
                    top: 9.h,
                    left: 0,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgVector,
                      height: 2.h,
                      width: 14.h,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgArrowleft,
                      height: 17.h,
                      width: 7.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            'Faire un don',
            style:
                TextStyleHelper.instance.title20SemiBold.copyWith(height: 1.25),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignInfoRow(BuildContext context) {
    return Container(
      height: 18.h,
      width: double.infinity,
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${campaigns?.length ?? 0} campagnes disponibles',
            style:
                TextStyleHelper.instance.body14SemiBold.copyWith(height: 1.29),
          ),
          if (errorMessage != null)
            Text(
              'Mode démo',
              style: TextStyleHelper.instance.body12Regular.copyWith(
                height: 1.33,
                color: appTheme.primaryRed,
              ),
            )
          else
            Text(
              'En ligne',
              style: TextStyleHelper.instance.body12Regular.copyWith(
                height: 1.33,
                color: appTheme.primaryPink,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: 108.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
      decoration: BoxDecoration(
        color: appTheme.blackCustom,
        borderRadius: BorderRadius.circular(4.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.colorFF8888,
            offset: Offset(0, 4.h),
            blurRadius: 10.h,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8.h,
            left: 8.h,
            child: Container(
              height: 21.h,
              width: 55.h,
              decoration: BoxDecoration(
                color: appTheme.colorFFF2AB,
                borderRadius: BorderRadius.circular(4.h),
              ),
              child: Center(
                child: Text(
                  'Bientôt',
                  style: TextStyleHelper.instance.label10Regular
                      .copyWith(height: 1.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    return Container(
      height: 4.h,
      width: 32.h,
      margin: EdgeInsets.only(top: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8.h,
            height: 4.h,
            decoration: BoxDecoration(
              color: appTheme.grey300,
              borderRadius: BorderRadius.circular(2.h),
            ),
          ),
          SizedBox(width: 4.h),
          Container(
            width: 8.h,
            height: 4.h,
            decoration: BoxDecoration(
              color: appTheme.colorFFFF57,
              borderRadius: BorderRadius.circular(2.h),
            ),
          ),
          SizedBox(width: 4.h),
          Container(
            width: 8.h,
            height: 4.h,
            decoration: BoxDecoration(
              color: appTheme.grey300,
              borderRadius: BorderRadius.circular(2.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 24.h),
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Text(
        'NOS CAMPAGNES',
        style: TextStyleHelper.instance.title22SemiBold.copyWith(height: 1.18),
      ),
    );
  }

  Widget _buildCampaignCards(BuildContext context) {
    if (campaigns == null || campaigns!.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.h),
          decoration: BoxDecoration(
            color: appTheme.lightPink.withAlpha(77),
            borderRadius: BorderRadius.circular(12.h),
          ),
          child: Column(
            children: [
              Icon(
                Icons.event_busy,
                size: 48,
                color: appTheme.colorFF5050,
              ),
              SizedBox(height: 12.h),
              Text(
                'Aucune campagne disponible',
                style: TextStyleHelper.instance.body16Regular,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: campaigns!.map<Widget>((campaign) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: CampaignCardWidget(
              title: campaign['titre'] ?? 'Campagne',
              date: _formatDate(campaign['date'] ?? ''),
              lieu: campaign['lieu'] ?? '',
              description: campaign['description'] ?? '',
              urgence: campaign['urgence'] ?? 'normale',
              objectif: campaign['objectif'] ?? 0,
              participants: campaign['participants_actuels'] ?? 0,
              iconPath: ImageConstant.imgDna,
              onTap: () => _showCampaignDetails(campaign),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
        'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _showCampaignDetails(Map<String, dynamic> campaign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.h)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40.h,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: appTheme.colorFF5050,
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              
              // Titre et urgence
              Row(
                children: [
                  Expanded(
                    child: Text(
                      campaign['titre'] ?? 'Campagne',
                      style: TextStyleHelper.instance.title20SemiBold,
                    ),
                  ),
                  if (campaign['urgence'] == 'haute')
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: appTheme.primaryRed,
                        borderRadius: BorderRadius.circular(12.h),
                      ),
                      child: Text(
                        'URGENT',
                        style: TextStyleHelper.instance.body12SemiBold.copyWith(
                          color: appTheme.whiteCustom,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16.h),
              
              // Informations détaillées
              _buildDetailRow('Date', _formatDate(campaign['date'] ?? '')),
              _buildDetailRow('Lieu', campaign['lieu'] ?? ''),
              _buildDetailRow('Organisateur', campaign['organisateur'] ?? ''),
              _buildDetailRow('Heures', campaign['heures'] ?? ''),
              
              SizedBox(height: 16.h),
              
              // Progression
              if (campaign['objectif'] != null) ...[
                Text(
                  'Progression',
                  style: TextStyleHelper.instance.title16SemiBold,
                ),
                SizedBox(height: 8.h),
                LinearProgressIndicator(
                  value: (campaign['participants_actuels'] ?? 0) / (campaign['objectif'] ?? 1),
                  backgroundColor: appTheme.lightPink,
                  valueColor: AlwaysStoppedAnimation<Color>(appTheme.primaryPink),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${campaign['participants_actuels'] ?? 0} / ${campaign['objectif'] ?? 0} participants',
                  style: TextStyleHelper.instance.body14Regular,
                ),
                SizedBox(height: 16.h),
              ],
              
              // Description
              Text(
                'Description',
                style: TextStyleHelper.instance.title16SemiBold,
              ),
              SizedBox(height: 8.h),
              Text(
                campaign['description'] ?? 'Aucune description disponible',
                style: TextStyleHelper.instance.body14Regular,
              ),
              
              Spacer(),
              
              // Bouton d'inscription
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _registerForCampaign(campaign);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.primaryPink,
                    foregroundColor: appTheme.whiteCustom,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text(
                    'S\'inscrire à cette campagne',
                    style: TextStyleHelper.instance.body16SemiBold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.h,
            child: Text(
              '$label:',
              style: TextStyleHelper.instance.body14SemiBold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyleHelper.instance.body14Regular,
            ),
          ),
        ],
      ),
    );
  }

  void _registerForCampaign(Map<String, dynamic> campaign) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Inscription à "${campaign['titre']}" en cours...'),
        backgroundColor: appTheme.primaryPink,
      ),
    );
  }
}
