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
  bool? period;
  bool? mode;
  int? index;
  DataBase db = DataBase();
  String name = '';
  final TextEditingController controller = TextEditingController();
  bool enabled = false;

  Color generateColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      200 + random.nextInt(56),
      200 + random.nextInt(56),
      200 + random.nextInt(56),
    );
  }

  void checkField() {
    setState(() {
      enabled = name != '';
    });
  }

  void getDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 100,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                            size: 24,
                          ),
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Название категории уже занято',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
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
          checkField();
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
    period = args['period'];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                if (index != null) {
                  Navigator.pushNamed(context, '/Category', arguments: {
                    'firstDate': firstDate,
                    'secondDate': secondDate,
                    'period': period,
                    'mode': mode
                  });
                } else {
                  Navigator.pushNamed(context, '/home', arguments: {
                    'firstDate': firstDate,
                    'secondDate': secondDate,
                    'period': period,
                    'mode': mode
                  });
                }
              },
              icon: const Icon(Icons.arrow_back)),
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
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: controller,
                        onChanged: (value) {
                          setState(() {
                            name = value;
                            checkField();
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Название категории',
                            border: InputBorder.none),
                      ),
                    )),
              )
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 300,
              child: FloatingActionButton(
                backgroundColor: !enabled ? Colors.grey : null,
                foregroundColor: !enabled ? Colors.white : null,
                onPressed: () {
                  if (!enabled) {
                    return;
                  }

                  List tmp = db.operations;

                  if (index != null) {
                    if (mode!) {
                      int count = db.depositsCategories
                          .where((item) => item['name'] == name)
                          .length;
                      if (count > 1) {
                        getDialog();
                        return;
                      }
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
                      int count = db.expensesCategories
                          .where((item) => item['name'] == name)
                          .length;
                      if (count > 1) {
                        getDialog();
                        return;
                      }
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
                    if (mode!) {
                      if (!db.depositsCategories
                          .any((item) => item['name'] == name)) {
                        db.depositsCategories.add(
                            {'name': name, 'color': generateColor().value});
                      } else {
                        getDialog();
                        return;
                      }
                    } else {
                      if (!db.expensesCategories
                          .any((item) => item['name'] == name)) {
                        db.expensesCategories.add(
                            {'name': name, 'color': generateColor().value});
                      } else {
                        getDialog();
                        return;
                      }
                    }
                    db.updateCategory();
                  }

                  Navigator.pushNamed(context, '/Category', arguments: {
                    'firstDate': firstDate,
                    'secondDate': secondDate,
                    'period': period,
                    'mode': mode
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
