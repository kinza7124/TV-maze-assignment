import 'package:flutter/material.dart';

import '../../../../core/entities/show.dart';
import '../../../../core/theme/app_colors.dart';

/// Tab 1: Quick info table + full summary.
/// It is a Column (not a ListView) because it sits inside a scroll view.
class OverviewTab extends StatelessWidget {
  final Show show;

  const OverviewTab({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    const divider = Divider(height: 1, color: AppColors.border);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Title('Quick Info'),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _InfoRow(Icons.radio_button_checked, 'Status', show.status),
                divider,
                _InfoRow(Icons.live_tv_outlined, 'Network', show.network),
                divider,
                _InfoRow(
                  Icons.shield_outlined,
                  'Genres',
                  show.genres.isEmpty ? null : show.genres.join(', '),
                ),
                divider,
                _InfoRow(Icons.language, 'Language', show.language),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _Title('Summary'),
          Text(
            show.summary.isEmpty ? 'No summary available.' : show.summary,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;

  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value ?? 'N/A', // missing data is shown as N/A
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
