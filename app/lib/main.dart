import 'package:flutter/material.dart';
import 'examples/row_column_example.dart'; // Import the lesson

void main() {
  runApp(
    MaterialApp(
      // home: Scaffold(body: Center(child: MyCounter())), // Old home
      home: const RowColumnLesson(), // Calling the new interactive lesson!
    ),
  );
}

class MyStatic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Heloo");
  }
}

class MyCounter extends StatefulWidget {
  @override
  State<MyCounter> createState() {
    return _Button();
  }
}

class _Button extends State<MyCounter> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: Text("Increase"),
        ),
        Text("Count $count"),
      ],
    );
  }
}
