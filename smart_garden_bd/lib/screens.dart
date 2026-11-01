import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'data.dart';

Widget demoBadge() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: kWarn.withOpacity(.2), borderRadius: BorderRadius.circular(20)),
      child: const Text('Demo Data',
          style: TextStyle(color: Color(0xFF9A5B00), fontWeight: FontWeight.w600, fontSize: 12)),
    );

Widget moistureBar(Zone z) => ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
          value: z.moisture / 100,
          minHeight: 7,
          backgroundColor: Colors.grey.shade200,
          color: z.statusColor),
    );

Widget plantIcon(Zone z, {double size = 44}) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: z.color.withOpacity(.12), borderRadius: BorderRadius.circular(12)),
      child: Icon(z.icon, color: z.color, size: size * .55),
    );

// ---------------- Splash / Login ----------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kGreen, kDark])),
          child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.water_drop, size: 90, color: Colors.white),
            SizedBox(height: 16),
            Text('Smart Garden BD',
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Smart Irrigation for Your Home Garden',
                style: TextStyle(color: Colors.white70)),
          ]),
        ),
      );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.all(24), children: [
            const SizedBox(height: 40),
            const Icon(Icons.water_drop, size: 56, color: kGreen),
            const Center(
                child: Text('Smart Garden BD',
                    style: TextStyle(color: kGreen, fontSize: 24, fontWeight: FontWeight.bold))),
            const SizedBox(height: 28),
            const Text('Welcome Back', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('Sign in to your account', style: TextStyle(color: kText2)),
            const SizedBox(height: 20),
            const TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline),
                    labelText: 'Email',
                    border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const TextField(
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    labelText: 'Password',
                    border: OutlineInputBorder())),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () {}, child: const Text('Forgot password?'))),
            FilledButton(
                onPressed: () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const MainShell())),
                child: const Text('Sign In (Demo)')),
            const SizedBox(height: 12),
            const Center(
                child: Text('Real login comes with Firebase in Phase 3.',
                    style: TextStyle(color: kText2, fontSize: 12))),
          ]),
        ),
      );
}

// ---------------- Shell ----------------
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    const pages = [HomeTab(), GardenTab(), WateringTab(), HistoryTab(), SettingsTab()];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        backgroundColor: Colors.white,
        indicatorColor: kGreen.withOpacity(.15),
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: kGreen), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.local_florist_outlined), selectedIcon: Icon(Icons.local_florist, color: kGreen), label: 'Garden'),
          NavigationDestination(icon: Icon(Icons.water_drop_outlined), selectedIcon: Icon(Icons.water_drop, color: kGreen), label: 'Watering'),
          NavigationDestination(icon: Icon(Icons.history), selectedIcon: Icon(Icons.history, color: kGreen), label: 'History'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings, color: kGreen), label: 'Settings'),
        ],
      ),
    );
  }
}

// ---------------- Home ----------------
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: appState,
        builder: (context, _) => ListView(padding: EdgeInsets.zero, children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [kGreen, kDark], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Expanded(
                    child: Text('Good Morning,\nRahim',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
                IconButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                    icon: const Icon(Icons.notifications_none, color: Colors.white)),
              ]),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.memory, color: kGreen),
                  title: const Text('My Garden', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('ESP32 Controller'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: kOk.withOpacity(.15), borderRadius: BorderRadius.circular(20)),
                    child: Text(appState.deviceOnline ? 'Online' : 'Offline',
                        style: const TextStyle(color: kOk, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ]),
          ),
          if (appState.isDemo)
            Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0), child: Align(alignment: Alignment.centerLeft, child: demoBadge())),
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [for (final z in appState.zones) ZoneCard(z)],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: SwitchListTile(
                activeColor: kGreen,
                title: const Text('Automatic Watering', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(appState.automatic ? 'Active - ${appState.zones.where((z) => z.enabled).length} Zones' : 'Off'),
                value: appState.automatic,
                onChanged: appState.setAutomatic,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ]),
      );
}

class ZoneCard extends StatelessWidget {
  final Zone z;
  const ZoneCard(this.z, {super.key});
  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ZoneDetailsScreen(z))),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                plantIcon(z, size: 34),
                const SizedBox(width: 8),
                Expanded(child: Text('Zone ${z.id}\n${z.plant}', style: const TextStyle(fontSize: 12, color: kText2))),
              ]),
              const Spacer(),
              Text('${z.moisture.round()}%', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              moistureBar(z),
            ]),
          ),
        ),
      );
}

