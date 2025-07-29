import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_text_input.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_bottom_navigation.dart';
import '../../theme/custom_button_styles.dart';

class CreateDonorScreen extends StatefulWidget {
  const CreateDonorScreen({Key? key}) : super(key: key);

  @override
  State<CreateDonorScreen> createState() => _CreateDonorScreenState();
}

class _CreateDonorScreenState extends State<CreateDonorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomsController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateNaissanceController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomsController.dispose();
    _emailController.dispose();
    _dateNaissanceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 20)), // 20 ans par défaut
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(Duration(days: 365 * 18)), // Au moins 18 ans
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
        _dateNaissanceController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _createDonor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      
      if (token == null) {
        throw Exception('Utilisateur non authentifié');
      }

      final api = ApiService();
      final donorData = {
        'nom': _nomController.text.trim(),
        'prenoms': _prenomsController.text.trim(),
        'email': _emailController.text.trim(),
        'date_de_naissance': _dateNaissanceController.text,
        'statut': 'absent', // Par défaut
      };

      final success = await api.createDonneur(token, donorData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Donneur créé avec succès!'),
            backgroundColor: appTheme.primaryPink,
          ),
        );
        Navigator.pop(context, true); // Retourner true pour indiquer le succès
      } else {
        throw Exception('Erreur lors de la création');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: appTheme.primaryRed,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.lightPink,
      appBar: AppBar(
        backgroundColor: appTheme.darkRed,
        title: Text(
          'Nouveau Donneur',
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
              // En-tête explicatif
              Container(
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: appTheme.whiteCustom,
                  borderRadius: BorderRadius.circular(12.h),
                  boxShadow: [
                    BoxShadow(
                      color: appTheme.blackCustom.withAlpha(26),
                      blurRadius: 8,
                      offset: Offset(0, 2),
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
                          size: 24.h,
                        ),
                        SizedBox(width: 8.h),
                        Text(
                          'Inscription Donneur',
                          style: TextStyleHelper.instance.title18SemiBold,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Créez un profil pour un nouveau donneur de sang. Toutes les informations sont obligatoires.',
                      style: TextStyleHelper.instance.body14Regular.copyWith(
                        color: appTheme.colorFF5050,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Formulaire
              Container(
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: appTheme.whiteCustom,
                  borderRadius: BorderRadius.circular(12.h),
                  boxShadow: [
                    BoxShadow(
                      color: appTheme.blackCustom.withAlpha(26),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
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

                    SizedBox(height: 16.h),

                    // Email
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

                    SizedBox(height: 16.h),

                    // Date de naissance
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
                            return null;
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Note sur l'âge minimum
                    Container(
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
                            size: 16.h,
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
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Boutons d'action
              Row(
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
                      text: _isLoading ? 'Création...' : 'Créer le Donneur',
                      onPressed: _isLoading ? null : _createDonor,
                      buttonStyle: CustomButtonStyles.fillPrimary,
                      buttonTextStyle: TextStyleHelper.instance.body16SemiBold.copyWith(
                        color: appTheme.whiteCustom,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(
        currentRoute: AppRoutes.bloodDonationMenuScreen,
      ),
    );
  }
}
