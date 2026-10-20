import 'package:flutter_application_1/core/entities/show.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Show.yearRange', () {
    test('shows start and end year for an ended show', () {
      const show = Show(
        id: 1,
        name: 'A',
        premiered: '2008-01-20',
        ended: '2013-09-29',
      );
      expect(show.yearRange, '2008 - 2013');
    });

    test('shows "Present" for a running show', () {
      const show = Show(
        id: 1,
        name: 'A',
        premiered: '2019-05-01',
        status: 'Running',
      );
      expect(show.yearRange, '2019 - Present');
    });

    test('shows one year when start and end are the same', () {
      const show = Show(
        id: 1,
        name: 'A',
        premiered: '2015-01-01',
        ended: '2015-12-01',
      );
      expect(show.yearRange, '2015');
    });

    test('shows only the start year when the end is unknown', () {
      const show = Show(
        id: 1,
        name: 'A',
        premiered: '2010-01-01',
        status: 'Ended',
      );
      expect(show.yearRange, '2010');
    });

    test('shows "Unknown year" when the premiere date is missing', () {
      const show = Show(id: 1, name: 'A');
      expect(show.yearRange, 'Unknown year');
    });
  });

  group('Show.genresText', () {
    test('joins genres with commas', () {
      const show = Show(id: 1, name: 'A', genres: ['Drama', 'Crime']);
      expect(show.genresText, 'Drama, Crime');
    });

    test('shows "Unknown genre" when there are no genres', () {
      const show = Show(id: 1, name: 'A');
      expect(show.genresText, 'Unknown genre');
    });
  });

  test('two shows with the same id are equal (Equatable)', () {
    const a = Show(id: 7, name: 'Old name');
    const b = Show(id: 7, name: 'New name');
    expect(a, equals(b));
  });
}
