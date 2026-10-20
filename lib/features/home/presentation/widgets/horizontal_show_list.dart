import 'package:flutter/material.dart';

import '../../../../core/entities/show.dart';
import 'show_card.dart';

/// A horizontal row of ShowCards.
/// [onEndReached] is called when the user scrolls near the right end
/// (used for pagination in "Popular Shows").
class HorizontalShowList extends StatefulWidget {
  final List<Show> shows;
  final void Function(Show show) onShowTap;
  final VoidCallback? onEndReached;
  final bool isLoadingMore;

  const HorizontalShowList({
    super.key,
    required this.shows,
    required this.onShowTap,
    this.onEndReached,
    this.isLoadingMore = false,
  });

  @override
  State<HorizontalShowList> createState() => _HorizontalShowListState();
}

class _HorizontalShowListState extends State<HorizontalShowList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (widget.onEndReached != null &&
        position.pixels >= position.maxScrollExtent - 200) {
      widget.onEndReached!();
    }
  }

  @override
  Widget build(BuildContext context) {
    // One extra item at the end for the loading spinner.
    final itemCount = widget.shows.length + (widget.isLoadingMore ? 1 : 0);

    return SizedBox(
      height: 200,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itemCount,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index >= widget.shows.length) {
            return const SizedBox(
              width: 50,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          final show = widget.shows[index];
          return SizedBox(
            width: 110,
            child: ShowCard(show: show, onTap: () => widget.onShowTap(show)),
          );
        },
      ),
    );
  }
}
