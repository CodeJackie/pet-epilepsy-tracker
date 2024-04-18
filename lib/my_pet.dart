import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/pet_details.dart';
import 'database/database_helper.dart';

class MyPet extends StatefulWidget {
  @override
  _MyPetState createState() => _MyPetState();
}

class _MyPetState extends State<MyPet> {
  DateTime? _birthdate;
  Future<List<PetDetails>> entries = Future.value([]);

 //A Conditional UI. Ooo!
  Widget _buildBirthdateOrAge() {
    print('Building birthdate or age widget');
    if (_birthdate == null) {
      return TextButton(
        onPressed: _pickBirthdate,
        child: Text("Birthdate: "),
      );
    } else {
      String age = calculateAge(_birthdate!);
      return TextButton(
        onPressed: _pickBirthdate,
        child: Text("Age: $age"),
      );
    }
  } 

  Future<void> _pickBirthdate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthdate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthdate) {
      setState((){
        _birthdate = picked;
      });
    }
  }

  String? _petName;
  String? _breed;
  String? _about;

  Widget _buildPetName() {
  String displayText = _petName?.isNotEmpty == true ? _petName! : "Pet Name";
  return GestureDetector(
    onTap: () async {
      TextEditingController controller = TextEditingController();
      String? newName = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Update Pet Name'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter pet name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text('Save'),
            ),
          ],
        ),
      );

      if (newName != null && newName.isNotEmpty) {
        // Update state and save to database
        setState(() {
          _petName = newName;
        });
        print('Button pressed for $newName');
        await DatabaseHelper.instance.updatePetName(newName); 
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        displayText,
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

  Widget _buildBreed() {
  String displayText = _breed?.isNotEmpty == true ? _breed! : "Breed";
  return GestureDetector(
    onTap: () async {
      TextEditingController controller = TextEditingController();
      String? newBreed = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Enter Breed'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter pet breed'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text('Save'),
            ),
          ],
        ),
      );

      if (newBreed != null && newBreed.isNotEmpty) {
        // Update state and save to database
        setState(() {
          _breed = newBreed;
        });
        print('Button pressed for $newBreed');
        await DatabaseHelper.instance.updatePetBreed(newBreed); 
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        displayText,
        style: TextStyle(fontSize: 20),
      ),
    ),
  );
}

Widget _buildAbout() {
  String displayText = _about?.isNotEmpty == true ? _about! : "About";
  return GestureDetector(
    onTap: () async {
      String? newAbout = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('About Your Pet'),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(hintText: 'About'),
              controller: TextEditingController(text: _about),
              maxLines: null, // No limit on lines
              keyboardType: TextInputType.multiline,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.of(context).pop(_about);
                },
              ),
            ],
          );
        },
      );

      if (newAbout != null) {
        setState(() {
          _about = newAbout;
        });
        // Save to database
        await DatabaseHelper.instance.updatePetAbout(newAbout);
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        displayText,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}




  @override
  void initState() {
    super.initState();
    _loadPetDetails();
  }

  void _loadPetDetails() async {
    try {
      List<PetDetails> details = await DatabaseHelper.instance.getDetails();
      if (details.isNotEmpty){
        PetDetails entry = details.first;
        setState(() {
          _petName = entry.name;
          _breed = entry.breed;
          _about = entry.about;
          _birthdate = entry.birthdate != null ? DateTime.tryParse(entry.birthdate!) : null;
        });
      }
    } catch (e) {
      print('Error loading pet details: $e');
      setState((){
        entries = Future.value([]);
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Pet Epilepsy Tracker'),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Adjust the overall padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.25,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey[300]),
                child: Center(child: Text('Pet Image Placeholder')),
              ),
            ),
            SizedBox(height: 8), // Control the space between image placeholder and next item
            _buildPetName(),
            Transform.translate(
              offset: Offset(3, -10), // Moves up by 10 pixels
              child: _buildBreed(),
            ),
            Transform.translate(
              offset: Offset(0, -10), // Moves up by 10 pixels
              child: _buildBirthdateOrAge(),
            ),   // Continue adding widgets here
            Transform.translate(
              offset: Offset(0, -10), // Moves up by 10 pixels
              child: _buildAbout(),
            ),   // Continue adding widgets here
          ],
        ),
      ),
    ),
  );
}

// Use the Intl library to calculate age in readable text
String formatDate(DateTime? date) {
  if (date == null) return 'N/A';
  return DateFormat('MM-dd-yyyy').format(date);
}

String calculateAge(DateTime birthdate) {
  DateTime today = DateTime.now();
  int yearDiff = today.year - birthdate.year;
  int monthDiff = today.month - birthdate.month;
  int dayDiff = today.day - birthdate.day;

  if (monthDiff < 0 || (monthDiff == 0 && dayDiff < 0)) {
    yearDiff--;
  }
  return '$yearDiff years old';
}

}