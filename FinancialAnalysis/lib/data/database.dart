import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataBase {
  List depositsCategories = [];
  List expensesCategories = [];
  List operations = [];

  final myBox = Hive.box('mybox');

  void loadData() {
    depositsCategories = myBox.get('depositsCategories', defaultValue: [{'name': 'Переводы от людей', 'color': Color.fromARGB(255, 107, 155, 52).value}]);
    expensesCategories = myBox.get('expensesCategories', defaultValue: [{'name': 'Переводы людям', 'color': Color.fromARGB(255, 107, 155, 52).value}]);
    operations = myBox.get('Operations', defaultValue: []);
  }

  void updateCategory() {
    myBox.put('depositsCategories', depositsCategories);
    myBox.put('expensesCategories', expensesCategories);
  }

  void updateOperations() {
    myBox.put('Operations', operations);
  }
}
