import 'package:flutter_application_1/core/constants/api_constants.dart';
import 'package:flutter_application_1/features/search/data/datasources/search_remote_data_source.dart';
import 'package:flutter_application_1/features/search/data/models/person_model.dart';
import 'package:flutter_application_1/features/search/data/repositories/search_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mock_api.dart';
import '../../../helpers/test_data.dart';

void main() {
  group('PersonModel.fromJson', () {
    test('reads name, image, country and birthday', () {
      final person = PersonModel.fromJson({
        'id': 14245,
        'name': 'Bryan Cranston',
        'image': {'medium': 'bryan.jpg'},
        'country': {'name': 'United States'},
        'birthday': '1956-03-07',
      });

      expect(person.id, 14245);
      expect(person.name, 'Bryan Cranston');
      expect(person.imageUrl, 'bryan.jpg');
      expect(person.country, 'United States');
      expect(person.birthday, '1956-03-07');
    });

    test('handles missing data', () {
      final person = PersonModel.fromJson({'id': 1});

      expect(person.name, 'Unknown');
      expect(person.imageUrl, isNull);
      expect(person.country, isNull);
    });
  });

  group('SearchRemoteDataSource', () {
    final dataSource = SearchRemoteDataSource(
      apiClient: mockApiClient({
        // The search API wraps every result: { "score": ..., "show": {...} }
        ApiConstants.searchShows('breaking'): [
          {'score': 0.9, 'show': breakingBadJson()},
        ],
        ApiConstants.searchShows('zzzz'): <Object>[],
        ApiConstants.searchPeople('bryan'): [
          {
            'score': 0.8,
            'person': {'id': 14245, 'name': 'Bryan Cranston'},
          },
        ],
      }),
    );

    test('searchShows reads the "show" object of each result', () async {
      final shows = await dataSource.searchShows('breaking');
      expect(shows.single.name, 'Breaking Bad');
    });

    test('searchShows returns an empty list when nothing is found', () async {
      expect(await dataSource.searchShows('zzzz'), isEmpty);
    });

    test('searchPeople reads the "person" object of each result', () async {
      final people = await dataSource.searchPeople('bryan');
      expect(people.single.name, 'Bryan Cranston');
    });
  });

  test('SearchRepositoryImpl passes the query to the data source', () async {
    final repository = SearchRepositoryImpl(
      remoteDataSource: SearchRemoteDataSource(
        apiClient: mockApiClient({
          ApiConstants.searchShows('breaking'): [
            {'score': 0.9, 'show': breakingBadJson()},
          ],
        }),
      ),
    );

    final shows = await repository.searchShows('breaking');

    expect(shows.single.id, 169);
  });
}
