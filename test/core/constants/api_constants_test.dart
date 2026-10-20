import 'package:flutter_application_1/core/constants/api_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('builds the endpoints from the assignment', () {
    expect(ApiConstants.shows(0), 'https://api.tvmaze.com/shows?page=0');
    expect(ApiConstants.shows(1), 'https://api.tvmaze.com/shows?page=1');
    expect(
      ApiConstants.searchShows('dark'),
      'https://api.tvmaze.com/search/shows?q=dark',
    );
    expect(ApiConstants.showDetails(82), 'https://api.tvmaze.com/shows/82');
    expect(ApiConstants.showCast(82), 'https://api.tvmaze.com/shows/82/cast');
    expect(
      ApiConstants.showEpisodes(82),
      'https://api.tvmaze.com/shows/82/episodes',
    );
  });

  test('encodes spaces and special characters in search queries', () {
    expect(
      ApiConstants.searchShows('breaking bad'),
      'https://api.tvmaze.com/search/shows?q=breaking+bad',
    );
    expect(
      ApiConstants.searchPeople('tom & jerry'),
      'https://api.tvmaze.com/search/people?q=tom+%26+jerry',
    );
  });
}
