import 'package:flutter/material.dart';

void main() {
  runApp(const ConversionApp());
}

class ConversionApp extends StatelessWidget {
  const ConversionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConversionPage(),
    );
  }
}

class ConversionPage extends StatefulWidget {
  const ConversionPage({Key? key}) : super(key: key);

  @override
  _ConversionPageState createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {
  String _selectedValue = 'Distance';
  String _selectedFrom = 'Miles';
  String _selectedTo = 'Kilometers';
  final TextEditingController _inputController = TextEditingController();
  String _result = '';

  final Map<String, List<String>> _units = {
    'Distance': ['Miles', 'Kilometers', 'Meters', 'Feet'],
    'Weight': ['Kilograms', 'Pounds', 'Grams', 'Ounces'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
  };

  final Map<String, Map<String, double Function(double)>> _conversionFactors = {
    'Distance': {
      'Miles_Kilometers': (value) => value * 1.60934,
      'Miles_Meters': (value) => value * 1609.34,
      'Miles_Feet': (value) => value * 5280,
      'Kilometers_Miles': (value) => value / 1.60934,
      'Kilometers_Meters': (value) => value * 1000,
      'Kilometers_Feet': (value) => value * 3280.84,
      'Meters_Miles': (value) => value / 1609.34,
      'Meters_Kilometers': (value) => value / 1000,
      'Meters_Feet': (value) => value * 3.28084,
      'Feet_Miles': (value) => value / 5280,
      'Feet_Kilometers': (value) => value / 3280.84,
      'Feet_Meters': (value) => value / 3.28084,
    },
    'Weight': {
      'Kilograms_Pounds': (value) => value * 2.20462,
      'Kilograms_Grams': (value) => value * 1000,
      'Kilograms_Ounces': (value) => value * 35.274,
      'Pounds_Kilograms': (value) => value / 2.20462,
      'Pounds_Grams': (value) => value * 453.592,
      'Pounds_Ounces': (value) => value * 16,
      'Grams_Kilograms': (value) => value / 1000,
      'Grams_Pounds': (value) => value / 453.592,
      'Grams_Ounces': (value) => value / 28.3495,
      'Ounces_Kilograms': (value) => value / 35.274,
      'Ounces_Pounds': (value) => value / 16,
      'Ounces_Grams': (value) => value * 28.3495,
    },
    'Temperature': {
      'Celsius_Fahrenheit': (value) => (value * 9/5) + 32,
      'Celsius_Kelvin': (value) => value + 273.15,
      'Fahrenheit_Celsius': (value) => (value - 32) * 5/9,
      'Fahrenheit_Kelvin': (value) => (value - 32) * 5/9 + 273.15,
      'Kelvin_Celsius': (value) => value - 273.15,
      'Kelvin_Fahrenheit': (value) => (value - 273.15) * 9/5 + 32,
    },
  };

  void _convert() {
    if (_inputController.text.isEmpty) {
      setState(() {
        _result = 'Please enter a value';
      });
      return;
    }

    double input = double.parse(_inputController.text);
    String conversionKey = '${_selectedFrom}_${_selectedTo}';

    if (_selectedFrom == _selectedTo) {
      setState(() {
        _result = '$input $_selectedFrom are $input $_selectedTo';
      });
      return;
    }

    double output = _conversionFactors[_selectedValue]![conversionKey]!(input);

    setState(() {
      _result = '$input $_selectedFrom are ${output.toStringAsFixed(2)} $_selectedTo';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measures Converter', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: Text('Value', style: TextStyle(fontSize: 18))),
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter number',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Center(child: Text('From', style: TextStyle(fontSize: 18))),
            DropdownButton<String>(
              value: _selectedFrom,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFrom = newValue!;
                });
              },
              items: _units[_selectedValue]!.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: Colors.blue)),
                );
              }).toList(),
              isExpanded: true,
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Center(child: Text('To', style: TextStyle(fontSize: 18))),
            DropdownButton<String>(
              value: _selectedTo,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTo = newValue!;
                });
              },
              items: _units[_selectedValue]!.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: Colors.blue)),
                );
              }).toList(),
              isExpanded: true,
              style: const TextStyle(fontSize: 22, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                  onPressed: _convert,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Convert'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}