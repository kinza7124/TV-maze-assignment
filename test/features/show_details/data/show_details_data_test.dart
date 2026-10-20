import 'package:flutter_application_1/core/constants/api_constants.dart';
import 'package:flutter_application_1/core/network/api_exception.dart';
import 'package:flutter_application_1/features/show_details/data/datasources/show_details_remote_data_source.dart';
import 'package:flutter_application_1/features/show_details/data/models/cast_member_model.dart';
import 'package:flutter_application_1/features/show_details/data/models/episode_model.dart';
import 'package:flutter_application_1/features/show_details/data/repositories/show_details_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mock_api.dart';
import '../../../helpers/test_data.dart';

void main() {
  group('CastMemberModel.fromJson', () {
    test('reads the actor, character and photo', () {
      final member = CastMemberModel.fromJson({
        'person': {
          'name': 'Bryan Cranston',
          'image': {'medium': 'bryan.jpg'},
        },
        'character': {'name': 'Walter White'},
      });

      expect(member.personName, 'Bryan Cranston');
      expect(member.characterName, 'Walter White');
      expect(member.imageUrl, 'bryan.jpg');
    });

    test('uses "Unknown" when names are missing', () {
      final member = CastMemberModel.fromJson({});

      expect(member.personName, 'Unknown');
      expect(member.characterName, 'Unknown');
      expect(member.imageUrl, isNull);
    });
  });

  group('EpisodeModel.fromJson', () {
    test('reads the episode and removes HTML from the summary', () {
      final episode = EpisodeModel.fromJson({
        'id': 12192,
        'name': 'Pilot',
        'season': 1,
        'number': 1,
        'airdate': '2008-01-20',
        'image': {'medium': 'pilot.jpg'},
        'summary': '<p>Walter gets bad news.</p>',
      });

      expect(episode.name, 'Pilot');
      expect(episode.season, 1);
      expect(episode.number, 1);
      expect(episode.airdate, '2008-01-20');
      expect(episode.imageUrl, 'pilot.jpg');
      expect(episode.summary, 'Walter gets bad news.');
    });

    test('handles a special episode with no number and no name', () {
      final episode = EpisodeModel.fromJson({'id': 5, 'season': 2});

      expect(episode.name, 'Untitled episode');
      expect(episode.number, isNull);
      expect(episode.summary, '');
    });
  });

  group('ShowDetailsRemoteDataSource + repository', () {
    final repository = ShowDetailsRepositoryImpl(
      remoteDataSource: ShowDetailsRemoteDataSource(
        apiClient: mockApiClient({
          ApiConstants.showDetails(169): breakingBadJson(),
          ApiConstants.showCast(169): [
            {
              'person': {'name': 'Aaron Paul'},
              'character': {'name': 'Jesse Pinkman'},
            },
          ],
          ApiConstants.showEpisodes(169): [
            {'id': 1, 'name': 'Pilot', 'season': 1, 'number': 1},
            {'id': 2, 'name': 'Episode 2', 'season': 1, 'number': 2},
          ],
        }),
      ),
    );

    test('getShowDetails returns the show', () async {
      final show = await repository.getShowDetails(169);
      expect(show.name, 'Breaking Bad');
    });

    test('getCast returns the cast list', () async {
      final cast = await repository.getCast(169);
      expect(cast.single.characterName, 'Jesse Pinkman');
    });

    test('getEpisodes returns the episodes', () async {
      final episodes = await repository.getEpisodes(169);
      expect(episodes.map((e) => e.name), ['Pilot', 'Episode 2']);
    });

    test('throws ApiException for a show that does not exist', () {
      expect(repository.getShowDetails(1), throwsA(isA<ApiException>()));
    });
  });
}
