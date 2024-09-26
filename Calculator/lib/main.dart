import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  void equal() {
    String tmp = exp;
    if (symbols.contains(tmp[tmp.length - 1])) {
      tmp = tmp.substring(0, tmp.length - 1);
    }
    Parser p = Parser();
    Expression expression = p.parse(tmp);
    ContextModel cm = ContextModel();
    double eval = expression.evaluate(EvaluationType.REAL, cm);
    String temp = eval.toString();
    tmp = temp;
    if (temp[temp.length - 1] == '0' && temp[temp.length - 2] == '.') {
      temp = temp.substring(0, temp.length - 2);
    }

    if (answer == temp) {
      exp = answer;
    } else {
      answer = temp;
      }
    
  }

  void changes(String text) {
    setState(() {
      if (text == '=') {
        equal();
      } else if (text == 'C') {
        exp = '0';
        answer = '0';
      } else if (text == 'del') {
        if (exp.length > 1) {
          exp = exp.substring(0, exp.length - 1);
        } else if (exp.length == 1) {
          exp = '0';
        }
      } else if (exp == '0') {
        if (numbers.contains(text)) {
          exp = text;
        } else {
          exp += text;
        }
      } else {
        String last = exp[exp.length - 1];
        String last2 = exp.length > 2 ? exp[exp.length - 2] : 'null';
        if (text == '.') {
          //Точка
          if (numbers.contains(last)) {
            for (int i = exp.length - 1; i >= 0; i--) {
              if (symbols.contains(exp[i]) || i == 0) {
                exp += text;
                break;
              } else if (exp[i] == '.') {
                break;
              }
            }
          } else if (symbols.contains(last)) {
            for (int i = exp.length - 2; i >= 0; i--) {
              if (symbols.contains(exp[i]) || i == 0) {
                exp = exp.substring(0, exp.length - 1) + text;
                break;
              } else if (exp[i] == '.') {
                break;
              }
            }
          }
        } else if (numbers.contains(text)) {
          //Число
          if (symbols.contains(last)) {
            exp += text;
          } else if (last == '0' && symbols.contains(last2)) {
            exp = exp.substring(0, exp.length - 1) + text;
          } else if (numbers.contains(last) || last == '.') {
            exp += text;
          }
        } else {
          //Символ
          if (symbols.contains(last) || last == '.') {
            exp = exp.substring(0, exp.length - 1) + text;
          } else {
            exp += text;
          }
        }
      }
    });
  }

  String exp = '0';
  String answer = '0';
  List numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  List symbols = ['+', '-', '*', '/', '^'];
  List<String> lastOperation = [];

  Widget getButton(String text, Color color) {
    bool t;
    if (text == '0') {
      t = true;
    } else {
      t = false;
    }

    return Expanded(
        flex: t == true ? 2 : 1,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.all(20)),
              onPressed: () {
                changes(text);
              },
              child: Text(text, style: TextStyle(fontSize: 20)),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text('Calculator', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //Display
            Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    exp,
                    style: const TextStyle(color: Colors.white, fontSize: 35),
                    textAlign: TextAlign.right,
                  ),
                )),
            SizedBox(height: 30 ,),
            Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    '=' + answer,
                    style: const TextStyle(color: Colors.white, fontSize: 45),
                    textAlign: TextAlign.right,
                  ),
                )),

            //Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                getButton('C', Colors.orange),
                getButton('del', Colors.orange),
                getButton('^', Colors.orange),
                getButton('/', Colors.orange),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                getButton('7', Colors.grey),
                getButton('8', Colors.grey),
                getButton('9', Colors.grey),
                getButton('*', Colors.orange),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                getButton('4', Colors.grey),
                getButton('5', Colors.grey),
                getButton('6', Colors.grey),
                getButton('-', Colors.orange),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                getButton('1', Colors.grey),
                getButton('2', Colors.grey),
                getButton('3', Colors.grey),
                getButton('+', Colors.orange),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                getButton('0', Colors.grey),
                getButton('.', Colors.grey),
                getButton('=', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
