import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/show.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/show_list_tile.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_state.dart';
import '../screens/show_details_screen.dart';

/// Tab 4: shows that share at least one genre with this show.
/// TVMaze has no "similar" API, so we use the shows already
/// loaded by HomeBloc (no extra network call).
class SimilarTab extends StatelessWidget {
  final Show show;

  const SimilarTab({super.key, required this.show});

  List<Show> _findSimilar(List<Show> allShows) {
    final similar = allShows
        .where((other) => other.id != show.id)
        .where((other) => other.genres.any(show.genres.contains))
        .toList();
    similar.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    return similar.take(20).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final similar = state is HomeLoaded
            ? _findSimilar(state.shows)
            : <Show>[];

        if (similar.isEmpty) {
          return const EmptyView(
            icon: Icons.movie_filter_outlined,
            title: 'No similar shows',
            message: 'We could not find shows with the same genres.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: similar.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, indent: 16, color: AppColors.border),
          itemBuilder: (context, index) => ShowListTile(
            show: similar[index],
            onTap: () => Navigator.push(
              context,
              ShowDetailsScreen.route(similar[index].id),
            ),
          ),
        );
      },
    );
  }
}
