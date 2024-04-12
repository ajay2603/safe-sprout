import 'package:flutter/material.dart';
import "../sections/home/Map.dart";
import '../providers/secure_storage.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  int _selectedIndex = 0;

  _Home() {
    disp();
  }

  void disp() async {
    print(await getKey("token"));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _sections = [
    Center(child: Text("Home")),
    Map(), // Place
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeSprout'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
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
    );
  }
}
