import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todoapp/models/widgets/login.dart';
import 'UI/Intray/intray_page.dart';
import 'models/classes/storage.dart';
import 'models/classes/task.dart';
import 'models/global.dart';
import 'package:todoapp/models/global.dart';
import 'package:http/http.dart' as http;
import 'models/widgets/login.dart';

// // Create storage
// final storage = new FlutterSecureStorage();

// // Read value
// String value = await storage.read(key: key);

// // Read all values
// Map<String, String> allValues = await storage.readAll();

// // Delete value
// await storage.delete(key: key);

// // Delete all
// await storage.deleteAll();

// // Write value
// await storage.write(key: key, value: value);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Productivity App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _storage = Storage();
  final _IntrayPage = IntrayPage();

  String userAuthToken;
  List tasks;

  void loadLocalData() async {
    var jsonData = await _storage.read("user");
    if (jsonData == null) return;

    var user = json.decode(jsonData);
    userAuthToken = user['idToken'];
    print("userAuthToken1");
    print(userAuthToken);

    tasks = json.decode((await _storage.read("tasks")));

    // print("tasks from storage...");
    // print(tasks);
  }

  @override
  Widget build(BuildContext context) {
    loadLocalData();

    return MaterialApp(
      color: Colors.yellow,
      home: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: new Scaffold(
            body: Stack(
              children: <Widget>[
                TabBarView(children: [
                  _IntrayPage,
                  LoginPageWidget(),
                  // new Container(
                  //   color: Colors.lightGreen,
                  // )
                ]),
                Container(
                  padding: EdgeInsets.only(left: 50),
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Intray",
                        style: intrayTitleStyle,
                      ),
                      Container(),
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  margin: EdgeInsets.only(
                      top: 120,
                      left: MediaQuery.of(context).size.width * 0.5 - 40),
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      size: 70,
                    ),
                    backgroundColor: primaryColor,
                    onPressed: () {
                      print('Pressed');
                      _showAddDialog();
                    },
                  ),
                )
              ],
            ),
            appBar: new AppBar(
              elevation: 0,
              title: new TabBar(
                tabs: [
                  Tab(icon: new Icon(Icons.home)),
                  Tab(icon: new Icon(Icons.perm_identity))
                  // Tab(icon: new Icon(Icons.rss_feed)),
                ],
                labelColor: darkGreyColor,
                unselectedLabelColor: Colors.blue,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.all(5.0),
              ),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showAddDialog() {
    TextEditingController taskName = new TextEditingController();
    TextEditingController deadline = new TextEditingController();

    if (userAuthToken == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            content: Container(
              constraints: BoxConstraints.expand(
                height: 95,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(13)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Text(
                    "You must be logged in to add new tasks.",
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RaisedButton(
                        color: primaryColor,
                        textColor: Colors.white,
                        child: Text(
                          "Ok",
                          // style: whiteButtonTitle,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
      return;
    }

    // Add user dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: darkGreyColor,
          content: Container(
            padding: EdgeInsets.all(20),
            constraints: BoxConstraints.expand(
              height: 250,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(13)),
              color: darkGreyColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Add New Task",
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  child: TextField(
                    controller: taskName,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      fillColor: Colors.white,
                      hintText: "Name of task",
                      hintStyle: TextStyle(color: Colors.white54),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   child: TextField(
                //     controller: deadline,
                //     decoration: InputDecoration(
                //       hintText: "Deadline",
                //       enabledBorder: UnderlineInputBorder(
                //         borderSide: BorderSide(color: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: primaryColor,
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      color: primaryColor,
                      child: Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                        // style: whiteButtonTitle,
                      ),
                      onPressed: () {
                        if (taskName.text != null) {
                          addTask(taskName.text);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void addTask(String title) async {
    await addUserTask(title);
  }

  Future<void> addUserTask(title) async {
    Map reqBody = {"title": title};
    print('add tasks...');

    final response = await http.post(
      // 'http://10.0.2.2:5000/api/task',
      'https://phondani1.pythonanywhere.com/api/task',
      headers: {
        HttpHeaders.authorizationHeader: userAuthToken,
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: json.encode(reqBody),
    );
    print(3);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(json.decode(response.body)[0]);
      var jsonRes = json.decode(response.body);

      tasks.insert(0, jsonRes['data']);

      _storage.addNewItem(
        "tasks",
        json.encode(tasks),
      );

      _IntrayPage.addTaskHandler(jsonRes['data']);

      // print(jsonRes);
    } else {
      print(response.body);
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load task');
    }
  }
}
