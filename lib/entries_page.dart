import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Widget _buildEntryItem(SeizureEntry entry) {
    String formattedDate = DateFormat('MMMM d, yyyy').format(DateTime.parse(entry.seizureDate));
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            formattedDate,
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          Text(
            '${entry.seizureCount} Seizure(s)',
            style: TextStyle(color: Colors.black87),
          )
        ],
      ),
    );
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seizure Entries'),
        backgroundColor: Color(0xFF593FA5),
      ),
      body: FutureBuilder<List<SeizureEntry>>(
        future: entries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) => SizedBox(height:2),
                itemBuilder: (context, index){
                  return _buildEntryItem(snapshot.data![index]);
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
    );
  }
}