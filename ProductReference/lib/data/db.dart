import 'package:hive_flutter/hive_flutter.dart';

class DataBase {
  List product = [];
  List breakfast = [];
  List lunch = [];
  List dinner = [];

  final myBox = Hive.box('mybox');

  void loadData() {
    DateTime date;
    if (myBox.get('date') == null) {
      myBox.put('date', DateTime.now());
    } else {
      date = myBox.get('date');
      if (DateTime.now().day != date.day) {
        myBox.put('Breakfast', []);
        myBox.put('Lunch', []);
        myBox.put('Dinner', []);

        myBox.put('date', DateTime.now());
      }
    }

    product = myBox.get('List', defaultValue: []);
    breakfast = myBox.get('Breakfast', defaultValue: []);
    lunch = myBox.get('Lunch', defaultValue: []);
    dinner = myBox.get('Dinner', defaultValue: []);
  }

  void updateFood(String time, List choosen, bool flag) {
    if (flag) {
      if (time == 'Breakfast') {
        breakfast.addAll(choosen);
        myBox.put(time, breakfast);
      } else if (time == 'Lunch') {
        lunch.addAll(choosen);
        myBox.put(time, lunch);
      } else {
        dinner.addAll(choosen);
        myBox.put(time, dinner);
      }
    } else {
      if (time == 'Breakfast') {
        breakfast = choosen;
        myBox.put(time, breakfast);
      } else if (time == 'Lunch') {
        lunch = choosen;
        myBox.put(time, lunch);
      } else {
        dinner = choosen;
        myBox.put(time, dinner);
      }
    }
  }

  void updateProduct() {
    myBox.put('List', product);
  }
}
