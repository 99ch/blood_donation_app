import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../core/navigation_helper.dart';

/// Middleware pour vérifier l'authentification sur les routes protégées
class AuthGuard extends StatefulWidget {
  final Widget child;
  final String routeName;

  const AuthGuard({
    super.key,
    required this.child,
    required this.routeName,
  });

  @override
  _AuthGuardState createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _isChecking = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    try {
      print('🔐 AuthGuard: Checking route ${widget.routeName}');

      // Vérifier si la route nécessite une authentification
      if (!NavigationHelper.isProtectedRoute(widget.routeName)) {
        print('✅ AuthGuard: Route publique, accès autorisé');
        setState(() {
          _isAuthenticated = true;
          _isChecking = false;
        });
        return;
      }

      print('🔒 AuthGuard: Route protégée, vérification authentification...');

      // Vérifier l'authentification
      final isLoggedIn = await AuthService.isLoggedIn();

      print('🔐 AuthGuard: Statut connexion = $isLoggedIn');

      setState(() {
        _isAuthenticated = isLoggedIn;
        _isChecking = false;
      });

      // Rediriger vers l'authentification si non connecté
      if (!isLoggedIn && mounted) {
        print('❌ AuthGuard: Non connecté, redirection vers authentification');
        NavigationHelper.goToAuth(context);
      } else if (isLoggedIn) {
        print('✅ AuthGuard: Connecté, accès autorisé');
      }
    } catch (e) {
      print('❌ AuthGuard: Erreur vérification authentification: $e');
      setState(() {
        _isAuthenticated = false;
        _isChecking = false;
      });

      if (mounted && NavigationHelper.isProtectedRoute(widget.routeName)) {
        NavigationHelper.goToAuth(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Vérification de l\'authentification...'),
            ],
          ),
        ),
      );
    }

    if (!_isAuthenticated &&
        NavigationHelper.isProtectedRoute(widget.routeName)) {
      return const Scaffold(
        body: Center(
          child: Text('Redirection vers l\'authentification...'),
        ),
      );
    }

    return widget.child;
  }
}

/// Widget pour valider la session automatiquement
class SessionValidator extends StatefulWidget {
  final Widget child;

  const SessionValidator({super.key, required this.child});

  @override
  _SessionValidatorState createState() => _SessionValidatorState();
}

class _SessionValidatorState extends State<SessionValidator>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _validateSession();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Valider la session quand l'app revient au premier plan
      _validateSession();
    }
  }

  Future<void> _validateSession() async {
    try {
      final token = await AuthService.getValidAccessToken();

      if (token == null && mounted) {
        // Token invalide ou expiré, déconnecter
        NavigationHelper.logout(context);
      }
    } catch (e) {
      print('Erreur validation session: $e');
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Wrapper pour les routes protégées
class ProtectedRoute extends StatelessWidget {
  final Widget child;
  final String routeName;

  const ProtectedRoute({
    super.key,
    required this.child,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return SessionValidator(
      child: AuthGuard(
        routeName: routeName,
        child: child,
      ),
    );
  }
}
