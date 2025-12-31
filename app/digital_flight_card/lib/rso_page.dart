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

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _scannedData = null;
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                      });
                      showDialog<void>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('QR Code Scanned'),
                          content: Text(raw),
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
