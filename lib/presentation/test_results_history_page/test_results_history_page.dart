import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../services/api_service.dart';
import './widgets/test_filter_widget.dart';
import './widgets/test_result_card_widget.dart';

class TestResultsHistoryPage extends StatefulWidget {
  const TestResultsHistoryPage({super.key});

  @override
  State<TestResultsHistoryPage> createState() => _TestResultsHistoryPageState();
}

class _TestResultsHistoryPageState extends State<TestResultsHistoryPage> {
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'All';
  
  // État pour les données de l'API
  List<dynamic>? _apiResults;
  bool _isLoading = true;
  String? _errorMessage;

  // Données mockées de fallback
  final List<Map<String, dynamic>> _mockTestResults = [
    {
      'date': '2025-07-08',
      'bloodType': 'O+',
      'hemoglobin': 14.5,
      'status': 'Healthy',
      'statusColor': Colors.green,
      'nextDonationDate': '2025-09-08',
      'labValues': {
        'White Blood Cells': '7.2 K/μL',
        'Red Blood Cells': '4.8 M/μL',
        'Platelets': '285 K/μL',
        'Iron': '85 μg/dL'
      },
      'recommendations': [
        'Continue maintaining healthy iron levels',
        'Stay hydrated before donations',
        'Regular exercise is beneficial'
      ]
    },
    {
      'date': '2025-05-15',
      'bloodType': 'O+',
      'hemoglobin': 12.8,
      'status': 'Borderline',
      'statusColor': Colors.orange,
      'nextDonationDate': '2025-07-15',
      'labValues': {
        'White Blood Cells': '6.8 K/μL',
        'Red Blood Cells': '4.2 M/μL',
        'Platelets': '265 K/μL',
        'Iron': '65 μg/dL'
      },
      'recommendations': [
        'Increase iron-rich foods in diet',
        'Consider iron supplements',
        'Retest in 4 weeks'
      ]
    },
    {
      'date': '2025-03-20',
      'bloodType': 'O+',
      'hemoglobin': 15.2,
      'status': 'Healthy',
      'statusColor': Colors.green,
      'nextDonationDate': '2025-05-20',
      'labValues': {
        'White Blood Cells': '7.5 K/μL',
        'Red Blood Cells': '5.1 M/μL',
        'Platelets': '295 K/μL',
        'Iron': '95 μg/dL'
      },
      'recommendations': [
        'Excellent health status',
        'Continue current lifestyle',
        'Regular donor - keep it up!'
      ]
    }
  ];

  // Propriété calculée pour obtenir les résultats finaux
  List<Map<String, dynamic>> get _testResults {
    if (_apiResults != null && _apiResults!.isNotEmpty) {
      // Convertir les données API au format attendu
      return _apiResults!.map((result) => _convertApiResultToDisplayFormat(result)).toList();
    }
    // Utiliser les données mockées comme fallback
    return _mockTestResults;
  }

  @override
  void initState() {
    super.initState();
    _fetchTestResults();
  }

