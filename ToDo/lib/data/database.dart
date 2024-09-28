import 'package:hive_flutter/hive_flutter.dart';

class ToDoList {
  List toDo = [];

  final myBox = Hive.box('mybox');

  void loadData() {
    toDo = myBox.get('List', defaultValue: []);
  }

  void update() {
    myBox.put('List', toDo);
  }
}
