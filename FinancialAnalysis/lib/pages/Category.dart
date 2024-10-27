import 'package:flutter/material.dart';
import 'package:financial_analysis/data/database.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  DataBase db = DataBase();
  bool mode = false;
  List categories = [];
  DateTime? firstDate;
  DateTime? secondDate;
  bool? period;

  @override
  void initState() {
    db.loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        mode = args['mode'];
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          toolbarHeight: 100,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        padding: const EdgeInsets.only(right: 20, left: 10),
                        onPressed: () {
                          Navigator.pushNamed(context, '/home', arguments: {
                            'firstDate': firstDate,
                            'secondDate': secondDate,
                            'period': period,
                            'mode': mode
                          });
                        },
                        icon: const Icon(Icons.arrow_back)),
                  ),
                  const Text('Мои категории'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            mode = false;
                          });
                        },
                        child: const Text('Расходы'),
                      ),
                    ),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                mode = true;
                              });
                            },
                            child: const Text('Зачисления')))
                  ],
                ),
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 3,
                      color: mode ? Colors.transparent : Colors.green,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 3,
                      color: mode ? Colors.green : Colors.transparent,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        body: Center(
          child: Column(children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: mode
                  ? db.depositsCategories.length
                  : db.expensesCategories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      enableDrag: true,
                      builder: (context) {
                        return SizedBox(
                            height: 180,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.horizontal_rule,
                                    size: 40,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/addCategory',
                                                arguments: {
                                                  'mode': mode,
                                                  'index': index,
                                                  'firstDate': firstDate,
                                                  'secondDate': secondDate,
                                                  'period': period
                                                });
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            width: double.infinity,
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  Icons.edit,
                                                  size: 40,
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 40),
                                                  child: Text(
                                                    'Редактировать',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                      const Divider(
                                        indent: 65,
                                        endIndent: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          String catName = '';
                                          if (mode) {
                                            catName =
                                                db.depositsCategories[index]
                                                    ['name'];
                                            db.operations.removeWhere(
                                                (operation) =>
                                                    operation['category'] ==
                                                        catName &&
                                                    operation['mode']);
                                            db.depositsCategories
                                                .removeAt(index);
                                          } else {
                                            catName =
                                                db.expensesCategories[index]
                                                    ['name'];
                                            db.operations.removeWhere(
                                                (operation) =>
                                                    operation['category'] ==
                                                        catName &&
                                                    !operation['mode']);
                                            db.expensesCategories
                                                .removeAt(index);
                                          }
                                          db.updateCategory();
                                          db.updateOperations();
                                          Navigator.pushNamed(
                                              context, '/Category', arguments: {
                                            'firstDate': firstDate,
                                            'secondDate': secondDate,
                                            'period': period,
                                            'mode': mode
                                          });
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          width: double.infinity,
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                size: 40,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 40),
                                                child: Text(
                                                  'Удалить',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ));
                      },
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.circle,
                        size: 27,
                        color: mode
                            ? Color(db.depositsCategories[index]['color'])
                            : Color(db.expensesCategories[index]['color'])),
                    title: Text(mode
                        ? db.depositsCategories[index]['name'].toString()
                        : db.expensesCategories[index]['name'].toString()),
                  ),
                );
              },
            ),
          ]),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 300,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addCategory', arguments: {
                    'mode': mode,
                    'firstDate': firstDate,
                    'secondDate': secondDate,
                    'period': period
                  });
                },
                child: const Text(
                  'Добавить категорию',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ));
  }
}
