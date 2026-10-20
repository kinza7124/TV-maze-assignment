import '../../../../core/entities/show.dart';
import '../../domain/entities/person.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Show>> searchShows(String query) {
    return remoteDataSource.searchShows(query);
  }

  @override
  Future<List<Person>> searchPeople(String query) {
    return remoteDataSource.searchPeople(query);
  }
}
