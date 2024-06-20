import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/global/consts.dart';
import 'package:mobile/providers/ChildrenListProvider.dart';
import 'package:mobile/utilities/childlocation.dart';
import 'package:mobile/utilities/dialogs.dart';
import 'package:mobile/utilities/permisions.dart';
import 'package:mobile/utilities/secure_storage.dart';
import 'package:mobile/utilities/status.dart';
import 'package:http/http.dart' as http;

class ChildInfo extends StatefulWidget {
  late Child child;

  ChildInfo({required this.child});

  @override
  _Child createState() => _Child();
}

class _Child extends State<ChildInfo> {
  Future<bool> validateSession() async {
    String token = await getKey("token") ?? "";
    try {
      var response = await http.Client().post(
          Uri.parse("${serverURL}/user/auth/validate-pass"),
          body: {"password": _controller.text},
          headers: {"Authorization": token});
      print(response.body);
      if (response.statusCode != 200) {
        var result = jsonDecode(response.body);
        alertDialog("Error", result['message'], context);
        return false;
      } else
        return true;
    } catch (err) {
      print(err);
      retryDialog("Error", "Network Error", context, validateSession);
      return false;
    }
  }

  Future<String> getChildToken() async {
    String token = await getKey("token") ?? "";
    try {
      var response = await http.Client().post(
          Uri.parse("${serverURL}/child/gen/child-id"),
          body: {"id": widget.child.id},
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

  void goToTracking() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/tracking',
      (Route<dynamic> route) => false,
    );
  }

  void validate(BuildContext pageContext) async {
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
                var auth = await validateSession();
                if (auth) {
                  bool permision = await requestLocationPermisionChild(context);
                  if (permision) {
                    try {
                      var token = await getChildToken();
                      alertDialog("Token", token, context);
                      setKey("token", token);
                      startBackgroundService();
                      goToTracking();
                      Navigator.of(context).pop();
                      goToTracking();
                    } catch (err) {
                      retryDialog(
                          "Error", err.toString(), context, getChildToken);
                    }
                  } else {
                    alertDialog("Error",
                        "Unable to access the Location all the time", context);
                  }
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Safe Sprout"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding:
                  EdgeInsets.only(top: 10, left: 22, right: 20, bottom: 20),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: setBgColor(widget.child.tracking, widget.child.live,
                    widget.child.safe),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ID: ${widget.child.id}",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${widget.child.name}",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Status: ${setStatus(widget.child.tracking, widget.child.live, widget.child.safe)}",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => {validate(context)},
              child: Text("Track this device"),
            ),
          ],
        ),
      ),
    );
  }
}
