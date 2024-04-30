import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'models/seizure_entry.dart';
import 'database/database_helper.dart';
import 'view_entries.dart';
import 'entries_page.dart';
import 'my_pet.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_){ 
  runApp(PetEpilepsyTracker());
  });
}

class PetEpilepsyTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        unselectedWidgetColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Pet Epilepsy Tracker',
        style: TextStyle(
        fontSize: 28.0, 
        fontWeight: FontWeight.bold,
        ) 
        )
        ),
        drawer: Drawer(
          child: Builder(
            builder: (context) => ListView(
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
          )
          )
        ),
        body: Theme(
          data: ThemeData.dark(),
          child: PetEpilepsyLayout(),
        ),
      ),
    );
  }
}



class EpilepsyTrackerForm extends StatefulWidget {
  @override
  _EpilepsyTrackerFormState createState() => _EpilepsyTrackerFormState();
}

class _EpilepsyTrackerFormState extends State<EpilepsyTrackerForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime seizureDate = DateTime.now();
  TimeOfDay seizureTime = TimeOfDay.now();
  String? seizureCount = '';
  String? seizureDuration = '';
  bool generalizedChecked = false;
  bool focalChecked = false;
  bool psychomotorChecked = false;
  bool idiopathicChecked = false;
  String? rescueMed = ''; 
  String? regularMed = ''; 
  String? preSymptoms = '';
  String? postSymptoms = '';
  String? postIctalDuration = '';
  String? triggers = '';
  String? notes = '';

