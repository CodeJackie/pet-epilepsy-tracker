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
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

  Widget _buildBreed() {
  String displayText = _breed?.isNotEmpty == true ? _breed! : "Pet Name";
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
      padding: const EdgeInsets.all(8.0),
      child: Text(
        displayText,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
      body: Column(
        children: <Widget> [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            color: Colors.grey[300],
            width: double.infinity,
            alignment: Alignment.center,
            child: Text('Pet Image Placeholder'),
          ),
          _buildBirthdateOrAge(),
          _buildPetName(),
          _buildBreed(),
      Expanded( 
        child: FutureBuilder<List<PetDetails>>(
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
      )
        ]
    )
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