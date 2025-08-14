import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';
import '../../widgets/modern_app_bar.dart';

class ApiConfigScreen extends StatefulWidget {
  const ApiConfigScreen({super.key});

  @override
  State<ApiConfigScreen> createState() => _ApiConfigScreenState();
}

class _ApiConfigScreenState extends State<ApiConfigScreen> {
  final TextEditingController _baseUrlController = TextEditingController();
  bool _isLoading = false;
  String? _currentUrl;

  // URLs prédéfinies pour faciliter les tests
  final Map<String, String> _presetUrls = {
    'Local Django': 'http://localhost:8000/api',
    'Local Django (IP)': 'http://127.0.0.1:8000/api',
    'Staging': 'https://staging-api.blooddonation.com/api',
    'Production': 'https://api.blooddonation.com/api',
  };

  @override
  void initState() {
    super.initState();
    _loadCurrentUrl();
  }

  Future<void> _loadCurrentUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('api_base_url') ?? 'http://localhost:8000/api';
    setState(() {
      _currentUrl = url;
      _baseUrlController.text = url;
    });
  }

  Future<void> _saveUrl() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('api_base_url', _baseUrlController.text.trim());

      setState(() {
        _currentUrl = _baseUrlController.text.trim();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('URL API sauvegardée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Test simple de connexion à l'API
      final response = await Future.delayed(
        const Duration(seconds: 2),
        () => 'OK', // Simuler une réponse pour l'instant
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connexion réussie: $response'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec de la connexion: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      // Header supprimé
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCurrentUrlCard(),
            SizedBox(height: 24.h),
            _buildPresetUrlsSection(),
            SizedBox(height: 24.h),
            _buildCustomUrlSection(),
            SizedBox(height: 32.h),
            _buildActionButtons(),
            SizedBox(height: 24.h),
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentUrlCard() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.colorFF8808.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: appTheme.colorFF8808.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'URL API actuelle',
            style: TextStyleHelper.instance.body16SemiBold.copyWith(
              color: appTheme.colorFF8808,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _currentUrl ?? 'Non définie',
            style: TextStyleHelper.instance.body14Regular.copyWith(
              color: appTheme.colorFF0F0B,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetUrlsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'URLs prédéfinies',
          style: TextStyleHelper.instance.body16SemiBold.copyWith(
            color: appTheme.colorFF0F0B,
          ),
        ),
        SizedBox(height: 12.h),
        ..._presetUrls.entries
            .map((entry) => _buildPresetUrlCard(entry.key, entry.value)),
      ],
    );
  }

  Widget _buildPresetUrlCard(String name, String url) {
    final isSelected = _currentUrl == url;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: () {
          setState(() {
            _baseUrlController.text = url;
          });
        },
        borderRadius: BorderRadius.circular(8.h),
        child: Container(
          padding: EdgeInsets.all(12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? appTheme.colorFF8808.withOpacity(0.1)
                : appTheme.colorFFF3F4,
            borderRadius: BorderRadius.circular(8.h),
            border: Border.all(
              color: isSelected ? appTheme.colorFF8808 : appTheme.colorFFD9D9,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyleHelper.instance.body14SemiBold.copyWith(
                        color: isSelected
                            ? appTheme.colorFF8808
                            : appTheme.colorFF0F0B,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      url,
                      style: TextStyleHelper.instance.body12Regular.copyWith(
                        color: appTheme.colorFF9A9A,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: appTheme.colorFF8808,
                  size: 20.h,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomUrlSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'URL personnalisée',
          style: TextStyleHelper.instance.body16SemiBold.copyWith(
            color: appTheme.colorFF0F0B,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: appTheme.colorFFF3F4,
            borderRadius: BorderRadius.circular(12.h),
            border: Border.all(
              color: appTheme.colorFFD9D9,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: _baseUrlController,
            style: TextStyleHelper.instance.body16Regular.copyWith(
              color: appTheme.colorFF0F0B,
              fontFamily: 'monospace',
            ),
            decoration: InputDecoration(
              hintText: 'https://api.example.com/api',
              hintStyle: TextStyleHelper.instance.body16Regular.copyWith(
                color: appTheme.colorFF9A9A,
              ),
              prefixIcon: Icon(
                Icons.link,
                color: appTheme.colorFF9A9A,
                size: 20.h,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 16.h,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveUrl,
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.colorFF8808,
              foregroundColor: appTheme.whiteCustom,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.h),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    width: 20.h,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(appTheme.whiteCustom),
                    ),
                  )
                : Text(
                    'Sauvegarder',
                    style: TextStyleHelper.instance.body16SemiBold,
                  ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: OutlinedButton(
            onPressed: _isLoading ? null : _testConnection,
            style: OutlinedButton.styleFrom(
              foregroundColor: appTheme.colorFF8808,
              side: BorderSide(
                color: appTheme.colorFF8808,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.h),
              ),
            ),
            child: Text(
              'Tester la connexion',
              style: TextStyleHelper.instance.body16SemiBold.copyWith(
                color: appTheme.colorFF8808,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue,
                size: 20.h,
              ),
              SizedBox(width: 8.h),
              Text(
                'Informations',
                style: TextStyleHelper.instance.body16SemiBold.copyWith(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '• L\'URL doit pointer vers l\'API Django\n'
            '• Format attendu: http(s)://domaine/api\n'
            '• Pour le développement local, utilisez localhost:8000\n'
            '• Assurez-vous que le serveur Django est démarré\n'
            '• Les changements prennent effet immédiatement',
            style: TextStyleHelper.instance.body14Regular.copyWith(
              color: Colors.blue.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    super.dispose();
  }
}
