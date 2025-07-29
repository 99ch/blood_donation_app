import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_input.dart';

import '../../services/api_service.dart';
import 'package:http/http.dart' as http;

class AccountRegistrationScreen extends StatefulWidget {
  AccountRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<AccountRegistrationScreen> createState() => _AccountRegistrationScreenState();
}

class _AccountRegistrationScreenState extends State<AccountRegistrationScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String selectedCountry = 'Bénin';
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFullNameSection(),
            SizedBox(height: 24.h),
            _buildEmailSection(),
            SizedBox(height: 24.h),
            _buildPasswordSection(),
            SizedBox(height: 24.h),
            _buildConfirmPasswordSection(),
            SizedBox(height: 24.h),
            _buildCountrySection(),
            SizedBox(height: 24.h),
            if (errorMessage != null)
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            _buildContinueButton(context),
            SizedBox(height: 16.h),
            _buildLoginLinkSection(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: appTheme.colorFFF2AB,
      elevation: 4,
      toolbarHeight: 112.h,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgArrowleft,
                height: 16.h,
                width: 7.h,
              ),
              SizedBox(width: 4.h),
              CustomImageView(
                imagePath: ImageConstant.imgVector,
                height: 2.h,
                width: 14.h,
              ),
            ],
          ),
        ),
      ),
      title: Text(
        'Créer un compte',
        style: TextStyleHelper.instance.title20
            .copyWith(color: appTheme.whiteCustom, height: 1.25),
      ),
      leadingWidth: 80.h,
    );
  }

  Widget _buildFullNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nom et prénom',
          style: TextStyleHelper.instance.title20.copyWith(height: 1.25),
        ),
        SizedBox(height: 8.h),
        CustomTextInput(
          controller: fullNameController,
          hintText: 'eg.Vikram varma',
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildEmailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyleHelper.instance.title20.copyWith(height: 1.25),
        ),
        SizedBox(height: 8.h),
        CustomTextInput(
          controller: emailController,
          textInputType: TextInputType.emailAddress,
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mot de passe',
          style: TextStyleHelper.instance.title20.copyWith(height: 1.25),
        ),
        SizedBox(height: 8.h),
        CustomTextInput(
          controller: passwordController,
          hintText: 'Password',
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirmation Mot de passe',
          style: TextStyleHelper.instance.title20.copyWith(height: 1.25),
        ),
        SizedBox(height: 8.h),
        CustomTextInput(
          controller: confirmPasswordController,
          hintText: 'Password',
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildCountrySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pays de résidence',
          style: TextStyleHelper.instance.title20.copyWith(height: 1.25),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 61.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: appTheme.colorFFD9D9,
            borderRadius: BorderRadius.circular(5.h),
            boxShadow: [
              BoxShadow(
                color: appTheme.blackCustom.withAlpha(26),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: selectedCountry,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
              border: InputBorder.none,
            ),
            style: TextStyleHelper.instance.body15.copyWith(height: 1.27),
            icon: CustomImageView(
              imagePath: ImageConstant.img,
              height: 16.h,
              width: 16.h,
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
                child: Text(country),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                selectedCountry = newValue;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return CustomButton(
      text: isLoading ? 'Création...' : 'Continuer',
      onPressed: isLoading ? null : () => _handleRegistration(context),
      variant: CustomButtonVariant.elevated,
      backgroundColor: appTheme.colorFF8808,
      textColor: appTheme.whiteCustom,
      isFullWidth: true,
      height: 44,
      fontSize: 14,
      fontWeight: FontWeight.w600,
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
    // Découper nom et prénom
    final fullName = fullNameController.text.trim();
    final parts = fullName.split(' ');
    final nom = parts.isNotEmpty ? parts.first : '';
    final prenoms = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    final data = {
      'username': emailController.text.trim(),
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'nom': nom,
      'prenoms': prenoms,
      // Optionnel : pays (selon backend)
    };
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/users/'),
        headers: {'Content-Type': 'application/json'},
        body: ApiService.encodeJson(data),
      );
      if (response.statusCode == 201) {
        setState(() { isLoading = false; });
        // Succès : naviguer ou afficher un message
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Succès'),
            content: Text('Compte créé avec succès. Connectez-vous !'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushReplacementNamed(context, AppRoutes.authenticationScreen);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Erreur lors de la création du compte : ' + response.body;
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
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 16.h),
        child: Column(
          children: [
            Text(
              'Vous avez déjà un compte?',
              style: TextStyleHelper.instance.title20
                  .copyWith(color: appTheme.blackCustom, height: 1.25),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.authenticationScreen);
              },
              child: Text(
                'Se connecter',
                style: TextStyleHelper.instance.title20
                    .copyWith(color: appTheme.colorFFFF37, height: 1.25),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
