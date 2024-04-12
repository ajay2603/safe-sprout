import 'package:flutter/material.dart';
import '../sections/auth/SignUp.dart';
import '../sections/auth/SignIn.dart';

class Auth extends StatefulWidget {
  @override
  _Auth createState() => _Auth();
}

class _Auth extends State<Auth> {
  bool _dispSignIn = true;

  void _toggleDisp() {
    setState(() {
      _dispSignIn = !_dispSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: _dispSignIn
              ? SignIn(
                  toggleDisp: _toggleDisp,
                )
              : SignUp(
                  toggleDisp: _toggleDisp,
                ),
        ),
      ),
    );
  }
}
