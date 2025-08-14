import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_navigation.dart';

/// Écran principal du menu de don de sang
///
/// Cet écran sert de tableau de bord principal pour les utilisateurs connectés.
/// Il affiche les options principales pour la gestion du don de sang.
class BloodDonationMenuScreen extends StatefulWidget {
  const BloodDonationMenuScreen({super.key});

  @override
  State<BloodDonationMenuScreen> createState() =>
      _BloodDonationMenuScreenState();
}

class _BloodDonationMenuScreenState extends State<BloodDonationMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      // Header supprimé
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.h, 48.h, 24.h, 24.h),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              SizedBox(height: 32.h),
              _buildQuickActions(),
              SizedBox(height: 32.h),
              _buildUpcomingAppointments(),
              SizedBox(height: 32.h),
              _buildStatistics(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRoutes.bloodDonationMenuScreen,
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appTheme.colorFF8808.withOpacity(0.1),
            appTheme.colorFF8808.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenue !',
            style: TextStyleHelper.instance.title20SemiBold.copyWith(
              color: appTheme.colorFF8808,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Prêt à sauver des vies ?',
            style: TextStyleHelper.instance.body16Regular.copyWith(
              color: appTheme.blackCustom.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions rapides',
          style: TextStyleHelper.instance.title18SemiBold.copyWith(
            color: appTheme.blackCustom,
          ),
        ),
        SizedBox(height: 16.h),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 16.h,
          mainAxisSpacing: 16.h,
          children: [
            _buildActionCard(
              'Campagnes',
              Icons.event,
              AppRoutes.donationCampaignListScreen,
            ),
            _buildActionCard(
              'Mon Volume',
              Icons.water_drop,
              AppRoutes.bloodVolumeVisualizationScreen,
            ),
            _buildActionCard(
              'Carte Donneur',
              Icons.credit_card,
              AppRoutes.digitalDonorCard,
            ),
            _buildActionCard(
              'Centres',
              Icons.location_on,
              AppRoutes.bloodCollectionCentersLocator,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: appTheme.whiteCustom,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.blackCustom.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32.h,
              color: appTheme.colorFF8808,
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyleHelper.instance.body14SemiBold.copyWith(
                color: appTheme.blackCustom,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointments() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: appTheme.colorFF8808.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prochains rendez-vous',
            style: TextStyleHelper.instance.title18SemiBold.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Aucun rendez-vous prévu',
            style: TextStyleHelper.instance.body14Regular.copyWith(
              color: appTheme.blackCustom.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 8.h),
          TextButton(
            onPressed: () => Navigator.pushNamed(
                context, AppRoutes.donationCampaignListScreen),
            child: Text(
              'Voir les campagnes disponibles',
              style: TextStyleHelper.instance.body14SemiBold.copyWith(
                color: appTheme.colorFF8808,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: appTheme.colorFF8808.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mes statistiques',
            style: TextStyleHelper.instance.title18SemiBold.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Dons', '0'),
              ),
              Expanded(
                child: _buildStatItem('Litres', '0.0'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyleHelper.instance.title20SemiBold.copyWith(
              color: appTheme.colorFF8808,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyleHelper.instance.body12Regular.copyWith(
              color: appTheme.blackCustom.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
