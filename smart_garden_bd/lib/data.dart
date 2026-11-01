import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kGreen = Color(0xFF16833B);
const kDark = Color(0xFF075B2B);
const kBg = Color(0xFFF5F8F4);
const kText = Color(0xFF17231A);
const kText2 = Color(0xFF7B847D);
const kWarn = Color(0xFFF4A340);
const kError = Color(0xFFE05252);
const kOk = Color(0xFF2EAD65);

class Zone {
  final int id;
  String plant;
  double moisture;
  int threshold;
  int duration;
  bool enabled;
  IconData icon;
  Color color;
  Zone(this.id, this.plant, this.moisture, this.threshold, this.icon, this.color,
      {this.duration = 5, this.enabled = true});

  String get status =>
      moisture < threshold ? 'Dry' : (moisture > 75 ? 'Wet' : 'Normal');
  Color get statusColor =>
      status == 'Dry' ? kWarn : (status == 'Wet' ? Colors.blue : kOk);
}

class AppState extends ChangeNotifier {
  // DEMO DATA ONLY - replaced by Firebase data in a later phase.
  final bool isDemo = true;
  final bool deviceOnline = true;
  bool automatic = true;
  final zones = <Zone>[
    Zone(1, 'Tomato', 36, 40, Icons.local_florist, Colors.red),
    Zone(2, 'Chili', 62, 45, Icons.whatshot, Colors.deepOrange),
    Zone(3, 'Herbs', 28, 35, Icons.eco, Colors.green),
    Zone(4, 'Flowers', 55, 50, Icons.filter_vintage, Colors.pink),
  ];
  bool onboardingSeen = false;
  SharedPreferences? _p;

  Future<void> load() async {
    try {
      final p = _p = await SharedPreferences.getInstance();
      onboardingSeen = p.getBool('seen') ?? false;
      automatic = p.getBool('auto') ?? true;
      for (final z in zones) {
        z.plant = p.getString('z${z.id}_plant') ?? z.plant;
        z.threshold = p.getInt('z${z.id}_thr') ?? z.threshold;
        z.duration = p.getInt('z${z.id}_dur') ?? z.duration;
        z.enabled = p.getBool('z${z.id}_en') ?? z.enabled;
      }
    } catch (_) {}
  }

  void _save() {
    final p = _p;
    if (p == null) return;
    p.setBool('seen', onboardingSeen);
    p.setBool('auto', automatic);
    for (final z in zones) {
      p.setString('z${z.id}_plant', z.plant);
      p.setInt('z${z.id}_thr', z.threshold);
      p.setInt('z${z.id}_dur', z.duration);
      p.setBool('z${z.id}_en', z.enabled);
    }
  }

  void update() {
    _save();
    notifyListeners();
  }

  void setAutomatic(bool v) {
    automatic = v;
    update();
  }

  void markOnboardingSeen() {
    onboardingSeen = true;
    update();
  }
}

final appState = AppState();

const demoHistory = [
  ['Zone 1 - Tomato', 'Watered for 5 minutes', '08:14 AM', 'Automatic', 'Today'],
  ['Zone 3 - Herbs', 'Watered for 4 minutes', '07:20 AM', 'Automatic', 'Today'],
  ['Zone 4 - Flowers', 'Watered for 5 minutes', '06:05 AM', 'Manual', 'Today'],
  ['Zone 2 - Chili', 'Watered for 5 minutes', '08:11 AM', 'Automatic', 'Yesterday'],
];

const demoAlerts = [
  ['Watering Completed', 'Zone 1 watered for 5 minutes.', '08:14 AM', true],
  ['Soil is Dry', 'Zone 3 moisture is 28%.', '07:10 AM', true],
  ['Device Online', 'My Garden is connected.', '06:55 AM', false],
];
