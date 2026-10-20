import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../show_details/presentation/screens/show_details_screen.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/show_card.dart';

/// "See All" page: a grid of every loaded show.
/// Uses the same HomeBloc, so scrolling to the bottom loads the next page.
class AllShowsScreen extends StatefulWidget {
  final String title;
  final bool sortByRating;

  const AllShowsScreen({
    super.key,
    required this.title,
    this.sortByRating = false,
  });

  static Route<void> route({required String title, bool sortByRating = false}) {
    return MaterialPageRoute(
      builder: (context) =>
          AllShowsScreen(title: title, sortByRating: sortByRating),
    );
  }

  @override
  State<AllShowsScreen> createState() => _AllShowsScreenState();
}

class _AllShowsScreenState extends State<AllShowsScreen> {
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

  /// Near the bottom -> ask the BLoC for the next page.
  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<HomeBloc>().add(const FetchMoreShows());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is! HomeLoaded) return const LoadingView();

          final shows = [...state.shows];
          if (widget.sortByRating) {
            shows.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
          }

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ShowCard(
                      show: shows[index],
                      onTap: () => Navigator.push(
                        context,
                        ShowDetailsScreen.route(shows[index].id),
                      ),
                    ),
                    childCount: shows.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildBottomLoader(state)),
            ],
          );
        },
      ),
    );
  }

  /// Bottom of the grid: spinner, retry button, or "end" text.
  Widget _buildBottomLoader(HomeLoaded state) {
    Widget child;
    if (state.isLoadingMore) {
      child = const CircularProgressIndicator(color: AppColors.primary);
    } else if (state.loadMoreFailed) {
      child = TextButton.icon(
        onPressed: () => context.read<HomeBloc>().add(const FetchMoreShows()),
        icon: const Icon(Icons.refresh),
        label: const Text('Could not load more. Tap to retry'),
      );
    } else if (state.hasReachedEnd) {
      child = const Text(
        "You've reached the end",
        style: TextStyle(color: AppColors.textSecondary),
      );
    } else {
      child = const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Center(child: child),
    );
  }
}
