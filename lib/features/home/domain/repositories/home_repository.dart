import '../../../../core/entities/show.dart';

/// REPOSITORY CONTRACT (domain layer).
/// The BLoC only knows this abstract class, not where data comes from.
abstract class HomeRepository {
  Future<List<Show>> getShows(int page);
}
