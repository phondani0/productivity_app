import 'package:flutter/material.dart';
import 'package:todoapp/models/classes/task.dart';
import 'package:todoapp/models/global.dart';
import 'package:todoapp/models/widgets/intray_todo.dart';

class IntrayPage extends StatefulWidget {
  @override
  _IntrayPageState createState() => _IntrayPageState();
}

class _IntrayPageState extends State<IntrayPage> {
  List<Task> taskList = [];

  @override
  Widget build(BuildContext context) {
    getList();
    return Container(
      color: darkGreyColor,
      child: _buildReorderableListSimple(context),
    );
  }

  Widget _buildListTile(BuildContext context, Task item) {
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
      child: ReorderableListView(
        padding: EdgeInsets.only(top: 250.0),
        children:
            taskList.map((Task item) => _buildListTile(context, item)).toList(),
        onReorder: _onReorder,
      ),
    );
  }

  void getList() {
    for (int i = 0; i < 10; i++) {
      taskList
          .add(Task(i.toString(), "Todo item " + (i + 1).toString(), false));
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      Task item = taskList[oldIndex];
      taskList.remove(item);
      taskList.insert(newIndex, item);
      print(taskList[0].title);
    });
  }
}
