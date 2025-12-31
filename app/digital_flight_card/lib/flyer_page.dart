import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FlyerPage extends StatefulWidget {
  const FlyerPage({super.key});

  @override
  State<FlyerPage> createState() => _FlyerPageState();
}

class _FlyerPageState extends State<FlyerPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _narController = TextEditingController();
  final TextEditingController _rocketController = TextEditingController();
  final TextEditingController _rocketManufacturerController = TextEditingController();
  final TextEditingController _rocketLengthController = TextEditingController();
  final TextEditingController _rocketDiameterController = TextEditingController();
  final TextEditingController _rocketWeightController = TextEditingController();
  final TextEditingController _rocketMotorController = TextEditingController();
  final TextEditingController _rocketDelayController = TextEditingController();
  String _qrData = '';
  String _certificationLevel = '0';

  @override
  void initState() {
    super.initState();
    _loadSavedFields();
  }

  Future<void> _loadSavedFields() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    final nar = prefs.getString('nar') ?? '';
    final cert = prefs.getString('cert_level') ?? '0';
    final rocket = prefs.getString('rocket_name') ?? '';
    final manufacturer = prefs.getString('rocket_manufacturer') ?? '';
    final length = prefs.getString('rocket_length') ?? '';
    final diameter = prefs.getString('rocket_diameter') ?? '';
    final weight = prefs.getString('rocket_weight') ?? '';
    
    setState(() {
      _controller.text = name;
      _narController.text = nar;
      _certificationLevel = cert;
      _rocketController.text = rocket;
      _rocketManufacturerController.text = manufacturer;
      _rocketLengthController.text = length;
      _rocketDiameterController.text = diameter;
      _rocketWeightController.text = weight;
      // motor is not persisted
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _narController.dispose();
    _rocketController.dispose();
    _rocketManufacturerController.dispose();
    _rocketLengthController.dispose();
    _rocketDiameterController.dispose();
    _rocketWeightController.dispose();
    _rocketMotorController.dispose();
    _rocketDelayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flyer Page')),
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //const Text('Digital Flight Card', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                if (_qrData.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: QrImageView(
                      data: _qrData,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
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
                            initialValue: _certificationLevel,
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
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Rocket Info', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _rocketController,
                            decoration: const InputDecoration(
                              labelText: 'Rocket Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _rocketManufacturerController,
                            decoration: const InputDecoration(
                              labelText: 'Manufacturer',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _rocketLengthController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Length (inches)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _rocketDiameterController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Diameter (inches)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _rocketWeightController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Weight (ounces)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _rocketMotorController,
                            decoration: const InputDecoration(
                              labelText: 'Motor',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _rocketDelayController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Delay (seconds)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final name = _controller.text.trim();
                    final nar = _narController.text.trim();
                    final rocket = _rocketController.text.trim();
                    final manufacturer = _rocketManufacturerController.text.trim();
                    final motor = _rocketMotorController.text.trim();
                    final delayText = _rocketDelayController.text.trim();
                    final lengthText = _rocketLengthController.text.trim();
                    final diameterText = _rocketDiameterController.text.trim();
                    final weightText = _rocketWeightController.text.trim();
                    final delay = int.tryParse(delayText);
                    final length = double.tryParse(lengthText);
                    final diameter = double.tryParse(diameterText);
                    final weight = double.tryParse(weightText);
                    final payload = jsonEncode({
                      'name': name,
                      'nar_tra_number': nar,
                      'certification_level': _certificationLevel,
                      'rocket_name': rocket,
                      'rocket_manufacturer': manufacturer,
                      'rocket_motor': motor,
                      'rocket_delay': delay,
                      'rocket_length': length,
                      'rocket_diameter': diameter,
                      'rocket_weight': weight,
                    });
                    setState(() {
                      _qrData = payload;
                    });

                    final snackText = (name.isEmpty && nar.isEmpty && rocket.isEmpty && manufacturer.isEmpty)
                        ? 'Submitted'
                        : 'Submitted: ${name.isEmpty ? '' : name}${nar.isEmpty ? '' : ' — $nar'}${rocket.isEmpty ? '' : ' — $rocket'}${manufacturer.isEmpty ? '' : ' — $manufacturer'}';
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(snackText)),
                      );
                    }

                    // persist fields for next app launch
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('name', name);
                    await prefs.setString('nar', nar);
                    await prefs.setString('cert_level', _certificationLevel);
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
