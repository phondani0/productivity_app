import 'dart:async';
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
  addTaskHandler(data) => createState().addTaskHandler(data);
  deleteTaskHandler(taskId) => createState().deleteTaskHandler(taskId);

  @override
  IntrayPageState createState() => IntrayPageState();
}

class IntrayPageState extends State<IntrayPage> {
  static List<Task> taskList = [];
  // static Stream<List<Task>> taskStream;
  final _storage = Storage();
  static StreamController<List<Task>> _tasksController;

  @override
  void initState() {
    super.initState();
    _tasksController = new StreamController<List<Task>>();
    loadTasks();
  }

  addTaskHandler(data) async {
    print("add task handler called...");
    print("data $data");
    // var list = _tasksController.sink;
    var task = Task.fromJson(data);
    print(task);
    print(taskList.length);
    taskList.insert(0, task);
    print(taskList.length);
    _tasksController.add(taskList);
  }

  deleteTaskHandler(taskId) async {
    print("deleteTaskHandler called...");
    print(taskList.length);
    var index =
        taskList.indexWhere((element) => element.taskId == taskId.toString());
    taskList.removeAt(index);
    print(taskList.length);
    _tasksController.add(taskList);
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
        keyValue: item.taskId.toString(),
      ),
    );
  }

  Widget _buildReorderableListSimple(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: StreamBuilder<List<Task>>(
        stream: _tasksController.stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return ReorderableListView(
              padding: EdgeInsets.only(top: 250.0),
              children: snapshot.data
                  .map<Widget>((Task item) => _buildListTile(context, item))
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

  void loadTasks() async {
    fetchTasks().then((res) async {
      print(res);
      _tasksController.add(res);
      taskList = res;
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
