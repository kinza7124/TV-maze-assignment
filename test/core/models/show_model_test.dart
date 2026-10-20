import 'package:flutter_application_1/core/models/show_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_data.dart';

void main() {
  group('ShowModel.fromJson', () {
    test('reads every field from the API json', () {
      final show = ShowModel.fromJson(breakingBadJson());

      expect(show.id, 169);
      expect(show.name, 'Breaking Bad');
      expect(show.genres, ['Drama', 'Crime', 'Thriller']);
      expect(show.rating, 9.2);
      expect(show.imageUrl, 'medium.jpg');
      expect(show.originalImageUrl, 'original.jpg');
      expect(show.status, 'Ended');
      expect(show.language, 'English');
      expect(show.network, 'AMC');
      expect(show.yearRange, '2008 - 2013');
    });

    test('removes HTML tags from the summary', () {
      final show = ShowModel.fromJson(breakingBadJson());
      expect(show.summary, 'Breaking Bad is a show.');
    });

    test('uses webChannel when network is missing (Netflix shows)', () {
      final json = breakingBadJson()
        ..['network'] = null
        ..['webChannel'] = {'name': 'Netflix'};

      expect(ShowModel.fromJson(json).network, 'Netflix');
    });

    test('reads an integer rating as a double', () {
      final json = breakingBadJson()..['rating'] = {'average': 8};
      expect(ShowModel.fromJson(json).rating, 8.0);
    });

    test('handles missing data without crashing', () {
      final show = ShowModel.fromJson({'id': 1});

      expect(show.name, 'Unknown show');
      expect(show.imageUrl, isNull);
      expect(show.rating, isNull);
      expect(show.genres, isEmpty);
      expect(show.summary, '');
      expect(show.network, isNull);
      expect(show.yearRange, 'Unknown year');
    });
  });

  group('ShowModel.toJson', () {
    test('toJson -> fromJson gives the same data (used by the watchlist)', () {
      final original = ShowModel.fromJson(breakingBadJson());
      final copy = ShowModel.fromJson(original.toJson());

      expect(copy.id, original.id);
      expect(copy.name, original.name);
      expect(copy.genres, original.genres);
      expect(copy.rating, original.rating);
      expect(copy.imageUrl, original.imageUrl);
      expect(copy.originalImageUrl, original.originalImageUrl);
      expect(copy.summary, original.summary);
      expect(copy.premiered, original.premiered);
      expect(copy.ended, original.ended);
      expect(copy.status, original.status);
      expect(copy.language, original.language);
      expect(copy.network, original.network);
    });

    test('fromEntity copies every field of a Show', () {
      final model = ShowModel.fromEntity(breakingBad);

      expect(model.id, breakingBad.id);
      expect(model.name, breakingBad.name);
      expect(model.genres, breakingBad.genres);
      expect(model.rating, breakingBad.rating);
      expect(model.network, breakingBad.network);
    });
  });
}
