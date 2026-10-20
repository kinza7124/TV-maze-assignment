import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/show.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../watchlist/presentation/bloc/watchlist_bloc.dart';
import '../../../watchlist/presentation/bloc/watchlist_event.dart';
import '../../../watchlist/presentation/bloc/watchlist_state.dart';

/// Adds the show if it is not saved, removes it if it is saved.
void _toggleWatchlist(BuildContext context, Show show, bool isSaved) {
  final bloc = context.read<WatchlistBloc>();
  if (isSaved) {
    bloc.add(RemoveFromWatchlist(show.id));
  } else {
    bloc.add(AddToWatchlist(show));
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          isSaved
              ? '${show.name} removed from watchlist'
              : '${show.name} added to watchlist',
        ),
      ),
    );
}

/// Big "Add to Watchlist" / "In Watchlist" button.
class WatchlistButton extends StatelessWidget {
  final Show show;

  const WatchlistButton({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    // BlocBuilder rebuilds this button whenever the watchlist changes.
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        final isSaved =
            state is WatchlistLoaded && state.isInWatchlist(show.id);

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: isSaved
                ? ElevatedButton.styleFrom(backgroundColor: AppColors.card)
                : null,
            onPressed: () => _toggleWatchlist(context, show, isSaved),
            icon: Icon(isSaved ? Icons.check : Icons.add),
            label: Text(isSaved ? 'In Watchlist' : 'Add to Watchlist'),
          ),
        );
      },
    );
  }
}

/// Heart icon for the app bar.
/// [withBackground] draws a dark circle behind it (used on top of the poster).
class WatchlistIconButton extends StatelessWidget {
  final Show show;
  final bool withBackground;

  const WatchlistIconButton({
    super.key,
    required this.show,
    this.withBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        final isSaved =
            state is WatchlistLoaded && state.isInWatchlist(show.id);

        return IconButton(
          style: withBackground
              ? IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.45),
                )
              : null,
          onPressed: () => _toggleWatchlist(context, show, isSaved),
          icon: Icon(
            isSaved ? Icons.favorite : Icons.favorite_border,
            color: isSaved ? AppColors.heart : Colors.white,
          ),
        );
      },
    );
  }
}
