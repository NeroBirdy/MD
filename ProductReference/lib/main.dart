import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_reference/data/db.dart';
import 'package:product_reference/pages/select.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://crbspbdlxhqxfbkhzlbm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNyYnNwYmRseGhxeGZia2h6bGJtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg4NzQ4ODcsImV4cCI6MjA0NDQ1MDg4N30.Vt3UK-EgFme81aYCMigz3_3P56Qs2KGfoGDUYoi1iQs',
  );

  await Hive.initFlutter();
  await Hive.openBox('mybox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Reference',
      home: ProductList(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/select': (context) => SelectProduct(),
        '/home': (context) => ProductList()
      },
    );
  }
}

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final myBox = Hive.box('mybox');
  DataBase db = DataBase();

  @override
  void initState() {
    db.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Справочник продуктов'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    Map values = {
                      'time': 'Breakfast',
                      'calories': 0,
                      'text': 'Завтрак',
                      'icon': FaIcon(FontAwesomeIcons.egg),
                      'list': db.breakfast
                    };
                    double temp = 0;

                    if (index == 1) {
                      values['calories'] = temp.toString();
                      values['time'] = 'Lunch';
                      values['text'] = 'Обед';
                      values['icon'] = FaIcon(FontAwesomeIcons.apple);
                      values['list'] = db.lunch;
                    } else if (index == 2) {
                      values['calories'] = temp.toString();
                      values['time'] = 'Dinner';
                      values['text'] = 'Ужин';
                      values['icon'] = FaIcon(FontAwesomeIcons.bowlFood);
                      values['list'] = db.dinner;
                    }

                    for (int i = 0; i < values['list'].length; i++) {
                      temp += values['list'][i]['calories'];
                    }
                    values['calories'] = temp.toString();

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(80, 0, 0, 0),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Theme(
                          data: ThemeData(
                            dividerColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            highlightColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            leading: values['icon'],
                            showTrailingIcon: false,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(values['text'] != 'Завтрак'
                                    ? values['text'] + '     '
                                    : values['text']),
                                Padding(
                                    padding: EdgeInsets.only(left: 70),
                                    child: Text('${values['calories']} Ккал')),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/select',
                                          arguments: <String, String>{
                                            'time': values['time'],
                                            'text': values['text']
                                          });
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.plus,
                                      color: Color.fromARGB(255, 59, 114, 61),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: values['list'].length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      ListTile(
                                          minVerticalPadding: 0,
                                          title: Text(values['list'][index]
                                                  ['name']
                                              .toString()),
                                          subtitle: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    '${values['list'][index]['calories']} ккал'),
                                              ),
                                              Divider()
                                            ],
                                          )),
                                      Positioned(
                                          right: 25,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                values['list'].removeAt(index);
                                                print(values['list']);
                                                db.updateFood(values['time'],
                                                    values['list'],false);
                                              });
                                            },
                                            icon: FaIcon(
                                              FontAwesomeIcons.minus,
                                              color: Color.fromARGB(255, 185, 82, 82),
                                            ),
                                          ))
                                    ],
                                  );
                                },
                              ),
                            ],
                          )),
                    );
                  }))
        ],
      ),
    );
  }
}
