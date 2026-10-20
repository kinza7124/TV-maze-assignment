import '../../../../core/constants/api_constants.dart';
import '../../../../core/models/show_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';

/// DATA SOURCE: talks to the TVMaze API and returns models.
class HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSource({required this.apiClient});

  /// GET https://api.tvmaze.com/shows?page=0
  Future<List<ShowModel>> getShows(int page) async {
    try {
      final data = await apiClient.get(ApiConstants.shows(page)) as List;
      return data
          .map((json) => ShowModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on ApiException catch (e) {
      // TVMaze returns 404 when there are no more pages.
      if (e.statusCode == 404) return [];
      rethrow;
    }
  }
}
