import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      debugShowCheckedModeBanner: false,
      home: const Calendar(),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();
  DateTime selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Widget getBack() {
      if (selected.year == today.year && selected.month == today.month) {
        return Container();
      }
      return IconButton(
          onPressed: () {
            setState(() {
              selected = DateTime.now();
            });
          },
          icon: FaIcon(FontAwesomeIcons.backward));
    }

    Widget getYearAndMonth() {
      String textMonth = DateFormat(
        'MMMM',
      ).format(selected);
      String textYear = DateFormat(
        'yyyy',
      ).format(selected);

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  selected = DateTime(selected.year, selected.month - 1);
                });
              },
              icon: FaIcon(FontAwesomeIcons.arrowLeft)),
          Column(
            children: [
              TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          child: ListView.builder(
                            itemCount: 100,
                            itemBuilder: (BuildContext context, int index) {
                              int year = today.year + index - 50;
                              return ListTile(
                                tileColor: selected.year == year
                                    ? Colors.black
                                    : Colors.white,
                                title: Text(
                                  textAlign: TextAlign.center,
                                  '$year',
                                  style: TextStyle(
                                      color: selected.year == year
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: selected.year == year
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ),
                                onTap: () {
                                  setState(() {
                                    selected = DateTime(year, selected.month);
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    textYear,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )),
              SizedBox(
                height: 0,
              ),
              Text(
                textMonth,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              )
            ],
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  selected = DateTime(selected.year, selected.month + 1);
                });
              },
              icon: FaIcon(FontAwesomeIcons.arrowRight)),
        ],
      );
    }

    Widget getDaysOfWeek() {
      const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days
            .map((item) => Text(
                  item,
                  style:
                      TextStyle(color: const Color.fromARGB(255, 245, 179, 93), fontSize: 19),
                ))
            .toList(),
      );
    }

    Color getColor(int day, DateTime date, bool current) {
      if (date.year == today.year &&
          date.month == today.month &&
          day == today.day) {
        return const Color.fromARGB(255, 245, 141, 141);
      } else if (current) {
        return const Color.fromARGB(255, 191, 222, 247);
      }
      return const Color.fromARGB(255, 172, 167, 167);
    }

    Widget getDayCell(int day, Color color) {
      return Card(
        color: color,
        child: Center(
          child: SizedBox(
              height: 100,
              width: 100,
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              )),
        ),
      );
    }

    Widget getDaysOfMonth() {
      List<Widget> grid = [];
      int previousMonth = selected.month == 1 ? 12 : selected.month - 1;

      int daysInCurrentMonth =
          DateUtils.getDaysInMonth(selected.year, selected.month);
      int daysInPreviousMonth =
          DateUtils.getDaysInMonth(selected.year, previousMonth);

      DateTime firstDayOfMonth = DateTime(selected.year, selected.month, 1);
      DateTime lastDayOfMonth =
          DateTime(selected.year, selected.month, daysInCurrentMonth);
      int previousMonthDays = firstDayOfMonth.weekday - 1;
      int nextMonthDays = 7 - lastDayOfMonth.weekday;

      int lastPreviousMonthDay =
          DateTime(selected.year, selected.month - 1, daysInPreviousMonth).day;
      for (int i = previousMonthDays; i > 0; i--) {
        grid.add(getDayCell(
            lastPreviousMonthDay - i + 1,
            getColor(lastPreviousMonthDay - i + 1,
                DateTime(selected.year, selected.month - 1), false)));
      }
      for (int i = 1; i <= daysInCurrentMonth; i++) {
        grid.add(getDayCell(
            i, getColor(i, DateTime(selected.year, selected.month), true)));
      }
      for (int i = 1; i <= nextMonthDays; i++) {
        grid.add(getDayCell(i,
            getColor(i, DateTime(selected.year, selected.month + 1), false)));
      }

      return GridView.count(crossAxisCount: 7, children: grid);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [getBack()],
        title: Text(
          'Calendar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 99, 153, 245),
      ),
      body: Column(
        children: [
          getYearAndMonth(),
          getDaysOfWeek(),
          Expanded(child: getDaysOfMonth())
        ],
      ),
    );
  }
}
