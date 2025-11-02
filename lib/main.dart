import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

void main() {
  runApp(const WalkApp());
}

class WalkApp extends StatefulWidget {
  const WalkApp({Key? key}) : super(key: key);

  @override
  State<WalkApp> createState() => _WalkAppState();
}

class _WalkAppState extends State<WalkApp> {
  Stream<StepCount>? stepStream;
  int steps = 0;

  @override
  void initState() {
    super.initState();
    stepStream = Pedometer.stepCountStream;
    stepStream!.listen(onStep).onError((e) {
      print("Hata: $e");
    });
  }

  void onStep(StepCount event) {
    setState(() {
      steps = event.steps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("WalkApp - Adım Sayar")),
        body: Center(
          child: Text(
            "$steps Adım",
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
