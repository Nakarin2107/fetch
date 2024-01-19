// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:fetch/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<User>> user;
  Future<List<User>> fetchUser() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    if (response.statusCode == 200) {
      List<dynamic> responseJson = json.decode(response.body);
      return responseJson.map((m) => User.fromJson(m)).toList();
    } else {
      throw Exception('error :(');
    }
  }

  @override
  void initState() {
    user = fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Fetch Photo Album'),
        ),
        body: FutureBuilder(
          future: fetchUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<User>? user = snapshot.data;
              return ListView.builder(
                itemCount: user!.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.topCenter,
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(32.4),
                      child: Column(
                        children: [
                          Image.network(
                            user[index].image,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 18.0,
                              right: 32.0,
                              top: 24.0,
                              bottom: 8.0,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  child: Image.network(
                                    user[index].profile,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  user[index].title,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${user[index].id}',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
