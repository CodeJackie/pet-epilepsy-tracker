import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/seizure_entry.dart';
import 'edit_entry_page.dart';

class DetailedEntryPage extends StatelessWidget {
  final SeizureEntry entry;

  DetailedEntryPage({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entry Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditEntryPage(entry: entry),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Date: ${DateFormat('MMMM d, yyyy').format(DateTime.parse(entry.seizureDate))}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Seizure Count: ${entry.seizureCount}', style: TextStyle(fontSize: 18)),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
