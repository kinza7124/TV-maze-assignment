import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/network/api_client.dart';

Future<void> main() async {
  // Web only: use normal URLs (localhost/abc) instead of hash URLs
  // (localhost/#/abc), so unknown paths reach our 404 page.
  // On Android/iOS this line does nothing.
  usePathUrlStrategy();

  // Needed because we use a plugin (SharedPreferences) before runApp.
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final apiClient = ApiClient();

  runApp(TvMazeApp(apiClient: apiClient, prefs: prefs));
}
