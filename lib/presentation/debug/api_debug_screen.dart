import 'package:flutter/material.dart';
import '../../services/api_test_service.dart';
import '../../services/api_service.dart';

/// Widget de test pour diagnostiquer les problèmes API
class ApiDebugScreen extends StatefulWidget {
  const ApiDebugScreen({Key? key}) : super(key: key);

  @override
  State<ApiDebugScreen> createState() => _ApiDebugScreenState();
}

class _ApiDebugScreenState extends State<ApiDebugScreen> {
  Map<String, bool>? testResults;
  bool isRunning = false;
  String? lastError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🔧 Diagnostic API'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🌐 Configuration Actuelle',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Backend URL: ${ApiService.baseUrl}'),
                    Text('App Web URL: ${Uri.base}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isRunning ? null : _runTests,
              child: isRunning
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Tests en cours...'),
                      ],
                    )
                  : Text('🧪 Lancer les tests de connectivité'),
            ),
            SizedBox(height: 16),
            if (testResults != null) _buildResults(),
            if (lastError != null) _buildError(),
            SizedBox(height: 16),
            _buildManualTest(),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📋 Résultats des Tests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...testResults!.entries.map((entry) {
              final icon = entry.value ? '✅' : '❌';
              final color = entry.value ? Colors.green : Colors.red;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(icon),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: TextStyle(color: color),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '❌ Dernière Erreur',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              lastError!,
              style: TextStyle(color: Colors.red[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualTest() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔧 Test Manuel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _testManualLogin,
              child: Text('Test de connexion manuel'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runTests() async {
    setState(() {
      isRunning = true;
      lastError = null;
    });

    try {
      final results = await ApiTestService.runAllTests();
      setState(() {
        testResults = results;
        isRunning = false;
      });
    } catch (e) {
      setState(() {
        lastError = e.toString();
        isRunning = false;
      });
    }
  }

  Future<void> _testManualLogin() async {
    try {
      setState(() => lastError = null);

      final apiService = ApiService();
      final token = await apiService.login('test@example.com', 'password123');

      if (token != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Connexion réussie! Token reçu.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '❌ Connexion échouée (credentials invalides mais API accessible)'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      setState(() => lastError = 'Erreur lors du test manuel: $e');
    }
  }
}
