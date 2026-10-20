import '../entities/show.dart';
import '../utils/text_utils.dart';

/// MODEL: extends the Show entity and adds JSON conversion.
/// fromJson -> used when reading API data (and the saved watchlist).
/// toJson   -> used when saving the watchlist in SharedPreferences.
class ShowModel extends Show {
  const ShowModel({
    required super.id,
    required super.name,
    super.imageUrl,
    super.originalImageUrl,
    super.genres,
    super.rating,
    super.summary,
    super.premiered,
    super.ended,
    super.status,
    super.language,
    super.network,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    // These nested objects can be null, so we read them safely with "?".
    final image = json['image'] as Map<String, dynamic>?;
    final rating = json['rating'] as Map<String, dynamic>?;
    final network = json['network'] as Map<String, dynamic>?;
    final webChannel = json['webChannel'] as Map<String, dynamic>?;

    return ShowModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unknown show',
      imageUrl: image?['medium'] as String?,
      originalImageUrl: image?['original'] as String?,
      genres: List<String>.from(json['genres'] as List? ?? []),
      rating: (rating?['average'] as num?)?.toDouble(),
      summary: TextUtils.stripHtml(json['summary'] as String?),
      premiered: json['premiered'] as String?,
      ended: json['ended'] as String?,
      status: json['status'] as String?,
      language: json['language'] as String?,
      // Netflix-type shows have "webChannel" instead of "network".
      network: (network?['name'] ?? webChannel?['name']) as String?,
    );
  }

  /// Converts any Show entity into a ShowModel (so we can call toJson).
  factory ShowModel.fromEntity(Show show) {
    return ShowModel(
      id: show.id,
      name: show.name,
      imageUrl: show.imageUrl,
      originalImageUrl: show.originalImageUrl,
      genres: show.genres,
      rating: show.rating,
      summary: show.summary,
      premiered: show.premiered,
      ended: show.ended,
      status: show.status,
      language: show.language,
      network: show.network,
    );
  }

  /// Same shape as the API JSON, so fromJson can read it back.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': {'medium': imageUrl, 'original': originalImageUrl},
      'genres': genres,
      'rating': {'average': rating},
      'summary': summary,
      'premiered': premiered,
      'ended': ended,
      'status': status,
      'language': language,
      'network': {'name': network},
    };
  }
}
