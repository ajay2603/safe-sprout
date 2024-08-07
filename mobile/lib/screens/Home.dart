import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:mobile/providers/ChildrenListProvider.dart';
import 'package:mobile/sockets/socket.dart';
import 'package:mobile/utilities/background-location.dart';
import 'package:mobile/utilities/childlocation.dart';
import 'package:provider/provider.dart';
import "../sections/home/Map.dart";
import '../utilities/secure_storage.dart';
import '../sections/home/Children.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startParentBackgroundService();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _sections = [
    Children(),
    Map(), // Place
  ];

  @override
  Widget build(BuildContext context) {
    getCurrentLocationStream(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('SafeSprout'),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () async {
                await removeKey("token");
                await removeKey("type");
                disconnectSocket();
                Navigator.pushReplacementNamed(context, "/");
              },
              icon: Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: _sections[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: "Home",
                backgroundColor: Colors.grey[800]),
            const BottomNavigationBarItem(
                icon: Icon(Icons.map_rounded),
                label: "Map",
                backgroundColor: Colors.blueGrey),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
        floatingActionButton: (_selectedIndex == 0)
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/add-child");
                },
                child: Icon(Icons.person_add_alt_rounded),
              )
            : null);
  }
}
