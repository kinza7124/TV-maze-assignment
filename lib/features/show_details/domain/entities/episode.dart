import 'package:equatable/equatable.dart';

/// One episode of a show.
class Episode extends Equatable {
  final int id;
  final String name;
  final int season;
  final int? number; // special episodes have no number
  final String? airdate;
  final String? imageUrl;
  final String summary;

  const Episode({
    required this.id,
    required this.name,
    required this.season,
    this.number,
    this.airdate,
    this.imageUrl,
    this.summary = '',
  });

  @override
  List<Object?> get props => [id];
}
