import 'package:filim_list_app/auth_screens/auth_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../Api/search_movies.dart';
import '../auth_screens/auth_service.dart';
import '../firebase_firestore/firestore_service.dart';
import '../hive/favorite_model.dart';
import '../model/model_movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Movies> displayMovie;

  final _authService = AuthService();

  final Box<MovieModel> _favoritesBox = Hive.box<MovieModel>('favoritesBox');
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    displayMovie = fetchMovie(); // Ensure fetchMovie returns a Future<Movies>
  }

  void _toggleFavorite(MovieModel movie) async {
    final user = _auth.currentUser;
    if (user != null) {
      if (_favoritesBox.containsKey(movie.id)) {
        await _firestoreService.removeFavoriteMovie(user.uid, movie.id);
        _favoritesBox.delete(movie.id);
      } else {
        await _firestoreService.addFavoriteMovie(user.uid, movie);
        _favoritesBox.put(movie.id, movie);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Movies>(
              future: displayMovie,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data!.results.isEmpty) {
                  return const Center(child: Text('No results found.'));
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,

                      childAspectRatio: 0.4, // Adjust aspect ratio for layout
                    ),
                    itemCount: snapshot.data!.results.length,
                    itemBuilder: (context, index) {
                      final movie = snapshot.data!.results[index];
                      final movieModel = MovieModel(
                        id: movie.id,
                        title: movie.title,
                        posterPath: movie.posterPath,
                        voteAverage: movie.voteAverage,
                      );
                      final isFavorite = _favoritesBox.containsKey(movie.id);
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AspectRatio(
                              aspectRatio: 2 / 3,
                              child: Image.network(
                                'https://image.tmdb.org/t/p/original${movie.posterPath}',
                                //https://api.themoviedb.org/3/movie/now_playing
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                movie.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                'Rating: ${movie.voteAverage}',
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              ),
                              onPressed: () => _toggleFavorite(movieModel),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            child: const Text('Sign Out'),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthOptions()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
      ),
    );
  }
}
// rules_version = '2';

// service cloud.firestore {
//   match /databases/{database}/documents {
//     match /{document=**} {
//       allow read, write: if
//           request.time < timestamp.date(2025, 2, 21);
//     }
//   }
// }