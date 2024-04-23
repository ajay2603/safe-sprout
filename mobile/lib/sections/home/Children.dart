import 'dart:convert';

import "package:flutter/material.dart";
import 'package:mobile/providers/ChildrenListProvider.dart';
import '../../components/home/ChildListItem.dart';
import "package:http/http.dart" as http;
import '../../global/consts.dart';
import '../../utilities/secure_storage.dart';
import '../../utilities/dialogs.dart';
import 'package:provider/provider.dart';

class Children extends StatefulWidget {
  @override
  _Children createState() => _Children();
}

class _Children extends State<Children> {
  @override
  void initState() {
    super.initState();
    getChildren();
  }

  Future<void> getChildren() async {
    var token = await getKey('token') ?? "";
    try {
      var response = await http.Client().get(
        Uri.parse("$serverURL/child/all"),
        headers: {"Authorization": token},
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        Provider.of<ChildrenListProvider>(context, listen: false)
            .setChildList(result['children']);
      }
    } catch (err) {
      print(err);
      retryAlertDialog(
          "Network Error", "Network error occured", context, getChildren);
    }
  }

  @override
  Widget build(BuildContext context) {
    var childrenList = context.watch<ChildrenListProvider>().childrenList;
    return (childrenList.isEmpty)
        ? Center(
            child: Text(
              "No children added \n Click the bottom button to add Children",
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            itemCount: childrenList.length,
            itemBuilder: (context, index) =>
                ChildListItem(id: childrenList[index]));
  }
}
