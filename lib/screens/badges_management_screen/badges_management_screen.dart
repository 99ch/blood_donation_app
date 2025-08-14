import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/modern_app_bar.dart';
import 'widgets/badge_card_widget.dart';
import 'widgets/badge_generation_widget.dart';

class BadgesManagementScreen extends StatefulWidget {
  const BadgesManagementScreen({super.key});

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

    try {
      final token = await AuthService.getValidAccessToken();
      if (token == null) {
        throw Exception('Utilisateur non authentifié');
      }

      final api = ApiService();

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
    try {
      final token = await AuthService.getValidAccessToken();
      if (token == null) {
        throw Exception('Utilisateur non authentifié');
      }

      setState(() {
        isLoading = true;
      });

      final api = ApiService();
      final success = await api.genererBadge(token, donneurId);

      if (success != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Badge généré avec succès!'),
            backgroundColor: appTheme.colorFF8808,
          ),
        );
        _fetchData(); // Recharger les données
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erreur lors de la génération du badge'),
            backgroundColor: appTheme.colorFF4444,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: appTheme.colorFF4444,
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
      backgroundColor: appTheme.whiteCustom,
      // Header supprimé
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: appTheme.colorFF4444,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        style: TextStyleHelper.instance.body14Regular,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchData,
                        child: const Text('Réessayer'),
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
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.card_membership_outlined,
                                size: 48,
                                color: appTheme.colorFF9A9A,
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
                                  style: TextStyleHelper.instance.body12Regular
                                      .copyWith(
                                    color: appTheme.colorFF7373,
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
                          physics: const NeverScrollableScrollPhysics(),
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
        content: const Text('Badge téléchargé avec succès!'),
        backgroundColor: appTheme.colorFF8808,
      ),
    );
  }

  void _shareBadge(Map<String, dynamic> badge) {
    // Simuler le partage du badge
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Badge partagé avec succès!'),
        backgroundColor: appTheme.colorFF8808,
      ),
    );
  }
}
