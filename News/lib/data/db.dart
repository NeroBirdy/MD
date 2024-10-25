import 'package:hive_flutter/hive_flutter.dart';

class Storage {
  List news = [];

  final myBox = Hive.box('mybox');

  void loadData() {
    news = myBox.get('List', defaultValue: []);
  }

  void update() {
    myBox.put('List', news);
  }

}
