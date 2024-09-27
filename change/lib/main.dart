import 'package:flutter/material.dart';
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
        // '/length': (context) => Length(),
        // '/exchange': (context) => Exchange(),
        // '/temp': (context) => Temperature(),
        // '/square': (context) => Square(),
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
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                    icon: const FaIcon(
                      FontAwesomeIcons.weightScale,
                      color: const Color.fromARGB(255, 131, 59, 255),
                    ),
                    onPressed: () => {Navigator.pushNamed(context, '/weight')},
                    label: Text('Weight')),
              ),
              Expanded(
                child: ElevatedButton.icon(
                    icon: const FaIcon(
                      FontAwesomeIcons.ruler,
                      color: const Color.fromARGB(255, 131, 59, 255),
                    ),
                    onPressed: () => {Navigator.pushNamed(context, '/length')},
                    label: Text('Length')),
              ),
              Expanded(
                child: ElevatedButton.icon(
                    icon: const FaIcon(
                      FontAwesomeIcons.euroSign,
                      color: const Color.fromARGB(255, 131, 59, 255),
                    ),
                    onPressed: () =>
                        {Navigator.pushNamed(context, '/exchange')},
                    label: Text('Exchange')),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const FaIcon(
                    FontAwesomeIcons.temperatureThreeQuarters,
                    color: const Color.fromARGB(255, 131, 59, 255),
                  ),
                  onPressed: () => {Navigator.pushNamed(context, '/temp')},
                  label: Text('Temperature'),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                    icon: const FaIcon(
                      FontAwesomeIcons.cube,
                      color: const Color.fromARGB(255, 131, 59, 255),
                      size: 40,
                      
                    ),
                    onPressed: () => {Navigator.pushNamed(context, '/square')},
                    label: Text('Square'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 100)),
                    ),
                    ),
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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
