import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Exchange extends StatefulWidget {
  const Exchange({super.key});

  @override
  State<Exchange> createState() => _ExchangeState();
}

class _ExchangeState extends State<Exchange> {
  final List<String> items = ['₽', '\$', '€'];
  String? selected = '₽';
  double typed = 0;

  double conversion(double value, String target) {
    if (selected == target) {
      return value;
    }

    if (selected == '₽') {
      if (target == '\$') {
        value *= 0.011;
      } else {
        value *= 0.0096;
      }
    } else if (selected == '\$') {
      if (target == '₽') {
        value *= 93.36;
      } else {
        value *= 0.89;
      }
    } else {
      if (target == '₽') {
        value *= 104.37;
      } else {
        value *= 1.12;
      }
    }
    return double.parse(value.toStringAsFixed(5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Exchange',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () => {Navigator.pushNamed(context, '/home')},
            icon: FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.indigo,
            )),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: 250,
                      child: TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp(r'^\d+\.?\d*'),
                              allow: true),
                        ],
                        onChanged: (value) => {
                          setState(() {
                            if (value == '') {
                              value = '0';
                            }
                            typed = double.parse(value);
                          })
                        },
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    )),
                DropdownMenu(
                  width: 100,
                  initialSelection: '₽',
                  onSelected: (value) => {
                    setState(() {
                      selected = value;
                    })
                  },
                  dropdownMenuEntries: items
                      .map(
                          (item) => DropdownMenuEntry(value: item, label: item))
                      .toList(),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: Card(
                  color: const Color.fromARGB(255, 180, 180, 180),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            conversion(typed, '₽').toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('₽', style: TextStyle(fontSize: 30)),
                        )
                      ],
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Card(
                  color: const Color.fromARGB(255, 180, 180, 180),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            conversion(typed, '\$').toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('\$', style: TextStyle(fontSize: 30)),
                        )
                      ],
                    ),
                  )),
            ),
            Card(
                color: const Color.fromARGB(255, 180, 180, 180),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          conversion(typed, '€').toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('€', style: TextStyle(fontSize: 30)),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
