import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

void main() => runApp(const WalkApp());

class WalkApp extends StatefulWidget {
  const WalkApp({super.key});
  @override
  State<WalkApp> createState() => _WalkAppState();
}

class _WalkAppState extends State<WalkApp> {
  String steps = "0";

  @override
  void initState() {
    super.initState();
    Pedometer.stepCountStream.listen((StepCount event) {
      setState(() => steps = event.steps.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            steps,
            style: const TextStyle(color: Colors.white, fontSize: 40),
          ),
        ),
      ),
    );
  }
}
