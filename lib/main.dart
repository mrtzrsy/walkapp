import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.activityRecognition.request();
  runApp(const WalkApp());
}

class WalkApp extends StatelessWidget {
  const WalkApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StepScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StepScreen extends StatefulWidget {
  const StepScreen({super.key});

  @override
  State<StepScreen> createState() => _StepScreenState();
}

class _StepScreenState extends State<StepScreen> {
  StreamSubscription<StepCount>? _subscription;
  int totalSteps = 0;

  @override
  void initState() {
    super.initState();
    _subscription = Pedometer.stepCountStream.listen((event) {
      setState(() => totalSteps = event.steps);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WalkApp - Adım Sayar")),
      body: Center(
        child: Text(
          "$totalSteps Adım",
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
