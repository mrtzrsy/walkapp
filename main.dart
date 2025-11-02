import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WalkApp());
}

class WalkApp extends StatelessWidget {
  const WalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'walkapp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const StepHomePage(),
    );
  }
}

class StepHomePage extends StatefulWidget {
  const StepHomePage({super.key});

  @override
  State<StepHomePage> createState() => _StepHomePageState();
}

class _StepHomePageState extends State<StepHomePage> {
  Stream<StepCount>? _stepCountStream;
  int _stepsToday = 0;
  int _lastReading = 0;
  DateTime _lastDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _ensurePermissions();
    _bindStreams();
  }

  Future<void> _ensurePermissions() async {
    if (await Permission.activityRecognition.request().isDenied) {
      final result = await Permission.activityRecognition.request();
      if (!result.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Adım sayacı izni verilmedi. Ayarlardan izin verin.'),
            ),
          );
        }
      }
    }
  }

  void _bindStreams() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen(_onStepCount, onError: _onStepCountError);
  }

  void _onStepCount(StepCount event) {
    final now = DateTime.now();
    if (!isSameDay(_lastDate, now)) {
      _stepsToday = 0;
      _lastReading = 0;
      _lastDate = now;
    }
    if (_lastReading == 0) {
      _lastReading = event.steps;
      _lastDate = now;
    } else {
      final delta = event.steps - _lastReading;
      if (delta > 0) {
        _stepsToday += delta;
        _lastReading = event.steps;
      }
    }
    if (mounted) setState(() {});
  }

  void _onStepCountError(error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adım sayacı hatası: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMMM yyyy, EEEE', 'tr_TR').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: const Text('walkapp'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(dateStr, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 6),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.directions_walk, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      '$_stepsToday',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('GÜNLÜK ADIM'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () async {
                  await _ensurePermissions();
                  setState(() {});
                },
                child: const Text('İzinleri Kontrol Et'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Not: Gerçek adım verisi yalnızca sensör bulunan cihazlarda görünür. '
                'Emülatörde çalışmayabilir.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
