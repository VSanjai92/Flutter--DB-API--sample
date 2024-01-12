import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../data/models/data_model.dart';
import '../data/source/databasesource.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final DatabaseSource databaseSource = DatabaseSource();
  late TextEditingController _nameController;

  String userName = '';
  String selectedGender = 'Male'; // Default to Male
  DateTime selectedDate = DateTime.now();
  String selectedProfession = 'Engineer'; // Default to Engineer
  List<String> selectedHobbies = [];
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Photo',style: TextStyle(
                color:Colors.indigo,
                fontSize:16,
              ),),
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  // Show dialog to choose camera or gallery
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Select Image Source'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _pickImage(ImageSource.camera);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Camera'),
                          ),
                          TextButton(
                            onPressed: () {
                              _pickImage(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Gallery'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImage!,
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10,),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (value) {
                  setState(() {
                    userName = value;
                  });
                },
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const Text('Gender:',
                      style:TextStyle(
                          color:Colors.indigo,
                         fontSize: 16,
                      )),
                  Radio(
                    value: 'Male',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value.toString();
                      });
                    },
                  ),
                  const Text('Male'),
                  Radio(
                    value: 'Female',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value.toString();
                      });
                    },
                  ),
                  const Text('Female'),
                  // Add more radio buttons as needed
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const Text(
                    'Date of Birth: ',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 16,
                    ),
                  ),
                  Text(DateFormat('yyyy-MM-dd').format(selectedDate)), // Format the date
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              const Text('Profession',
                style: TextStyle(
                color:Colors.indigo,
                fontSize:16,
              ),),
              DropdownButton<String>(
                value: selectedProfession,
                onChanged: (value) {
                  setState(() {
                    selectedProfession = value!;
                  });
                },
                items: ['Engineer', 'Doctor', 'Teacher', 'Other']
                    .map((profession) {
                  return DropdownMenuItem<String>(
                    value: profession,
                    child: Text(profession),
                  );
                }).toList(),
                hint: const Text('Select Profession',
                  ),
              ),
              // Add multi-select for hobbies

              const SizedBox(height: 10,),

              Wrap(
                children: [
                  const Text(
                    'Hobbies: ',style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 16,
                  ),),
                  Checkbox(
                    value: selectedHobbies.contains('Reading'),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          selectedHobbies.add('Reading');
                        } else {
                          selectedHobbies.remove('Reading');
                        }
                      });
                    },
                  ),
                  const Text('Reading'),
                  Checkbox(
                    value: selectedHobbies.contains('Sports'),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          selectedHobbies.add('Sports');
                        } else {
                          selectedHobbies.remove('Sports');
                        }
                      });
                    },
                  ),
                  const Text('Sports'),
                  Checkbox(
                    value: selectedHobbies.contains('Music'),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          selectedHobbies.add('Music');
                        } else {
                          selectedHobbies.remove('Music');
                        }
                      });
                    },
                  ),
                  const Text('Music'),
                ],
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  // Convert the string representation of gender to the Gender enum
                 /* Gender genderEnum;
                  if (selectedGender == 'Male') {
                    genderEnum = Gender.Male;
                  } else if (selectedGender == 'Female') {
                    genderEnum = Gender.Female;
                  } else {
                    genderEnum = Gender.Other;
                  }
*/
                  DataModel model = DataModel(
                    name: userName,
                    profilePhoto: _selectedImage?.path ?? '',
                    gender: selectedGender,
                    dob: selectedDate,
                    profession: selectedProfession,
                    hobbies: selectedHobbies,
                    key: null,
                  );

                  await databaseSource.saveData(model, null);

                  // Clear form fields after saving
                  _nameController.clear();
                  setState(() {
                    userName = '';
                  //  selectedGender = Gender.Male as String; // Assuming default value is Male for the dropdown
                    selectedDate = DateTime.now();
                    selectedProfession = 'Engineer';
                    selectedHobbies = [];
                    _selectedImage = null;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User saved successfully!'),
                    ),
                  );
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
