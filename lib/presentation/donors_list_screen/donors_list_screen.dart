import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../core/app_export.dart';

class DonorsListScreen extends StatefulWidget {
  const DonorsListScreen({Key? key}) : super(key: key);

  @override
  State<DonorsListScreen> createState() => _DonorsListScreenState();
}

class _DonorsListScreenState extends State<DonorsListScreen> {
  List<dynamic>? donors;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDonors();
  }

  Future<void> _fetchDonors() async {
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
    final result = await api.getDonneurs(token);
    setState(() {
      donors = result;
      isLoading = false;
      if (donors == null) {
        errorMessage = "Erreur lors du chargement des donneurs.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des donneurs'),
        backgroundColor: appTheme.colorFFF2AB,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : ListView.builder(
                  itemCount: donors?.length ?? 0,
                  itemBuilder: (context, index) {
                    final donor = donors![index];
                    return ListTile(
                      title: Text('${donor['nom']} ${donor['prenoms']}'),
                      subtitle: Text(donor['email'] ?? ''),
                    );
                  },
                ),
    );
  }
}
