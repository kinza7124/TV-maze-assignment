import 'package:equatable/equatable.dart';

/// One actor and the character they play.
class CastMember extends Equatable {
  final String personName;
  final String characterName;
  final String? imageUrl;

  const CastMember({
    required this.personName,
    required this.characterName,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [personName, characterName];
}
