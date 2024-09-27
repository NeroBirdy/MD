import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converter',
      initialRoute: '/home',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => Home(),
        '/weight': (context) => Weight(),
        '/length': (context) => Length(),
        '/exchange': (context) => Exchange(),
        '/temp': (context) => Temperature(),
        '/square': (context) => Square(),
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Converter', style: TextStyle(color: Colors.white)),
            backgroundColor: const Color.fromARGB(255, 161, 154, 154),
            automaticallyImplyLeading: false),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: SizedBox(
                    height: 100,
                    width: 350,
                    child: ElevatedButton.icon(
                        icon: const FaIcon(
                          FontAwesomeIcons.weightScale,
                          color: const Color.fromARGB(255, 131, 59, 255),
                          size: 40,
                        ),
                        onPressed: () =>
                            {Navigator.pushNamed(context, '/weight')},
                        label: Text('Weight'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 192, 183, 183),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ))),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: SizedBox(
                  height: 100,
                  width: 350,
                  child: ElevatedButton.icon(
                      icon: const FaIcon(
                        FontAwesomeIcons.ruler,
                        color: const Color.fromARGB(255, 131, 59, 255),
                        size: 40,
                      ),
                      onPressed: () =>
                          {Navigator.pushNamed(context, '/length')},
                      label: Text('Length'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 192, 183, 183),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: SizedBox(
                  height: 100,
                  width: 350,
                  child: ElevatedButton.icon(
                      icon: const FaIcon(
                        FontAwesomeIcons.euroSign,
                        color: const Color.fromARGB(255, 131, 59, 255),
                        size: 40,
                      ),
                      onPressed: () =>
                          {Navigator.pushNamed(context, '/exchange')},
                      label: Text('Exchange'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 192, 183, 183),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: SizedBox(
                  height: 100,
                  width: 350,
                  child: ElevatedButton.icon(
                      icon: const FaIcon(
                        FontAwesomeIcons.temperatureThreeQuarters,
                        color: const Color.fromARGB(255, 131, 59, 255),
                        size: 40,
                      ),
                      onPressed: () => {Navigator.pushNamed(context, '/temp')},
                      label: Text('Temperature'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 192, 183, 183),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: SizedBox(
                  height: 100,
                  width: 350,
                  child: ElevatedButton.icon(
                    icon: const FaIcon(
                      FontAwesomeIcons.cube,
                      color: const Color.fromARGB(255, 131, 59, 255),
                      size: 40,
                    ),
                    onPressed: () => {Navigator.pushNamed(context, '/square')},
                    label: Text('Square'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 192, 183, 183),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class Weight extends StatefulWidget {
  const Weight({super.key});

  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  final List<String> items = ['g', 'kg', 'c'];
  String? selected = 'g';
  double typed = 0;

  double conversion(double value, String target) {
    if (selected == target) {
      return value;
    }

    if (selected == 'g') {
      if (target == 'kg') {
        value /= 1000;
      } else {
        value /= 100000;
      }
    } else if (selected == 'kg') {
      if (target == 'g') {
        value *= 1000;
      } else {
        value /= 100;
      }
    } else {
      if (target == 'g') {
        value /= 100000;
      } else {
        value /= 100;
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
          'Weight',
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
                  initialSelection: 'g',
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
                            conversion(typed, 'g').toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(' g', style: TextStyle(fontSize: 30)),
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
                            conversion(typed, 'kg').toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('kg', style: TextStyle(fontSize: 30)),
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
                          conversion(typed, 'c').toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('c', style: TextStyle(fontSize: 30)),
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

class Length extends StatefulWidget {
  const Length({super.key});

  @override
  State<Length> createState() => _LengthState();
}

class _LengthState extends State<Length> {
  final List<String> items = ['cm', 'm', 'km'];
  String? selected = 'cm';
  double typed = 0;

  double conversion(double value, String target) {
    if (selected == target) {
      return value;
    }

    if (selected == 'cm') {
      if (target == 'm') {
        value /= 100;
      } else {
        value /= 100000;
      }
    } else if (selected == 'm') {
      if (target == 'cm') {
        value *= 100;
      } else {
        value /= 1000;
      }
    } else {
      if (target == 'cm') {
        value /= 100000;
      } else {
        value /= 100;
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
          'Length',
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
                  initialSelection: 'cm',
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
                            conversion(typed, 'cm').toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('cm', style: TextStyle(fontSize: 30)),
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
                            conversion(typed, 'm').toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('  m', style: TextStyle(fontSize: 30)),
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
                          conversion(typed, 'km').toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('km', style: TextStyle(fontSize: 30)),
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
        title: Text(
          'Temperature',
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
                            InputDecoration(border: OutlineInputBorder()),
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
                            conversion(typed, '°C').toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              conversion(typed, '°C').toString() != 'error'
                                  ? '°C'
                                  : '',
                              style: TextStyle(fontSize: 30)),
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
                            conversion(typed, '℉').toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              conversion(typed, '°C').toString() != 'error'
                                  ? '℉'
                                  : '',
                              style: TextStyle(fontSize: 30)),
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
                          conversion(typed, 'K').toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                            conversion(typed, '°C').toString() != 'error'
                                ? 'K'
                                : '',
                            style: TextStyle(fontSize: 30)),
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

class Square extends StatefulWidget {
  const Square({super.key});

  @override
  State<Square> createState() => _SquareState();
}

class _SquareState extends State<Square> {
  final List<String> items = ['cm²', 'd²', 'm²'];
  String? selected = 'cm²';
  double typed = 0;
  bool error = false;

  double conversion(double value, String target) {
    if (selected == target) {
      return value;
    }

    if (selected == 'cm²') {
      if (target == 'd²') {
        value *= 0.01;
      } else {
        value *= 0.0001;
      }
    } else if (selected == 'd²') {
      if (target == 'cm²') {
        value *= 100;
      } else {
        value *= 0.01;
      }
    } else {
      if (target == 'cm²') {
        value *= 10000;
      } else {
        value *= 100;
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
          'Temperature',
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
                          // FilteringTextInputFormatter(RegExp(r'^-?\d+(\.\d+)?'),
                          //     allow: true),
                        ],
                        onChanged: (value) => {
                          setState(() {
                            if (value == '' || value == '-') {
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
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    )),
                DropdownMenu(
                  width: 100,
                  initialSelection: 'cm²',
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
                            conversion(typed, 'cm²').toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('cm²', style: TextStyle(fontSize: 30)),
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
                            conversion(typed, 'd²').toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('d²', style: TextStyle(fontSize: 30)),
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
                          conversion(typed, 'm²').toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('m²', style: TextStyle(fontSize: 30)),
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