//function to clear all data in form upon submission
  void resetForm() {
    setState(() {
      seizureDate = DateTime.now();
      seizureTime = TimeOfDay.now();
      seizureCount = '';
      seizureDuration = '';
      generalizedChecked = false;
      focalChecked = false;
      psychomotorChecked = false;
      idiopathicChecked = false;
      rescueMed = '';
      regularMed = '';
      preSymptoms = '';
      postSymptoms = '';
      postIctalDuration = '';
      triggers = '';
      notes = '';
    });
  }

  // Function to handle date selection
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: seizureDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != seizureDate) {
      setState(() {
        seizureDate = picked;
      });
    }
  }

  // Function to handle time selection
  _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: seizureTime,
    );
    if (picked != null && picked != seizureTime) {
      setState(() {
        seizureTime = picked;
      });
    }
  }

  // Function to convert Time to string
  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  // Function to combine checkbox values into string
  String getSeizureTypes() {
    List<String> types = [];
    if (generalizedChecked) types.add('Generalized');
    if (focalChecked) types.add('Focal');
    if (psychomotorChecked) types.add('Psychomotor');
    if (idiopathicChecked) types.add('Idiopathic');
    return types.join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
      child: Padding( // Wrap Column in Padding widget
        padding: const EdgeInsets.all(20), // Apply padding to all sides
        child: Column(
          children: [
            ListTile(
            title: Text(
              "Date: ${seizureDate.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(
                color: Colors.white, // Apply style here
              ),
            ),
            trailing: const Icon(Icons.calendar_today, color: Colors.white),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 50),
            ListTile(
              title: Text("Time: ${seizureTime.format(context)}",
                style: const TextStyle(
                  color: Colors.white, // Apply style here
                ),
              ),
              trailing: const Icon(Icons.access_time, 
                color: Colors.white),
              onTap: () => _selectTime(context),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 100, 0),
              child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Number of Seizures',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white60),
              ),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                seizureCount = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter number of seizures';
                }
                return null;
              },
            ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 100, 0),
              child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Seizure Duration',
                hintText: 'mm:ss', 
                labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white60),
              ),
              
              
              onSaved: (value) {
                seizureDuration = value;
              },
              
              ),
            ),
            const SizedBox(height: 50),
            const ListTile(
              title: Text("Seizure Type(s)"),
              titleTextStyle: TextStyle(fontWeight:FontWeight.bold, color: Colors.white, fontSize: 18),
             ),
            CheckboxListTile(
              title: const Text("Generalized (Grand Mal)", style:TextStyle(color: Colors.white),),
              tileColor: Colors.white,
              value: generalizedChecked,
              onChanged: (bool? value) {
                setState(() {
                  generalizedChecked = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("Focal or Partial", style:TextStyle(color: Colors.white),),
              value: focalChecked,
              onChanged: (bool? value) {
                setState(() {
                  focalChecked = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("Psychomotor", style:TextStyle(color: Colors.white),),
              value: psychomotorChecked,
              onChanged: (bool? value) {
                setState(() {
                  psychomotorChecked = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("Idiopathic", style:TextStyle(color: Colors.white),),
              value: idiopathicChecked,
              onChanged: (bool? value) {
                setState(() {
                  idiopathicChecked = value!;
                });
              },
            ),
            const SizedBox(height: 50),
            const ListTile(
              title: Text('Rescue medication administered?'),
              titleTextStyle: TextStyle(fontWeight:FontWeight.bold, color: Colors.white, fontSize: 18),
             ),
            ListTile(
              title: const Text('Yes', style:TextStyle(color: Colors.white)),
              leading: Radio<String>(
                value: 'Yes',
                groupValue: rescueMed,
                onChanged: (String? value) {
                  setState(() {
                    rescueMed = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('No', style:TextStyle(color: Colors.white)),
              tileColor: Colors.white,
              leading: Radio<String>(
                value: 'No',
                groupValue: rescueMed,
                onChanged: (String? value) {
                  setState(() {
                    rescueMed = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 50),
            const ListTile(
              title: Text('Regular medication administered on time?'),
              titleTextStyle: TextStyle(fontWeight:FontWeight.bold, color: Colors.white, fontSize: 18,),
             ),
            ListTile(
              title: const Text('Yes', style:TextStyle(color: Colors.white)),
              leading: Radio<String>(
                value: 'Yes',
                groupValue: regularMed,
                onChanged: (String? value) {
                  setState(() {
                    regularMed = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('No', style:TextStyle(color: Colors.white)),
              leading: Radio<String>(
                value: 'No',
                groupValue: regularMed,
                onChanged: (String? value) {
                  setState(() {
                    regularMed = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Symptoms Before Seizure',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white60),
                hintText: 'Describe symptoms (if any)',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onSaved: (value) {
                preSymptoms = value;
              }
               ), 
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Symptoms After Seizure',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white60),
                hintText: 'Describe symptoms (if any)',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onSaved: (value) {
                postSymptoms = value;
              },
              ),// No validator means no validation checks - the field is optional
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 100, 0),
              child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Post Ictal Duration',
                hintText: 'hh:mm', 
                labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white60),
              ),
              
              onSaved: (value) {
                postIctalDuration = value;
              },
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Suspected Triggers',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white60),
                hintText: 'Triggers and Auras',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onSaved: (value) {
                triggers = value;
              },
              ),// No validator means no validation checks - the field is optional
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Additional Notes',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white60),
                hintText: 'Anything else of note',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onSaved: (value) {
                notes = value;
              },
              ),// No validator means no validation checks - the field is optional
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  SeizureEntry entry = SeizureEntry(
                    seizureDate: seizureDate.toIso8601String(), 
                    seizureTime: formatTimeOfDay(seizureTime), 
                    seizureCount: seizureCount ?? '1', 
                    seizureDuration: seizureDuration ?? '', 
                    seizureTypes: getSeizureTypes(), 
                    rescueMed: rescueMed ?? 'No', 
                    regularMed: regularMed ?? 'Yes', 
                    preSymptoms: preSymptoms ?? '', 
                    postSymptoms: postSymptoms ?? '', 
                    postIctalDuration: postIctalDuration ?? '', 
                    triggers: triggers ?? '', 
                    notes: notes ?? ''
                    );
                    DatabaseHelper.instance.insertEntry(entry);
                    resetForm();
                    print('Passed the reset form');
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewEntries()),
                );
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    ));
  }
}






class PetEpilepsyLayout extends StatefulWidget {
  @override
  _PetEpilepsyLayoutState createState() => _PetEpilepsyLayoutState();
}

class _PetEpilepsyLayoutState extends State<PetEpilepsyLayout> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: const Color(0xFF593FA5), // Main section background color: purple
            child: Theme(
              data: ThemeData(
                textTheme: const TextTheme(
                  bodyLarge: TextStyle(color: Colors.white),
                  bodyMedium: TextStyle(color: Colors.white),
                  bodySmall: TextStyle(color: Colors.white),
                ),
                unselectedWidgetColor: Colors.white,
                brightness: Brightness.dark
              ),
            child: EpilepsyTrackerForm(), 
          ),
        ),
        ),
      ]);
  }
}
