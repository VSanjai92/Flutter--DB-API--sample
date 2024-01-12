import 'package:hive_flutter/adapters.dart';

part 'data_model.g.dart';

@HiveType(typeId: 1)
class DataModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String profilePhoto;

  @HiveField(2)
  final String gender;

  @HiveField(3)
  final DateTime dob;

  @HiveField(4)
  final String profession;

  @HiveField(5)
  final List<String> hobbies;

  DataModel({
    required this.name,
    required this.profilePhoto,
    required this.gender,
    required this.dob,
    required this.profession,
    required this.hobbies, required key,
  });

  @override
  String toString() {
    return "DataModel(name:$name, profilePhoto:$profilePhoto, gender:$gender, dob:$dob, profession:$profession, hobbies:$hobbies)";
  }
}


