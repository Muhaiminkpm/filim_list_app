import 'package:filim_list_app/Home/home_screen.dart';
import 'package:filim_list_app/auth_screens/auth_options.dart';
import 'package:filim_list_app/auth_screens/auth_service.dart';
import 'package:flutter/material.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  final _authServise = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UseTextFormField(
                  cammandText: 'Enter valid name',
                  hintText: 'User Name',
                  textController: _email,
                ),
                SizedBox(height: 20),
                UseTextFormField(
                  cammandText: 'Enter valid password',
                  hintText: 'Enter Password',
                  textController: _password,
                ),
                SizedBox(height: 20),
                UseElevated(
                    name: 'Login',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        print(_email.text);
                        print(_password.text);
                        var user = await _authServise.signIn(
                            _email.text, _password.text);
                        if (user != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomeScreen()));
                          ;
                        }
                      }
                    },
                    selectColor: Colors.green)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
