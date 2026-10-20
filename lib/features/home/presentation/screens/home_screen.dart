import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/entities/show.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../show_details/presentation/screens/show_details_screen.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/horizontal_show_list.dart';
import '../widgets/section_title.dart';
import 'all_shows_screen.dart';

class HomeScreen extends StatelessWidget {
  /// Called when the user taps the search bar (switches to the Search tab).
  final VoidCallback onSearchTap;

  /// Called when the user taps the settings button (switches to Profile).
  final VoidCallback onSettingsTap;

  const HomeScreen({
    super.key,
    required this.onSearchTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<HomeBloc>().add(const FetchShows()),
              );
            }
            if (state is HomeLoaded) {
              if (state.shows.isEmpty) {
                return const EmptyView(
                  icon: Icons.tv_off,
                  title: 'No shows found',
                  message: 'Please try again later.',
                );
              }
              return _buildContent(context, state);
            }
            // HomeInitial or HomeLoading
            return const LoadingView();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeLoaded state) {
    // "Trending" = the 10 highest rated shows we have loaded.
    final trending = [...state.shows]
      ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

    void openDetails(Show show) =>
        Navigator.push(context, ShowDetailsScreen.route(show.id));

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => context.read<HomeBloc>().add(const FetchShows()),
      child: ListView(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          SectionTitle(
            title: 'Trending Now',
            onSeeAll: () => Navigator.push(
              context,
              AllShowsScreen.route(title: 'Trending Now', sortByRating: true),
            ),
          ),
          HorizontalShowList(
            shows: trending.take(10).toList(),
            onShowTap: openDetails,
          ),
          SectionTitle(
            title: 'Popular Shows',
            onSeeAll: () => Navigator.push(
              context,
              AllShowsScreen.route(title: 'Popular Shows'),
            ),
          ),
          // Pagination: reaching the end of this row loads the next page.
          HorizontalShowList(
            shows: state.shows,
            onShowTap: openDetails,
            isLoadingMore: state.isLoadingMore,
            onEndReached: () =>
                context.read<HomeBloc>().add(const FetchMoreShows()),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: TextStyle(fontSize: 15, color: AppColors.textPrimary),
                ),
                SizedBox(height: 2),
                Text(
                  'TV Explorer! 👋',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            child: IconButton(
              onPressed: onSettingsTap,
              icon: const Icon(Icons.settings_outlined),
            ),
          ),
        ],
      ),
    );
  }

  /// Looks like a search field, but only switches to the Search tab.
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onSearchTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, size: 20, color: AppColors.textSecondary),
              SizedBox(width: 10),
              Text(
                'Search shows...',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
