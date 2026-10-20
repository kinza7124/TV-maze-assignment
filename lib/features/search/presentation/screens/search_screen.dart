import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/show_list_tile.dart';
import '../../../show_details/presentation/screens/show_details_screen.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/person_tile.dart';
import '../widgets/search_tabs.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  SearchCategory _category = SearchCategory.shows;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    context.read<SearchBloc>().add(SearchQueryChanged(query));
    setState(() {}); // only to show/hide the clear (X) button
  }

  void _clear() {
    _controller.clear();
    _onChanged('');
  }

  void _onCategoryChanged(SearchCategory category) {
    setState(() => _category = category);
    context.read<SearchBloc>().add(SearchCategoryChanged(category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: TextField(
                controller: _controller,
                onChanged: _onChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search shows...',
                  isDense: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: _clear,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchTabs(
                selected: _category,
                onChanged: _onCategoryChanged,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) => _buildResults(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, SearchState state) {
    const divider = Divider(height: 1, indent: 16, color: AppColors.border);

    if (state is SearchLoading) {
      return const LoadingView();
    }
    if (state is SearchEmpty) {
      return EmptyView(
        icon: Icons.search_off,
        title: 'No results found',
        message: 'We couldn\'t find anything for "${state.query}".',
      );
    }
    if (state is SearchError) {
      return ErrorView(
        message: state.message,
        onRetry: () =>
            context.read<SearchBloc>().add(SearchQueryChanged(state.query)),
      );
    }
    if (state is SearchLoaded) {
      return ListView.separated(
        itemCount: state.shows.length,
        separatorBuilder: (context, index) => divider,
        itemBuilder: (context, index) {
          final show = state.shows[index];
          return ShowListTile(
            show: show,
            onTap: () =>
                Navigator.push(context, ShowDetailsScreen.route(show.id)),
          );
        },
      );
    }
    if (state is PeopleLoaded) {
      return ListView.separated(
        itemCount: state.people.length,
        separatorBuilder: (context, index) => divider,
        itemBuilder: (context, index) =>
            PersonTile(person: state.people[index]),
      );
    }
    // SearchInitial
    return const EmptyView(
      icon: Icons.manage_search,
      title: 'Search TV Shows',
      message: 'Type a name, like "Dark" or "Breaking Bad".',
    );
  }
}
