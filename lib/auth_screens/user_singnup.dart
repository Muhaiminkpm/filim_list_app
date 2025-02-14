import 'dart:developer';

import 'package:filim_list_app/Home/home_screen.dart';
import 'package:filim_list_app/auth_screens/auth_options.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

class SignupController extends StatefulWidget {
  const SignupController({super.key});

  @override
  State<SignupController> createState() => _SignupControllerState();
}

class _SignupControllerState extends State<SignupController> {
  final _authServise = AuthService();
  final _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UseTextFormField(
                cammandText: 'Enter Valid Name',
                hintText: 'Enter Username',
                textController: _username,
              ),
              SizedBox(height: 20),
              UseTextFormField(
                cammandText: 'Enter Valid Email',
                hintText: 'Enter Email',
                textController: _email,
              ),
              SizedBox(height: 20),
              UseTextFormField(
                cammandText: 'Enter Valid Password',
                hintText: 'Enter Password',
                textController: _password,
              ),
              SizedBox(height: 20),
              UseElevated(
                  name: 'SignUp',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print(_email.text);
                      print(_password.text);
                      var user = await _authServise.signUp(
                          _email.text, _password.text);
                      if (user != null) {
                        log("User Created Successfully");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      }
                    }
                  },
                  )
            ],
          ),
        ),
      ),
    );
  }
}
