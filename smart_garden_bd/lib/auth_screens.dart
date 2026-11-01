import 'package:flutter/material.dart';
import 'data.dart';
import 'screens.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int page = 0;
  static const pages = [
    [Icons.memory, 'Connect your controller', 'Pair your Smart Garden ESP32 controller with your account.'],
    [Icons.water_drop, 'Monitor soil moisture', 'See live moisture for all four zones, from anywhere.'],
    [Icons.eco, 'Automate watering', 'Keep your plants healthy with smart automatic watering.'],
  ];

  void finish() {
    appState.markOnboardingSeen();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(children: [
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: finish, child: const Text('Skip'))),
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => page = i),
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    CircleAvatar(radius: 70, backgroundColor: kGreen.withOpacity(.12), child: Icon(pages[i][0] as IconData, size: 70, color: kGreen)),
                    const SizedBox(height: 32),
                    Text(pages[i][1] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(pages[i][2] as String, textAlign: TextAlign.center, style: const TextStyle(color: kText2, fontSize: 16)),
                  ]),
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (var i = 0; i < pages.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.all(4),
                  width: page == i ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(color: page == i ? kGreen : Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
                ),
            ]),
            Padding(
              padding: const EdgeInsets.all(24),
              child: FilledButton(
                onPressed: () => page == pages.length - 1
                    ? finish()
                    : controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
                child: Text(page == pages.length - 1 ? 'Get Started' : 'Next'),
              ),
            ),
          ]),
        ),
      );
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirm = TextEditingController();
  String? error;

  void submit() {
    String? e;
    if (name.text.trim().isEmpty) {
      e = 'Please enter your name.';
    } else if (!email.text.contains('@')) {
      e = 'Please enter a valid email.';
    } else if (pass.text.length < 6) {
      e = 'Password must be at least 6 characters.';
    } else if (pass.text != confirm.text) {
      e = 'Passwords do not match.';
    }
    setState(() => error = e);
    if (e == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo mode: no real account was created.')));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainShell()), (r) => false);
    }
  }

  Widget field(TextEditingController c, String label, IconData i, {bool hide = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(controller: c, obscureText: hide, decoration: InputDecoration(prefixIcon: Icon(i), labelText: label, border: const OutlineInputBorder())),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Sign Up'), backgroundColor: kBg),
        body: ListView(padding: const EdgeInsets.all(24), children: [
          const Text('Create your account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          field(name, 'Full name', Icons.person_outline),
          field(email, 'Email', Icons.mail_outline),
          field(pass, 'Password', Icons.lock_outline, hide: true),
          field(confirm, 'Confirm password', Icons.lock_outline, hide: true),
          if (error != null) Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(error!, style: const TextStyle(color: kError))),
          FilledButton(onPressed: submit, child: const Text('Create Account')),
        ]),
      );
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Forgot Password'), backgroundColor: kBg),
        body: ListView(padding: const EdgeInsets.all(24), children: [
          const Text('Enter your email and we will send a reset link.', style: TextStyle(color: kText2)),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.mail_outline), labelText: 'Email', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo mode: no email is sent. Real reset comes with Firebase.')));
              Navigator.pop(context);
            },
            child: const Text('Send Reset Link'),
          ),
        ]),
      );
}
