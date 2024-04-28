import 'package:flutter/material.dart';
import 'models/seizure_entry.dart';
import 'database/database_helper.dart';

class ViewEntries extends StatefulWidget {
  @override
  _ViewEntriesState createState() => _ViewEntriesState();
} 

class _ViewEntriesState extends State<ViewEntries> {
  late Future<List<SeizureEntry>> entries;

  @override
  void initState() {
    super.initState();
    entries = DatabaseHelper.instance.getEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
      ),
      body: FutureBuilder<List<SeizureEntry>>(
        future: entries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                SeizureEntry entry = snapshot.data![index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Date: ${entry.seizureDate}'),
                        Text('Time: ${entry.seizureTime}'),
                        Text('Count: ${entry.seizureCount}'),
                        Text('Duration: ${entry.seizureDuration}'),
                        Text('Types: ${entry.seizureTypes}'),
                        Text('Rescue Med: ${entry.rescueMed}'),
                        Text('Regular Meds: ${entry.regularMed}'),
                        Text('Symptoms Before Seizure: ${entry.preSymptoms}'),
                        Text('Symptoms After Seizure: ${entry.postSymptoms}'),
                        Text('Post Ictal Duration: ${entry.postIctalDuration}'),
                        Text('Suspected Triggers: ${entry.triggers}'),
                        Text('Additional Notes: ${entry.notes}'),
                      ]
                    )
                    ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      );
  }
}