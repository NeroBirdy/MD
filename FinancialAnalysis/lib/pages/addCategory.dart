import 'package:flutter/material.dart';
import 'dart:math';
import 'package:financial_analysis/data/database.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  DateTime? firstDate;
  DateTime? secondDate;
  bool? mode;
  int? index;
  DataBase db = DataBase();
  String name = '';
  final TextEditingController controller = TextEditingController();

  Color generateColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      200 + random.nextInt(56),
      200 + random.nextInt(56),
      200 + random.nextInt(56),
    );
  }

  @override
  void initState() {
    db.loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      mode = args['mode']!;
      setState(() {
        if (args['index'] != null) {
          index = args['index']!;
          name = mode!
              ? db.depositsCategories[index!]['name']
              : db.expensesCategories[index!]['name'];
          controller.text = name;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    firstDate = args['firstDate'];
    secondDate = args['secondDate'];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                if (index != null) {
                  Navigator.pushNamed(context, '/Category', arguments: {
                    'firstDate': firstDate,
                    'secondDate': secondDate
                  });
                } else {
                  Navigator.pushNamed(context, '/home', arguments: {
                    'firstDate': firstDate,
                    'secondDate': secondDate
                  });
                }
              },
              icon: Icon(Icons.arrow_back)),
          backgroundColor: Colors.white,
          title: Text(index != null ? 'Редактировать' : 'Новая категория'),
        ),
        body: Center(
          child: Column(
            children: [
              Card(
                color: const Color.fromARGB(255, 223, 220, 220),
                shadowColor: Colors.transparent,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: controller,
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'Название категории',
                            border: InputBorder.none),
                      ),
                    )),
              )
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 25),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 300,
              child: FloatingActionButton(
                onPressed: () {
                  List tmp = db.operations;

                  if (index != null) {
                    if (mode!) {
                      tmp
                          .where((operation) =>
                              operation['category'] ==
                                  db.depositsCategories[index!]['name'] &&
                              operation['mode'])
                          .forEach((operation) {
                        operation['category'] = name;
                      });
                      db.depositsCategories[index!]['name'] = name;
                    } else {
                      tmp
                          .where((operation) =>
                              operation['category'] ==
                                  db.expensesCategories[index!]['name'] &&
                              !operation['mode'])
                          .forEach((operation) {
                        operation['category'] = name;
                      });
                      db.expensesCategories[index!]['name'] = name;
                    }
                    db.operations = tmp;
                    db.updateCategory();
                    db.updateOperations();
                  } else {
                    mode!
                        ? db.depositsCategories
                            .add({'name': name, 'color': generateColor().value})
                        : db.expensesCategories.add(
                            {'name': name, 'color': generateColor().value});
                    db.updateCategory();
                  }

                  Navigator.pushNamed(context, '/Category', arguments: {
                    'firstDate': firstDate,
                    'secondDate': secondDate
                  });
                },
                child: Text(
                  index != null ? 'Сохранить' : 'Добавить',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ));
  }
}
