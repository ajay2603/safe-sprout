import "dart:convert";

import "package:flutter/material.dart";
import "package:mobile/global/consts.dart";
import "package:mobile/utilities/childlocation.dart";
import "package:mobile/utilities/dialogs.dart";
import "package:mobile/utilities/secure_storage.dart";
import 'package:http/http.dart' as http;

class Tracking extends StatefulWidget {
  _Tracking createState() => _Tracking();
}

class _Tracking extends State<Tracking> {
  void goToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (Route<dynamic> route) => false,
    );
  }

  void validate() async {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Validate User"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Enter Password',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('cancle'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: Text('Continue'),
                onPressed: () async {
                  try {
                    String token = await getParentToken();
                    alertDialog("token", token, context);
                    setKey("token", token);
                    setKey("type", "parent");
                    stopBackgroundService();
                    goToHome();
                  } catch (err) {
                    alertDialog("Error", err.toString(), context);
                  }
                }),
          ],
        );
      },
    );
  }

  Future<String> getParentToken() async {
    String token = await getKey("token") ?? "";
    try {
      var response = await http.Client().post(
          Uri.parse("${serverURL}/user/auth/gen/token"),
          headers: {"Authorization": token});
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return result['token'];
      } else {
        throw Exception(result['message']);
      }
    } catch (err) {
      print(err);
      throw Exception("Network Error");
    }
  }

  void endTracking() {
    validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          Text("Tracking Page"),
          ElevatedButton(onPressed: endTracking, child: Text("Stop Tracking"))
        ]),
      ),
    );
  }
}
