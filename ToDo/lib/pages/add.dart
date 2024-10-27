import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/database.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final myBox = Hive.box('mybox');
  ToDoList db = ToDoList();
  String text = '';

  @override
  void initState() {
    db.loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 157, 101, 194),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(72, 103, 56, 134),
        title: const Text('Add ToDo', style: TextStyle(color: Colors.white)),
        leading: IconButton(
            onPressed: () => {Navigator.pushNamed(context, '/home')},
            icon: const FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.black,
            )),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 109, 72, 133))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            width: 2, color: Color.fromARGB(255, 52, 30, 66)))),
                onChanged: (value) {
                  setState(() {
                    text = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: IconButton(
                  iconSize: 50,
                  color: const Color.fromARGB(248, 94, 57, 124),
                  onPressed: () {
                    if (text != '') {
                      db.toDo.add([text, false]);
                      db.update();
                    }
                    Navigator.pushNamed(context, '/home');
                  },
                  icon: const FaIcon(FontAwesomeIcons.circlePlus)),
            )
          ],
        ),
      ),
    );
  }
}
