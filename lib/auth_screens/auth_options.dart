import 'package:filim_list_app/Home/favorites_movie.dart';
import 'package:filim_list_app/auth_screens/user_login.dart';
import 'package:filim_list_app/auth_screens/user_singnup.dart';
import 'package:flutter/material.dart';
import '../Home/home_screen.dart';

class AuthOptions extends StatefulWidget {
  const AuthOptions({super.key});

  @override
  State<AuthOptions> createState() => _AuthOptions();
}

class _AuthOptions extends State<AuthOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UseElevated(
                  name: 'Login',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserLogin()));
                  },
                 ),
              SizedBox(height: 20),
              UseElevated(
                  name: 'SignUp',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupController()));
                  },
                  ),
              SizedBox(height: 20),
              UseElevated(
                  name: 'Sign With Google',
                  onPressed: () {},
                 ),
              SizedBox(height: 20),
              UseElevated(
                  name: 'set',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                 ),
              SizedBox(height: 20),
              UseElevated(
                  name: 'Favorite',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoriteMovies()));
                  },
                 )
            ],
          ),
        ),
      ),
    );
  }
}

class UseElevated extends StatelessWidget {
  final String name;
  final Function() onPressed;
  const UseElevated({
    required this.name,
    required this.onPressed,
    
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            fixedSize: const Size(250, 40),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        onPressed: onPressed,
        child: Text(name,style: TextStyle(
          color: Colors.black
        ),));
  }
}

class UseTextFormField extends StatelessWidget {
  final String cammandText;
  final String hintText;
  final TextEditingController textController;
  const UseTextFormField({
    required this.cammandText,
    required this.hintText,
    required this.textController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      validator: (value) => value!.isEmpty ? cammandText : null,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
