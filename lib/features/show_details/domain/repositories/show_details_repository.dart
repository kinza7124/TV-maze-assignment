import '../../../../core/entities/show.dart';
import '../entities/cast_member.dart';
import '../entities/episode.dart';

/// REPOSITORY CONTRACT for one show's details, cast and episodes.
abstract class ShowDetailsRepository {
  Future<Show> getShowDetails(int showId);
  Future<List<CastMember>> getCast(int showId);
  Future<List<Episode>> getEpisodes(int showId);
}
