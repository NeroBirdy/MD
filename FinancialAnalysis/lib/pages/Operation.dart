import 'package:flutter/material.dart';
import 'package:financial_analysis/data/database.dart';

class Operation extends StatefulWidget {
  const Operation({super.key});

  @override
  State<Operation> createState() => _OperationState();
}

class _OperationState extends State<Operation> {
  DateTime? firstDate;
  DateTime? secondDate;
  List list = [];
  String? catName;
  DataBase db = DataBase();
  bool mode = false;
  List arr = [];
  @override
  void initState() {
    db.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      mode = args['mode']!;
      arr = args['list'];
      catName = arr[0]['category'];
      firstDate = args['firstDate'];
      secondDate = args['secondDate'];
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home', arguments: {
                'firstDate': firstDate,
                'secondDate': secondDate
              });
            },
            icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.white,
        title: Text(arr[0]['category']),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: ListView.separated(
              itemCount: arr.length,
              separatorBuilder: (context, index) {
                return Divider(
                  endIndent: 15,
                  indent: 55,
                  thickness: 1,
                );
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      enableDrag: true,
                      builder: (context) {
                        return Container(
                            height: 180,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.horizontal_rule,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/addOperation',
                                                arguments: {
                                                  'mode': mode,
                                                  'index': db.operations
                                                      .indexOf(arr[index]),
                                                  'category': arr[index]
                                                      ['category'],
                                                  'firstDate': firstDate,
                                                  'secondDate': secondDate
                                                });
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            width: double.infinity,
                                            child: Row(
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
                                      Divider(
                                        indent: 65,
                                        endIndent: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          db.operations.removeWhere((item) =>
                                              item['id'] == arr[index]['id']);
                                          db.updateOperations();
                                          list = db.operations
                                              .where((item) =>
                                                  item['category'] == catName &&
                                                  item['mode'] == mode &&
                                                  item['date']
                                                      .isAfter(firstDate!) &&
                                                  item['date']
                                                      .isBefore(secondDate!))
                                              .toList();
                                          if (list.isNotEmpty) {
                                            Navigator.pushNamed(
                                                context, '/Operation',
                                                arguments: {
                                                  'mode': mode,
                                                  'list': list,
                                                  'firstDate': firstDate,
                                                  'secondDate': secondDate
                                                });
                                          } else {
                                            Navigator.pushNamed(
                                                context, '/home', arguments: {
                                              'firstDate': firstDate,
                                              'secondDate': secondDate
                                            });
                                          }
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          width: double.infinity,
                                          child: Row(
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
                        size: 27, color: Color(arr[index]['color'])),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          arr[index]['name'],
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          arr[index]['money'].toString() + '₽',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    subtitle: Text(
                      arr[index]['date'].toString().substring(0, 10),
                      style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 87, 86, 83)),
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
