import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_text_input.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../theme/custom_button_styles.dart';

/// Écran de création de compte donneur unifié
///
/// Permet aux nouveaux utilisateurs de créer un compte et un profil donneur
/// dans un seul processus. Inclut la validation des données, la création
/// du compte utilisateur avec mot de passe, et la redirection automatique
/// vers la configuration du profil médical.
///
/// Fonctionnalités :
/// - Création de compte utilisateur avec authentification
/// - Création automatique du profil donneur associé
/// - Validation des champs obligatoires et formats
/// - Sélection de date de naissance avec restrictions d'âge
/// - Navigation fluide vers l'étape suivante
class CreateDonorScreen extends StatefulWidget {
  const CreateDonorScreen({super.key});

  @override
  State<CreateDonorScreen> createState() => _CreateDonorScreenState();
}

class _CreateDonorScreenState extends State<CreateDonorScreen> {
  /// Clé globale pour la validation du formulaire
  final _formKey = GlobalKey<FormState>();

  /// Contrôleurs pour les champs de saisie
  final _nomController = TextEditingController();
  final _prenomsController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dateNaissanceController = TextEditingController();

  /// Indicateur de chargement pendant l'inscription
  bool _isLoading = false;

  /// Libère les ressources des contrôleurs lors de la destruction du widget
  @override
  void dispose() {
    _nomController.dispose();
    _prenomsController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateNaissanceController.dispose();
    super.dispose();
  }

  /// Affiche le sélecteur de date pour la date de naissance
  ///
  /// Limite l'âge minimum à 18 ans et maximum à 122 ans (1900).
  /// Met à jour automatiquement le contrôleur de texte avec la date sélectionnée.
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now()
          .subtract(const Duration(days: 365 * 20)), // 20 ans par défaut
      firstDate: DateTime(1900),
      lastDate: DateTime.now()
          .subtract(const Duration(days: 365 * 18)), // Au moins 18 ans
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appTheme.primaryPink,
              onPrimary: appTheme.whiteCustom,
              surface: appTheme.whiteCustom,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateNaissanceController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  /// Gère le processus complet d'inscription donneur
  ///
  /// 1. Valide tous les champs du formulaire
  /// 2. Vérifie la correspondance des mots de passe
  /// 3. Crée le compte utilisateur avec authentification
  /// 4. Crée automatiquement le profil donneur associé
  /// 5. Connecte l'utilisateur et navigue vers l'étape suivante
  Future<void> _createDonor() async {
    if (!_formKey.currentState!.validate()) return;

    // Vérification de la correspondance des mots de passe
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Les mots de passe ne correspondent pas'),
          backgroundColor: appTheme.primaryRed,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final api = ApiService();

      // Étape 1: Créer le compte utilisateur
      final userResult = await api.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (userResult == null) {
        throw Exception('Erreur lors de la création du compte');
      }

      // Étape 2: Se connecter pour obtenir le token
      final loginSuccess = await api.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (loginSuccess == null) {
        throw Exception('Erreur lors de la connexion');
      }

      // Étape 3: Créer le profil donneur avec tous les champs requis
      final donorData = {
        'nom': _nomController.text.trim(),
        'prenoms': _prenomsController.text.trim(),
        'email': _emailController.text.trim(),
        'telephone': _telephoneController.text.trim(),
        'date_de_naissance': _dateNaissanceController.text,
        'pays': 'benin', // Valeur par défaut Django
        'statut': 'absent', // Par défaut
      };

      final donorResult =
          await api.createDonneur(loginSuccess['access_token'], donorData);

      if (donorResult != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Compte créé avec succès ! Complétez maintenant votre profil médical.'),
            backgroundColor: appTheme.primaryPink,
            duration: const Duration(seconds: 3),
          ),
        );

