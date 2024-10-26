import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();
  DateTime selected = DateTime.now();
  DateTime selectedDate = DateTime.now();

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
      String textMonth = DateFormat('MMMM', 'ru_RU').format(selected);
      textMonth = textMonth[0].toUpperCase() + textMonth.substring(1);
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
              Padding(
                padding: EdgeInsets.only(
                  top: 25,
                ),
                child: Text(
                  textYear,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
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
          (selected.year == today.year && selected.month + 1 <= today.month)
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      selected = DateTime(selected.year, selected.month + 1);
                    });
                  },
                  icon: FaIcon(FontAwesomeIcons.arrowRight))
              : SizedBox(
                  width: 60,
                )
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
                  style: TextStyle(
                      color: const Color.fromARGB(255, 245, 179, 93),
                      fontSize: 19),
                ))
            .toList(),
      );
    }

    Color getColor(int day, DateTime date) {
      if (date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          day == selectedDate.day) {
        return const Color.fromARGB(255, 100, 207, 105);
      }
      if (date.year == today.year &&
          date.month == today.month &&
          day == today.day) {
        return const Color.fromARGB(255, 245, 141, 141);
      } else if ((date.year == today.year &&
          date.month == today.month &&
          day >= today.day)) {
        return const Color.fromARGB(255, 172, 167, 167);
      }
      return const Color.fromARGB(255, 191, 222, 247);
    }

    Widget getDayCell(int day, Color color) {
      return GestureDetector(
        onTap: () {
          setState(() {
            if (selected.year <= today.year &&
                selected.month <= today.month &&
                day <= today.day) {
              selectedDate = DateTime(selected.year, selected.month, day);
            }
          });
        },
        child: Card(
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
        ),
      );
    }

    Widget getDaysOfMonth() {
      List<Widget> grid = [];

      int daysInCurrentMonth =
          DateUtils.getDaysInMonth(selected.year, selected.month);

      DateTime firstDayOfMonth = DateTime(selected.year, selected.month, 1);
      DateTime lastDayOfMonth =
          DateTime(selected.year, selected.month, daysInCurrentMonth);
      int previousMonthDays = firstDayOfMonth.weekday - 1;
      int nextMonthDays = 7 - lastDayOfMonth.weekday;
      for (int i = previousMonthDays; i > 0; i--) {
        grid.add(Container());
      }
      for (int i = 1; i <= daysInCurrentMonth; i++) {
        grid.add(getDayCell(
            i, getColor(i, DateTime(selected.year, selected.month))));
      }
      for (int i = 1; i <= nextMonthDays; i++) {
        grid.add(Container());
      }

      return GridView.count(
          crossAxisCount: 7,
          children: grid,
          physics: NeverScrollableScrollPhysics());
    }

    return Scaffold(
      body: Column(
        children: [
          getYearAndMonth(),
          getDaysOfWeek(),
          Expanded(child: getDaysOfMonth()),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, DateTime.now());
                  },
                  child: Text('Отмена')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, selectedDate);
                  },
                  child: Text('Ок'))
            ],
          )
        ],
      ),
    );
  }
}
