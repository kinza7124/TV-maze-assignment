import '../../../../core/entities/show.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

/// REPOSITORY IMPLEMENTATION (data layer).
/// Gets the data from the remote data source.
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Show>> getShows(int page) {
    return remoteDataSource.getShows(page);
  }
}
