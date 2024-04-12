import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utilities/secure_storage.dart';

class SignIn extends StatefulWidget {
  Function? toggleDisp;
  SignIn({Key? key, required this.toggleDisp}) : super(key: key);
  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  final double _gap = 20;

  void alertDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _handleToggle() {
    widget.toggleDisp!();
  }

  void handleSignIn() async {
    try {
      var response = await http.Client()
          .post(Uri.parse("http://192.168.29.82:4000/user/auth/login"), body: {
        "email": _emailController.text,
        "password": _passwordController.text,
      });
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map data = jsonDecode(response.body);
        await setKey("token", data['token']);
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (err) {
      print(err);
      alertDialog("Error", "Error in login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Sign In",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: _gap * 2,
        ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: "Enter your email"),
        ),
        SizedBox(
          height: _gap,
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: "Enter your password"),
        ),
        SizedBox(
          height: _gap * (3 / 4),
        ),
        ElevatedButton(
            onPressed: () {
              handleSignIn();
            },
            child: Text("Sign In")),
        SizedBox(
          height: _gap * (3 / 2),
        ),
        Text('New to SafeSprout'),
        GestureDetector(
          onTap: _handleToggle,
          child: Text(
            "Click here to register",
            style: TextStyle(color: Colors.blue),
          ),
        )
      ],
    );
  }
}
