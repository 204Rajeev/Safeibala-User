import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saf_user/screens/dump_map.dart';
import 'package:saf_user/screens/pick_up_screen.dart';
import 'package:saf_user/screens/add_post_screen.dart';
import '../providers/user_provider.dart';
import 'home_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  BottomNavigationBarScreen({Key? key}) : super(key: key);

  static List screens = [
    HomeScreen(),
    AddPostScreen(),
    PickUpScreen(),
    DumpMap()
  ];

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  List<Map<String, dynamic>> _pages = [];
  var _selectedIndex = 0;


  // Future<void> getUserName() async {
  //   model.User? _user = await Provider.of<UserProvider>(context).refreshUser();
  //   userName = _user!.userName;
  // }


  @override
  void initState() {
  
    _pages = [
      {
        'page': HomeScreen(),
      },
      {
        'page': PickUpScreen(),
      },
      {
        'page': AddPostScreen(),
      },
      {
        'page': DumpMap(),
      },
    ];
    super.initState();
  }

  void onTapedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.lightBlue.shade600),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: 'Home',
                backgroundColor: Theme.of(context).primaryColor),
            BottomNavigationBarItem(
                icon: const Icon(Icons.local_shipping_outlined),
                label: 'pick Up',
                backgroundColor: Theme.of(context).primaryColor),
            BottomNavigationBarItem(
                icon: const Icon(Icons.add),
                label: 'Post',
                backgroundColor: Theme.of(context).primaryColor),
            BottomNavigationBarItem(
                icon: const Icon(Icons.location_on),
                label: 'dump Map',
                backgroundColor: Theme.of(context).primaryColor),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromARGB(255, 1, 149, 211),
          unselectedItemColor: Colors.grey,
          onTap: onTapedItem,
          elevation: 0,
        ),
      ),
    );
  }
}
