import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/favorite_model.dart';


class FavoriteMovies extends StatefulWidget {
  const FavoriteMovies({super.key});

  @override
  State<FavoriteMovies> createState() => _FavoriteMoviesState();
}

class _FavoriteMoviesState extends State<FavoriteMovies> {
  final Box<MovieModel> _favoritesBox = Hive.box<MovieModel>('favoritesBox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: _favoritesBox.isEmpty
          ? const Center(child: Text('No favorite movies yet.'))
          : ListView.builder(
              itemCount: _favoritesBox.length,
              itemBuilder: (context, index) {
                final movie = _favoritesBox.getAt(index);
                return ListTile(
                  leading: Image.network(
                    'https://image.tmdb.org/t/p/original${movie!.posterPath}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie.title),
                  subtitle: Text('Rating: ${movie.voteAverage}'),
                );
              },
            ),
    );
  }
}