// ---------------- Garden ----------------
class GardenTab extends StatelessWidget {
  const GardenTab({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('My Garden'), centerTitle: true, backgroundColor: kBg),
        body: ListenableBuilder(
          listenable: appState,
          builder: (context, _) => ListView(padding: const EdgeInsets.all(16), children: [
            for (final z in appState.zones)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: plantIcon(z, size: 52),
                  title: Text('Zone ${z.id} - ${z.plant}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Moisture: ${z.moisture.round()}% (${z.status})'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ZoneDetailsScreen(z))),
                ),
              ),
          ]),
        ),
      );
}

// ---------------- Zone details ----------------
class ZoneDetailsScreen extends StatefulWidget {
  final Zone z;
  const ZoneDetailsScreen(this.z, {super.key});
  @override
  State<ZoneDetailsScreen> createState() => _ZoneDetailsScreenState();
}

class _ZoneDetailsScreenState extends State<ZoneDetailsScreen> {
  Zone get z => widget.z;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Zone ${z.id}'), centerTitle: true, backgroundColor: kBg),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Row(children: [
            plantIcon(z, size: 56),
            const SizedBox(width: 12),
            Expanded(child: Text(z.plant, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            IconButton(icon: const Icon(Icons.edit_outlined), onPressed: _rename),
          ]),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Text('Soil Moisture', style: TextStyle(color: kText2)),
                  const Spacer(),
                  Chip(label: Text(z.status), backgroundColor: z.statusColor.withOpacity(.2), side: BorderSide.none),
                ]),
                Text('${z.moisture.round()}%', style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold)),
                moistureBar(z),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: kGreen,
                  title: const Text('Zone enabled'),
                  value: z.enabled,
                  onChanged: (v) => setState(() { z.enabled = v; appState.update(); }),
                ),
                Row(children: [
                  const Text('Water when below'),
                  const Spacer(),
                  Text('${z.threshold}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
                Slider(
                  value: z.threshold.toDouble(), min: 10, max: 80, divisions: 70, activeColor: kGreen,
                  onChanged: (v) => setState(() { z.threshold = v.round(); appState.update(); }),
                ),
                Row(children: [
                  const Text('Watering duration'),
                  const Spacer(),
                  Text('${z.duration} min', style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
                Slider(
                  value: z.duration.toDouble(), min: 1, max: 15, divisions: 14, activeColor: kGreen,
                  onChanged: (v) => setState(() { z.duration = v.round(); appState.update(); }),
                ),
                const Align(alignment: Alignment.centerLeft, child: Text('Maximum is 15 minutes for safety.', style: TextStyle(color: kText2, fontSize: 12))),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: z.enabled ? () => confirmWater(context, z) : null,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Water Now'),
          ),
        ]),
      );

  void _rename() async {
    final c = TextEditingController(text: z.plant);
    final name = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Plant name'),
        content: TextField(controller: c, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, c.text.trim()), child: const Text('Save')),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) setState(() { z.plant = name; appState.update(); });
  }
}

Future<void> confirmWater(BuildContext context, Zone z) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Water Zone ${z.id}?'),
      content: Text('Start watering ${z.plant} for ${z.duration} minutes?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Start')),
      ],
    ),
  );
  if (ok == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Demo mode: command not sent. With a real device, success is shown only after the ESP32 confirms.')));
  }
}

// ---------------- Watering ----------------
class WateringTab extends StatefulWidget {
  const WateringTab({super.key});
  @override
  State<WateringTab> createState() => _WateringTabState();
}

class _WateringTabState extends State<WateringTab> {
  bool manual = false;
  int selected = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Smart Watering'), centerTitle: true, backgroundColor: kBg),
        body: ListenableBuilder(
          listenable: appState,
          builder: (context, _) => ListView(padding: const EdgeInsets.all(16), children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Automatic')),
                ButtonSegment(value: true, label: Text('Manual')),
              ],
              selected: {manual},
              onSelectionChanged: (s) => setState(() => manual = s.first),
            ),
            const SizedBox(height: 16),
            if (!manual) ...[
              const Text('The controller waters automatically based on each zone\'s soil moisture, even without internet.', style: TextStyle(color: kText2)),
              const SizedBox(height: 12),
              for (final z in appState.zones)
                Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: SwitchListTile(
                    activeColor: kGreen,
                    secondary: plantIcon(z),
                    title: Text('Zone ${z.id} - ${z.plant}'),
                    subtitle: Text('Water when below ${z.threshold}%'),
                    value: z.enabled,
                    onChanged: (v) { z.enabled = v; appState.update(); },
                  ),
                ),
            ] else ...[
              const Text('Choose a zone', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, children: [
                for (var i = 0; i < 4; i++)
                  ChoiceChip(
                    label: Text('Zone ${i + 1} - ${appState.zones[i].plant}'),
                    selected: selected == i,
                    onSelected: (_) => setState(() => selected = i),
                  ),
              ]),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => confirmWater(context, appState.zones[selected]),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Watering'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo mode: nothing is running.'))),
                icon: const Icon(Icons.stop),
                label: const Text('Stop Watering'),
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50), foregroundColor: kError),
              ),
            ],
          ]),
        ),
      );
}

