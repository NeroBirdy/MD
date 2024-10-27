import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather Forecast',
        home: Weather());
  }
}

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String city = 'Khanty-Mansiysk';
  var key = 'cd02fbd755664b35b3e133313241610';
  late Future<Map<String, dynamic>> response;
  final ScrollController sc = ScrollController();

  Map<String, HugeIcon> directionIcons = {
    'N': const HugeIcon(
        icon: HugeIcons.strokeRoundedArrowUp04, color: Colors.black),
    'NE': const HugeIcon(
        icon: HugeIcons.strokeRoundedArrowUpRight02, color: Colors.black),
    'E': const HugeIcon(
        icon: HugeIcons.strokeRoundedArrowRight04, color: Colors.black),
    'SE': const HugeIcon(
        icon: HugeIcons.strokeRoundedArrowDownRight02, color: Colors.black),
    'S': const HugeIcon(
        icon: HugeIcons.strokeRoundedArrowDown04, color: Colors.black),
    'SW': const HugeIcon(
        icon: HugeIcons.strokeRoundedArrowDownLeft02, color: Colors.black),
    'W': const HugeIcon(
        icon: HugeIcons.strokeRoundedArrowLeft04, color: Colors.black),
    'NW': const HugeIcon(
        icon: HugeIcons.strokeRoundedArrowUpLeft02, color: Colors.black)
  };
  List<String> Days = [
    'Monday',
    'Tuesday',
    'Wendesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  List<String> cities = [
    'Khanty-Mansiysk',
    'Moscow',
    'Surgut',
    'Tyumen',
    'Perm'
  ];

  List<bool> full = List.generate(14, (index) {
    return [0, 1].contains(index) ? true : false;
  });

  @override
  void initState() {
    super.initState();
    response = getData();
  }

  Future<Map<String, dynamic>> getData() async {
    var url = Uri.parse(
        "http://api.weatherapi.com/v1/forecast.json?key=$key&q=$city&days=14");
    var res = await http.get(url);

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      return json;
    } else {
      throw Exception(res.statusCode);
    }
  }

  void jump(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sc.jumpTo(47.0 * index);
    });
  }

  HugeIcon getIcon(String windDir) {
    return directionIcons[windDir]!;
  }

  Widget getRow(String label, dynamic data, String windDirection) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Expanded(
          child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(label, style: const TextStyle(color: Colors.white)))),
      Expanded(
          child: Row(children: [
        Image.network('http:' + data['condition']['icon'], height: 40),
        Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
                '${(data['temp_c'].toString()[0] != '-' ? '+' : '') +
                    data['temp_c'].toStringAsFixed(0)}°',
                style: const TextStyle(color: Colors.white)))
      ])),
      Expanded(
          child: Text((data['wind_kph'] / 3.6).toStringAsFixed(1) +
              '  m/s, ' +
              (data['wind_dir'].toString().length == 3
                  ? data['wind_dir'].substring(1)
                  : data['wind_dir']) +
              ' ')),
      Padding(
          padding: const EdgeInsets.only(right: 10), child: getIcon(windDirection))
    ]);
  }

  Widget getCardChildren(Map data) {
    int index = data['index'];
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
              padding: const EdgeInsets.only(left: 20, top: 15, bottom: 10),
              child: Text(data['weekDay'] + ', ' + data['d'] + '.' + data['m'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: (!full[index]) ? 18 : 16))),
          if (!full[index]) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(
                  'http:' + data['day']['condition']['icon'],
                  height: 35,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20),
                    child: Text(
                      '${(data['day']['temp_c'].toString()[0] != '-' ? '+' : '') +
                          data['day']['temp_c'].toStringAsFixed(0) +
                          '°' +
                          '/' +
                          (data['night']['temp_c'].toString()[0] != '-'
                              ? '+'
                              : '') +
                          data['night']['temp_c'].toStringAsFixed(0)}°',
                      style: TextStyle(fontSize: (!full[index]) ? 18 : 16),
                    ))
              ],
            )
          ]
        ]),
        if (full[index]) ...[
          getRow('Morning', data['morning'], data['windDirections'][0]),
          getRow('Day', data['day'], data['windDirections'][1]),
          getRow('Evening', data['evening'], data['windDirections'][2]),
          getRow('Night', data['night'], data['windDirections'][3]),
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 84, 134, 221),
        body: FutureBuilder(
            future: response,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var current = snapshot.data!['current'];
                var forecast = snapshot.data!['forecast'];
                DateTime now = DateTime.now();
                int hour = now.hour;

                jump(hour);

                return SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Center(
                                      child: TextButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SizedBox(
                                                    height: 280,
                                                    child: ListView.builder(
                                                      itemCount: 5,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return ListTile(
                                                          title: Text(
                                                              cities[index],
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 24),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                          onTap: () {
                                                            setState(() {
                                                              city =
                                                                  cities[index];
                                                              response =
                                                                  getData();
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        );
                                                      },
                                                    ));
                                              },
                                            );
                                          },
                                          child: Text(city,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24),
                                              textAlign: TextAlign.center)))),
                              Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Card(
                                      color: const Color.fromARGB(
                                          186, 59, 92, 163),
                                      child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          current['temp_c']
                                                                  .toStringAsFixed(
                                                                      0) +
                                                              '°',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 60)),
                                                      Image.network(
                                                          'http:' +
                                                              current['condition']
                                                                  ['icon'],
                                                          height: 60)
                                                    ]),
                                                Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 10),
                                                    child: SizedBox(
                                                        height: 100,
                                                        child: ListView.builder(
                                                            controller: sc,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount: 24,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              var temp = forecast[
                                                                          'forecastday']
                                                                      [
                                                                      0]['hour']
                                                                  [
                                                                  index]['temp_c'];
                                                              var time = forecast[
                                                                          'forecastday']
                                                                      [
                                                                      0]['hour']
                                                                  [
                                                                  index]['time'];
                                                              return Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                                  child: Column(
                                                                      children: [
                                                                        Image.network(
                                                                            'http:' +
                                                                                forecast['forecastday'][0]['hour'][index]['condition']['icon'],
                                                                            height: 50),
                                                                        Text(
                                                                            temp.toStringAsFixed(0) +
                                                                                '°',
                                                                            style:
                                                                                const TextStyle(color: Colors.white)),
                                                                        Text(
                                                                            time.toString().substring(11,
                                                                                16),
                                                                            style:
                                                                                const TextStyle(color: Colors.white))
                                                                      ]));
                                                            })))
                                              ])))),
                              Padding(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: Column(children: [
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Weather forecast for 14 days',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ])),
                                    ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: 14,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var forecastday =
                                              forecast['forecastday'][index];
                                          var morning = forecastday['hour'][7];
                                          var day = forecastday['hour'][13];
                                          var evening = forecastday['hour'][19];
                                          var night = forecastday['hour'][23];

                                          List<String> windDirections = [
                                            morning['wind_dir'],
                                            day['wind_dir'],
                                            evening['wind_dir'],
                                            night['wind_dir']
                                          ];
                                          for (int i = 0; i < 4; i++) {
                                            windDirections[i] =
                                                windDirections[i].length == 3
                                                    ? windDirections[i]
                                                        .substring(1)
                                                    : windDirections[i];
                                          }

                                          List<String> date =
                                              forecastday['date'].split('-');
                                          String d = date[2];
                                          String m = date[1];
                                          int temp = DateTime.parse(
                                                  forecastday['date'])
                                              .weekday;
                                          String weekDay = Days[temp - 1];

                                          Map<String, dynamic> data = {
                                            'morning': morning,
                                            'day': day,
                                            'evening': evening,
                                            'night': night,
                                            'windDirections': windDirections,
                                            'weekDay': weekDay,
                                            'd': d,
                                            'm': m,
                                            'index': index
                                          };

                                          return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if ([0, 1].contains(index)) {
                                                    return;
                                                  }
                                                  for (int i = 0; i < 14; i++) {
                                                    if (![0,1,index].contains(i)) {
                                                      full[i] = false;
                                                    }
                                                  }
                                                  full[index] = !full[index];
                                                });
                                              },
                                              child: SizedBox(
                                                  child: Card(
                                                      color: const Color.fromARGB(
                                                          181, 93, 127, 199),
                                                      elevation: 0.6,
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            getCardChildren(
                                                                data)
                                                          ]))));
                                        })
                                  ]))
                            ])));
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
