import 'package:hive/hive.dart';

part 'favorite_model.g.dart';

@HiveType(typeId: 0)
class MovieModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String posterPath;

  @HiveField(3)
  final double voteAverage;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
  });
}
