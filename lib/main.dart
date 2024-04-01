import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(PetEpilepsyTracker());
}

class PetEpilepsyTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Pet Epilepsy Tracker',
        style: TextStyle(
        fontSize: 28.0, 
        fontWeight: FontWeight.bold,) 
        )),
        body: PetEpilepsyLayout(),
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
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool generalizedChecked = false;
  bool focalChecked = false;
  bool psychomotorChecked = false;
  bool idiopathicChecked = false;
  String? rescueMedication = 'No'; 
  String? regularMedication = 'Yes'; 

  // Function to handle date selection
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Function to handle time selection
  _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ListTile(
            title: Text(
              "Date: ${selectedDate.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(
                color: Colors.white, // Apply style here
              ),
            ),
            trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 50),
            ListTile(
              title: Text("Time: ${selectedTime.format(context)}"),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            const SizedBox(height: 50),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Number of Seizures',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white60),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 50),
            const ListTile(
              title: Text("Seizure Type(s)"),
              titleTextStyle: TextStyle(fontWeight:FontWeight.bold),
             ),
            CheckboxListTile(
              title: const Text("Generalized (Grand Mal)"),
              value: generalizedChecked,
              onChanged: (bool? value) {
                setState(() {
                  generalizedChecked = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("Focal or Partial"),
              value: focalChecked,
              onChanged: (bool? value) {
                setState(() {
                  focalChecked = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("Psychomotor"),
              value: psychomotorChecked,
              onChanged: (bool? value) {
                setState(() {
                  psychomotorChecked = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text("Idiopathic"),
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
              titleTextStyle: TextStyle(fontWeight:FontWeight.bold),
             ),
            ListTile(
              title: const Text('Yes'),
              leading: Radio<String>(
                value: 'Yes',
                groupValue: rescueMedication,
                onChanged: (String? value) {
                  setState(() {
                    rescueMedication = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('No'),
              leading: Radio<String>(
                value: 'No',
                groupValue: rescueMedication,
                onChanged: (String? value) {
                  setState(() {
                    rescueMedication = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 50),
            const ListTile(
              title: Text('Regular medication administered on time?'),
              titleTextStyle: TextStyle(fontWeight:FontWeight.bold),
             ),
            ListTile(
              title: const Text('Yes'),
              leading: Radio<String>(
                value: 'Yes',
                groupValue: regularMedication,
                onChanged: (String? value) {
                  setState(() {
                    regularMedication = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('No'),
              leading: Radio<String>(
                value: 'No',
                groupValue: regularMedication,
                onChanged: (String? value) {
                  setState(() {
                    regularMedication = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 50),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Symptoms Before Seizure',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white60),
                hintText: 'Describe symptoms (if any)',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              // No validator means no validation checks - the field is optional
            ),
            const SizedBox(height: 50),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Symptoms After Seizure',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white60),
                hintText: 'Describe symptoms (if any)',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              // No validator means no validation checks - the field is optional
            ),
            const SizedBox(height: 50),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Post Ictal Duration',
                hintText: 'hh:mm', 
                labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white60),
              ),
              keyboardType: TextInputType.number, 
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}:\d{0,2}$')), // Allow input matching 00:00 format
              ],
              validator: (value) {
                if (value == null || !RegExp(r'^\d{2}:\d{2}$').hasMatch(value)) {
                  return 'Enter time in hh:mm format';
                }
                return null; // Return null if the input format is correct
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Process form submission here
                }
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
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
          flex: 1,
          child: Container(
            color: const Color(0xFFFFFFFF), 
            child: const Column(
              children: [
                Text(
                  'Profile',
                  style: TextStyle(color: Color(0xFF593FA5), fontSize: 16), 
                ),
                Text(
                  'Data',
                  style: TextStyle(color: Color(0xFF593FA5), fontSize: 16), 
                ),
                Text(
                  'Dedication',
                  style: TextStyle(color: Color(0xFF593FA5), fontSize: 16), 
                ),
              ],
            ),
          ),
        ),
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
              ),
            child: EpilepsyTrackerForm(), 
          ),
        ),
        ),
      ]);
  }
}
