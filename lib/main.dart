import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.activityRecognition.request();
  runApp(const WalkApp());
}

class WalkApp extends StatefulWidget {
  const WalkApp({Key? key}) : super(key: key);

  @override
  _WalkAppState createState() => _WalkAppState();
}

class _WalkAppState extends State<WalkApp> {
  int _steps = 0;

  @override
  void initState() {
    super.initState();
    initStepCounter();
  }

  void initStepCounter() {
    Pedometer.stepCountStream.listen((event) {
      setState(() => _steps = event.steps);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("WalkApp - Adım Sayar")),
        body: Center(
          child: Text(
            "Atılan Adım: $_steps",
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
