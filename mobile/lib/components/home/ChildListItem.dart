import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../global/consts.dart';
import "../../utilities/secure_storage.dart";

class ChildListItem extends StatefulWidget {
  late String id;
  ChildListItem({required this.id});

  @override
  _ChildListItem createState() => _ChildListItem();
}

class _ChildListItem extends State<ChildListItem> {
  @override
  _ChildListItem() {
    getDetails();
  }

  String status = "- -";
  String distance = "- -";
  String name = "- -";

  bool live = false;
  bool tracking = false;
  bool safe = false;

  //green Color.fromARGB(255, 107, 255, 112)
  //red Color.fromARGB(255, 253, 116, 106)
  //grey Color.fromARGB(255, 191, 191, 191)
  //purple Color.fromARGB(255, 236, 125, 255)

  Color setBgColor(tracking, live, safe) {
    return (tracking)
        ? (live
            ? (safe
                ? Color.fromARGB(255, 107, 255, 112)
                : Color.fromARGB(255, 253, 116, 106))
            : Color.fromARGB(255, 236, 125, 255))
        : Color.fromARGB(255, 191, 191, 191);
  }

  String setStatus(tracking, live, safe) {
    return (tracking)
        ? (live ? (safe ? "safe" : "off route") : "offline")
        : "Not tracking";
  }

  Future<void> getDetails() async {
    print("called hello");
    try {
      var token = await getKey("token") ?? "";
      var response = await http.Client().get(
        Uri.parse("$serverURL/child/info?id=${widget.id}"),
        headers: {"Authorization": token},
      );
      Map data = jsonDecode(response.body);
      setState(() {
        live = data['info']['live'];
        tracking = data['info']['tracking'];
        safe = true;
        name = data['info']['name'];
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: setBgColor(tracking, live, safe),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "Child: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Distance: ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            distance,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Row(
                        children: [
                          Text(
                            "Status: ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            setStatus(tracking, live, safe),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Center(
              child: Icon(
                Icons.location_on_rounded,
                size: 35,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}
