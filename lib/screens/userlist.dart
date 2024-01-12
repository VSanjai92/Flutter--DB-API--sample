import 'package:flutter/material.dart';
import 'package:profilescreen/data/models/data_model.dart';
import 'package:profilescreen/data/source/databasesource.dart';
import 'adduser.dart';
import 'editscreen.dart'; // Assuming you have an AddUserScreen

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final DatabaseSource databaseSource = DatabaseSource();
  late ValueNotifier<List<DataModel>> usersNotifier;

  @override
  void initState() {
    super.initState();
    usersNotifier = databaseSource.dataListNotifier;
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    await databaseSource.initHive();
    await databaseSource.openBox(); // Add this line to open the box
    await loadUsers();
  }


  Future<void> loadUsers() async {
    await databaseSource.getAllData();
    setState(() {}); // Trigger a rebuild after updating the data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddUser(),
                ),
              ).then((_) {
                // Reload the users when returning from AddUserScreen
                loadUsers();
              });
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<List<DataModel>>(
        valueListenable: usersNotifier,
        builder: (context, users, _) {
          return users == null
              ? const Center(child: CircularProgressIndicator())
              : users.isEmpty
              ? const Center(child: Text('No users found.'))
              : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final DataModel user = users[index];
              return Card(
                elevation: 3,
                color: Colors.cyanAccent,
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(user.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gender: ${user.gender}'),
                      Text('DOB: ${user.dob.toString()}'),
                      Text('Profession: ${user.profession}'),
                      Text('Hobbies: ${user.hobbies.join(', ')}'),
                    ],

                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return  EditUser(user: user); // Pass the selected user to the edit screen
                            },
                            isScrollControlled: true,
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete User'),
                                content: const Text(
                                    'Are you sure you want to delete this user?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Implement the delete operation
                                      databaseSource.deleteData(
                                          user.key); // Adjust accordingly
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}