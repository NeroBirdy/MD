import 'package:flutter/material.dart';
import 'package:financial_analysis/data/database.dart';
import 'package:financial_analysis/data/calendar.dart';
import 'package:flutter/services.dart';

class AddOperation extends StatefulWidget {
  const AddOperation({super.key});

  @override
  State<AddOperation> createState() => _AddOperationState();
}

class _AddOperationState extends State<AddOperation> {
  List list = [];
  String catName = '';
  bool mode = false;
  int? index;
  List arr = [];
  DataBase db = DataBase();
  String name = '';
  String money = '';
  DateTime date = DateTime.now();
  Map? selectedItem;
  DateTime selectedDate = DateTime.now();
  DateTime? firstDate;
  DateTime? secondDate;
  bool? period;

  TextEditingController moneyController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  bool enabled = false;

  void checkFields() {
    setState(() {
      enabled = name != '' && money != '' && selectedItem != null;
    });
  }

  void getModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(
              Icons.horizontal_rule,
              size: 40,
            ),
            ...arr.map((item) {
              return ListTile(
                title: Text(item['name']),
                leading:
                    Icon(Icons.circle, size: 27, color: Color(item['color'])),
                trailing: Radio<Map>(
                  value: item,
                  groupValue: selectedItem,
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value;
                    });
                    Navigator.pop(context);
                  },
                ),
                onTap: () {
                  setState(() {
                    selectedItem = item;
                    checkFields();
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ]),
        ));
      },
    );
  }

  Future getDate(BuildContext context) async {
    DateTime? date = await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 400,
              child: Calendar(
                twoDates: false,
              ),
            ),
          );
        });
    if (date != null) {
      selectedDate = date;
    }
  }

  int getId() {
    if (db.operations.isNotEmpty) {
      if (db.operations.length == 1) {
        return 1;
      } else {
        return db.operations[db.operations.length - 1]['id'] + 1;
      }
    } else {
      return 0;
    }
  }

  String getText() {
    List text = selectedDate.toString().substring(0, 10).split('-');
    return '${text[2]}.${text[1]}.${text[0]}';
  }

  @override
  void initState() {
    db.loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        mode = args['mode']!;
        arr = mode ? db.depositsCategories : db.expensesCategories;
        if (args['index'] != null) {
          catName = args['category'];
          index = args['index'];
          selectedDate = db.operations[index!]['date'];
          name = db.operations[index!]['name'];
          money = db.operations[index!]['money'];
          nameController.text = name;
          moneyController.text = money;
          if (mode) {
            selectedItem = db.depositsCategories
                .where(
                    (item) => item['name'] == db.operations[index!]['category'])
                .toList()[0];
          } else {
            selectedItem = db.expensesCategories
                .where(
                    (item) => item['name'] == db.operations[index!]['category'])
                .toList()[0];
          }
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
                if (args['index'] != null) {
                  list = db.operations
                      .where((item) =>
                          item['category'] == catName &&
                          item['mode'] == mode &&
                          item['date'].isAfter(firstDate!) &&
                          item['date'].isBefore(secondDate!))
                      .toList();
                  Navigator.pushNamed(context, '/Operation', arguments: {
                    'mode': mode,
                    'list': list,
                    'firstDate': firstDate,
                    'secondDate': secondDate,
                    'period': period
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
              icon: Icon(Icons.arrow_back)),
          title: index == null
              ? Text(mode ? 'Новое зачисление' : 'Новый расход')
              : Text('Редактировать'),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            children: [
              Card(
                color: const Color.fromARGB(255, 223, 220, 220),
                shadowColor: Colors.transparent,
                child: SizedBox(
                    height: 55,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: nameController,
                        onChanged: (value) {
                          setState(() {
                            name = value;
                            checkFields();
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'Название', border: InputBorder.none),
                      ),
                    )),
              ),
              Card(
                color: const Color.fromARGB(255, 223, 220, 220),
                shadowColor: Colors.transparent,
                child: SizedBox(
                    height: 55,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp(r'\d*'),
                              allow: true),
                        ],
                        controller: moneyController,
                        onChanged: (value) {
                          setState(() {
                            money = value;
                            checkFields();
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'Сумма', border: InputBorder.none),
                      ),
                    )),
              ),
              GestureDetector(
                onTap: () {
                  getDate(context);
                },
                child: Card(
                  color: const Color.fromARGB(255, 223, 220, 220),
                  shadowColor: Colors.transparent,
                  child: SizedBox(
                      height: 55,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                              labelText: getText(),
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none),
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  getModal();
                },
                child: Card(
                  color: const Color.fromARGB(255, 223, 220, 220),
                  shadowColor: Colors.transparent,
                  child: SizedBox(
                      height: 55,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            selectedItem == null
                                ? Text(
                                    'Категория',
                                    style: TextStyle(fontSize: 17),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 3),
                                            child: Text('Категория',
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              selectedItem!['name'] ?? '',
                                              style: TextStyle(fontSize: 17)),
                                        ),
                                      ],
                                    ),
                                  ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.arrow_downward),
                            )
                          ],
                        ),
                      )),
                ),
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
                backgroundColor: !enabled ? Colors.grey : null,
                foregroundColor: !enabled ? Colors.white : null,
                onPressed: () {
                  if (!enabled) {
                    return;
                  }

                  if (index == null) {
                    db.operations.add({
                      'id': getId(),
                      'name': name,
                      'money': money,
                      'category': selectedItem!['name'].toString(),
                      'date': selectedDate,
                      'mode': mode,
                      'color': selectedItem!['color']
                    });
                    db.updateOperations();
                    Navigator.pushNamed(context, '/home', arguments: {
                      'firstDate': firstDate,
                      'secondDate': secondDate,
                      'period': period,
                      'mode': mode
                    });
                  } else {
                    db.operations[index!] = {
                      'id': db.operations[index!]['id'],
                      'name': name,
                      'money': money,
                      'category': selectedItem!['name'].toString(),
                      'date': selectedDate,
                      'mode': mode,
                      'color': selectedItem!['color']
                    };
                    db.updateOperations();
                    list = db.operations
                        .where((item) =>
                            item['category'] == catName &&
                            item['mode'] == mode &&
                            item['date'].isAfter(firstDate!) &&
                            item['date'].isBefore(secondDate!))
                        .toList();
                    if (list.isNotEmpty) {
                      Navigator.pushNamed(context, '/Operation', arguments: {
                        'mode': mode,
                        'list': list,
                        'firstDate': firstDate,
                        'secondDate': secondDate,
                        'period': period
                      });
                    } else {
                      Navigator.pushNamed(context, '/home', arguments: {
                        'firstDate': firstDate,
                        'secondDate': secondDate,
                        'period': period,
                        'mode': mode
                      });
                    }
                  }
                },
                child: Text(
                  index == null ? 'Добавить' : 'Сохранить',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ));
  }
}
