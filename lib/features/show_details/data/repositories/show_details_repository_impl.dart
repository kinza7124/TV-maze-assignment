import '../../../../core/entities/show.dart';
import '../../domain/entities/cast_member.dart';
import '../../domain/entities/episode.dart';
import '../../domain/repositories/show_details_repository.dart';
import '../datasources/show_details_remote_data_source.dart';

class ShowDetailsRepositoryImpl implements ShowDetailsRepository {
  final ShowDetailsRemoteDataSource remoteDataSource;

  ShowDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Show> getShowDetails(int showId) {
    return remoteDataSource.getShowDetails(showId);
  }

  @override
  Future<List<CastMember>> getCast(int showId) {
    return remoteDataSource.getCast(showId);
  }

  @override
  Future<List<Episode>> getEpisodes(int showId) {
    return remoteDataSource.getEpisodes(showId);
  }
}
