import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/database.dart';

class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final myBox = Hive.box('mybox');
  ToDoList db = ToDoList();
  TextEditingController controller = TextEditingController();
  String text = '';
  bool flag = true;

  @override
  void initState() {
    db.loadData();
    controller.text = text;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (flag) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, int>;

      if (db.toDo.isNotEmpty) {
        text = db.toDo[args['index']!][0];
        controller.text = text;
      }
      flag = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, int>;

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 157, 101, 194),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(72, 103, 56, 134),
          title: const Text('Edit ToDo', style: TextStyle(color: Colors.white)),
          leading: IconButton(
              onPressed: () => {Navigator.pushNamed(context, '/home')},
              icon: const FaIcon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.black,
              )),
        ),
        body: Stack(
          children: [
            Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                    iconSize: 50,
                    color: const Color.fromARGB(248, 94, 57, 124),
                    onPressed: () {
                      db.toDo.removeAt(args['index']!);
                      db.update();
                      Navigator.pushNamed(context, '/home');
                    },
                    icon: const FaIcon(FontAwesomeIcons.trash))),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 109, 72, 133))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 52, 30, 66)))),
                      onChanged: (value) {
                        setState(() {
                          text = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                      iconSize: 50,
                      color: const Color.fromARGB(248, 94, 57, 124),
                      onPressed: () {
                        db.toDo[args['index']!][0] = text;
                        db.update();
                        Navigator.pushNamed(context, '/home',
                            arguments: {'routeBefore': 'edit'});
                      },
                      icon: const FaIcon(FontAwesomeIcons.solidCircleCheck))
                ],
              ),
            ),
          ],
        ));
  }
}
