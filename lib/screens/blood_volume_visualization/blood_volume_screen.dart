import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/app_export.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../widgets/modern_app_bar.dart';

class BloodVolumeVisualizationScreen extends StatefulWidget {
  const BloodVolumeVisualizationScreen({super.key});

  @override
  State<BloodVolumeVisualizationScreen> createState() =>
      _BloodVolumeVisualizationScreenState();
}

class _BloodVolumeVisualizationScreenState
    extends State<BloodVolumeVisualizationScreen>
    with TickerProviderStateMixin {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _donneurData;

  late AnimationController _animationController;
  late Animation<double> _fillAnimation;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadDonneurData();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadDonneurData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await AuthService.getValidAccessToken();
      if (token == null) {
        throw Exception('Utilisateur non authentifié');
      }

      final currentUser = await _apiService.getCurrentUser(token);
      if (currentUser?['donneur'] != null) {
        setState(() {
          _donneurData = currentUser!['donneur'];
          _isLoading = false;
        });

        // Calculer le pourcentage de remplissage (max 5L pour l'animation)
        final litresDonnes = (_donneurData!['litres_donnes'] ?? 0.0) as num;
        final fillPercentage = (litresDonnes / 5.0).clamp(0.0, 1.0);

        _fillAnimation = Tween<double>(
          begin: 0.0,
          end: fillPercentage.toDouble(),
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));

        _animationController.forward();
      } else {
        throw Exception('Profil donneur introuvable');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      // Header supprimé
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null
              ? _buildErrorState()
              : _buildContent(),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRoutes.bloodVolumeVisualizationScreen,
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
            'Chargement de vos données...',
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
            _errorMessage!,
            style: TextStyleHelper.instance.body14Regular,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _loadDonneurData,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final litresDonnes = (_donneurData!['litres_donnes'] ?? 0.0) as num;
    final nbDons = (_donneurData!['nb_dons'] ?? 0) as int;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.h),
      child: Column(
        children: [
          _buildStatsHeader(litresDonnes.toDouble(), nbDons),
          SizedBox(height: 40.h),
          _buildBloodJarAnimation(litresDonnes.toDouble()),
          SizedBox(height: 40.h),
          _buildProgressInfo(litresDonnes.toDouble()),
          SizedBox(height: 30.h),
          _buildMilestones(litresDonnes.toDouble()),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(double litresDonnes, int nbDons) {
    return Container(
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [appTheme.colorFF8808, appTheme.colorFFF871],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard(
            icon: Icons.water_drop,
            value: '${litresDonnes.toStringAsFixed(1)}L',
            label: 'Litres donnés',
            color: Colors.red[300]!,
          ),
          _buildStatCard(
            icon: Icons.favorite,
            value: '$nbDons',
            label: 'Nombre de dons',
            color: Colors.blue[300]!,
          ),
          _buildStatCard(
            icon: Icons.people,
            value: '${(litresDonnes * 3).toInt()}',
            label: 'Vies sauvées*',
            color: Colors.green[300]!,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28.h),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyleHelper.instance.headline20Bold.copyWith(
            color: appTheme.whiteCustom,
          ),
        ),
        Text(
          label,
          style: TextStyleHelper.instance.body12Regular.copyWith(
            color: appTheme.whiteCustom.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBloodJarAnimation(double litresDonnes) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fillAnimation, _waveAnimation]),
      builder: (context, child) {
        return SizedBox(
          width: 200.h,
          height: 300.h,
          child: CustomPaint(
            painter: BloodJarPainter(
              fillPercentage: _fillAnimation.value,
              waveOffset: _waveAnimation.value,
              litresDonnes: litresDonnes,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressInfo(double litresDonnes) {
    final nextMilestone = _getNextMilestone(litresDonnes);
    final progress = litresDonnes / nextMilestone;

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.colorFFF2AB.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Column(
        children: [
          Text(
            'Prochain objectif: ${nextMilestone.toInt()}L',
            style: TextStyleHelper.instance.headline16Bold,
          ),
          SizedBox(height: 12.h),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(appTheme.colorFF8808),
          ),
          SizedBox(height: 8.h),
          Text(
            'Plus que ${(nextMilestone - litresDonnes).toStringAsFixed(1)}L à donner',
            style: TextStyleHelper.instance.body14Regular,
          ),
        ],
      ),
    );
  }

  Widget _buildMilestones(double litresDonnes) {
    final milestones = [1.0, 2.0, 5.0, 10.0, 15.0, 20.0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Objectifs de don',
          style: TextStyleHelper.instance.headline16Bold,
        ),
        SizedBox(height: 16.h),
        ...milestones.map((milestone) => _buildMilestoneItem(
              milestone: milestone,
              achieved: litresDonnes >= milestone,
              current: litresDonnes,
            )),
        SizedBox(height: 16.h),
        Text(
          '* Estimation basée sur le fait qu\'1L de sang peut sauver jusqu\'à 3 vies',
          style: TextStyleHelper.instance.body12Regular.copyWith(
            color: appTheme.colorFF9A9A,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneItem({
    required double milestone,
    required bool achieved,
    required double current,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: achieved ? Colors.green[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(
          color: achieved ? Colors.green[200]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            achieved ? Icons.check_circle : Icons.radio_button_unchecked,
            color: achieved ? Colors.green : Colors.grey,
            size: 24.h,
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Text(
              '${milestone.toInt()}L de sang donné',
              style: TextStyleHelper.instance.body16Regular.copyWith(
                color: achieved ? Colors.green[800] : Colors.grey[600],
                fontWeight: achieved ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          if (achieved)
            Text(
              '✓',
              style: TextStyleHelper.instance.headline16Bold.copyWith(
                color: Colors.green,
              ),
            ),
        ],
      ),
    );
  }

  double _getNextMilestone(double current) {
    final milestones = [1.0, 2.0, 5.0, 10.0, 15.0, 20.0, 30.0, 50.0];
    return milestones.firstWhere(
      (milestone) => milestone > current,
      orElse: () => current + 10.0,
    );
  }
}

class BloodJarPainter extends CustomPainter {
  final double fillPercentage;
  final double waveOffset;
  final double litresDonnes;

  BloodJarPainter({
    required this.fillPercentage,
    required this.waveOffset,
    required this.litresDonnes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dessiner le contour du bocal
    final jarPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.grey[400]!;

    final jarPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.1)
      ..lineTo(size.width * 0.8, size.height * 0.1)
      ..lineTo(size.width * 0.85, size.height * 0.9)
      ..lineTo(size.width * 0.15, size.height * 0.9)
      ..close();

    canvas.drawPath(jarPath, jarPaint);

    // Dessiner le sang avec effet de vague
    if (fillPercentage > 0) {
      final bloodPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.red[600]!;

      final fillHeight = size.height * 0.8 * fillPercentage;
      const waveHeight = 10.0;

      final bloodPath = Path();
      bloodPath.moveTo(size.width * 0.15, size.height * 0.9);

      for (double x = size.width * 0.15; x <= size.width * 0.85; x += 2) {
        final normalizedX = (x - size.width * 0.15) / (size.width * 0.7);
        final wave = waveHeight *
            math.sin((normalizedX * 4 * math.pi) + (waveOffset * 2 * math.pi));
        final y = size.height * 0.9 - fillHeight + wave;

        if (x == size.width * 0.15) {
          bloodPath.moveTo(x, y);
        } else {
          bloodPath.lineTo(x, y);
        }
      }

      bloodPath.lineTo(size.width * 0.85, size.height * 0.9);
      bloodPath.lineTo(size.width * 0.15, size.height * 0.9);
      bloodPath.close();

      canvas.drawPath(bloodPath, bloodPaint);
    }

    // Ajouter le texte du volume
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${litresDonnes.toStringAsFixed(1)}L',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.red[800],
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        size.height * 0.95,
      ),
    );
  }

  @override
  bool shouldRepaint(BloodJarPainter oldDelegate) {
    return fillPercentage != oldDelegate.fillPercentage ||
        waveOffset != oldDelegate.waveOffset ||
        litresDonnes != oldDelegate.litresDonnes;
  }
}
