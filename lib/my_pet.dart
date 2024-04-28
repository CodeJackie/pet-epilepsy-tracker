import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'models/pet_details.dart';
import 'database/database_helper.dart';
import 'dart:io';

class MyPet extends StatefulWidget {
  @override
  _MyPetState createState() => _MyPetState();
}

class _MyPetState extends State<MyPet> {
  DateTime? _birthdate;
  Future<List<PetDetails>> entries = Future.value([]);

 //A Conditional UI. Ooo!
  Widget _buildBirthdateOrAge() {
    if (_birthdate == null) {
    print('Building birthdate or age widget');
      return TextButton(
        onPressed: _pickBirthdate,
        child: Text("Birthdate: "),
      );
    } else {
      String age = calculateAge(_birthdate!);
      return TextButton(
        onPressed: _pickBirthdate,
        child: Text(
          "Age: $age", 
          style: TextStyle(fontSize:16, color: Colors.white70)
          ),
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
      await DatabaseHelper.instance.updatePetBirthdate(picked.toIso8601String());
    }
  }

  String? _petName;
  String? _breed;
  String? _about;
  String? _imagePath;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image !=null) {
      setState((){
        _imagePath = image.path;
      });
      try {
         bool updateSuccess = await DatabaseHelper.instance.updatePetImagePath(_imagePath!, 1);
        if (updateSuccess)  {
          print('imagePath update successfully');
        } else {
          print('Failed to update imagePath');
        }
      } catch (e) {
        print('Error updating image path: $e');
      }
    } else {
      print('No image selected');
    }
  }

  Widget _buildPetImage() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          image: _imagePath != null
            ? DecorationImage(
              image: FileImage(File(_imagePath!)),
              fit: BoxFit.cover,
            )
            :null,
        ),
        alignment: Alignment.center,
        child: _imagePath == null
          ? Text('Tap to add pet image', style: TextStyle(color: Colors.black))
          : null,
      ),
    );
  }

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
        style: TextStyle(
          fontSize: 32, 
          fontWeight: FontWeight.bold, 
          color: Colors.white
        ),
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
        style: TextStyle(fontSize: 20, color: Colors.white70),
      ),
    ),
  );
}

Widget _buildAbout() {
  String displayText = _about?.isNotEmpty == true ? _about! : "About";
  return GestureDetector(
    onTap: () async {
      TextEditingController textController = TextEditingController(text: _about);
      String? newAbout = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('About Your Pet'),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(hintText: 'About'),
              controller: textController,
              maxLines: null, 
              keyboardType: TextInputType.multiline,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.of(context).pop(textController.text);
                },
              ),
            ],
          );
        },
      );

      if (newAbout != null && newAbout != _about) {
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
        style: const TextStyle(fontSize: 16, color: Colors.white),
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
          _imagePath = entry.imagePath;
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
      title: Text('My Pet'),
    ),
    body: SingleChildScrollView(
      child: Container(
        color: const Color(0xFF593FA5),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildPetImage(),
            SizedBox(height: 8),
            _buildPetName(),
            Transform.translate(
              offset: Offset(3, -10), 
              child: _buildBreed(),
            ),
            Transform.translate(
              offset: Offset(-2, -25),
              child: _buildBirthdateOrAge(),
            ),
            Transform.translate(
              offset: Offset(0, -10), 
              child: _buildAbout(),
            ),
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