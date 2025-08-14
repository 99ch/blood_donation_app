import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

/// Location Dropdown Widget
///
/// A dropdown selector for choosing location with search functionality
class LocationDropdown extends StatefulWidget {
  final String selectedLocation;
  final Function(String) onLocationSelected;

  const LocationDropdown({
    super.key,
    required this.selectedLocation,
    required this.onLocationSelected,
  });

  @override
  State<LocationDropdown> createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown> {
  final List<String> locations = [
    'Cotonou',
    'Porto-Novo',
    'Parakou',
    'Djougou',
    'Bohicon',
    'Kandi',
    'Ouidah',
    'Abomey',
    'Lokossa',
    'Dogbo',
  ];

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.colorFFD9D9,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.colorFF9A9A.withAlpha(77),
            offset: Offset(0, 4.h),
            blurRadius: 12.h,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDropdownHeader(),
          if (isExpanded) _buildDropdownList(),
        ],
      ),
    );
  }

  Widget _buildDropdownHeader() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        height: 61.h,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        decoration: BoxDecoration(
          color: appTheme.colorFFD9D9,
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(
            color: isExpanded ? appTheme.colorFFF2AB : Colors.transparent,
            width: 2.h,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: appTheme.colorFF8808,
              size: 24.h,
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: Text(
                widget.selectedLocation,
                style:
                    TextStyleHelper.instance.headline25RegularLexend.copyWith(
                  color: appTheme.colorFF4444,
                  fontSize: 16.fSize,
                ),
              ),
            ),
            AnimatedRotation(
              duration: const Duration(milliseconds: 200),
              turns: isExpanded ? 0.5 : 0,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: appTheme.colorFF8808,
                size: 24.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownList() {
    return Container(
      margin: EdgeInsets.only(top: 4.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.colorFF9A9A.withAlpha(51),
            offset: Offset(0, 4.h),
            blurRadius: 8.h,
          ),
        ],
      ),
      child: Column(
        children:
            locations.map((location) => _buildLocationItem(location)).toList(),
      ),
    );
  }

  Widget _buildLocationItem(String location) {
    bool isSelected = widget.selectedLocation == location;

    return GestureDetector(
      onTap: () {
        widget.onLocationSelected(location);
        setState(() {
          isExpanded = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? appTheme.colorFFF2AB.withAlpha(26)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.h),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: isSelected ? appTheme.colorFF8808 : appTheme.colorFF9A9A,
              size: 18.h,
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: Text(
                location,
                style: TextStyleHelper.instance.body15RegularLexend.copyWith(
                  color:
                      isSelected ? appTheme.colorFF8808 : appTheme.colorFF4444,
                  fontSize: 14.fSize,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: appTheme.colorFF8808,
                size: 18.h,
              ),
          ],
        ),
      ),
    );
  }
}
