import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/models/show_model.dart';

/// LOCAL DATA SOURCE: saves the watchlist on the phone.
/// Each show is converted to a JSON string and stored in a String list,
/// so the data is still there after the app restarts.
class WatchlistLocalDataSource {
  static const String _watchlistKey = 'watchlist_shows';

  final SharedPreferences prefs;

  WatchlistLocalDataSource({required this.prefs});

  List<ShowModel> getWatchlist() {
    final savedShows = prefs.getStringList(_watchlistKey) ?? [];
    return savedShows
        .map(
          (text) =>
              ShowModel.fromJson(jsonDecode(text) as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> saveWatchlist(List<ShowModel> shows) async {
    final textList = shows.map((show) => jsonEncode(show.toJson())).toList();
    await prefs.setStringList(_watchlistKey, textList);
  }
}
