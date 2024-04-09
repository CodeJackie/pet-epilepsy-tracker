import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'models/pet_details.dart';
import 'database/database_helper.dart';

class MyPet extends StatefulWidget {
  @override
  _MyPetState createState() => _MyPetState();
}

class _MyPetState extends State<MyPet> {
  late Future<List<PetDetails>> entries;

  @override
  void initState() {
    super.initState();
    entries = DatabaseHelper.instance.getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Epilepsy Tracker'),
      ),
      body: FutureBuilder<List<PetDetails>>(
        future: entries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                PetDetails entry = snapshot.data![index];
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget> [
                        Text('About ${entry.name}: ${entry.about}'),
                      ]
                    )
                  ),
                );
              }
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }
}