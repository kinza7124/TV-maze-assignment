import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_client.dart';
import '../core/theme/app_theme.dart';
import '../features/home/data/datasources/home_remote_data_source.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import '../features/home/presentation/bloc/home_event.dart';
import '../features/search/data/datasources/search_remote_data_source.dart';
import '../features/search/data/repositories/search_repository_impl.dart';
import '../features/search/domain/repositories/search_repository.dart';
import '../features/search/presentation/bloc/search_bloc.dart';
import '../features/show_details/data/datasources/show_details_remote_data_source.dart';
import '../features/show_details/data/repositories/show_details_repository_impl.dart';
import '../features/show_details/domain/repositories/show_details_repository.dart';
import '../features/watchlist/data/datasources/watchlist_local_data_source.dart';
import '../features/watchlist/data/repositories/watchlist_repository_impl.dart';
import '../features/watchlist/domain/repositories/watchlist_repository.dart';
import '../features/watchlist/presentation/bloc/watchlist_bloc.dart';
import '../features/watchlist/presentation/bloc/watchlist_event.dart';
import 'app_router.dart';

/// Root widget.
/// 1. RepositoryProviders create the repositories (data layer).
/// 2. BlocProviders create the app-wide BLoCs (they read the repositories).
/// Any widget below can now use context.read<...>() to get them.
class TvMazeApp extends StatelessWidget {
  final ApiClient apiClient;
  final SharedPreferences prefs;

  const TvMazeApp({super.key, required this.apiClient, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HomeRepository>(
          create: (context) => HomeRepositoryImpl(
            remoteDataSource: HomeRemoteDataSource(apiClient: apiClient),
          ),
        ),
        RepositoryProvider<SearchRepository>(
          create: (context) => SearchRepositoryImpl(
            remoteDataSource: SearchRemoteDataSource(apiClient: apiClient),
          ),
        ),
        RepositoryProvider<ShowDetailsRepository>(
          create: (context) => ShowDetailsRepositoryImpl(
            remoteDataSource: ShowDetailsRemoteDataSource(apiClient: apiClient),
          ),
        ),
        RepositoryProvider<WatchlistRepository>(
          create: (context) => WatchlistRepositoryImpl(
            localDataSource: WatchlistLocalDataSource(prefs: prefs),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                HomeBloc(repository: context.read<HomeRepository>())
                  ..add(const FetchShows()),
          ),
          BlocProvider(
            create: (context) =>
                SearchBloc(repository: context.read<SearchRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                WatchlistBloc(repository: context.read<WatchlistRepository>())
                  ..add(const LoadWatchlist()),
          ),
        ],
        child: MaterialApp(
          title: 'TVMaze',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          // Routing: "/" opens MainScreen, any other URL opens the 404 page.
          onGenerateRoute: AppRouter.onGenerateRoute,
          onGenerateInitialRoutes: AppRouter.onGenerateInitialRoutes,
        ),
      ),
    );
  }
}
