import 'package:hive_flutter/hive_flutter.dart';

class DataBase {
  List depositsCategories = [];
  List expensesCategories = [];
  List operations = [];

  final myBox = Hive.box('mybox');

  void loadData() {
    depositsCategories = myBox.get('depositsCategories', defaultValue: []);
    expensesCategories = myBox.get('expensesCategories', defaultValue: []);
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
