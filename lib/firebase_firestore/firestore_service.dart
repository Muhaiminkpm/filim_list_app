import 'package:cloud_firestore/cloud_firestore.dart';
import '../hive/favorite_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a favorite movie to Firestore
  Future<void> addFavoriteMovie(String userId, MovieModel movie) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(movie.id.toString())
        .set({
      'id': movie.id,
      'title': movie.title,
      'posterPath': movie.posterPath,
      'voteAverage': movie.voteAverage,
    });
  }

  // Remove a favorite movie from Firestore
  Future<void> removeFavoriteMovie(String userId, int movieId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(movieId.toString())
        .delete();
  }

  // Fetch favorite movies from Firestore
  Future<List<MovieModel>> getFavoriteMovies(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    return snapshot.docs.map((doc) {
      return MovieModel(
        id: doc['id'],
        title: doc['title'],
        posterPath: doc['posterPath'],
        voteAverage: doc['voteAverage'],
      );
    }).toList();
  }
}