import 'package:financial_analysis/data/calendar.dart';
import 'package:financial_analysis/pages/Operation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:financial_analysis/data/database.dart';
import 'package:financial_analysis/pages/Category.dart';
import 'package:financial_analysis/pages/addCategory.dart';
import 'package:financial_analysis/pages/addOperation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('mybox');

  initializeDateFormatting('ru_RU', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Анализ финансов',
      routes: {
        '/home': (context) => Financial(),
        '/Category': (context) => Category(),
        '/addCategory': (context) => AddCategory(),
        '/addOperation': (context) => AddOperation(),
        '/Operation': (context) => Operation()
      },
      initialRoute: '/home',
    );
  }
}

class Financial extends StatefulWidget {
  const Financial({super.key});

  @override
  State<Financial> createState() => _FinancialState();
}

class _FinancialState extends State<Financial> {
  bool period = false;
  bool isLoading = true;
  DateTime today = DateTime.now();
  DateTime? firstDate;
  DateTime? secondDate;
  DataBase db = DataBase();
  bool mode = false;
  Map<String, Map> depositsCategoriesSum = {};
  Map<String, Map> expensesCategoriesSum = {};
  int dSum = 0;
  int eSum = 0;

  void getSum() {
    depositsCategoriesSum = {};
    expensesCategoriesSum = {};
    dSum = 0;
    eSum = 0;
    for (int i = 0; i < db.depositsCategories.length; i++) {
      List temp = db.operations
          .where((item) =>
              item['category'] == db.depositsCategories[i]['name'] &&
              item['mode'] &&
              ((item['date'].isAfter(firstDate!) &&
                      item['date'].isBefore(secondDate!)) ||
                  item['date'] == firstDate ||
                  item['date'] == secondDate))
          .toList();
      int sum = 0;
      int count = 0;
      for (int a = 0; a < temp.length; a++) {
        sum += int.parse(temp[a]['money']);
        count++;
      }
      sum != 0
          ? depositsCategoriesSum.putIfAbsent(
              db.depositsCategories[i]['name'],
              () => {
                    'sum': sum,
                    'count': count,
                    'operations': temp,
                    'color': db.depositsCategories[i]['color']
                  })
          : null;
    }
    for (int i = 0; i < db.expensesCategories.length; i++) {
      List temp = db.operations
          .where((item) =>
              item['category'] == db.expensesCategories[i]['name'] &&
              !item['mode'] &&
              ((item['date'].isAfter(firstDate!) &&
                      item['date'].isBefore(secondDate!)) ||
                  item['date'] == firstDate ||
                  item['date'] == secondDate))
          .toList();
      int sum = 0;
      int count = 0;
      for (int a = 0; a < temp.length; a++) {
        sum += int.parse(temp[a]['money'].toString());
        count++;
      }
      sum != 0
          ? expensesCategoriesSum.putIfAbsent(
              db.expensesCategories[i]['name'],
              () => {
                    'sum': sum,
                    'count': count,
                    'operations': temp,
                    'color': db.expensesCategories[i]['color']
                  })
          : null;
    }

    depositsCategoriesSum.forEach((key, value) {
      dSum += int.parse(value['sum'].toString());
    });
    expensesCategoriesSum.forEach((key, value) {
      eSum += int.parse(value['sum'].toString());
    });
  }

  String getOperationText(int count) {
    if (count % 100 >= 11 && count % 100 <= 19) {
      return "$count операций";
    }

    switch (count % 10) {
      case 1:
        return "$count операция";
      case 2:
      case 3:
      case 4:
        return "$count операции";
      default:
        return "$count операций";
    }
  }

  String getMonthName(DateTime date) {
    if (period) {
      int days = (firstDate == secondDate)
          ? 1
          : secondDate!.difference(firstDate!).inDays;
      int lastDigit = days % 10;
      int lastTwoDigits = days % 100;

      if (lastTwoDigits >= 11 && lastTwoDigits <= 19) {
        return "$days дней";
      } else if (lastDigit == 1) {
        return "$days день";
      } else if (lastDigit >= 2 && lastDigit <= 4) {
        return "$days дня";
      } else {
        return "$days дней";
      }
    }
    String monthText = DateFormat('MMMM', 'ru_RU').format(date);
    if (date.year < today.year) {
      return monthText[0].toUpperCase() +
          monthText.substring(1) +
          ', ${date.year}';
    }
    return monthText[0].toUpperCase() + monthText.substring(1);
  }

