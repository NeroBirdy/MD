import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Weight extends StatefulWidget {
  const Weight({super.key});

  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  final List<String> items = ['g', 'kg', 'c', 'f'];
  String? selected = 'g';
  double typed = 0;

  double conversion(double value, String target) {
    if (selected == target) {
      return value;
    }
    // 1 f - 453.592
    //
    //

    if (selected == 'g') {
      if (target == 'kg') {
        value /= 1000;
      } else if (target == 'f') {
        value /= 493.592;
      } else {
        value /= 100000;
      }
    } else if (selected == 'kg') {
      if (target == 'g') {
        value *= 1000;
      } else if (target == 'f') {
        value *= 0.453592;
      } else {
        value /= 100;
      }
    } else if (selected == 'f') {
      value *= 453.592;
      if (target == 'kg') {
        value /= 1000;
      } else if (target == 'c'){
        value /= 100000;
      }
    } else {
      if (target == 'g') {
        value /= 100000;
      } else if (target == 'f') {
        value *= 0.00453592;
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
        title: const Text(
          'Weight',
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
                            const InputDecoration(border: OutlineInputBorder()),
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
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: Card(
                  color: const Color.fromARGB(255, 180, 180, 180),
                  child: SizedBox(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            conversion(typed, 'g').toString(),
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(' g', style: TextStyle(fontSize: 30)),
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
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            conversion(typed, 'kg').toString(),
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                        const Padding(
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
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          conversion(typed, 'c').toString(),
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('c', style: TextStyle(fontSize: 30)),
                      )
                    ],
                  ),
                )),
            Card(
                color: const Color.fromARGB(255, 180, 180, 180),
                child: SizedBox(
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          conversion(typed, 'f').toString(),
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('f', style: TextStyle(fontSize: 30)),
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
