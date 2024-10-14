import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/db.dart';

class SelectProduct extends StatefulWidget {
  const SelectProduct({super.key});

  @override
  State<SelectProduct> createState() => _SelectProductState();
}

class _SelectProductState extends State<SelectProduct> {
  final myBox = Hive.box('mybox');
  DataBase db = DataBase();
  final supabase = Supabase.instance.client;
  List filtered = [];

  String filter = '';

  List choosen = [];

  void Search(String text) {
    final regex = RegExp('^' + text, caseSensitive: false);
    setState(() {
      filtered = db.product.where((item) {
        return regex.hasMatch(item['name']);
      }).toList();
    });
  }

  void fetchData() async {
    try {
      final response = await supabase.from('products').select();
      setState(() {
        if (!check(db.product, response)) {
          db.product = response;
          db.updateProduct();
        }
        filtered = db.product;
      });
    } catch (error) {
      setState(() {
        filtered = db.product;
      });
    }
  }

  bool check(List list1, List list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i]['id'] != list2[i]['id'] ||
          list1[i]['name'] != list2[i]['name'] ||
          list1[i]['proteins'] != list2[i]['proteins'] ||
          list1[i]['fats'] != list2[i]['fats'] ||
          list1[i]['carbohydrates'] != list2[i]['carbohydrates'] ||
          list1[i]['calories'] != list2[i]['calories']) return false;
    }

    return true;
  }

  @override
  void initState() {
    db.loadData();
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String time = args['time']!;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          height: 60,
          color: const Color.fromARGB(148, 105, 240, 175),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  icon: FaIcon(FontAwesomeIcons.arrowLeft)),
              Text(
                args['text']!,
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                  onPressed: () {
                    db.updateFood(time, choosen, true);
                    Navigator.pushNamed(context, '/home');
                  },
                  icon: FaIcon(FontAwesomeIcons.check))
            ],
          )),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: Colors.greenAccent,
        titleTextStyle: TextStyle(fontSize: 13, color: Colors.black),
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                height: 35,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      filter = text;
                      Search(filter);
                    });
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 11,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 48, right: 70),
                    child: Text('Ккал'),
                  ),
                  Text('Б'),
                  Text('Ж'),
                  Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: Text('У'),
                  ),
                  SizedBox(
                    width: 30,
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                          child: Stack(
                        children: [
                          Card(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15, top: 7),
                                    child: Text(
                                      filtered[index]['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        textAlign: TextAlign.left,
                                        filtered[index]['description'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 10),
                                      ),
                                    )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 60, right: 80, bottom: 4),
                                      child: Text(
                                        filtered[index]['calories'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(filtered[index]['protein'].toString()),
                                    Text(filtered[index]['fats'].toString()),
                                    Text(filtered[index]['carbohydrates']
                                        .toString()),
                                    SizedBox(
                                      width: 40,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 2,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    print(choosen);
                                    if (choosen.any((item) =>
                                        item['id'] == filtered[index]['id'])) {
                                      choosen.removeWhere((item) =>
                                          item['id'] == filtered[index]['id']);
                                    } else {
                                      choosen.add({
                                        'id': filtered[index]['id'],
                                        'calories': filtered[index]['calories'],
                                        'name': filtered[index]['name']
                                      });
                                    }
                                  });
                                },
                                icon: !choosen.any((item) =>
                                        item['id'] == filtered[index]['id'])
                                    ? FaIcon(FontAwesomeIcons.plus,
                                        color: Color.fromARGB(255, 59, 114, 61))
                                    : FaIcon(FontAwesomeIcons.minus,
                                        color:
                                            Color.fromARGB(255, 185, 82, 82))),
                          ),
                        ],
                      ));
                    })),
          ],
        ),
      ),
    );
  }
}
