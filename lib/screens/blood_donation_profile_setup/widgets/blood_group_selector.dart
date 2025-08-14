import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_button.dart';

/// Blood Group Selector Widget
///
/// A responsive grid of blood group buttons with active state management
class BloodGroupSelector extends StatelessWidget {
  final String selectedBloodType;
  final Function(String) onBloodTypeSelected;

  const BloodGroupSelector({
    super.key,
    required this.selectedBloodType,
    required this.onBloodTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBloodTypeRow(['A+', 'O+', 'B+', 'AB+']),
        SizedBox(height: 16.h),
        _buildBloodTypeRow(['A-', 'O-', 'B-', 'AB-']),
      ],
    );
  }

  Widget _buildBloodTypeRow(List<String> bloodTypes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: bloodTypes
          .map((bloodType) => _buildBloodTypeButton(bloodType))
          .toList(),
    );
  }

  Widget _buildBloodTypeButton(String bloodType) {
    bool isSelected = selectedBloodType == bloodType;

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.h),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: CustomButton(
            text: bloodType,
            onPressed: () {
              onBloodTypeSelected(bloodType);
            },
            variant: isSelected
                ? CustomButtonVariant.elevated
                : CustomButtonVariant.outlined,
            backgroundColor:
                isSelected ? appTheme.colorFFF998 : appTheme.whiteCustom,
            textColor: isSelected ? appTheme.whiteCustom : appTheme.blackCustom,
            borderColor:
                isSelected ? appTheme.colorFFF998 : appTheme.blackCustom,
            width: double.infinity,
            height: 70.h,
            fontSize: 18.fSize,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
