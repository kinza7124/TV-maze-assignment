import 'package:equatable/equatable.dart';

/// A person (actor / crew) found by the People search.
class Person extends Equatable {
  final int id;
  final String name;
  final String? imageUrl;
  final String? country;
  final String? birthday; // "1956-03-07"

  const Person({
    required this.id,
    required this.name,
    this.imageUrl,
    this.country,
    this.birthday,
  });

  @override
  List<Object?> get props => [id];
}
