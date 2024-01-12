import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> fetchdata() async {
    try {
      final response = await http.get(Uri.parse("https://dev.smef.online/api/otp-mgmt/health-check"));
      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body)['data']['health'];
        });
      } else {
        // Handle error, maybe show an error message
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      // Handle network errors
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter API'),
          backgroundColor: Colors.indigo,
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final healthItem = data[index];
            return ListTile(
              title: Text(
                healthItem['name'],
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  for (var accessibleItem in healthItem['accessible'])

                    Text(
                      ' ${accessibleItem['message']}',

                      style: const TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontSize: 17,
                      ),
                    ),



                ],
              ),
            );
          },
        )

    );
  }
}
