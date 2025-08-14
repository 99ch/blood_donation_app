import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/modern_app_bar.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Map<String, dynamic>> appointments = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await AuthService.getValidAccessToken();
      if (token == null) {
        throw Exception('Utilisateur non authentifié');
      }

      // TODO: Implémenter getAppointments dans ApiService
      // Pour l'instant, on simule des données vides en attendant l'implémentation backend
      setState(() {
        appointments = [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      // Header supprimé
      body: SafeArea(
        child: isLoading
            ? _buildLoadingState()
            : errorMessage != null
                ? _buildErrorState()
                : _buildContent(),
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRoutes.appointmentsScreen,
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
            'Chargement des rendez-vous...',
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
            onPressed: _loadAppointments,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (appointments.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _buildAppointmentCard(context, appointment);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80.h,
            color: appTheme.colorFF9A9A,
          ),
          SizedBox(height: 24.h),
          Text(
            'Aucun rendez-vous',
            style: TextStyleHelper.instance.headline16Bold.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Vous n\'avez pas encore de rendez-vous planifiés.\nL\'administrateur vous assignera des rendez-vous ici.',
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
                  'Types de rendez-vous :',
                  style: TextStyleHelper.instance.body14SemiBold.copyWith(
                    color: appTheme.blackCustom,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '• Don de sang\n• Consultation pré-don\n• Bilan sanguin\n• Suivi médical',
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

  Widget _buildAppointmentCard(
      BuildContext context, Map<String, dynamic> appointment) {
    Color getStatusColor(String status) {
      switch (status) {
        case 'confirmed':
        case 'Confirmé':
          return Colors.green;
        case 'pending':
        case 'En attente':
          return Colors.orange;
        case 'completed':
        case 'Terminé':
          return Colors.blue;
        case 'cancelled':
        case 'Annulé':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    final isUpcoming = appointment['status'] == 'confirmed' ||
        appointment['status'] == 'pending';
    final date = appointment['date'] ?? '';
    final time = appointment['time'] ?? '';
    final location = appointment['location'] ?? '';
    final status = appointment['status'] ?? '';
    final type = appointment['type'] ?? '';
    final doctor = appointment['doctor'] ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: isUpcoming
                ? appTheme.colorFF8808.withOpacity(0.1)
                : appTheme.blackCustom.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
        border: isUpcoming
            ? Border.all(
                color: appTheme.colorFF8808.withOpacity(0.2), width: 1.h)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
                decoration: BoxDecoration(
                  color: getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.h),
                ),
                child: Text(
                  status,
                  style: TextStyleHelper.instance.body12Regular.copyWith(
                    color: getStatusColor(status),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.fSize,
                  ),
                ),
              ),
              if (isUpcoming)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: appTheme.colorFF9A9A,
                    size: 20.h,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'modify':
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Modifier le rendez-vous')),
                        );
                        break;
                      case 'cancel':
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Annuler le rendez-vous')),
                        );
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'modify',
                      child: Text('Modifier'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'cancel',
                      child: Text('Annuler'),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                width: 50.h,
                height: 50.h,
                decoration: BoxDecoration(
                  color: appTheme.colorFF8808.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.h),
                ),
                child: Icon(
                  Icons.medical_services,
                  color: appTheme.colorFF8808,
                  size: 28.h,
                ),
              ),
              SizedBox(width: 16.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: TextStyleHelper.instance.body16SemiBold.copyWith(
                        color: appTheme.colorFF0F0B,
                        fontSize: 16.fSize,
                      ),
                    ),
                    if (doctor.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        doctor,
                        style: TextStyleHelper.instance.body14Regular.copyWith(
                          color: appTheme.colorFF7373,
                          fontSize: 14.fSize,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (date.isNotEmpty) _buildInfoRow(Icons.calendar_today, date),
          if (date.isNotEmpty && time.isNotEmpty) SizedBox(height: 8.h),
          if (time.isNotEmpty) _buildInfoRow(Icons.access_time, time),
          if (time.isNotEmpty && location.isNotEmpty) SizedBox(height: 8.h),
          if (location.isNotEmpty) _buildInfoRow(Icons.location_on, location),
          if (isUpcoming) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rappel programmé')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: appTheme.colorFF8808,
                      side: BorderSide(color: appTheme.colorFF8808),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                    ),
                    child: const Text('Rappel'),
                  ),
                ),
                SizedBox(width: 12.h),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Détails du rendez-vous')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.colorFF8808,
                      foregroundColor: appTheme.whiteCustom,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                    ),
                    child: const Text('Détails'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.h,
          color: appTheme.colorFF9A9A,
        ),
        SizedBox(width: 8.h),
        Expanded(
          child: Text(
            text,
            style: TextStyleHelper.instance.body14Regular.copyWith(
              color: appTheme.colorFF7373,
              fontSize: 14.fSize,
            ),
          ),
        ),
      ],
    );
  }
}
