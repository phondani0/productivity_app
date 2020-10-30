import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todoapp/UI/Intray/intray_page.dart';
import 'package:todoapp/models/classes/storage.dart';
import 'package:todoapp/models/global.dart';
import 'package:http/http.dart' as http;

class IntrayTodo extends StatelessWidget {
  final String title;
  final String keyValue;
  IntrayTodo({this.keyValue, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(keyValue),
      margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
      padding: EdgeInsets.all(10),
      height: 100,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          new BoxShadow(color: Colors.black.withOpacity(.5), blurRadius: 10.0)
        ],
      ),
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              child: Text(
                title,
                style: darkTodoTitle,
              ),
              alignment: Alignment.center,
            ),
            IconButton(
              icon: Icon(Icons.done_outline),
              onPressed: _deleteTask,
            ),
          ],
        ),
      ),
    );
  }

  _deleteTask() async {
    print("done...");
    print(keyValue);
    final _storage = Storage();
    var userAuthToken;
    var data = await _storage.read("user");
    if (data != null) {
      userAuthToken = json.decode(data)['idToken'];
    }

    final response = await http.delete(
      // 'http://10.0.2.2:5000/api/task',
      'https://phondani1.pythonanywhere.com/api/task/$keyValue',
      headers: {HttpHeaders.authorizationHeader: userAuthToken},
    );

    if (response.statusCode == 200) {
      print(response.body);
      IntrayPage().deleteTaskHandler(keyValue);
    } else {
      print(response.body);
      throw Exception('Failed to load task');
    }
  }
}
