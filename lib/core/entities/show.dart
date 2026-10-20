import 'package:equatable/equatable.dart';

/// ENTITY: the plain TV show object our app works with.
/// It has no JSON code. It is shared by all features
/// (home, search, details, watchlist), so it lives in core.
class Show extends Equatable {
  final int id;
  final String name;
  final String? imageUrl; // small poster
  final String? originalImageUrl; // big poster
  final List<String> genres;
  final double? rating;
  final String summary;
  final String? premiered; // "2008-01-20"
  final String? ended; // "2013-09-29"
  final String? status; // "Running" / "Ended"
  final String? language;
  final String? network;

  const Show({
    required this.id,
    required this.name,
    this.imageUrl,
    this.originalImageUrl,
    this.genres = const [],
    this.rating,
    this.summary = '',
    this.premiered,
    this.ended,
    this.status,
    this.language,
    this.network,
  });

  /// "2008 - 2013", "2019 - Present" or "2019"
  String get yearRange {
    if (premiered == null || premiered!.length < 4) return 'Unknown year';
    final start = premiered!.substring(0, 4);

    if (ended != null && ended!.length >= 4) {
      final end = ended!.substring(0, 4);
      return start == end ? start : '$start - $end';
    }
    if (status == 'Running') return '$start - Present';
    return start;
  }

  /// "Drama, Crime, Thriller"
  String get genresText => genres.isEmpty ? 'Unknown genre' : genres.join(', ');

  /// Two shows are equal if they have the same id.
  @override
  List<Object?> get props => [id];
}
