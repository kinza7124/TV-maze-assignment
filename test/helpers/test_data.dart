import 'package:flutter_application_1/core/entities/show.dart';
import 'package:flutter_application_1/features/search/domain/entities/person.dart';
import 'package:flutter_application_1/features/show_details/domain/entities/cast_member.dart';
import 'package:flutter_application_1/features/show_details/domain/entities/episode.dart';

/// Sample data shared by all tests.
/// (Only used in tests - the app itself never uses hardcoded shows.)

const breakingBad = Show(
  id: 169,
  name: 'Breaking Bad',
  genres: ['Drama', 'Crime', 'Thriller'],
  rating: 9.2,
  summary: 'A chemistry teacher becomes a drug dealer.',
  premiered: '2008-01-20',
  ended: '2013-09-29',
  status: 'Ended',
  language: 'English',
  network: 'AMC',
);

const dark = Show(id: 17861, name: 'Dark', genres: ['Drama'], rating: 8.7);

const firefly = Show(id: 180, name: 'Firefly', genres: ['Drama'], rating: 8.9);

const bryan = Person(id: 14245, name: 'Bryan Cranston', country: 'United States');

const castList = [
  CastMember(personName: 'Bryan Cranston', characterName: 'Walter White'),
  CastMember(personName: 'Aaron Paul', characterName: 'Jesse Pinkman'),
];

const episodeList = [
  Episode(id: 1, name: 'Pilot', season: 1, number: 1),
  Episode(id: 2, name: "Cat's in the Bag...", season: 1, number: 2),
  Episode(id: 3, name: 'Seven Thirty-Seven', season: 2, number: 1),
];

/// One show exactly as the TVMaze API sends it (GET /shows/169).
Map<String, dynamic> breakingBadJson() => {
  'id': 169,
  'name': 'Breaking Bad',
  'genres': ['Drama', 'Crime', 'Thriller'],
  'status': 'Ended',
  'premiered': '2008-01-20',
  'ended': '2013-09-29',
  'language': 'English',
  'rating': {'average': 9.2},
  'network': {'name': 'AMC'},
  'webChannel': null,
  'image': {'medium': 'medium.jpg', 'original': 'original.jpg'},
  'summary': '<p><b>Breaking Bad</b> is a show.</p>',
};
