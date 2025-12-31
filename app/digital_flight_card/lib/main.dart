import 'package:flutter/material.dart';
import 'rso_page.dart';
import 'flyer_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeSelector(),
    );
  }
}

class HomeSelector extends StatelessWidget {
  const HomeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digital Flight Card')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(320, 96),
                textStyle: const TextStyle(fontSize: 24),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FlyerPage()));
              },
              child: const Text('I\'m a Flyer'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(320, 96),
                textStyle: const TextStyle(fontSize: 24),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RSOPage()));
              },
              child: const Text('I\'m an RSO'),
            ),
          ],
        ),
      ),
    );
  }
}

// FlyerPage moved to lib/flyer_page.dart
