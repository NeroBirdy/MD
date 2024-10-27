import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Temperature extends StatefulWidget {
  const Temperature({super.key});

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  final List<String> items = ['°C', '℉', 'K'];
  String? selected = '°C';
  double typed = 0;
  bool error = false;

  String conversion(double value, String target) {
    if (error) {
      return 'error';
    }

    if (selected == target) {
      return value.toString();
    }

    if (selected == '°C') {
      if (target == '℉') {
        value = value * 1.8 + 32;
      } else {
        value += 273.15;
      }
    } else if (selected == '℉') {
      if (target == '°C') {
        value = (value - 32) * 5 / 9;
      } else {
        value = (value - 32) * 5 / 9 + 273.15;
      }
    } else {
      if (target == '°C') {
        value -= 273.15;
      } else {
        value = (value - 273.15) * 1.8 + 32;
      }
    }
    return value.toStringAsFixed(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Temperature',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () => {Navigator.pushNamed(context, '/home')},
            icon: const FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.indigo,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: 250,
                      child: TextField(
                        inputFormatters: const [
                          // FilteringTextInputFormatter(RegExp(r'^-?\d+(\.\d+)?'),
                          //     allow: true),
                        ],
                        onChanged: (value) => {
                          setState(() {
                            if (value == '') {
                              value = '0';
                            }
                            try {
                              typed = double.parse(value);
                              error = false;
                            } catch (e) {
                              typed = 0;
                              error = true;
                            }
                          })
                        },
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                    )),
                DropdownMenu(
                  width: 100,
                  initialSelection: '°C',
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
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: Card(
                  color: const Color.fromARGB(255, 180, 180, 180),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            conversion(typed, '°C').toString(),
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              conversion(typed, '°C').toString() != 'error'
                                  ? '°C'
                                  : '',
                              style: const TextStyle(fontSize: 30)),
                        )
                      ],
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Card(
                  color: const Color.fromARGB(255, 180, 180, 180),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            conversion(typed, '℉').toString(),
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              conversion(typed, '°C').toString() != 'error'
                                  ? '℉'
                                  : '',
                              style: const TextStyle(fontSize: 30)),
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          conversion(typed, 'K').toString(),
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                            conversion(typed, '°C').toString() != 'error'
                                ? 'K'
                                : '',
                            style: const TextStyle(fontSize: 30)),
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
