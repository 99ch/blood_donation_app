import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../services/api_service.dart';

class AccountRegistrationScreen extends StatefulWidget {
  const AccountRegistrationScreen({super.key});

  @override
  State<AccountRegistrationScreen> createState() =>
      _AccountRegistrationScreenState();
}

class _AccountRegistrationScreenState extends State<AccountRegistrationScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String selectedCountry = 'Bénin';
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 60.h),
              _buildWelcomeSection(),
              SizedBox(height: 30.h),
              _buildRegistrationCard(context),
              SizedBox(height: 30.h),
              _buildLoginLinkSection(context),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rejoignez-nous !',
          style: TextStyleHelper.instance.headline24BoldManrope.copyWith(
            color: appTheme.colorFF8808,
            fontSize: 28.fSize,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Créez votre compte pour commencer à sauver des vies',
          style: TextStyleHelper.instance.body16Regular.copyWith(
            color: appTheme.colorFF7373,
            fontSize: 16.fSize,
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationCard(BuildContext context) {
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
          _buildFormFields(),
          SizedBox(height: 32.h),
          _buildContinueButton(context),
          if (errorMessage != null) ...[
            SizedBox(height: 16.h),
            _buildErrorMessage(),
          ],
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModernInputSection(
          label: 'Nom et prénom',
          controller: fullNameController,
          hintText: 'ex: Vikram Varma',
          keyboardType: TextInputType.name,
          prefixIcon: Icons.person_outline,
        ),
        SizedBox(height: 20.h),
        _buildModernInputSection(
          label: 'Adresse e-mail',
          controller: emailController,
          hintText: 'exemple@gmail.com',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
        ),
        SizedBox(height: 20.h),
        _buildModernInputSection(
          label: 'Mot de passe',
          controller: passwordController,
          hintText: 'Votre mot de passe',
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          prefixIcon: Icons.lock_outline,
        ),
        SizedBox(height: 20.h),
        _buildModernInputSection(
          label: 'Confirmer le mot de passe',
          controller: confirmPasswordController,
          hintText: 'Confirmez votre mot de passe',
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          prefixIcon: Icons.lock_outline,
        ),
        SizedBox(height: 20.h),
        _buildCountryDropdown(),
      ],
    );
  }

  Widget _buildModernInputSection({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    bool obscureText = false,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyleHelper.instance.body16SemiBold.copyWith(
            color: appTheme.colorFF0F0B,
            fontSize: 14.fSize,
          ),
        ),
        SizedBox(height: 8.h),
        _buildModernInputField(
          controller: controller,
          hintText: hintText,
          keyboardType: keyboardType,
          obscureText: obscureText,
          prefixIcon: prefixIcon,
        ),
      ],
    );
  }

  Widget _buildModernInputField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    bool obscureText = false,
    IconData? prefixIcon,
  }) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: appTheme.colorFFF3F4,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: appTheme.colorFFD9D9,
          width: 1.h,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyleHelper.instance.body16Regular.copyWith(
          color: appTheme.colorFF0F0B,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyleHelper.instance.body16Regular.copyWith(
            color: appTheme.colorFF9A9A,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: appTheme.colorFF9A9A,
                  size: 20.h,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 16.h,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.h),
            borderSide: BorderSide(
              color: appTheme.colorFF8808,
              width: 2.h,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.h),
            borderSide: BorderSide(
              color: appTheme.colorFFFF37,
              width: 2.h,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pays de résidence',
          style: TextStyleHelper.instance.body16SemiBold.copyWith(
            color: appTheme.colorFF0F0B,
            fontSize: 14.fSize,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 56.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: appTheme.colorFFF3F4,
            borderRadius: BorderRadius.circular(12.h),
            border: Border.all(
              color: appTheme.colorFFD9D9,
              width: 1.h,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedCountry,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.public,
                color: appTheme.colorFF9A9A,
                size: 20.h,
              ),
            ),
            style: TextStyleHelper.instance.body16Regular.copyWith(
              color: appTheme.colorFF0F0B,
            ),
            dropdownColor: appTheme.whiteCustom,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: appTheme.colorFF9A9A,
            ),
            items: [
              'Bénin',
              'France',
              'Sénégal',
              'Côte d\'Ivoire',
              'Burkina Faso',
              'Mali',
              'Niger',
              'Togo',
              'Ghana',
              'Nigeria',
            ].map((String country) {
              return DropdownMenuItem<String>(
                value: country,
                child: Text(
                  country,
                  style: TextStyleHelper.instance.body16Regular.copyWith(
                    color: appTheme.colorFF0F0B,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedCountry = newValue;
                });
              }
            },
          ),
        ),
      ],
    );
  }

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
              errorMessage!,
              style: TextStyleHelper.instance.body14Regular.copyWith(
                color: appTheme.darkRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _handleRegistration(context),
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
        child: isLoading
            ? SizedBox(
                width: 24.h,
                height: 24.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.h,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(appTheme.whiteCustom),
                ),
              )
            : Text(
                'Créer mon compte',
                style: TextStyleHelper.instance.body16SemiBold.copyWith(
                  color: appTheme.whiteCustom,
                  fontSize: 16.fSize,
                ),
              ),
      ),
    );
  }

  Future<void> _handleRegistration(BuildContext context) async {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        selectedCountry.isEmpty) {
      setState(() {
        errorMessage = 'Veuillez remplir tous les champs requis.';
        isLoading = false;
      });
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Les mots de passe ne correspondent pas.';
        isLoading = false;
      });
      return;
    }

    try {
      final apiService = ApiService();
      final result = await apiService.register(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      setState(() {
        isLoading = false;
      });

      if (result != null) {
        // Succès : naviguer ou afficher un message
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Succès'),
            content: const Text('Compte créé avec succès. Connectez-vous !'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.authenticationScreen);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          errorMessage =
              'Erreur lors de la création du compte. Vérifiez vos informations.';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Erreur réseau ou serveur.';
      });
    }
  }

  Widget _buildLoginLinkSection(BuildContext context) {
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
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Vous avez déjà un compte ? ',
            style: TextStyleHelper.instance.body16Regular.copyWith(
              color: appTheme.colorFF7373,
            ),
            children: [
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.authenticationScreen);
                  },
                  child: Text(
                    'Se connecter',
                    style: TextStyleHelper.instance.body16SemiBold.copyWith(
                      color: appTheme.colorFF8808,
                      decoration: TextDecoration.underline,
                      decorationColor: appTheme.colorFF8808,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
