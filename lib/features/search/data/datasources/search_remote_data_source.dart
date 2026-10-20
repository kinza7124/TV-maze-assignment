import '../../../../core/constants/api_constants.dart';
import '../../../../core/models/show_model.dart';
import '../../../../core/network/api_client.dart';
import '../models/person_model.dart';

/// DATA SOURCE: calls the TVMaze search APIs.
class SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSource({required this.apiClient});

  /// GET https://api.tvmaze.com/search/shows?q=dark
  /// The API returns: [ { "score": 0.9, "show": { ... } }, ... ]
  Future<List<ShowModel>> searchShows(String query) async {
    final data = await apiClient.get(ApiConstants.searchShows(query)) as List;
    return data
        .map((item) => ShowModel.fromJson(item['show'] as Map<String, dynamic>))
        .toList();
  }

  /// GET https://api.tvmaze.com/search/people?q=bryan
  /// The API returns: [ { "score": 0.5, "person": { ... } }, ... ]
  Future<List<PersonModel>> searchPeople(String query) async {
    final data = await apiClient.get(ApiConstants.searchPeople(query)) as List;
    return data
        .map(
          (item) =>
              PersonModel.fromJson(item['person'] as Map<String, dynamic>),
        )
        .toList();
  }
}
