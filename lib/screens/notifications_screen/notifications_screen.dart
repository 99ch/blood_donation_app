import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_bottom_navigation.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await AuthService.getValidAccessToken();
      if (token == null) {
        throw Exception('Utilisateur non authentifié');
      }

      // TODO: Implémenter getNotifications dans ApiService
      // Pour l'instant, on simule des données vides en attendant l'implémentation backend
      setState(() {
        notifications = [];
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
      body: isLoading
          ? _buildLoadingState()
          : errorMessage != null
              ? _buildErrorState()
              : _buildContent(),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRoutes.notificationsScreen,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(appTheme.colorFF8808),
            ),
            SizedBox(height: 16.h),
            Text(
              'Chargement des notifications...',
              style: TextStyleHelper.instance.body16Regular,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
              onPressed: _loadNotifications,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.h),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_none_outlined,
                size: 80.h,
                color: appTheme.colorFF9A9A,
              ),
              SizedBox(height: 24.h),
              Text(
                'Aucune notification',
                style: TextStyleHelper.instance.headline16Bold.copyWith(
                  color: appTheme.blackCustom,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Vous n\'avez pas encore reçu de notifications.\nL\'administrateur vous enverra des informations importantes ici.',
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: appTheme.colorFF8808,
                      size: 32.h,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Les notifications incluront :',
                      style: TextStyleHelper.instance.body14SemiBold.copyWith(
                        color: appTheme.blackCustom,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '• Résultats d\'analyses\n• Rappels de rendez-vous\n• Campagnes de don\n• Informations importantes',
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
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['read'] ?? false;
    final title = notification['title'] ?? 'Notification';
    final message = notification['message'] ?? '';
    final date = notification['created_at'] ?? '';
    final type = notification['type'] ?? 'info';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: isRead
            ? appTheme.whiteCustom
            : appTheme.colorFFF2AB.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: isRead
              ? appTheme.colorFF9A9A.withOpacity(0.3)
              : appTheme.colorFF8808.withOpacity(0.3),
          width: 1.h,
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withOpacity(0.05),
            offset: Offset(0, 2.h),
            blurRadius: 8.h,
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.h,
              height: 40.h,
              decoration: BoxDecoration(
                color: _getNotificationColor(type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.h),
              ),
              child: Icon(
                _getNotificationIcon(type),
                color: _getNotificationColor(type),
                size: 20.h,
              ),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: isRead
                              ? TextStyleHelper.instance.body16Regular
                              : TextStyleHelper.instance.body16SemiBold,
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8.h,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: appTheme.colorFF8808,
                            borderRadius: BorderRadius.circular(4.h),
                          ),
                        ),
                    ],
                  ),
                  if (message.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      message,
                      style: TextStyleHelper.instance.body14Regular.copyWith(
                        color: appTheme.colorFF7373,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (date.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      _formatNotificationDate(date),
                      style: TextStyleHelper.instance.body12Regular.copyWith(
                        color: appTheme.colorFF9A9A,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'analysis':
        return Icons.science;
      case 'appointment':
        return Icons.schedule;
      case 'campaign':
        return Icons.campaign;
      case 'urgent':
        return Icons.priority_high;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'analysis':
        return Colors.blue;
      case 'appointment':
        return appTheme.colorFF8808;
      case 'campaign':
        return Colors.green;
      case 'urgent':
        return Colors.red;
      default:
        return appTheme.colorFF8808;
    }
  }

  String _formatNotificationDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 60) {
        return 'Il y a ${difference.inMinutes} min';
      } else if (difference.inHours < 24) {
        return 'Il y a ${difference.inHours}h';
      } else if (difference.inDays < 7) {
        return 'Il y a ${difference.inDays}j';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }
}
