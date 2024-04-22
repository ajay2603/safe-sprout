import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../global/consts.dart';
import '../utilities/secure_storage.dart';
import '../utilities/dialogs.dart';

class Validation extends StatefulWidget {
  const Validation({Key? key});

  @override
  _ValidationState createState() => _ValidationState();
}

class _ValidationState extends State<Validation> {
  _ValidationState() {
    validateSession();
  }

  Future<void> validateSession() async {
    try {
      String token = await getKey("token") ?? "";
      var response = await http.Client().post(
          Uri.parse("${serverURL}/user/auth/validate-token"),
          headers: {"Authorization": token});
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    } catch (error) {
      print(error);
      retryDialog(
          "Error", "Network error.\nPlease retry", context, validateSession);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Validating Session\n Please Wait ...")),
    );
  }
}
