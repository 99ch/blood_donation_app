import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/modern_app_bar.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import 'widgets/test_filter_widget.dart';
import 'widgets/test_result_card_widget.dart';

class TestResultsHistoryPage extends StatefulWidget {
  const TestResultsHistoryPage({super.key});

  @override
  State<TestResultsHistoryPage> createState() => _TestResultsHistoryPageState();
}

class _TestResultsHistoryPageState extends State<TestResultsHistoryPage> {
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'All';

  List<dynamic>? testResults;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTestResults();
  }

  Future<void> _fetchTestResults() async {
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
      final results = await api.getResultatsAnalyse(token);

      setState(() {
        testResults = results
                ?.map((result) => _convertApiResultToDisplayFormat(result))
                .toList() ??
            [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur lors du chargement: $e';
        testResults = [];
        isLoading = false;
      });
    }
  }

  Map<String, dynamic> _convertApiResultToDisplayFormat(dynamic apiResult) {
    // Convertir le format de l'API backend vers le format attendu par l'UI
    return {
      'date': apiResult['date_ajout']?.substring(0, 10) ?? '2025-01-01',
      'bloodType':
          'O+', // Non disponible dans l'API, utiliser une valeur par défaut
      'hemoglobin':
          14.5, // Non disponible dans l'API, utiliser une valeur par défaut
      'status': 'Healthy',
      'statusColor': Colors.green,
      'nextDonationDate': _calculateNextDonationDate(apiResult['date_ajout']),
      'labValues': {
        'File': apiResult['fichier_pdf'] ?? 'Aucun fichier',
        'Donneur ID': apiResult['donneur']?.toString() ?? 'N/A',
        'Date Ajout': apiResult['date_ajout'] ?? 'N/A',
      },
      'recommendations': [
        'Résultat d\'analyse disponible',
        'Contactez votre médecin pour l\'interprétation',
        'Gardez ce document pour vos dossiers médicaux'
      ],
      'apiData': apiResult, // Garder les données originales
    };
  }

  String _calculateNextDonationDate(String? dateAjout) {
    if (dateAjout == null) return '2025-09-01';

    try {
      final date = DateTime.parse(dateAjout);
      final nextDate = date.add(const Duration(days: 90)); // 3 mois après
      return '${nextDate.year}-${nextDate.month.toString().padLeft(2, '0')}-${nextDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return '2025-09-01';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      // Header supprimé
      body: isLoading
          ? _buildLoadingState()
          : errorMessage != null
              ? _buildErrorState()
              : _buildContent(),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRoutes.testResultsHistoryPage,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(appTheme.colorFF8808),
          ),
          SizedBox(height: 16.h),
          Text(
            'Chargement des résultats...',
            style: TextStyleHelper.instance.body16Regular,
          ),
        ],
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
            onPressed: _fetchTestResults,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (testResults == null || testResults!.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Column(
        children: [
          // Breadcrumb navigation
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Row(
              children: [
                Text(
                  'Accueil',
                  style: TextStyleHelper.instance.body14Regular.copyWith(
                    color: appTheme.colorFF8808,
                  ),
                ),
                Icon(Icons.chevron_right, color: appTheme.colorFF9A9A),
                Text(
                  'Résultats d\'Analyses',
                  style: TextStyleHelper.instance.body14SemiBold,
                ),
              ],
            ),
          ),
          // Filter chips
          TestFilterWidget(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
          // Test results list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.h),
              itemCount: testResults!.length,
              itemBuilder: (context, index) {
                final testResult = testResults![index];
                return TestResultCardWidget(
                  testResult: testResult,
                  onTap: () => _showTestResultDetails(testResult),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80.h,
            color: appTheme.colorFF9A9A,
          ),
          SizedBox(height: 24.h),
          Text(
            'Aucun résultat d\'analyse',
            style: TextStyleHelper.instance.headline16Bold.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Vous n\'avez pas encore de résultats d\'analyses.\nVos résultats apparaîtront ici après vos dons.',
            style: TextStyleHelper.instance.body16Regular.copyWith(
              color: appTheme.colorFF7373,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          Container(
            padding: EdgeInsets.all(20.h),
            margin: EdgeInsets.symmetric(horizontal: 32.h),
            decoration: BoxDecoration(
              color: appTheme.colorFFF2AB.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12.h),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: appTheme.colorFF8808,
                  size: 32.h,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Les résultats incluront :',
                  style: TextStyleHelper.instance.body14SemiBold.copyWith(
                    color: appTheme.blackCustom,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '• Analyses sanguines\n• Rapports médicaux\n• Recommandations\n• Historique complet',
                  style: TextStyleHelper.instance.body14Regular.copyWith(
                    color: appTheme.colorFF7373,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Recharger les données depuis l'API
    await _fetchTestResults();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.h))),
        builder: (context) {
          return Container(
              padding: EdgeInsets.all(16.h),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Filter by Date Range',
                    style: TextStyle(
                        fontSize: 18.fSize, fontWeight: FontWeight.w600)),
                SizedBox(height: 16.h),
                ListTile(
                    title: const Text('Last 3 Months'),
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'Last 3 Months';
                      });
                      Navigator.pop(context);
                    }),
                ListTile(
                    title: const Text('Last 6 Months'),
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'Last 6 Months';
                      });
                      Navigator.pop(context);
                    }),
                ListTile(
                    title: const Text('Last Year'),
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'Last Year';
                      });
                      Navigator.pop(context);
                    }),
              ]));
        });
  }

  void _showTestResultDetails(Map<String, dynamic> testResult) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.h)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Container(
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
                  Text(
                    'Résultat d\'Analyse - ${testResult['date']}',
                    style: TextStyleHelper.instance.title20SemiBold,
                  ),
                  SizedBox(height: 12.h),
                  // Lab values section
                  _buildDetailSection(
                      'Valeurs Laboratoire', testResult['labValues']),
                  SizedBox(height: 12.h),
                  // Recommendations section
                  _buildRecommendationsSection(testResult['recommendations']),
                  if (testResult['nextDonationDate'] != null) ...[
                    SizedBox(height: 12.h),
                    // Next donation date
                    _buildNextDonationSection(testResult['nextDonationDate']),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailSection(String title, Map<String, dynamic> values) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyleHelper.instance.headline16Bold,
        ),
        SizedBox(height: 10.h),
        ...values.entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: TextStyleHelper.instance.body14Regular,
                ),
                Text(
                  entry.value.toString(),
                  style: TextStyleHelper.instance.body14SemiBold,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecommendationsSection(List<dynamic> recommendations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommandations Médicales',
          style: TextStyleHelper.instance.headline16Bold,
        ),
        SizedBox(height: 10.h),
        ...recommendations.map((recommendation) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  color: appTheme.colorFF8808,
                  size: 20.h,
                ),
                SizedBox(width: 8.h),
                Expanded(
                  child: Text(
                    recommendation,
                    style: TextStyleHelper.instance.body14Regular,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNextDonationSection(String nextDate) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.colorFF8808.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: appTheme.colorFF8808,
            size: 24.h,
          ),
          SizedBox(width: 12.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prochain Don Éligible',
                style: TextStyleHelper.instance.body14SemiBold,
              ),
              Text(
                nextDate,
                style: TextStyleHelper.instance.headline16Bold.copyWith(
                  color: appTheme.colorFF8808,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