        // Rediriger vers la configuration du profil médical
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.bloodDonationProfileSetup,
        );
      } else {
        throw Exception('Erreur lors de la création du profil donneur');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: appTheme.primaryRed,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Construit l'interface utilisateur de l'écran d'inscription
  ///
  /// Structure :
  /// - AppBar avec titre et bouton retour
  /// - ScrollView avec formulaire d'inscription
  /// - Carte d'explication du processus
  /// - Formulaire avec tous les champs nécessaires
  /// - Boutons d'action (Annuler / S'inscrire)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.lightPink,
      appBar: AppBar(
        backgroundColor: appTheme.darkRed,
        title: Text(
          'Devenir Donneur',
          style: TextStyleHelper.instance.title20SemiBold.copyWith(
            color: appTheme.whiteCustom,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appTheme.whiteCustom),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Carte d'explication du processus d'inscription
              _buildExplanationCard(),

              SizedBox(height: 24.h),

              /// Formulaire principal avec tous les champs requis
              _buildRegistrationForm(),

              SizedBox(height: 24.h),

              /// Boutons d'action (Annuler / S'inscrire)
              _buildActionButtons(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRoutes.bloodDonationMenuScreen,
      ),
    );
  }

  /// Construit la carte d'explication du processus d'inscription
  Widget _buildExplanationCard() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_add,
                color: appTheme.primaryPink,
              ),
              SizedBox(width: 8.h),
              Text(
                'Devenir Donneur',
                style: TextStyleHelper.instance.title18SemiBold,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Rejoignez notre communauté de donneurs de sang et aidez à sauver des vies. Complétez votre profil en quelques étapes simples.',
            style: TextStyleHelper.instance.body14Regular.copyWith(
              color: appTheme.colorFF5050,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit le formulaire principal avec tous les champs requis
  Widget _buildRegistrationForm() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameFields(),
          SizedBox(height: 16.h),
          _buildEmailField(),
          SizedBox(height: 16.h),
          _buildPhoneField(),
          SizedBox(height: 16.h),
          _buildPasswordFields(),
          SizedBox(height: 16.h),
          _buildDateField(),
          SizedBox(height: 8.h),
          _buildAgeWarning(),
        ],
      ),
    );
  }

  /// Construit les champs nom et prénoms
  Widget _buildNameFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nom
        Text(
          'Nom *',
          style: TextStyleHelper.instance.body14SemiBold,
        ),
        SizedBox(height: 8.h),
        CustomTextInput(
          controller: _nomController,
          hintText: 'Entrez le nom de famille',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Le nom est obligatoire';
            }
            if (value.trim().length < 2) {
              return 'Le nom doit contenir au moins 2 caractères';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        // Prénoms
        Text(
          'Prénoms *',
          style: TextStyleHelper.instance.body14SemiBold,
        ),
        SizedBox(height: 8.h),
        CustomTextInput(
          controller: _prenomsController,
          hintText: 'Entrez le(s) prénom(s)',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Les prénoms sont obligatoires';
            }
            if (value.trim().length < 2) {
              return 'Les prénoms doivent contenir au moins 2 caractères';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Construit le champ email
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email *',
          style: TextStyleHelper.instance.body14SemiBold,
        ),
        SizedBox(height: 8.h),
        CustomTextInput(
          controller: _emailController,
          hintText: 'exemple@email.com',
          textInputType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'L\'email est obligatoire';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Format d\'email invalide';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Construit le champ téléphone
  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Téléphone *',
          style: TextStyleHelper.instance.body14SemiBold,
        ),
        SizedBox(height: 8.h),
        CustomTextInput(
          controller: _telephoneController,
          hintText: '+229 XX XX XX XX',
          textInputType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Le numéro de téléphone est obligatoire';
            }
            if (!RegExp(r'^\+?[0-9\s\-]{8,15}$').hasMatch(value.trim())) {
              return 'Format de téléphone invalide';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Construit les champs de mot de passe
  Widget _buildPasswordFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mot de passe
        Text(
          'Mot de passe *',
          style: TextStyleHelper.instance.body14SemiBold,
        ),
        SizedBox(height: 8.h),
        CustomTextInput(
          controller: _passwordController,
          hintText: 'Créez un mot de passe sécurisé',
          obscureText: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Le mot de passe est obligatoire';
            }
            if (value.length < 6) {
              return 'Le mot de passe doit contenir au moins 6 caractères';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        // Confirmation mot de passe
        Text(
          'Confirmer le mot de passe *',
          style: TextStyleHelper.instance.body14SemiBold,
        ),
        SizedBox(height: 8.h),
        CustomTextInput(
          controller: _confirmPasswordController,
          hintText: 'Confirmez votre mot de passe',
          obscureText: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'La confirmation est obligatoire';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Construit le champ de date de naissance
  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date de naissance *',
          style: TextStyleHelper.instance.body14SemiBold,
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: _selectDate,
          child: AbsorbPointer(
            child: CustomTextInput(
              controller: _dateNaissanceController,
              hintText: 'Sélectionnez votre date de naissance',
              suffixIcon: Icon(
                Icons.calendar_today,
                color: appTheme.primaryPink,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La date de naissance est obligatoire';
                }

                // Validation de l'âge minimum (18 ans) - Alignée avec Django
                try {
                  final birthDate = DateTime.parse(value);
                  final today = DateTime.now();
                  int age = today.year - birthDate.year;
                  if (today.month < birthDate.month ||
                      (today.month == birthDate.month &&
                          today.day < birthDate.day)) {
                    age--;
                  }

                  if (age < 18) {
                    return 'Vous devez avoir au moins 18 ans pour être donneur';
                  }
                } catch (e) {
                  return 'Format de date invalide';
                }

                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Construit l'avertissement sur l'âge minimum
  Widget _buildAgeWarning() {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: appTheme.primaryPink.withAlpha(26),
        borderRadius: BorderRadius.circular(8.h),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info,
            color: appTheme.primaryPink,
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: Text(
              'Les donneurs doivent être âgés d\'au moins 18 ans',
              style: TextStyleHelper.instance.body12Regular.copyWith(
                color: appTheme.primaryPink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit les boutons d'action (Annuler / S'inscrire)
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: appTheme.colorFF5050,
              side: BorderSide(color: appTheme.colorFF5050),
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
            child: Text(
              'Annuler',
              style: TextStyleHelper.instance.body16Regular,
            ),
          ),
        ),
        SizedBox(width: 16.h),
        Expanded(
          child: CustomButton(
            text: _isLoading ? 'Inscription...' : 'Devenir Donneur',
            onPressed: _isLoading ? null : _createDonor,
            buttonStyle: CustomButtonStyles.fillPrimary,
            buttonTextStyle: TextStyleHelper.instance.body16SemiBold.copyWith(
              color: appTheme.whiteCustom,
            ),
          ),
        ),
      ],
    );
  }
}
