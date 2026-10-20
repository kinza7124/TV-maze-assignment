import '../../../../core/utils/text_utils.dart';
import '../../domain/entities/episode.dart';

class EpisodeModel extends Episode {
  const EpisodeModel({
    required super.id,
    required super.name,
    required super.season,
    super.number,
    super.airdate,
    super.imageUrl,
    super.summary,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'] as Map<String, dynamic>?;

    return EpisodeModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Untitled episode',
      season: json['season'] as int? ?? 0,
      number: json['number'] as int?,
      airdate: json['airdate'] as String?,
      imageUrl: image?['medium'] as String?,
      summary: TextUtils.stripHtml(json['summary'] as String?),
    );
  }
}
