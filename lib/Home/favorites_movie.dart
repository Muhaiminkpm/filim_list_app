import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../firebase_firestore/firestore_service.dart';
import '../hive/favorite_model.dart';

class FavoriteMovies extends StatefulWidget {
  const FavoriteMovies({super.key});

  @override
  State<FavoriteMovies> createState() => _FavoriteMoviesState();
}

class _FavoriteMoviesState extends State<FavoriteMovies> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Box<MovieModel> _favoritesBox = Hive.box<MovieModel>('favoritesBox');
  void initState() {
    super.initState();
    _syncFavoritesWithFirestore();
  }

  // Sync local Hive data with Firestore
  Future<void> _syncFavoritesWithFirestore() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Fetch favorite movies from Firestore
      final firestoreFavorites =
          await _firestoreService.getFavoriteMovies(user.uid);

      // Add Firestore favorites to Hive if they don't exist
      for (final movie in firestoreFavorites) {
        if (!_favoritesBox.containsKey(movie.id)) {
          _favoritesBox.put(movie.id, movie);
        }
      }

      // Upload local Hive favorites to Firestore
      for (final movie in _favoritesBox.values) {
        await _firestoreService.addFavoriteMovie(user.uid, movie);
      }
    }
  }

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
