import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news/pages/description.dart';
import 'package:news/data/db.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lqptdmcnveiphokgxwfm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxxcHRkbWNudmVpcGhva2d4d2ZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjkyMjcxMzAsImV4cCI6MjA0NDgwMzEzMH0.GJ5IDbQYl57-af_1Vlf5fOw2qPezR54q4GvGEKFpGug',
  );

  await Hive.initFlutter();
  await Hive.openBox('mybox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bad News',
      home: News(),
      routes: {
        '/home': (context) => News(),
        '/description': (context) => Description()
      },
    );
  }
}

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final supabase = Supabase.instance.client;
  Storage db = Storage();
  String? imagePath;
  List temp = [];
  List news = [];
  List<String> dates = [];
  List<String> datesForFilteredDate = [];
  List<String> tags = [];
  List filtered = [];
  List filteredTags = [];
  List filteredDate = [];
  bool reversed = false;

  void fetchData() async {
    try {
      final response = await supabase.from('news').select();

      setState(() {
        temp = response;
        if (!check(temp, db.news)) {
          db.news = temp;
          db.update();
        }
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      news = db.news;
      List tmp = news.where((item) => item['news_of_the_day']).toList();
      if (tmp.length != 0) {
        checkFile(tmp[0]['image']);
      }
      sortNews();
      Set<String> uniqueDates = {};
      Set<String> uniqueTags = {};

      for (int i = 0; i < news.length; i++) {
        dates.add(getDate(i, true));
        uniqueDates.add(getDate(i, false));
        uniqueTags.add(news[i]['tag']);
      }
      datesForFilteredDate = uniqueDates.toList();
      tags = uniqueTags.toList();

      getFiltered();
    });
  }

  bool checkDate(String str) {
    DateTime today = DateTime.now();
    DateTime tmp = DateTime.parse(str);
    if (tmp.year == today.year &&
        tmp.month == today.month &&
        tmp.day == today.day) {
      return true;
    }
    return false;
  }

  void sortNews() {
    news.sort((a, b) {
      bool newsOfTheDayA = a['news_of_the_day'];
      bool newsOfTheDayB = b['news_of_the_day'];

      DateTime dateA = DateTime.parse(a['created_at']);
      DateTime dateB = DateTime.parse(b['created_at']);
      DateTime today = DateTime.now();

      bool isTodayA = dateA.year == today.year &&
          dateA.month == today.month &&
          dateA.day == today.day;
      bool isTodayB = dateB.year == today.year &&
          dateB.month == today.month &&
          dateB.day == today.day;

      if (newsOfTheDayA && !newsOfTheDayB && isTodayA) {
        return -1;
      } else if (!newsOfTheDayA && newsOfTheDayB && isTodayB) {
        return 1;
      }

      if (isTodayA && !isTodayB) {
        return -1;
      } else if (!isTodayA && isTodayB) {
        return 1;
      } else if (isTodayA & isTodayB) {
        return dateB.compareTo(dateA);
      } else {
        return dateA.compareTo(dateB);
      }
    });
  }

  void sortFiltered(bool reversed) {
    Map? tmp;
    if (checkNewsOfTheDay(filtered[0]['list'])) {
      tmp = filtered[0];
      filtered.removeAt(0);
    }
    filtered = filtered.reversed.toList();
    if (tmp != null) {
      filtered.insert(0, tmp);
    }
  }

  bool check(List list1, List list2) {
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i]['id'] != list2[i]['id'] ||
          list1[i]['name'] != list2[i]['name'] ||
          list1[i]['tag'] != list2[i]['tag'] ||
          list1[i]['description'] != list2[i]['description'] ||
          list1[i]['image'] != list2[i]['image'] ||
          list1[i]['created_at'] != list2[i]['created_at'] ||
          list1[i]['news_of_the_day'] != list2[i]['news_of_the_day']) {
        return false;
      }
    }
    return true;
  }

  void getFiltered() {
    filtered = [];
    if (filteredDate.length != 0 && filteredTags.length != 0) {
      for (int i = 0; i < news.length; i++) {
        if (filteredDate.contains(dates[i].substring(0, 10)) &&
            filteredTags.contains(news[i]['tag'])) {
          filtered.add({'list': news[i], 'date': dates[i]});
        }
      }
    } else if (filteredDate.length != 0) {
      for (int i = 0; i < news.length; i++) {
        if (filteredDate.contains(dates[i].substring(0, 10))) {
          filtered.add({'list': news[i], 'date': dates[i]});
        }
      }
    } else if (filteredTags.length != 0) {
      for (int i = 0; i < news.length; i++) {
        if (filteredTags.contains(news[i]['tag'])) {
          filtered.add({'list': news[i], 'date': dates[i]});
        }
      }
    } else {
      for (int i = 0; i < news.length; i++) {
        filtered.add({'list': news[i], 'date': dates[i]});
      }
    }
  }

  String getDate(int index, bool full) {
    String temp;
    List date;
    RegExp regex = RegExp(r'\d{4}-\d{2}-\d{2}');
    var match = regex.firstMatch(news[index]['created_at'].toString());
    temp = match!.group(0) ?? '';
    date = temp.split('-');
    regex = RegExp(r'\d{2}:\d{2}');
    match = regex.firstMatch(news[index]['created_at'].toString());
    temp = match!.group(0) ?? '';
    if (full) {
      return '${date[2]}.${date[1]}.${date[0]}, $temp';
    }
    return '${date[2]}.${date[1]}.${date[0]}';
  }

  Widget getPopUpMenu(List<String> arr, List changed) {
    return PopupMenuButton(
      child: IconButton(
          onPressed: null,
          icon: Icon(
            changed == filteredDate ? Icons.edit_calendar : Icons.tag_sharp,
            color: const Color.fromARGB(255, 61, 61, 61),
          )),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
              child: Container(
            width: 150,
            height: arr.length > 5 ? 270 : null,
            child: SingleChildScrollView(
              child: Column(
                children: arr.map((temp) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return CheckboxListTile(
                        title: Text(temp),
                        value: changed.contains(temp),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (value) {
                          setState(() {
                            value! ? changed.add(temp) : changed.remove(temp);
                          });
                          this.setState(() {
                            getFiltered();
                          });
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ))
        ];
      },
    );
  }

  @override
  void initState() {
    fetchData();
    db.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('News'),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        reversed = !reversed;
                        sortFiltered(reversed);
                      });
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.filter,
                      color: reversed
                          ? const Color.fromARGB(255, 190, 117, 111)
                          : const Color.fromARGB(255, 98, 172, 100),
                    )),
                getPopUpMenu(datesForFilteredDate, filteredDate),
                SizedBox(
                  width: 20,
                ),
                getPopUpMenu(tags, filteredTags)
              ],
            )
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: news.length != 0
                  ? ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/description',
                                  arguments: <String, Map>{
                                    'list': filtered[index]
                                  });
                            },
                            child: buildChild(
                                checkNewsOfTheDay(filtered[index]['list']),
                                index));
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ))
        ],
      ),
    );
  }

  bool checkNewsOfTheDay(Map news) {
    if (news['news_of_the_day'] && (checkDate(news['created_at']))) {
      return true;
    }
    return false;
  }

  Widget buildChild(bool newsOfTheDay, int index) {
    if (!newsOfTheDay) {
      return Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Card(
                    color: const Color.fromARGB(121, 211, 210, 210),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    textAlign: TextAlign.left,
                                    filtered[index]['list']['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.5),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(
                                  filtered[index]['list']['description'],
                                  style: TextStyle(fontSize: 15.5),
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ))
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 20,
            child: Text(
              filtered[index]['date'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 12,
            child: Text(
              '#${filtered[index]['list']['tag']}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          )
        ],
      );
    } else {
      return FutureBuilder(
        future: checkFile(filtered[index]['list']['image']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Ошибка загрузки изображения');
          } else if (snapshot.hasData) {
            String imagePath = snapshot.data ?? '';

            return Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Card(
                            color: const Color.fromARGB(169, 245, 244, 244),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Image.file(File(imagePath))),
                              ),
                            ),
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      textAlign: TextAlign.left,
                                      filtered[index]['list']['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.5),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(),
                                )
                              ],
                            ),
                            Positioned(
                                top: 1,
                                right: 2,
                                child: Text(
                                  filtered[index]['date'].substring(0, 10),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ))
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Text(
                            filtered[index]['list']['description'],
                            style: TextStyle(fontSize: 15.5),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                )
              ],
            );
          } else {
            return Text('Изображеие не найдено');
          }
        },
      );
    }
  }

  Future getImage(String url) async {
    try {
      String publicUrl = supabase.storage.from('images').getPublicUrl(url);
      final response = await http.get(Uri.parse(publicUrl));

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$url';
        File image = File(filePath);
        await image.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> checkFile(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$url';
    File image = File(filePath);
    if (await image.exists()) {
      return filePath;
    } else {
      return await getImage(url);
    }
  }
}
