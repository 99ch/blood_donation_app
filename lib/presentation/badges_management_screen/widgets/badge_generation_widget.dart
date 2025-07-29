import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class BadgeGenerationWidget extends StatefulWidget {
  final List<dynamic> donneurs;
  final Function(int) onGenerateBadge;

  const BadgeGenerationWidget({
    Key? key,
    required this.donneurs,
    required this.onGenerateBadge,
  }) : super(key: key);

  @override
  State<BadgeGenerationWidget> createState() => _BadgeGenerationWidgetState();
}

class _BadgeGenerationWidgetState extends State<BadgeGenerationWidget> {
  int? selectedDonneurId;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredDonneurs = widget.donneurs.where((donneur) {
      final fullName = '${donneur['nom']} ${donneur['prenoms']}'.toLowerCase();
      return fullName.contains(searchQuery.toLowerCase());
    }).toList();

    return Container(
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
          // Titre
          Row(
            children: [
              Icon(
                Icons.add_card,
                color: appTheme.darkRed,
                size: 24.h,
              ),
              SizedBox(width: 8.h),
              Text(
                'Générer un nouveau badge',
                style: TextStyleHelper.instance.title16SemiBold,
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Champ de recherche
          TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher un donneur...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.h),
                borderSide: BorderSide(color: appTheme.colorFF5050),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.h),
                borderSide: BorderSide(color: appTheme.darkRed),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
                selectedDonneurId = null; // Reset selection on search
              });
            },
          ),

          SizedBox(height: 16.h),

          // Liste des donneurs
          if (filteredDonneurs.isNotEmpty) ...[
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                border: Border.all(color: appTheme.colorFF5050.withAlpha(77)),
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: ListView.builder(
                itemCount: filteredDonneurs.length,
                itemBuilder: (context, index) {
                  final donneur = filteredDonneurs[index];
                  final isSelected = selectedDonneurId == donneur['id'];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected 
                        ? appTheme.primaryPink 
                        : appTheme.lightPink,
                      child: Icon(
                        Icons.person,
                        color: isSelected 
                          ? appTheme.whiteCustom 
                          : appTheme.darkRed,
                      ),
                    ),
                    title: Text(
                      '${donneur['nom']} ${donneur['prenoms']}',
                      style: TextStyleHelper.instance.body14SemiBold.copyWith(
                        color: isSelected ? appTheme.darkRed : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(donneur['email'] ?? ''),
                        Text(
                          'Dons: ${donneur['nb_dons'] ?? 0}',
                          style: TextStyleHelper.instance.body12Regular.copyWith(
                            color: appTheme.primaryPink,
                          ),
                        ),
                      ],
                    ),
                    selected: isSelected,
                    selectedTileColor: appTheme.lightPink.withAlpha(77),
                    onTap: () {
                      setState(() {
                        selectedDonneurId = donneur['id'];
                      });
                    },
                  );
                },
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.h),
              decoration: BoxDecoration(
                color: appTheme.lightPink.withAlpha(77),
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 32.h,
                    color: appTheme.colorFF5050,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Aucun donneur trouvé',
                    style: TextStyleHelper.instance.body14Regular.copyWith(
                      color: appTheme.colorFF5050,
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 16.h),

          // Bouton de génération
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: selectedDonneurId != null
                  ? () => widget.onGenerateBadge(selectedDonneurId!)
                  : null,
              icon: Icon(Icons.card_membership, size: 20.h),
              label: Text('Générer le Badge'),
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.primaryPink,
                foregroundColor: appTheme.whiteCustom,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                disabledBackgroundColor: appTheme.colorFF5050.withAlpha(128),
              ),
            ),
          ),

          if (selectedDonneurId == null) ...[
            SizedBox(height: 8.h),
            Text(
              'Veuillez sélectionner un donneur',
              style: TextStyleHelper.instance.body12Regular.copyWith(
                color: appTheme.colorFF5050,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