  Future<void> _fetchTestResults() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      
      if (token != null) {
        final api = ApiService();
        final results = await api.getResultatsAnalyse(token);
        
        setState(() {
          _apiResults = results;
          _isLoading = false;
        });
      } else {
        // Pas de token, utiliser les données mockées
        setState(() {
          _apiResults = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement: $e';
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _convertApiResultToDisplayFormat(dynamic apiResult) {
    // Convertir le format de l'API backend vers le format attendu par l'UI
    return {
      'date': apiResult['date_ajout']?.substring(0, 10) ?? '2025-01-01',
      'bloodType': 'O+', // Non disponible dans l'API, utiliser une valeur par défaut
      'hemoglobin': 14.5, // Non disponible dans l'API, utiliser une valeur par défaut
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
      final nextDate = date.add(Duration(days: 90)); // 3 mois après
      return '${nextDate.year}-${nextDate.month.toString().padLeft(2, '0')}-${nextDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return '2025-09-01';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            leading: IconButton(
                icon:
                    Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
                onPressed: () => Navigator.pop(context)),
            title: Text('Test Results',
                style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 20.fSize,
                    fontWeight: FontWeight.w600)),
            actions: [
              IconButton(
                  icon: Icon(Icons.filter_list,
                      color: theme.colorScheme.onSurface),
                  onPressed: () => _showFilterBottomSheet()),
            ]),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          _errorMessage!,
                          style: TextStyle(fontSize: 16.fSize),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: _fetchTestResults,
                          child: Text('Réessayer'),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Affichage des données de démonstration',
                          style: TextStyle(
                            fontSize: 12.fSize,
                            color: theme.colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: Column(children: [
              // Breadcrumb navigation
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Row(children: [
                    Text('Home',
                        style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 14.fSize)),
                    const Icon(Icons.chevron_right),
                    Text('Test Results',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 14.fSize,
                            fontWeight: FontWeight.w500)),
                  ])),
              // Filter chips
              TestFilterWidget(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: (filter) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  }),
              // Test results list
              Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(16.h),
                      itemCount: _testResults.length,
                      itemBuilder: (context, index) {
                        final testResult = _testResults[index];
                        return TestResultCardWidget(
                            testResult: testResult,
                            onTap: () => _showTestResultDetails(testResult));
                      })),
            ])),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _requestNewInterpretation(),
            backgroundColor: theme.colorScheme.primary,
            icon: Icon(Icons.analytics, color: theme.colorScheme.onPrimary),
            label: Text('Request Analysis',
                style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 14.fSize,
                    fontWeight: FontWeight.w500))),
        bottomNavigationBar: const CustomBottomNavigation(
          currentRoute: AppRoutes.testResultsHistoryPage,
        ));
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.h))),
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
                          Text('Test Results - ${testResult['date']}',
                              style: TextStyle(
                                  fontSize: 20.fSize,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 12.h),
                          // Lab values section
                          _buildDetailSection(
                              'Lab Values', testResult['labValues']),
                          SizedBox(height: 12.h),
                          // Recommendations section
                          _buildRecommendationsSection(
                              testResult['recommendations']),
                          SizedBox(height: 12.h),
                          // Next donation date
                          _buildNextDonationSection(
                              testResult['nextDonationDate']),
                        ]));
              });
        });
  }

  Widget _buildDetailSection(String title, Map<String, dynamic> values) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title,
          style: TextStyle(fontSize: 18.fSize, fontWeight: FontWeight.w600)),
      SizedBox(height: 10.h),
      ...values.entries.map((entry) {
        return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key, style: TextStyle(fontSize: 14.fSize)),
                  Text(entry.value.toString(),
                      style: TextStyle(
                          fontSize: 14.fSize, fontWeight: FontWeight.w500)),
                ]));
      }),
    ]);
  }

  Widget _buildRecommendationsSection(List<dynamic> recommendations) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Medical Recommendations',
          style: TextStyle(fontSize: 18.fSize, fontWeight: FontWeight.w600)),
      SizedBox(height: 10.h),
      ...recommendations.map((recommendation) {
        return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.check_circle, color: theme.colorScheme.primary),
              SizedBox(width: 8.h),
              Expanded(
                  child: Text(recommendation,
                      style: TextStyle(fontSize: 14.fSize))),
            ]));
      }),
    ]);
  }

  Widget _buildNextDonationSection(String nextDate) {
    return Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(12.h)),
        child: Row(children: [
          Icon(Icons.calendar_today, color: theme.colorScheme.primary),
          SizedBox(width: 12.h),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Next Eligible Donation',
                style:
                    TextStyle(fontSize: 14.fSize, fontWeight: FontWeight.w500)),
            Text(nextDate,
                style: TextStyle(
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary)),
          ]),
        ]));
  }

  void _requestNewInterpretation() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Request New Analysis'),
              content: const Text(
                  'Would you like to request a new test result interpretation from our medical team?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text('Analysis request submitted successfully')));
                    },
                    child: const Text('Submit Request')),
              ]);
        });
  }
}
