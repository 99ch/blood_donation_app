import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class SearchFilterWidget extends StatelessWidget {
  final String searchQuery;
  final String selectedCenterType;
  final String selectedHours;
  final Function(String) onSearchChanged;
  final Function(String) onCenterTypeChanged;
  final Function(String) onHoursChanged;

  const SearchFilterWidget({
    super.key,
    required this.searchQuery,
    required this.selectedCenterType,
    required this.selectedHours,
    required this.onSearchChanged,
    required this.onCenterTypeChanged,
    required this.onHoursChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        TextField(
          onChanged: onSearchChanged,
          decoration: InputDecoration(
              hintText: 'Search by name or address',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.h)),
              filled: true,
              fillColor: Colors.grey[100]),
        ),
        const SizedBox(height: 10),
        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Center type filter
              _buildFilterDropdown(
                  'Type',
                  selectedCenterType,
                  ['All', 'Hospital', 'Clinic', 'Mobile Unit'],
                  onCenterTypeChanged),
              SizedBox(width: 12.h),
              // Hours filter
              _buildFilterDropdown('Hours', selectedHours,
                  ['All', 'Open Now', '24/7', 'Weekends'], onHoursChanged),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(String label, String selectedValue,
      List<String> options, Function(String) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8.h)),
      child: DropdownButton<String>(
        value: selectedValue,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
              value: option,
              child: Text('$label: $option',
                  style: TextStyle(fontSize: 14.fSize)));
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }
}
