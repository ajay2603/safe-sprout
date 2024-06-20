import 'package:flutter/material.dart';
import 'package:mobile/utilities/childlocation.dart';
import '../sections/auth/SignUp.dart';
import '../sections/auth/SignIn.dart';

class Auth extends StatefulWidget {
  @override
  _Auth createState() => _Auth();
}

class _Auth extends State<Auth> {
  bool _dispSignIn = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stopBackgroundService();
  }

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
