import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Converter', style: TextStyle(color: Colors.white)),
            backgroundColor: const Color.fromARGB(255, 161, 154, 154),
            automaticallyImplyLeading: false),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: SizedBox(
                    height: 100,
                    width: 350,
                    child: ElevatedButton.icon(
                        icon: const FaIcon(
                          FontAwesomeIcons.weightScale,
                          color: Color.fromARGB(255, 131, 59, 255),
                          size: 40,
                        ),
                        onPressed: () =>
                            {Navigator.pushNamed(context, '/weight')},
                        label: const Text('Weight'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 192, 183, 183),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: SizedBox(
                  height: 100,
                  width: 350,
                  child: ElevatedButton.icon(
                      icon: const FaIcon(
                        FontAwesomeIcons.ruler,
                        color: Color.fromARGB(255, 131, 59, 255),
                        size: 40,
                      ),
                      onPressed: () =>
                          {Navigator.pushNamed(context, '/length')},
                      label: const Text('Length'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 192, 183, 183),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: SizedBox(
                  height: 100,
                  width: 350,
                  child: ElevatedButton.icon(
                      icon: const FaIcon(
                        FontAwesomeIcons.euroSign,
                        color: Color.fromARGB(255, 131, 59, 255),
                        size: 40,
                      ),
                      onPressed: () =>
                          {Navigator.pushNamed(context, '/exchange')},
                      label: const Text('Exchange'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 192, 183, 183),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: SizedBox(
                  height: 100,
                  width: 350,
                  child: ElevatedButton.icon(
                      icon: const FaIcon(
                        FontAwesomeIcons.temperatureThreeQuarters,
                        color: Color.fromARGB(255, 131, 59, 255),
                        size: 40,
                      ),
                      onPressed: () => {Navigator.pushNamed(context, '/temp')},
                      label: const Text('Temperature'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 192, 183, 183),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: SizedBox(
                  height: 100,
                  width: 350,
                  child: ElevatedButton.icon(
                    icon: const FaIcon(
                      FontAwesomeIcons.cube,
                      color: Color.fromARGB(255, 131, 59, 255),
                      size: 40,
                    ),
                    onPressed: () => {Navigator.pushNamed(context, '/square')},
                    label: const Text('Square'),
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
