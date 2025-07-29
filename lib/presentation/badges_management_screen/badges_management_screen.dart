import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_navigation.dart';
import './widgets/badge_card_widget.dart';
import './widgets/badge_generation_widget.dart';

class BadgesManagementScreen extends StatefulWidget {
  const BadgesManagementScreen({Key? key}) : super(key: key);

  @override
  State<BadgesManagementScreen> createState() => _BadgesManagementScreenState();
}

class _BadgesManagementScreenState extends State<BadgesManagementScreen> {
  List<dynamic>? badges;
  List<dynamic>? donneurs;
  bool isLoading = true;
  String? errorMessage;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    
    if (token == null) {
      setState(() {
        errorMessage = "Utilisateur non authentifié.";
        isLoading = false;
      });
      return;
    }

    final api = ApiService();
    
    try {
      // Récupérer les badges
      final badgesResult = await api.getBadges(token);
      
      // Vérifier si l'utilisateur est admin en essayant de récupérer tous les donneurs
      final donneursResult = await api.getDonneurs(token);
      
      setState(() {
        badges = badgesResult ?? [];
        donneurs = donneursResult ?? [];
        isAdmin = donneursResult != null && donneursResult.isNotEmpty;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Erreur lors du chargement des données: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _genererBadge(int donneurId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    
    if (token == null) return;

    setState(() {
      isLoading = true;
    });

    final api = ApiService();
    final success = await api.genererBadge(token, donneurId);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Badge généré avec succès!'),
          backgroundColor: appTheme.primaryPink,
        ),
      );
      _fetchData(); // Recharger les données
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la génération du badge'),
          backgroundColor: appTheme.primaryRed,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.lightPink,
      appBar: AppBar(
        backgroundColor: appTheme.darkRed,
        title: Text(
          'Gestion des Badges',
          style: TextStyleHelper.instance.title20SemiBold.copyWith(
            color: appTheme.whiteCustom,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appTheme.whiteCustom),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: appTheme.whiteCustom),
            onPressed: _fetchData,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: appTheme.primaryRed,
                      ),
                      SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: TextStyleHelper.instance.body14Regular,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchData,
                        child: Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section génération de badges (pour les admins)
                      if (isAdmin) ...[
                        Text(
                          'Génération de Badges',
                          style: TextStyleHelper.instance.title18SemiBold,
                        ),
                        SizedBox(height: 12.h),
                        BadgeGenerationWidget(
                          donneurs: donneurs ?? [],
                          onGenerateBadge: _genererBadge,
                        ),
                        SizedBox(height: 24.h),
                      ],

                      // Section badges existants
                      Text(
                        isAdmin ? 'Badges Existants' : 'Mon Badge',
                        style: TextStyleHelper.instance.title18SemiBold,
                      ),
                      SizedBox(height: 12.h),
                      
                      if (badges!.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24.h),
                          decoration: BoxDecoration(
                            color: appTheme.whiteCustom,
                            borderRadius: BorderRadius.circular(12.h),
                            boxShadow: [
                              BoxShadow(
                                color: appTheme.blackCustom.withAlpha(26),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.card_membership_outlined,
                                size: 48,
                                color: appTheme.colorFF5050,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                isAdmin 
                                  ? 'Aucun badge généré'
                                  : 'Aucun badge disponible',
                                style: TextStyleHelper.instance.body16Regular,
                                textAlign: TextAlign.center,
                              ),
                              if (!isAdmin) ...[
                                SizedBox(height: 8.h),
                                Text(
                                  'Contactez un administrateur pour générer votre badge',
                                  style: TextStyleHelper.instance.body12Regular.copyWith(
                                    color: appTheme.colorFF5050,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: badges!.length,
                          itemBuilder: (context, index) {
                            final badge = badges![index];
                            return BadgeCardWidget(
                              badge: badge,
                              isAdmin: isAdmin,
                              onDownload: () => _downloadBadge(badge),
                              onShare: () => _shareBadge(badge),
                            );
                          },
                        ),
                    ],
                  ),
                ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRoutes.bloodDonationMenuScreen,
      ),
    );
  }

  void _downloadBadge(Map<String, dynamic> badge) {
    // Simuler le téléchargement du badge
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Badge téléchargé avec succès!'),
        backgroundColor: appTheme.primaryPink,
      ),
    );
  }

  void _shareBadge(Map<String, dynamic> badge) {
    // Simuler le partage du badge
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Badge partagé avec succès!'),
        backgroundColor: appTheme.primaryPink,
      ),
    );
  }
}
