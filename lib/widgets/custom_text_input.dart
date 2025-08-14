import 'package:flutter/material.dart';

import '../core/app_export.dart';

/// Widget de champ de saisie personnalisé réutilisable avec style cohérent
///
/// Fonctionnalités :
/// - Texte d'aide et validation personnalisables
/// - Style cohérent avec ombre et coins arrondis
/// - États de focus avec couleurs de bordure personnalisées
/// - Design responsive utilisant SizeUtils
/// - Support pour différents types de saisie
/// - Gestion des mots de passe avec bouton de visibilité
/// - Validation automatique et personnalisée
class CustomTextInput extends StatefulWidget {
  const CustomTextInput({
    super.key,
    this.controller,
    this.hintText,
    this.isRequired,
    this.validator,
    this.textInputType,
    this.enabled,
    this.suffixIcon,
    this.obscureText,
  });

  /// Contrôleur pour gérer la saisie de texte
  final TextEditingController? controller;

  /// Texte d'aide affiché comme placeholder
  final String? hintText;

  /// Indique si le champ est obligatoire pour la validation
  final bool? isRequired;

  /// Fonction de validation personnalisée
  final String? Function(String?)? validator;

  /// Type de clavier à afficher
  final TextInputType? textInputType;

  /// Indique si le champ de saisie est activé
  final bool? enabled;

  /// Widget d'icône de suffixe
  final Widget? suffixIcon;

  /// Indique si le texte doit être masqué (pour les mots de passe)
  final bool? obscureText;

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  /// État local pour la visibilité du texte (mots de passe)
  late bool _obscureText;

  /// Initialise l'état de visibilité du texte
  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? false;
  }

  /// Construit l'interface utilisateur du champ de saisie
  @override
  Widget build(BuildContext context) {
    /// Détermine si c'est un champ de mot de passe
    final isPasswordField = widget.obscureText == true;

    return Container(
      height: 61.h,
      decoration: BoxDecoration(
        color: appTheme.colorFFD9D9,
        borderRadius: BorderRadius.circular(5.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 4.h,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.textInputType ?? TextInputType.text,
        enabled: widget.enabled ?? true,
        obscureText: _obscureText,
        validator: widget.validator ??
            (widget.isRequired == true ? _defaultValidator : null),
        style:
            TextStyleHelper.instance.body15RegularLexend.copyWith(height: 1.27),
        decoration: InputDecoration(
          hintText: widget.hintText ?? "Saisir le texte",
          hintStyle: TextStyleHelper.instance.body15RegularLexend
              .copyWith(color: appTheme.colorFF9A9A, height: 1.27),

          /// Affiche le bouton de visibilité pour les mots de passe ou l'icône personnalisée
          suffixIcon: isPasswordField
              ? _buildPasswordVisibilityIcon()
              : widget.suffixIcon,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 21.h,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: _buildFocusedBorder(),
          errorBorder: _buildErrorBorder(),
          focusedErrorBorder: _buildErrorBorder(),
        ),
      ),
    );
  }

  /// Construit l'icône de visibilité pour les champs de mot de passe
  Widget _buildPasswordVisibilityIcon() {
    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility : Icons.visibility_off,
        color: appTheme.colorFF9A9A,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }

  /// Construit la bordure pour l'état focus
  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.h),
      borderSide: BorderSide(
        color: appTheme.colorFFF2AB,
        width: 2.h,
      ),
    );
  }

  /// Construit la bordure pour l'état d'erreur
  OutlineInputBorder _buildErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.h),
      borderSide: BorderSide(
        color: appTheme.redCustom,
        width: 2.h,
      ),
    );
  }

  /// Validateur par défaut pour les champs obligatoires
  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire';
    }
    return null;
  }
}
