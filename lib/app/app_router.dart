import 'package:flutter/material.dart';

import '../features/not_found/presentation/screens/not_found_screen.dart';
import 'main_screen.dart';

/// Decides which page to open for a URL / route name.
/// "/"          -> MainScreen (Home, Search, Watchlist, Profile tabs)
/// anything else -> NotFoundScreen (404)
class AppRouter {
  static const String home = '/';

  static Route<void> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const MainScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => NotFoundScreen(path: settings.name ?? ''),
        );
    }
  }

  /// The FIRST page when the app opens (on web this is the URL in the
  /// address bar). Without this, Flutter would ignore an unknown URL and
  /// silently show Home instead of the 404 page.
  static List<Route<dynamic>> onGenerateInitialRoutes(String initialRoute) {
    return [onGenerateRoute(RouteSettings(name: initialRoute))];
  }
}
