import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/poster_image.dart';
import '../../domain/entities/person.dart';

/// One row in the People search results.
class PersonTile extends StatelessWidget {
  final Person person;

  const PersonTile({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    final details = [
      if (person.country != null) person.country!,
      if (person.birthday != null && person.birthday!.length >= 4)
        'Born ${person.birthday!.substring(0, 4)}',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          PosterImage(
            imageUrl: person.imageUrl,
            width: 56,
            height: 74,
            borderRadius: 6,
            placeholderIcon: Icons.person,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  details.isEmpty
                      ? 'No details available'
                      : details.join(' · '),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
