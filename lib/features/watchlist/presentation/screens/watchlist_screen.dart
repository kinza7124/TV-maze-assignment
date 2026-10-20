import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/show.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/show_list_tile.dart';
import '../../../show_details/presentation/screens/show_details_screen.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';
import '../widgets/empty_watchlist.dart';

class WatchlistScreen extends StatelessWidget {
  /// Called by the "Explore Shows" button (switches to the Home tab).
  final VoidCallback onExploreTap;

  const WatchlistScreen({super.key, required this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        final hasShows = state is WatchlistLoaded && state.shows.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Watchlist'),
            actions: [
              if (hasShows)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Clear all',
                  onPressed: () => _confirmClear(context),
                ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, WatchlistState state) {
    if (state is WatchlistError) {
      return ErrorView(
        message: state.message,
        onRetry: () => context.read<WatchlistBloc>().add(const LoadWatchlist()),
      );
    }
    if (state is WatchlistLoaded) {
      if (state.shows.isEmpty) {
        return EmptyWatchlist(onExploreTap: onExploreTap);
      }
      return ListView.separated(
        itemCount: state.shows.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 16, color: AppColors.border),
        itemBuilder: (context, index) {
          final show = state.shows[index];
          return ShowListTile(
            show: show,
            onTap: () => _openDetails(context, show),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite, color: AppColors.heart),
                  tooltip: 'Remove',
                  onPressed: () => _remove(context, show),
                ),
                _buildMenu(context, show),
              ],
            ),
          );
        },
      );
    }
    return const LoadingView();
  }

  /// The ⋮ menu on each row.
  Widget _buildMenu(BuildContext context, Show show) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
      color: AppColors.surface,
      onSelected: (value) {
        if (value == 'details') _openDetails(context, show);
        if (value == 'remove') _remove(context, show);
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'details', child: Text('View details')),
        PopupMenuItem(value: 'remove', child: Text('Remove')),
      ],
    );
  }

  void _openDetails(BuildContext context, Show show) {
    Navigator.push(context, ShowDetailsScreen.route(show.id));
  }

  void _remove(BuildContext context, Show show) {
    context.read<WatchlistBloc>().add(RemoveFromWatchlist(show.id));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${show.name} removed from watchlist')),
      );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Clear watchlist?'),
        content: const Text('All saved shows will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<WatchlistBloc>().add(const ClearWatchlist());
              Navigator.pop(dialogContext);
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppColors.heart),
            ),
          ),
        ],
      ),
    );
  }
}
