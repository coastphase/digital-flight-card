import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _narController = TextEditingController();
  String _qrData = '';
  String _certificationLevel = '0';

  @override
  void dispose() {
    _controller.dispose();
    _narController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_qrData.isNotEmpty) ...[
                QrImageView(
                  data: _qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                const SizedBox(height: 16),
              ],
              const Text('Digital Flight Card', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Flyer Info', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: _narController,
                          decoration: const InputDecoration(
                            labelText: 'NAR/TRA Number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<String>(
                          value: _certificationLevel,
                          decoration: const InputDecoration(
                            labelText: 'Certification Level',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: '0', child: Text('None')),
                            DropdownMenuItem(value: '1', child: Text('1')),
                            DropdownMenuItem(value: '2', child: Text('2')),
                            DropdownMenuItem(value: '3', child: Text('3')),
                          ],
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() {
                              _certificationLevel = v;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final name = _controller.text.trim();
                  final nar = _narController.text.trim();
                  final payload = jsonEncode({
                    'name': name,
                    'nar_tra_number': nar,
                    'certification_level': _certificationLevel,
                  });
                  setState(() {
                    _qrData = payload;
                  });
                  final snackText = (name.isEmpty && nar.isEmpty)
                      ? 'Submitted'
                      : 'Submitted: ${name.isEmpty ? '' : name}${nar.isEmpty ? '' : ' — $nar'}';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(snackText)),
                  );
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
