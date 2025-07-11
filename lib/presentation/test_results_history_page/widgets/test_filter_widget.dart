import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class TestFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const TestFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> filters = [
      'All',
      'Last 3 Months',
      'Last 6 Months',
      'Last Year'
    ];

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = selectedFilter == filter;

              return Padding(
                  padding: EdgeInsets.only(right: 8.h),
                  child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          onFilterChanged(filter);
                        }
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: theme.colorScheme.primary.withAlpha(51),
                      labelStyle: TextStyle(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : Colors.grey[700],
                          fontSize: 14.fSize,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.w400),
                      side: BorderSide(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : Colors.grey[300]!)));
            }));
  }
}
