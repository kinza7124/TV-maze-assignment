import 'package:flutter/material.dart';

import '../../../../core/entities/show.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/genre_chip.dart';
import 'watchlist_button.dart';

/// Title, years, seasons, rating, genres, summary and the watchlist button.
class DetailsHeader extends StatelessWidget {
  final Show show;
  final int seasonCount;

  const DetailsHeader({
    super.key,
    required this.show,
    required this.seasonCount,
  });

  @override
  Widget build(BuildContext context) {
    const infoStyle = TextStyle(fontSize: 13, color: AppColors.textPrimary);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            show.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 18,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(show.yearRange, style: infoStyle),
              if (seasonCount > 0)
                Text(
                  '$seasonCount ${seasonCount == 1 ? 'Season' : 'Seasons'}',
                  style: infoStyle,
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: AppColors.star,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    show.rating == null ? 'N/A' : '${show.rating}/10',
                    style: infoStyle,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: show.genres.map((g) => GenreChip(label: g)).toList(),
          ),
          const SizedBox(height: 12),
          Text(
            show.summary.isEmpty ? 'No summary available.' : show.summary,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textPrimary, height: 1.4),
          ),
          const SizedBox(height: 16),
          WatchlistButton(show: show),
        ],
      ),
    );
  }
}
