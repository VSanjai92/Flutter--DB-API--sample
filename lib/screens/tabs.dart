import 'package:flutter/material.dart';
import 'package:profilescreen/screens/adduser.dart';
import 'package:profilescreen/screens/showapi.dart';
import 'package:profilescreen/screens/userlist.dart';


import '../data/models/data_model.dart';
import 'editscreen.dart';

class TabsScreen extends StatefulWidget {


   const TabsScreen({super.key});


  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _currentIndex = 0;


  final List<Widget> _tabs = [
     const AddUser(),
    const UserListScreen(),
    const HomePage(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label:'Add User',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label:'Edit User',
          ),

          BottomNavigationBarItem(
            icon:Icon(Icons.wifi_2_bar),
             label:'Api Page',
          ),


          // Add more BottomNavigationBarItems as needed
        ],
      ),
    );
  }
}

