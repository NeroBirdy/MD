import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Description extends StatefulWidget {
  const Description({super.key});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  final supabase = Supabase.instance.client;
  String? imagePath;

  Future getImage(String url) async {
    try {
      String publicUrl = supabase.storage.from('images').getPublicUrl(url);
      final response = await http.get(Uri.parse(publicUrl));

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$url';
        File image = File(filePath);
        await image.writeAsBytes(response.bodyBytes);

        setState(() {
          imagePath = filePath;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void checkFile(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$url';
    File image = File(filePath);
    if (await image.exists()) {
      setState(() {
        imagePath = filePath;
      });
    } else {
      await getImage(url);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, Map>;
      Map info = args['list']!;
      if (info['list']['image'] != null) {
        checkFile(info['list']['image']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, Map>;
    Map info = args['list']!;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imagePath != null
                        ? Expanded(
                            child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.file(
                              File(imagePath!),
                            ),
                          ))
                        : SizedBox()
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Text(
                      info['list']['name'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                        info['list']['description'],
                        style: TextStyle(fontSize: 17),
                      ))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${info['list']['tag']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      info['date'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
