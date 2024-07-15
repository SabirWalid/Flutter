import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const TemperatureConverter(),
    );
  }
}

class TemperatureConverter extends StatefulWidget {
  const TemperatureConverter({super.key});

  @override
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  final _formKey = GlobalKey<FormState>();
  final _history = <String>[];
  double? _inputValue;
  double? _result;
  String _selectedConversion = 'FtoC'; // Default to Fahrenheit to Celsius

  void _convertTemperature() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        if (_selectedConversion == 'FtoC') {
          _result = (_inputValue! - 32) * 5 / 9;
          _history.add('F to C: ${_inputValue!.toStringAsFixed(1)} => ${_result!.toStringAsFixed(2)}');
        } else {
          _result = _inputValue! * 9 / 5 + 32;
          _history.add('C to F: ${_inputValue!.toStringAsFixed(1)} => ${_result!.toStringAsFixed(2)}');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Enter Temperature'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a temperature';
                  }
                  return null;
                },
                onSaved: (value) => _inputValue = double.parse(value!),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Radio(
                    value: 'FtoC',
                    groupValue: _selectedConversion,
                    onChanged: (value) {
                      setState(() {
                        _selectedConversion = value!;
                      });
                    },
                  ),
                  const Text('Fahrenheit to Celsius'),
                  Radio(
                    value: 'CtoF',
                    groupValue: _selectedConversion,
                    onChanged: (value) {
                      setState(() {
                        _selectedConversion = value!;
                      });
                    },
                  ),
                  const Text('Celsius to Fahrenheit'),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _convertTemperature,
                child: const Text('Convert'),
              ),
              const SizedBox(height: 16),
              if (_result != null)
                Text(
                  'Result: ${_result!.toStringAsFixed(2)} ${_selectedConversion == 'FtoC' ? '°C' : '°F'}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_history[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}