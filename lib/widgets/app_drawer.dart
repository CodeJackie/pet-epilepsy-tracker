import 'package:flutter/material.dart';
import '../main.dart';
import '../my_pet.dart';
import '../entries_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Color(0xFF593FA5),
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Profile', style: TextStyle(color: Color(0xFF593FA5))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('New Seizure', style: TextStyle(color: Color(0xFF593FA5))),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => PetEpilepsyTracker()));
            },
          ),
          ListTile(
            title: Text('My Pet', style: TextStyle(color: Color(0xFF593FA5))),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyPet()));
            },
          ),
          ListTile(
            title: Text('Entries', style: TextStyle(color: Color(0xFF593FA5))),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => EntriesPage()));
            },
          ),
          ListTile(
            title: Text('Useful Tips', style: TextStyle(color: Color(0xFF593FA5))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Dedication', style: TextStyle(color: Color(0xFF593FA5))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
