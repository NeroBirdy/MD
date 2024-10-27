import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final myBox = Hive.box('mybox');
  ToDoList db = ToDoList();
  List filtered = [];
  Color filterColor = const Color.fromARGB(255, 51, 51, 51);
   List<bool> full = [];

  @override
  void initState() {
    db.loadData();
    print(db.toDo);

    filtered = getList();
    full = List.generate(filtered.length, (index) => false);

    super.initState();
  }

  int filter = 2;

  List getList() {
    if (filter != 2) {
      bool temp = filter == 1 ? true : false;
      filtered = db.toDo
          .asMap()
          .entries
          .where((item) => item.value[1] == temp)
          .map((item) => item.key)
          .toList();
    } else {
      filtered = db.toDo.asMap().entries.map((item) => item.key).toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 157, 101, 194),
        appBar: AppBar(
            title: const Text('ToDo', style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    filter = (filter + 1) % 3;
                    switch (filter) {
                      case (1):
                        filterColor = const Color.fromARGB(255, 124, 165, 77);
                      case (0):
                        filterColor = const Color.fromARGB(255, 196, 88, 88);
                      default:
                        filterColor = const Color.fromARGB(255, 51, 51, 51);
                    }
                    filtered = getList();
                  });
                },
                icon: const FaIcon(FontAwesomeIcons.filter),
                color: filterColor,
              )
            ],
            backgroundColor: const Color.fromARGB(72, 103, 56, 134),
            automaticallyImplyLeading: false),
        body: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Expanded(
                      child: ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: filtered.length,
                    itemBuilder: (BuildContext context, int index) {
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            full[index] = !full[index];
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(72, 103, 56, 134)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Transform.scale(
                                        scale: 1.4,
                                        child: Checkbox(
                                            side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 51, 51, 51),
                                                width: 2),
                                            value: db.toDo[filtered[index]][1],
                                            onChanged: (bool? value) {
                                              setState(() {
                                                db.toDo[filtered[index]][1] =
                                                    value;
                                                db.update();
                                              });
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6),
                                          child: IntrinsicHeight(
                                            child: Text(
                                              db.toDo[filtered[index]][0],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                              maxLines: full[index] ? null : 3,
                                              overflow: full[index] ? TextOverflow.visible : TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        iconSize: 28,
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/edit',
                                              arguments: <String, int>{
                                                'index': filtered[index]
                                              });
                                        },
                                        icon: const FaIcon(FontAwesomeIcons.edit),
                                        color: const Color.fromARGB(
                                            255, 51, 51, 51),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 20,
                    ),
                  ))
                ],
              ),
            ),
            Positioned(
                right: 0,
                bottom: 0,
                child: IconButton(
                    iconSize: 50,
                    color: const Color.fromARGB(248, 94, 57, 124),
                    onPressed: () {
                      Navigator.pushNamed(context, '/add');
                    },
                    icon: const FaIcon(FontAwesomeIcons.circlePlus)))
          ],
        ));
  }
}
