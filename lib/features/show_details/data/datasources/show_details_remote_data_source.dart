import '../../../../core/constants/api_constants.dart';
import '../../../../core/models/show_model.dart';
import '../../../../core/network/api_client.dart';
import '../models/cast_member_model.dart';
import '../models/episode_model.dart';

/// DATA SOURCE: calls the 3 details APIs.
class ShowDetailsRemoteDataSource {
  final ApiClient apiClient;

  ShowDetailsRemoteDataSource({required this.apiClient});

  /// GET /shows/82
  Future<ShowModel> getShowDetails(int showId) async {
    final data = await apiClient.get(ApiConstants.showDetails(showId));
    return ShowModel.fromJson(data as Map<String, dynamic>);
  }

  /// GET /shows/82/cast
  Future<List<CastMemberModel>> getCast(int showId) async {
    final data = await apiClient.get(ApiConstants.showCast(showId)) as List;
    return data
        .map((json) => CastMemberModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// GET /shows/82/episodes
  Future<List<EpisodeModel>> getEpisodes(int showId) async {
    final data = await apiClient.get(ApiConstants.showEpisodes(showId)) as List;
    return data
        .map((json) => EpisodeModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
