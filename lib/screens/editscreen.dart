import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../data/models/data_model.dart';
import '../data/source/databasesource.dart';

class EditUser extends StatefulWidget {
  final DataModel user;

  const EditUser({super.key, required this.user,});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  late TextEditingController _nameController;

  String userName = '';
  String selectedGender = '';
  DateTime selectedDate = DateTime.now();
  String selectedProfession = '';
  List<String> selectedHobbies = [];
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    userName = widget.user.name;
    selectedGender = widget.user.gender;
    selectedDate = widget.user.dob;
    selectedProfession = widget.user.profession;
    selectedHobbies = List.from(widget.user.hobbies);
    _selectedImage = File(widget.user.profilePhoto);
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
        title: const Text('Edit User'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Photo',
                style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
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
                  const Text(
                    'Gender:',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 16,
                    ),
                  ),
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
                  Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              const Text(
                'Profession',
                style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 16,
                ),
              ),
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
              const SizedBox(height: 10,),
              Wrap(
                children: [
                  const Text(
                    'Hobbies: ',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 16,
                    ),
                  ),
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
                  DataModel updatedUser = DataModel(
                    name: userName,
                    profilePhoto: _selectedImage?.path ?? '',
                    gender: selectedGender,
                    dob: selectedDate,
                    profession: selectedProfession,
                    hobbies: selectedHobbies,
                    key: widget.user.key,
                  );

                  await DatabaseSource().saveData(updatedUser, widget.user.key);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User updated successfully!'),
                    ),
                  );
                },
                child: const Text(
                  'Save Changes',
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
