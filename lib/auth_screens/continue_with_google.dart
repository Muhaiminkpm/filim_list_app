import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Home/home_screen.dart';
import 'auth_service.dart';

class ContinueWithGoogle extends StatefulWidget {
  const ContinueWithGoogle({super.key});

  @override
  State<ContinueWithGoogle> createState() => _ContinueWithGoogleState();
}

class _ContinueWithGoogleState extends State<ContinueWithGoogle> {
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final user = await _authService.signInWithGoogle();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/google_logo.png', // ഗൂഗിൾ ലോഗോ ആസറ്റ് ഫോൾഡറിൽ ചേർക്കണം
                height: 24,
              ),
              SizedBox(width: 12),
              Text('Continue with Google'),
            ],
          ),
        ),
      ),
    );
  }
}