import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global/consts.dart';
import '../utilities/secure_storage.dart';

class NewChild extends StatefulWidget {
  @override
  _NewChild createState() => _NewChild();
}

class _NewChild extends State<NewChild> {
  TextEditingController _nameController = TextEditingController();

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

  void goBack() {
    Navigator.pop(context);
  }

  void alertActionDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              child: Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
                _nameController.text = "";
              },
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  goBack();
                },
                child: Text("Back to Home"))
          ],
        );
      },
    );
  }

  void createChild() async {
    String token = await getKey("token") ?? "";
    try {
      var response = await http.Client().post(
          Uri.parse("${serverURL}/child/new-child"),
          body: {'name': _nameController.text},
          headers: {"Authorization": token});
      Map result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        alertActionDialog("Ok", result["message"]);
      } else {
        alertDialog("Error", result["message"]);
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Child"),
        centerTitle: false,
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration:
                  InputDecoration(labelText: "Give a name to the child"),
            ),
            ElevatedButton(
              onPressed: () => createChild(),
              child: Text("Add the child"),
            ),
          ],
        ),
      )),
    );
  }
}
