import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/models/classes/storage.dart';
import 'package:todoapp/models/classes/task.dart';
import 'package:todoapp/models/global.dart';
import 'package:todoapp/models/widgets/intray_todo.dart';
import 'package:http/http.dart' as http;

class IntrayPage extends StatefulWidget {
  addTaskHandler() => createState().addTaskHandler();

  @override
  IntrayPageState createState() => IntrayPageState();
}

class IntrayPageState extends State<IntrayPage> {
  List<Task> taskList = [];
  static Future<List<Task>> taskAlbum;
  final _storage = Storage();

  @override
  void initState() {
    super.initState();
    taskAlbum = fetchTasks();
  }

  addTaskHandler() {
    print("add task handler called...");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: darkGreyColor,
      child: _buildReorderableListSimple(context),
    );
  }

  Widget _buildListTile(BuildContext context, Task item) {
    print('build_tile...');
    return ListTile(
      key: Key(item.taskId.toString()),
      title: IntrayTodo(
        title: item.title,
      ),
    );
  }

  Widget _buildReorderableListSimple(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: FutureBuilder<List<Task>>(
        future: taskAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return ReorderableListView(
              padding: EdgeInsets.only(top: 250.0),
              children: snapshot.data
                  .map((Task item) => _buildListTile(context, item))
                  .toList(),
              onReorder: _onReorder,
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
              height: 50.0,
              width: 50.0,
            ),
          );
        },
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      print("$oldIndex, $newIndex");
      Task item = taskList[oldIndex];
      taskList.remove(item);
      taskList.insert(newIndex, item);
    });
  }

  Future<List<Task>> fetchTasks() async {
    var tasks = [];
    var jsonData = await _storage.read("tasks");
    if (jsonData != null) {
      tasks = json.decode(jsonData).cast<Map<String, dynamic>>();
    }

    print("tasks from storage.. $tasks");
    if (tasks.length > 0) {
      // var jsonRes = json.decode(tasks).cast<Map<String, dynamic>>();
      var response = tasks.map<Task>((json) => Task.fromJson(json)).toList();
      print("response.. $response");
      return response;
    }

    var userAuthToken;
    var data = await _storage.read("user");
    if (data != null) {
      userAuthToken = json.decode(data)['idToken'];
    }
    // print(userAuthToken);

    print('get tasks...');

    final response = await http.get(
      // 'http://10.0.2.2:5000/api/task',
      'https://phondani1.pythonanywhere.com/api/task',
      headers: {HttpHeaders.authorizationHeader: userAuthToken},
    );
    print(3);
    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(json.decode(response.body));

      print(response.body);
      _storage.addNewItem("tasks", response.body);

      var jsonRes = json.decode(response.body).cast<Map<String, dynamic>>();

      return jsonRes.map<Task>((json) => Task.fromJson(json)).toList();
    } else {
      print(response.body);
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load task');
    }
  }
}
