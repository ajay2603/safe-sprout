import 'package:flutter/material.dart';

void alertDialog(String title, String description, BuildContext context) {
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

void retryDialog(String title, String description, BuildContext context,
    Function retryFunction) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: <Widget>[
          TextButton(
            child: Text('Retry'),
            onPressed: () {
              retryFunction();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void retryAlertDialog(String title, String description, BuildContext context,
    Function retryFunction) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: <Widget>[
          TextButton(
            child: Text('Retry'),
            onPressed: () {
              retryFunction();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('cancle'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
