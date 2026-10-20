import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/search_event.dart';

/// The "Shows | People" switch under the search field.
class SearchTabs extends StatelessWidget {
  final SearchCategory selected;
  final ValueChanged<SearchCategory> onChanged;

  const SearchTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildTab('Shows', SearchCategory.shows),
          _buildTab('People', SearchCategory.people),
        ],
      ),
    );
  }

  Widget _buildTab(String label, SearchCategory category) {
    final isSelected = selected == category;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(category),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
