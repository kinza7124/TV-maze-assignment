import '../../domain/entities/cast_member.dart';

class CastMemberModel extends CastMember {
  const CastMemberModel({
    required super.personName,
    required super.characterName,
    super.imageUrl,
  });

  /// API item: { "person": { "name", "image" }, "character": { "name" } }
  factory CastMemberModel.fromJson(Map<String, dynamic> json) {
    final person = json['person'] as Map<String, dynamic>? ?? {};
    final character = json['character'] as Map<String, dynamic>? ?? {};
    final image = person['image'] as Map<String, dynamic>?;

    return CastMemberModel(
      personName: person['name'] as String? ?? 'Unknown',
      characterName: character['name'] as String? ?? 'Unknown',
      imageUrl: image?['medium'] as String?,
    );
  }
}
