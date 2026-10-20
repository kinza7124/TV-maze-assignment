import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/text_utils.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/poster_image.dart';
import '../../domain/entities/episode.dart';
import '../bloc/show_details_bloc.dart';
import '../bloc/show_details_event.dart';
import '../bloc/show_details_state.dart';

/// Tab 2: season dropdown + episodes of the selected season.
class EpisodesTab extends StatelessWidget {
  final ShowDetailsLoaded state;

  const EpisodesTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.episodes.isEmpty) {
      return const EmptyView(
        icon: Icons.video_library_outlined,
        title: 'No episodes',
        message: 'Episodes are not available for this show.',
      );
    }

    final episodes = state.episodesOfSeason(state.selectedSeason);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButton<int>(
              value: state.selectedSeason,
              isExpanded: true,
              isDense: false,
              underline: const SizedBox.shrink(),
              dropdownColor: AppColors.surface,
              icon: const Icon(Icons.keyboard_arrow_down),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
              items: state.seasons.map((season) {
                final count = state.episodesOfSeason(season).length;
                return DropdownMenuItem(
                  value: season,
                  child: Text('Season $season ($count episodes)'),
                );
              }).toList(),
              // Selecting a season sends an event to the BLoC.
              onChanged: (season) {
                if (season != null) {
                  context.read<ShowDetailsBloc>().add(SeasonSelected(season));
                }
              },
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: episodes.length,
            itemBuilder: (context, index) =>
                _EpisodeTile(episode: episodes[index]),
          ),
        ),
      ],
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  final Episode episode;

  const _EpisodeTile({required this.episode});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showEpisodeSummary(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 84,
              height: 48,
              child: Stack(
                children: [
                  PosterImage(
                    imageUrl: episode.imageUrl,
                    width: 84,
                    height: 48,
                    borderRadius: 6,
                    placeholderIcon: Icons.movie_outlined,
                  ),
                  // Episode number badge on the right side of the image.
                  if (episode.number != null)
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(6),
                          ),
                        ),
                        child: Text(
                          '${episode.number}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    TextUtils.formatDate(episode.airdate),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                size: 20,
                color: AppColors.background,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the episode summary in a bottom sheet.
  void _showEpisodeSummary(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'S${episode.season} E${episode.number ?? '-'} · ${episode.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              episode.summary.isEmpty
                  ? 'No summary available.'
                  : episode.summary,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
