import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class RSOPage extends StatefulWidget {
  const RSOPage({super.key});

  @override
  State<RSOPage> createState() => _RSOPageState();
}

class _RSOPageState extends State<RSOPage> {
  final MobileScannerController _cameraController = MobileScannerController();
  bool _scanning = false;
  String? _scannedData;
  Map<String, dynamic>? _parsedData;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _scannedData = null;
      _parsedData = null;
      _scanning = true;
    });
  }

  void _stopScan() {
    _cameraController.stop();
    setState(() {
      _scanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RSO Page')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_scanning) ...[
              SizedBox(
                width: 320,
                height: 420,
                child: MobileScanner(
                  controller: _cameraController,
                  onDetect: (capture) {
                    for (final barcode in capture.barcodes) {
                      final String? raw = barcode.rawValue;
                      if (raw == null) continue;
                      // stop further scanning
                      _stopScan();
                      setState(() {
                        _scannedData = raw;
                        _parsedData = null;
                      });

                      // Try to parse JSON payload
                      Widget content;
                      try {
                        final dynamic decoded = jsonDecode(raw);
                        if (decoded is Map<String, dynamic>) {
                          _parsedData = decoded;
                          content = SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: decoded.entries
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Text('${e.key}: ${e.value}'),
                                      ))
                                  .toList(),
                            ),
                          );
                        } else {
                          content = Text('Scanned data is not a JSON object:\n\n$raw');
                        }
                      } catch (e) {
                        content = Text('Failed to parse JSON:\n\n$raw');
                      }

                      showDialog<void>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('QR Code Scanned'),
                          content: content,
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );

                      break;
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _stopScan,
                icon: const Icon(Icons.close),
                label: const Text('Cancel'),
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: _startScan,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan QR'),
              ),
              const SizedBox(height: 12),
              if (_scannedData != null) ...[
                const Text('Last scanned:'),
                const SizedBox(height: 8),
                SelectableText(_scannedData!),
                const SizedBox(height: 12),
                if (_parsedData != null) ...[
                  const Text('Parsed properties:'),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _parsedData!.entries
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text('${e.key}: ${e.value}'),
                            ))
                        .toList(),
                  ),
                ],
              ] else ...[
                const Text('No QR scanned yet.'),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
