import 'package:flutter/material.dart';
import 'models/seizure_entry.dart';

class EditEntryPage extends StatefulWidget {
  final SeizureEntry entry;

  EditEntryPage({required this.entry});

  @override
  _EditEntryPageState createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage>
{
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Entry'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            // Create form fields prepopulated with entry data here
            TextFormField(
              initialValue: widget.entry.seizureDate, // Example for the date
              // Add more form fields as necessary
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement save functionality here
              },
              child: Text('Save Entry'),
            )
          ],
        ),
      ),
    );
  }
}
