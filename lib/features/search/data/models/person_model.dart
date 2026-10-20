import '../../domain/entities/person.dart';

class PersonModel extends Person {
  const PersonModel({
    required super.id,
    required super.name,
    super.imageUrl,
    super.country,
    super.birthday,
  });

  /// API item: { "id", "name", "image": {...}, "country": { "name" }, "birthday" }
  factory PersonModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'] as Map<String, dynamic>?;
    final country = json['country'] as Map<String, dynamic>?;

    return PersonModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unknown',
      imageUrl: image?['medium'] as String?,
      country: country?['name'] as String?,
      birthday: json['birthday'] as String?,
    );
  }
}
