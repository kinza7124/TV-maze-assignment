/// All TVMaze API URLs live in one place.
/// If the API changes, we only update this file.
class ApiConstants {
  static const String baseUrl = 'https://api.tvmaze.com';

  /// Get TV Shows / Load More Shows (page = 0, 1, 2 ...)
  static String shows(int page) => '$baseUrl/shows?page=$page';

  /// Search Shows (example: q=dark)
  static String searchShows(String query) =>
      '$baseUrl/search/shows?q=${Uri.encodeQueryComponent(query)}';

  /// Search People (example: q=bryan)
  static String searchPeople(String query) =>
      '$baseUrl/search/people?q=${Uri.encodeQueryComponent(query)}';

  /// Show Details (example: /shows/82)
  static String showDetails(int showId) => '$baseUrl/shows/$showId';

  /// Show Cast (example: /shows/82/cast)
  static String showCast(int showId) => '$baseUrl/shows/$showId/cast';

  /// Show Episodes (example: /shows/82/episodes)
  static String showEpisodes(int showId) => '$baseUrl/shows/$showId/episodes';
}
