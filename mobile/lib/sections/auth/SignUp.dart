import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../global/consts.dart';
import '../../utilities/dialogs.dart';

class SignUp extends StatefulWidget {
  Function? toggleDisp;
  SignUp({Key? key, required this.toggleDisp}) : super(key: key);
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  final double _gap = 20;

  void _handleToggle() {
    widget.toggleDisp!();
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void handleSignUp() async {
    if (_confirmPasswordController.value != _passwordController.value) {
      alertDialog("Warning Message",
          "Password and confirm password should be same", context);
      return;
    }
    try {
      var response = await http.Client()
          .post(Uri.parse("${serverURL}/user/auth/register"), body: {
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
      });
      if (response.statusCode >= 200 && response.statusCode < 300) {
        ;
        _handleToggle();
      } else {
        Map body = jsonDecode(response.body);
        String errorMsg = "Unknown Error";

        if (body.containsKey("message")) errorMsg = body['message'];

        alertDialog("Error Message", errorMsg, context);
      }
    } catch (err) {
      alertDialog("Network Error", "Unable to send request", context);
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: _gap * 2,
        ),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: "Enter your Name"),
        ),
        SizedBox(
          height: _gap,
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
          height: _gap,
        ),
        TextField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(labelText: "Re-Enter your password"),
        ),
        SizedBox(
          height: _gap * (3 / 4),
        ),
        ElevatedButton(onPressed: () => handleSignUp(), child: Text("Sign UP")),
        SizedBox(
          height: _gap * (3 / 2),
        ),
        Text('Already have an account'),
        GestureDetector(
          onTap: _handleToggle,
          child: Text(
            "Click here to login",
            style: TextStyle(color: Colors.blue),
          ),
        )
      ],
    );
  }
}
