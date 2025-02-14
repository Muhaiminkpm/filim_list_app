import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'auth_screens/user_login.dart';
import 'hive/favorite_model.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  Hive.registerAdapter(MovieModelAdapter());
  await Hive.openBox<MovieModel>('favoritesBox');
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);

// Ideal time to initialize
// Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//...

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: UserLogin(),
    );
  }
}
