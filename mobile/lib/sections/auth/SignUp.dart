import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  TextEditingController _nameController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void handleSignUp() async {
    if (_confirmPasswordController.value != _passwordController.value) {
      alertDialog(
          "Warning Message", "Password and confirm password should be same");
      return;
    }
    try {
      var response = await http.Client().post(
          Uri.parse("http://192.168.29.82:4000/user/auth/register"),
          body: {
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

        alertDialog("Error Message", errorMsg);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error Message"),
              content: Text(errorMsg),
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
    } catch (err) {
      alertDialog("Network Error", "Unable to send request");
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
