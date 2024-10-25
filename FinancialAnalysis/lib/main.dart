import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Анализ финансов',
      home: Financial(),
    );
  }
}

class Financial extends StatefulWidget {
  const Financial({super.key});

  @override
  State<Financial> createState() => _FinancialState();
}

class _FinancialState extends State<Financial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Анализ финансов'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                TextButton(onPressed: () {}, child: Text('Расходы')),
                TextButton(onPressed: () {}, child: Text('Зачисления')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('0')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: AspectRatio(
                  aspectRatio: 1.26,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: PieChart(PieChartData(sections: [
                      PieChartSectionData(value: 10,title: ''),
                      PieChartSectionData(value: 20,title: '')
                    ])),
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
