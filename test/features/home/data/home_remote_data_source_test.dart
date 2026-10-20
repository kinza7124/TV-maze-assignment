import 'package:flutter_application_1/core/constants/api_constants.dart';
import 'package:flutter_application_1/core/network/api_client.dart';
import 'package:flutter_application_1/core/network/api_exception.dart';
import 'package:flutter_application_1/features/home/data/datasources/home_remote_data_source.dart';
import 'package:flutter_application_1/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../../helpers/mock_api.dart';
import '../../../helpers/test_data.dart';

void main() {
  group('HomeRemoteDataSource.getShows', () {
    test('converts the API list into ShowModels', () async {
      final dataSource = HomeRemoteDataSource(
        apiClient: mockApiClient({
          ApiConstants.shows(0): [
            breakingBadJson(),
            {'id': 2, 'name': 'Dark'},
          ],
        }),
      );

      final shows = await dataSource.getShows(0);

      expect(shows.map((s) => s.name), ['Breaking Bad', 'Dark']);
      expect(shows.first.rating, 9.2);
    });

    test('returns an empty list on 404 (no more pages)', () async {
      final dataSource = HomeRemoteDataSource(apiClient: mockApiClient({}));

      expect(await dataSource.getShows(999), isEmpty);
    });

    test('rethrows other API errors', () {
      final dataSource = HomeRemoteDataSource(
        apiClient: ApiClient(
          client: MockClient((request) async => http.Response('', 500)),
        ),
      );

      expect(dataSource.getShows(0), throwsA(isA<ApiException>()));
    });
  });

  test('HomeRepositoryImpl returns the shows from the data source', () async {
    final repository = HomeRepositoryImpl(
      remoteDataSource: HomeRemoteDataSource(
        apiClient: mockApiClient({
          ApiConstants.shows(1): [breakingBadJson()],
        }),
      ),
    );

    final shows = await repository.getShows(1);

    expect(shows.single.id, 169);
  });
}
