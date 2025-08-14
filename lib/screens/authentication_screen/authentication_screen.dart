import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_text_input.dart';

/// Écran d'authentification permettant aux utilisateurs existants de se connecter
/// et aux nouveaux utilisateurs de créer un compte donneur.
///
/// Fonctionnalités :
/// - Connexion avec email/mot de passe
/// - Validation des champs de saisie
/// - Gestion des erreurs d'authentification
/// - Redirection vers la création de compte donneur
/// - Interface utilisateur moderne avec animations de chargement
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  /// Clé du formulaire pour la validation
  final _formKey = GlobalKey<FormState>();

  /// Contrôleur pour le champ email
  final _emailController = TextEditingController();

  /// Contrôleur pour le champ mot de passe
  final _passwordController = TextEditingController();

  /// Indicateur de chargement pendant l'authentification
  bool _isLoading = false;

  /// Message d'erreur à afficher en cas d'échec de connexion
  String? _errorMessage;

  /// Libère les ressources des contrôleurs de texte
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Gère le processus de connexion utilisateur
  ///
  /// Valide le formulaire, effectue la connexion via [AuthService],
  /// et navigue vers le menu principal en cas de succès
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.bloodDonationMenuScreen,
        );
      } else {
        setState(() {
          _errorMessage = "Identifiants invalides. Veuillez réessayer.";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Une erreur s'est produite. Veuillez réessayer.";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 60.h),
                  _buildWelcomeHeader(),
                  SizedBox(height: 40.h),
                  _buildLoginCard(),
                  SizedBox(height: 30.h),
                  _buildCreateAccountSection(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Construit l'en-tête de bienvenue avec le titre et la description
  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connectez-vous',
          style: TextStyleHelper.instance.headline24BoldManrope.copyWith(
            color: appTheme.colorFF8808,
            fontSize: 32.fSize,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Connectez-vous à votre compte pour continuer',
          style: TextStyleHelper.instance.body16Regular.copyWith(
            color: appTheme.colorFF7373,
            fontSize: 16.fSize,
          ),
        ),
      ],
    );
  }

  /// Construit la carte de connexion avec les champs de saisie
  Widget _buildLoginCard() {
    return Container(
      padding: EdgeInsets.all(24.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(20.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.colorFF8808.withOpacity(0.1),
            offset: const Offset(0, 10),
            blurRadius: 25,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: appTheme.blackCustom.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputSection(),
          SizedBox(height: 24.h),
          _buildForgotPasswordButton(),
          SizedBox(height: 32.h),
          _buildLoginButton(),
          if (_errorMessage != null) ...[
            SizedBox(height: 16.h),
            _buildErrorMessage(),
          ],
        ],
      ),
    );
  }

  /// Construit la section des champs de saisie (email et mot de passe)
  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email field
        Text(
          'Adresse e-mail *',
          style: TextStyleHelper.instance.body16SemiBold.copyWith(
            color: appTheme.colorFF0F0B,
            fontSize: 14.fSize,
          ),
        ),
        SizedBox(height: 8.h),
        CustomTextInput(
          controller: _emailController,
          hintText: 'exemple@gmail.com',
          textInputType: TextInputType.emailAddress,
          validator: _validateEmail,
        ),

        SizedBox(height: 20.h),

        // Password field
        Text(
          'Mot de passe *',
          style: TextStyleHelper.instance.body16SemiBold.copyWith(
            color: appTheme.colorFF0F0B,
            fontSize: 14.fSize,
          ),
        ),
        SizedBox(height: 8.h),
        CustomTextInput(
          controller: _passwordController,
          hintText: 'Votre mot de passe',
          obscureText: true,
          validator: _validatePassword,
        ),
      ],
    );
  }

  /// Valide l'adresse email saisie par l'utilisateur
  ///
  /// Vérifie que l'email n'est pas vide et respecte le format standard
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'adresse e-mail est obligatoire';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Veuillez entrer une adresse e-mail valide';
    }
    return null;
  }

  /// Valide le mot de passe saisi par l'utilisateur
  ///
  /// Vérifie que le mot de passe n'est pas vide et contient au moins 6 caractères
  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le mot de passe est obligatoire';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  /// Construit le bouton "Mot de passe oublié"
  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Handle forgot password
          print('Forgot password tapped');
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
        ),
        child: Text(
          'Mot de passe oublié ?',
          style: TextStyleHelper.instance.body14Regular.copyWith(
            color: appTheme.colorFF8808,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Construit le bouton de connexion avec indicateur de chargement
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.colorFF8808,
          foregroundColor: appTheme.whiteCustom,
          disabledBackgroundColor: appTheme.colorFF9A9A,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.h),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: _isLoading
            ? SizedBox(
                width: 20.h,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.h,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(appTheme.whiteCustom),
                ),
              )
            : Text(
                'Se connecter',
                style: TextStyleHelper.instance.body16SemiBold.copyWith(
                  color: appTheme.whiteCustom,
                  fontSize: 16.fSize,
                ),
              ),
      ),
    );
  }

  /// Construit le message d'erreur avec icône et styling approprié
  Widget _buildErrorMessage() {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: appTheme.lightRed,
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(
          color: appTheme.colorFFFF37.withOpacity(0.3),
          width: 1.h,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: appTheme.colorFFFF37,
            size: 20.h,
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyleHelper.instance.body14Regular.copyWith(
                color: appTheme.darkRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit la section de création de compte avec séparateur et bouton
  Widget _buildCreateAccountSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1.h,
                color: appTheme.colorFFD9D9,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Text(
                'ou',
                style: TextStyleHelper.instance.body14Regular.copyWith(
                  color: appTheme.colorFF9A9A,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1.h,
                color: appTheme.colorFFD9D9,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.createDonorScreen);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: appTheme.colorFF8808,
              side: BorderSide(
                color: appTheme.colorFF8808,
                width: 2.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.h),
              ),
            ),
            child: Text(
              'Devenir Donneur',
              style: TextStyleHelper.instance.body16SemiBold.copyWith(
                color: appTheme.colorFF8808,
                fontSize: 16.fSize,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        // Debug button - TODO: Remove in production
        if (const bool.fromEnvironment('DEBUG', defaultValue: true))
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.apiDebugScreen);
            },
            style: TextButton.styleFrom(
              foregroundColor: appTheme.colorFF9A9A,
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bug_report_outlined,
                  size: 16.h,
                  color: appTheme.colorFF9A9A,
                ),
                SizedBox(width: 4.h),
                Text(
                  'Debug API',
                  style: TextStyleHelper.instance.body12Regular.copyWith(
                    color: appTheme.colorFF9A9A,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
