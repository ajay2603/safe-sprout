import 'package:flutter/material.dart';

class Validation extends StatefulWidget {
  const Validation({Key? key});

  @override
  _ValidationState createState() => _ValidationState();
}


class _ValidationState extends State<Validation> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Validating Session\n Please Wait ...")),
    );
  }
}
