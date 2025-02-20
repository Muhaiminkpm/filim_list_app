import 'package:filim_list_app/auth_screens/auth_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../Api/search_movies.dart';
import '../auth_screens/auth_service.dart';
import '../firebase_firestore/firestore_service.dart';
import '../hive/favorite_model.dart';
import '../model/model_movie.dart';
import '../widget/custom_bottom_navigation_bar.dart';
import 'favorites_movie.dart';
import 'movie_details.dart';

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

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    displayMovie = fetchMovie();
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

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Home - already on home screen
        break;
      case 1:
        // Navigate to Favorites
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoriteMovies()),
        );
        break;
      case 2:
        // Playlist - Add your playlist navigation logic here
        break;
      case 3:
        _showSignOutDialog();
        break;
    }
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthOptions()),
              );
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.sort)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Movies',
              style: TextStyle(fontSize: 32),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        'See all',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Icon(Icons.chevron_right, color: Colors.blue),
                    ],
                  ),
                ),
              ],
            ),
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.4,
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailsScreen(
                                  movie: movieModel,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AspectRatio(
                                  aspectRatio: 2 / 3,
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/original${movie.posterPath}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  movie.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Rating: ${movie.voteAverage}',
                                  style: const TextStyle(fontSize: 12.0),
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
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
