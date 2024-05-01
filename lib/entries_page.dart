import 'package:flutter/material.dart';
import 'package:pet_epilepsy_tracker/entry_item.dart';
import 'package:pet_epilepsy_tracker/widgets/app_drawer.dart';
import 'models/seizure_entry.dart';
import 'database/database_helper.dart';

class EntriesPage extends StatefulWidget {
  @override
  _EntriesPageState createState() => _EntriesPageState();
}

class _EntriesPageState extends State {
 late Future<List<SeizureEntry>>entries;
  @override
  void initState() {
    super.initState();
    entries = DatabaseHelper.instance.getEntries();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seizure Entries'),
      ),
      drawer: AppDrawer(),
      body: Container(
        color: Color(0xFF593FA5),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: FutureBuilder<List<SeizureEntry>>(
        future: entries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) => SizedBox(height:1),
                itemBuilder: (context, index){
                  return EntryItem(entry:snapshot.data![index],
                  );
                },
              );
            } else {
              return Center(child: Text('No entries found'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      )
    );
  }
}