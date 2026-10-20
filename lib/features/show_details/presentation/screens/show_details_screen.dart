import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/poster_image.dart';
import '../../domain/repositories/show_details_repository.dart';
import '../bloc/show_details_bloc.dart';
import '../bloc/show_details_event.dart';
import '../bloc/show_details_state.dart';
import '../widgets/cast_tab.dart';
import '../widgets/details_header.dart';
import '../widgets/episodes_tab.dart';
import '../widgets/overview_tab.dart';
import '../widgets/similar_tab.dart';
import '../widgets/watchlist_button.dart';

class ShowDetailsScreen extends StatelessWidget {
  final int showId;

  const ShowDetailsScreen({super.key, required this.showId});

  /// Use: Navigator.push(context, ShowDetailsScreen.route(show.id));
  static Route<void> route(int showId) {
    return MaterialPageRoute(
      builder: (context) => ShowDetailsScreen(showId: showId),
    );
  }

  @override
  Widget build(BuildContext context) {
    // A new ShowDetailsBloc is created for every details page
    // and it immediately starts loading with LoadShowDetails.
    return BlocProvider(
      create: (context) =>
          ShowDetailsBloc(repository: context.read<ShowDetailsRepository>())
            ..add(LoadShowDetails(showId)),
      child: BlocBuilder<ShowDetailsBloc, ShowDetailsState>(
        builder: (context, state) {
          if (state is ShowDetailsLoaded) {
            return _DetailsView(state: state);
          }
          return Scaffold(
            appBar: AppBar(),
            body: state is ShowDetailsError
                ? ErrorView(
                    message: state.message,
                    onRetry: () => context.read<ShowDetailsBloc>().add(
                      LoadShowDetails(showId),
                    ),
                  )
                : const LoadingView(),
          );
        },
      ),
    );
  }
}

/// Overview tab  -> big poster header (like the design).
/// Other tabs    -> small app bar with the title in the middle.
class _DetailsView extends StatefulWidget {
  final ShowDetailsLoaded state;

  const _DetailsView({required this.state});

  @override
  State<_DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<_DetailsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Rebuild when the user changes tab.
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TabBar _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 13),
      tabs: const [
        Tab(text: 'Overview'),
        Tab(text: 'Episodes'),
        Tab(text: 'Cast'),
        Tab(text: 'Similar'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController.index == 0) {
      return _buildOverviewLayout();
    }
    return _buildCompactLayout();
  }

  /// Layout 1: big poster, show info, tabs, quick info.
  Widget _buildOverviewLayout() {
    final show = widget.state.show;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: AppColors.background,
            leading: Padding(
              padding: const EdgeInsets.all(6),
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.45),
                ),
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              WatchlistIconButton(show: show, withBackground: true),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PosterImage(
                    imageUrl: show.originalImageUrl ?? show.imageUrl,
                    borderRadius: 0,
                  ),
                  // Dark fade at the bottom so the title is readable.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.background],
                        stops: [0.45, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: DetailsHeader(
              show: show,
              seasonCount: widget.state.seasons.length,
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(_buildTabBar()),
          ),
          SliverToBoxAdapter(child: OverviewTab(show: show)),
        ],
      ),
    );
  }

  /// Layout 2: small app bar + tabs + the selected tab's list.
  Widget _buildCompactLayout() {
    final show = widget.state.show;

    final Widget content = switch (_tabController.index) {
      1 => EpisodesTab(state: widget.state),
      2 => CastTab(cast: widget.state.cast),
      _ => SimilarTab(show: show),
    };

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          show.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [WatchlistIconButton(show: show)],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(child: content),
        ],
      ),
    );
  }
}

/// Keeps the TabBar stuck at the top while scrolling.
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppColors.background, child: tabBar);
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => true;
}