  String getPeriodText() {
    List first = firstDate.toString().substring(0, 10).split('-');
    List second = secondDate.toString().substring(0, 10).split('-');
    if (firstDate == secondDate) {
      return '${first[2]}.${first[1]}.${first[0].substring(1, 3)}';
    }
    if (firstDate!.year != today.year || secondDate!.year != today.year) {
      return '${first[2]}.${first[1]}.${first[0].substring(2)} - ${second[2]}.${second[1]}.${second[0].substring(2)}';
    } else {
      return '${first[2]}.${first[1]} - ${second[2]}.${second[1]}';
    }
  }

  Future getPeriod(BuildContext context) async {
    Map? dates = await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 400,
              child: Calendar(
                twoDates: true,
              ),
            ),
          );
        });
    if (dates != null) {
      setState(() {
        firstDate = dates['firstDate'];
        secondDate = dates['secondDate'];
        period = true;
        getSum();
      });
    }
  }

  @override
  void initState() {
    firstDate = DateTime(today.year, today.month, 1);
    int lastDay = DateUtils.getDaysInMonth(today.year, today.month);
    secondDate = DateTime(today.year, today.month, lastDay);
    db.loadData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        if (args['firstDate'] != null) {
          firstDate = args['firstDate'];
          secondDate = args['secondDate'];
          period = args['period'];
          mode = args['mode'];
        }
      }
      setState(() {
        getSum();
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0,
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          title: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text('Анализ финансов'),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                                splashFactory: NoSplash.splashFactory),
                            onPressed: () {
                              setState(() {
                                mode = false;
                              });
                            },
                            child: Text('Расходы'),
                          ),
                        ),
                        Expanded(
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    splashFactory: NoSplash.splashFactory),
                                onPressed: () {
                                  setState(() {
                                    mode = true;
                                  });
                                },
                                child: Text('Зачисления')))
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
              Positioned(
                  top: -5,
                  right: 0,
                  child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            enableDrag: true,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Container(
                                  height: 220,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.horizontal_rule,
                                        size: 40,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              Navigator.pop(context);
                                              getPeriod(context);
                                            });
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            width: double.infinity,
                                            child: const Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 20, left: 5),
                                                      child: Icon(
                                                        Icons.calendar_month,
                                                        size: 40,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Выбрать произвольный период',
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 65),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        'например, отличный от месяца',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                      const Divider(
                                        indent: 55,
                                        endIndent: 20,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/Category',
                                                arguments: {
                                                  'firstDate': firstDate,
                                                  'secondDate': secondDate,
                                                  'period': period,
                                                  'mode': mode
                                                });
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            width: double.infinity,
                                            child: const Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 20, left: 5),
                                                      child: Icon(
                                                        Icons.edit,
                                                        size: 40,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Создать категорию',
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 65),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        'или изменить те, что уже создали',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      icon: Icon(Icons.more_horiz)))
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mode ? dSum.toString() + '₽' : eSum.toString() + '₽',
                      style: TextStyle(fontSize: 20),
                    ),
                    period
                        ? SizedBox(
                            height: 40,
                            width: firstDate == secondDate
                                ? 120
                                : firstDate!.year != today.year ||
                                        secondDate!.year != today.year
                                    ? 180
                                    : 140,
                            child: Card(
                              color: const Color.fromARGB(255, 221, 220, 220),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(getPeriodText()),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        firstDate = DateTime(
                                            today.year, today.month, 1);
                                        int lastDay = DateUtils.getDaysInMonth(
                                            today.year, today.month);
                                        secondDate = DateTime(
                                            today.year, today.month, lastDay);
                                        getSum();
                                        period = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Icon(Icons.close, size: 17),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 40,
                          )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !period
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                firstDate = DateTime(
                                    firstDate!.year, firstDate!.month - 1, 1);
                                int lastDay = DateUtils.getDaysInMonth(
                                    firstDate!.year, firstDate!.month);
                                secondDate = DateTime(secondDate!.year,
                                    secondDate!.month - 1, lastDay);
                                getSum();
                              });
                            },
                            child: Icon(Icons.arrow_back),
                          )
                        : SizedBox(),
                    Expanded(
                        child: AspectRatio(
                      aspectRatio: period ? 1.15 : 1,
                      child: Container(
                          margin: EdgeInsets.all(10),
                          child: Stack(
                            children: [
                              PieChart(
                                PieChartData(
                                  sectionsSpace: 0,
                                  sections: mode
                                      ? depositsCategoriesSum.isNotEmpty
                                          ? depositsCategoriesSum.entries
                                              .map((item) {
                                              return PieChartSectionData(
                                                  value: item.value['sum']
                                                      .toDouble(),
                                                  title: '',
                                                  radius: 35,
                                                  color: Color(
                                                      item.value['color']));
                                            }).toList()
                                          : [
                                              PieChartSectionData(
                                                value: 1,
                                                title: '',
                                                radius: 35,
                                                color: const Color.fromARGB(
                                                    255, 182, 181, 181),
                                              ),
                                            ]
                                      : expensesCategoriesSum.isNotEmpty
                                          ? expensesCategoriesSum.entries
                                              .map((item) {
                                              return PieChartSectionData(
                                                  value: item.value['sum']
                                                      .toDouble(),
                                                  title: '',
                                                  radius: 35,
                                                  color: Color(
                                                      item.value['color']));
                                            }).toList()
                                          : [
                                              PieChartSectionData(
                                                value: 1,
                                                title: '',
                                                radius: 35,
                                                color: const Color.fromARGB(
                                                    255, 182, 181, 181),
                                              ),
                                            ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  getMonthName(firstDate!),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )),
                    )),
                    DateTime(firstDate!.year, firstDate!.month + 1)
                                .isBefore(today) &&
                            !period
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                firstDate = DateTime(
                                    firstDate!.year, firstDate!.month + 1, 1);
                                int lastDay = DateUtils.getDaysInMonth(
                                    firstDate!.year, firstDate!.month);
                                secondDate = DateTime(secondDate!.year,
                                    secondDate!.month + 1, lastDay);
                                getSum();
                              });
                            },
                            child: Icon(Icons.arrow_forward),
                          )
                        : SizedBox(
                            width: period ? 0 : 24,
                          )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (mode) {
                            if (db.depositsCategories.isNotEmpty) {
                              Navigator.pushNamed(context, '/addOperation',
                                  arguments: {
                                    'mode': mode,
                                    'firstDate': firstDate,
                                    'secondDate': secondDate,
                                    'period': period
                                  });
                            }
                          } else {
                            if (db.expensesCategories.isNotEmpty) {
                              Navigator.pushNamed(context, '/addOperation',
                                  arguments: {
                                    'mode': mode,
                                    'firstDate': firstDate,
                                    'secondDate': secondDate,
                                    'period': period
                                  });
                            }
                          }
                        },
                        child: Text(
                            mode ? 'Добавить зачисления' : 'Добавить расходы'))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Категории',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: mode
                          ? depositsCategoriesSum.length
                          : expensesCategoriesSum.length,
                      itemBuilder: (context, index) {
                        var entry = mode
                            ? depositsCategoriesSum.entries.elementAt(index)
                            : expensesCategoriesSum.entries.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/Operation',
                                arguments: {
                                  'mode': mode,
                                  'list': entry.value['operations'],
                                  'firstDate': firstDate,
                                  'secondDate': secondDate,
                                  'period': period
                                });
                          },
                          child: Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.circle,
                                            color: Color(entry.value['color'])),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Text(
                                            entry.key.toString(),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 30),
                                      child: Text(
                                        entry.value['sum'].toString() + '₽',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 32),
                                  child: Text(
                                      getOperationText(entry.value['count'])),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                  child: Divider(
                                    thickness: 1,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