// ---------------- History + Analytics ----------------
class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});
  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('History'),
            centerTitle: true,
            backgroundColor: kBg,
            bottom: const TabBar(labelColor: kGreen, indicatorColor: kGreen, tabs: [Tab(text: 'Watering'), Tab(text: 'Analytics')]),
          ),
          body: const TabBarView(children: [_WateringList(), _Analytics()]),
        ),
      );
}

class _WateringList extends StatelessWidget {
  const _WateringList();
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
        demoRow(),
        for (final h in demoHistory)
          Card(
            margin: const EdgeInsets.only(top: 10),
            child: ListTile(
              leading: const Icon(Icons.water_drop, color: kGreen),
              title: Text(h[0], style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${h[1]} - ${h[3]} - ${h[4]}'),
              trailing: Text(h[2], style: const TextStyle(color: kText2, fontSize: 12)),
            ),
          ),
      ]);
}

Widget demoRow() => Align(alignment: Alignment.centerLeft, child: demoBadge());

class _Analytics extends StatelessWidget {
  const _Analytics();
  @override
  Widget build(BuildContext context) {
    final colors = [Colors.red, Colors.green, Colors.blue, Colors.purple];
    return ListView(padding: const EdgeInsets.all(16), children: [
      demoRow(),
      const SizedBox(height: 4),
      const Text('24-hour moisture (sample data)', style: TextStyle(color: kText2)),
      const SizedBox(height: 12),
      SizedBox(
        height: 240,
        child: LineChart(LineChartData(
          minY: 0, maxY: 100, minX: 0, maxX: 24,
          gridData: const FlGridData(drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            for (var i = 0; i < 4; i++)
              LineChartBarData(
                isCurved: true,
                color: colors[i],
                barWidth: 3,
                dotData: const FlDotData(show: false),
                spots: [
                  for (var h = 0; h <= 24; h += 2)
                    FlSpot(h.toDouble(), (appState.zones[i].moisture + 8 * sin(h / 4 + i)).clamp(0, 100).toDouble()),
                ],
              ),
          ],
        )),
      ),
      const SizedBox(height: 12),
      for (var i = 0; i < 4; i++)
        ListTile(
          dense: true,
          leading: CircleAvatar(radius: 6, backgroundColor: colors[i]),
          title: Text('Zone ${i + 1} - ${appState.zones[i].plant}'),
          trailing: Text('Avg. ${appState.zones[i].moisture.round()}%'),
        ),
    ]);
  }
}

// ---------------- Notifications ----------------
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Notifications'), centerTitle: true, backgroundColor: kBg),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          demoRow(),
          for (final a in demoAlerts)
            Card(
              margin: const EdgeInsets.only(top: 10),
              child: ListTile(
                leading: Icon(a[3] == true ? Icons.circle : Icons.circle_outlined, size: 12, color: kGreen),
                title: Text(a[0] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(a[1] as String),
                trailing: Text(a[2] as String, style: const TextStyle(color: kText2, fontSize: 12)),
              ),
            ),
        ]),
      );
}

// ---------------- Settings ----------------
class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});
  @override
  Widget build(BuildContext context) {
    Widget item(IconData i, String t, [String? s]) =>
        ListTile(leading: Icon(i, color: kGreen), title: Text(t), subtitle: s == null ? null : Text(s), trailing: const Icon(Icons.chevron_right), onTap: () {});
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true, backgroundColor: kBg),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: item(Icons.person_outline, 'Rahim Hossain', 'rahim@example.com')),
        const SizedBox(height: 8),
        Card(
          child: Column(children: [
            item(Icons.wifi, 'Wi-Fi Setup'),
            item(Icons.memory, 'My Device', 'ESP32 Controller'),
            item(Icons.grass, 'Garden Configuration', '4 Zones'),
            item(Icons.notifications_none, 'Notifications'),
            item(Icons.language, 'App Language', 'English'),
            item(Icons.help_outline, 'Help and Support'),
            item(Icons.info_outline, 'About', 'Smart Garden BD v1.0'),
          ]),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.logout, color: kError),
            title: const Text('Logout', style: TextStyle(color: kError)),
            onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false),
          ),
        ),
      ]),
    );
  }
}
