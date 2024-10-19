import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Description extends StatelessWidget {
  const Description({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, Map>;
    Map info = args['list']!;
    
    return Scaffold(
        appBar: AppBar(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Text(
                      info['list']['name'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
                Row(
                  children: [info['list']['image'] != null ? Image.network(supabase.storage.from('images').getPublicUrl(info['list']['image']).publicUrl): SizedBox()],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Flexible(child: Text(info['date']))],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20,bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(child: Text(info['list']['description']))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text('#${info['list']['tag']}',style: TextStyle(fontWeight: FontWeight.bold),)],
                )
              ],
            ),
          ),
        ));
  }
}
