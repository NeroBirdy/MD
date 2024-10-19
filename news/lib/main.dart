import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lqptdmcnveiphokgxwfm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxxcHRkbWNudmVpcGhva2d4d2ZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjkyMjcxMzAsImV4cCI6MjA0NDgwMzEzMH0.GJ5IDbQYl57-af_1Vlf5fOw2qPezR54q4GvGEKFpGug',
  );

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
  List news = [];
  List<String> dates = [];
  List<String> tags = [];
  List filtered = [];
  List filteredTags = [];
  List filteredDate = [];

  void fetchData() async {
    final response = await supabase.from('news').select();
    setState(() {
      news = response;
      Set<String> uniqueDates = {};
      Set<String> uniqueTags = {};
      for (int i = 0; i < news.length; i++) {
        uniqueDates.add(getDate(i));
        uniqueTags.add(news[i]['tag']);
      }
      dates = uniqueDates.toList();
      tags = uniqueTags.toList();

      getFiltered();
    });
  }

  void getFiltered() {
    filtered = [];
    if (filteredDate.length != 0 && filteredTags.length != 0) {
      for (int i = 0; i < news.length; i++) {
        if (filteredDate.contains(dates[i]) &&
            filteredTags.contains(news[i]['tag'])) {
          filtered.add({'list': news[i], 'date': dates[i]});
        }
      }
    } else if (filteredDate.length != 0) {
      for (int i = 0; i < news.length; i++) {
        if (filteredDate.contains(dates[i])) {
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

  String getDate(int index) {
    String temp;
    List date;
    RegExp regex = RegExp(r'\d{4}-\d{2}-\d{2}');
    var match = regex.firstMatch(news[index]['created_at'].toString());
    temp = match!.group(0) ?? '';
    date = temp.split('-');
    return '${date[2]}.${date[1]}.${date[0]}';
  }

  Widget getPopUpMenu(List<String> arr, List changed) {
    return PopupMenuButton(
      child: IconButton(
          onPressed: null,
          icon: Icon(
              changed == filteredDate ? Icons.edit_calendar : Icons.tag_sharp)),
      itemBuilder: (context) {
        return arr.map((String temp) {
          return PopupMenuItem(
            child: StatefulBuilder(
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
            ),
          );
        }).toList();
      },
    );
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('News'),
            Row(
              children: [
                getPopUpMenu(dates, filteredDate),
                SizedBox(
                  width: 20,
                ),
                getPopUpMenu(tags, filteredTags)
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            textAlign: TextAlign.center,
                            filtered[index]['list']['name'],
                            style: TextStyle(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(filtered[index]['date']),
                              Text('#${filtered[index]['list']['tag']}')
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
