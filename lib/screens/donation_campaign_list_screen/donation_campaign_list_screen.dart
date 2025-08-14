import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_navigation.dart';
// import '../../widgets/custom_image_view.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import 'widgets/campaign_card_widget.dart';

class DonationCampaignListScreen extends StatefulWidget {
  const DonationCampaignListScreen({super.key});

  @override
  State<DonationCampaignListScreen> createState() =>
      _DonationCampaignListScreenState();
}

class _DonationCampaignListScreenState
    extends State<DonationCampaignListScreen> {
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
        campaigns = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? _buildErrorState()
              : SingleChildScrollView(
                  child: SizedBox(
                    width: 375.h,
                    child: Column(
                      children: [
                        _buildCampaignInfoRow(context),
                        _buildHeroSection(context),
                        _buildPageIndicator(context),
                        _buildSectionTitle(context),
                        _buildCampaignCards(context),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRoutes.donationCampaignListScreen,
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.h,
            color: appTheme.colorFF4444,
          ),
          SizedBox(height: 16.h),
          Text(
            'Erreur de chargement',
            style: TextStyleHelper.instance.headline16Bold,
          ),
          SizedBox(height: 8.h),
          Text(
            errorMessage!,
            style: TextStyleHelper.instance.body14Regular,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _fetchCampaigns,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  // Méthode _buildHeader supprimée

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
              'Hors ligne',
              style: TextStyleHelper.instance.body12Regular.copyWith(
                height: 1.33,
                color: appTheme.colorFF4444,
              ),
            )
          else
            Text(
              'En ligne',
              style: TextStyleHelper.instance.body12Regular.copyWith(
                height: 1.33,
                color: appTheme.colorFF8808,
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
          padding: EdgeInsets.all(32.h),
          decoration: BoxDecoration(
            color: appTheme.colorFFF2AB.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12.h),
          ),
          child: Column(
            children: [
              Icon(
                Icons.campaign_outlined,
                size: 64.h,
                color: appTheme.colorFF9A9A,
              ),
              SizedBox(height: 16.h),
              Text(
                'Aucune campagne disponible',
                style: TextStyleHelper.instance.headline16Bold.copyWith(
                  color: appTheme.blackCustom,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Aucune campagne de don de sang n\'est actuellement programmée.\nL\'administrateur publiera de nouvelles campagnes ici.',
                style: TextStyleHelper.instance.body14Regular.copyWith(
                  color: appTheme.colorFF7373,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: appTheme.colorFF8808.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.h),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: appTheme.colorFF8808,
                      size: 24.h,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Les campagnes incluront :',
                      style: TextStyleHelper.instance.body12SemiBold.copyWith(
                        color: appTheme.blackCustom,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '• Dates et lieux de collecte\n• Objectifs de participation\n• Informations d\'inscription',
                      style: TextStyleHelper.instance.body12Regular.copyWith(
                        color: appTheme.colorFF7373,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
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
        'Jan',
        'Fév',
        'Mar',
        'Avr',
        'Mai',
        'Jun',
        'Jul',
        'Aoû',
        'Sep',
        'Oct',
        'Nov',
        'Déc'
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
                    color: appTheme.colorFF9A9A,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: appTheme.colorFF4444,
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
                  value: (campaign['participants_actuels'] ?? 0) /
                      (campaign['objectif'] ?? 1),
                  backgroundColor: appTheme.colorFFF2AB.withOpacity(0.3),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(appTheme.colorFF8808),
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

              const Spacer(),

              // Bouton d'inscription
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _registerForCampaign(campaign);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.colorFF8808,
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

  Future<void> _registerForCampaign(Map<String, dynamic> campaign) async {
    // Affichage du snackbar de chargement
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(appTheme.whiteCustom),
              ),
            ),
            const SizedBox(width: 12),
            Text('Inscription à "${campaign['titre']}" en cours...'),
          ],
        ),
        backgroundColor: appTheme.colorFF8808,
        duration: const Duration(seconds: 3),
      ),
    );

    try {
      final api = ApiService();

      // Récupérer le token d'authentification
      final token = await AuthService.getAccessToken();
      if (token == null) {
        throw Exception('Token d\'authentification non disponible');
      }

      // Inscrire le donneur à la campagne
      final success = await api.inscrireCampagne(token, campaign['id']);

      if (success) {
        // Actualiser la liste des campagnes
        await _fetchCampaigns();

        // Afficher le succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: appTheme.whiteCustom),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Inscription réussie à "${campaign['titre']}"!'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Naviguer vers l'écran de confirmation ou détails
        _showRegistrationSuccess(campaign);
      } else {
        throw Exception('Échec de l\'inscription');
      }
    } catch (e) {
      // Afficher l'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: appTheme.whiteCustom),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Erreur lors de l\'inscription: $e'),
              ),
            ],
          ),
          backgroundColor: appTheme.colorFF4444,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showRegistrationSuccess(Map<String, dynamic> campaign) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
        title: Row(
          children: [
            Icon(Icons.celebration, color: appTheme.colorFF8808, size: 28),
            const SizedBox(width: 12),
            Text(
              'Inscription réussie !',
              style: TextStyleHelper.instance.title18SemiBold,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vous êtes maintenant inscrit(e) à la campagne :',
              style: TextStyleHelper.instance.body14Regular,
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                color: appTheme.colorFFF2AB.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign['titre'] ?? 'Campagne',
                    style: TextStyleHelper.instance.body16SemiBold,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${_formatDate(campaign['date'] ?? '')} - ${campaign['lieu'] ?? ''}',
                    style: TextStyleHelper.instance.body12Regular,
                  ),
                  if (campaign['heures'] != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      'Heures: ${campaign['heures']}',
                      style: TextStyleHelper.instance.body12Regular,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Vous recevrez bientôt une confirmation par notification. N\'oubliez pas de vous présenter à l\'heure !',
              style: TextStyleHelper.instance.body12Regular,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Voir mes inscriptions',
              style: TextStyleHelper.instance.body14Regular.copyWith(
                color: appTheme.colorFF8808,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.colorFF8808,
              foregroundColor: appTheme.whiteCustom,
            ),
            child: Text(
              'Parfait !',
              style: TextStyleHelper.instance.body14SemiBold,
            ),
          ),
        ],
      ),
    );
  }
}
