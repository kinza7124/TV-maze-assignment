import 'package:flutter/material.dart';

import '../../../../core/entities/show.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/poster_image.dart';

/// A vertical card: poster, title and genres.
class ShowCard extends StatelessWidget {
  final Show show;
  final VoidCallback onTap;

  const ShowCard({super.key, required this.show, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PosterImage(
              imageUrl: show.imageUrl,
              width: double.infinity,
              height: double.infinity,
              borderRadius: 8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            show.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            show.genres.take(2).join(', '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
