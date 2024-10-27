import 'package:flutter/material.dart';

void main() {
  runApp(ConversionApp());
}

class ConversionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversion App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ConversionHomePage(),
    );
  }
}

class ConversionHomePage extends StatefulWidget {
  @override
  _ConversionHomePageState createState() => _ConversionHomePageState();
}

class _ConversionHomePageState extends State<ConversionHomePage> {
  final TextEditingController _inputController = TextEditingController();
  double? _result;
  String _conversionType = 'Distance';
  String _selectedUnit = 'Miles to Kilometers';
  String _unit ='km';

//hashMap for how to convert different values
  final Map<String, Function(double)> conversionMap = {
    'Miles to Kilometers': (value) => value * 1.60934,
    'Kilometers to Miles': (value) => value / 1.60934,
    'Pounds to Kilograms': (value) => value * 0.453592,
    'Kilograms to Pounds': (value) => value / 0.453592,
  };
 //hashMap for the unit of value  based on dropdown
  final Map<String, String> unitMap= {
    'Miles to Kilometers': 'km',
    'Kilometers to Miles': 'miles' ,
    'Pounds to Kilograms': 'kg',
    'Kilograms to Pounds': 'lbs',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Conversion App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
           //Creating a dropdown for choosing between weight and distance
            DropdownButton<String>(
              value: _conversionType,
              items: <String>['Distance', 'Weight'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  //Changing the value of states on value change of dropdown
                  _conversionType = newValue!;
                  _selectedUnit = _conversionType == 'Distance'
                      ? 'Miles to Kilometers'
                      : 'Pounds to Kilograms';
                  _unit = unitMap[_selectedUnit]!;
                  _convert();
                });
              },
            ),
            DropdownButton<String>(
              value: _selectedUnit,
              items: (_conversionType == 'Distance'
                  ? ['Miles to Kilometers', 'Kilometers to Miles']
                  : ['Pounds to Kilograms', 'Kilograms to Pounds'])
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value)
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedUnit = newValue!;
                  _unit = unitMap[_selectedUnit]!;
                  _convert();
                });
              },
            ),
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: 'Enter value',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Convert'),
            ),
            SizedBox(height: 20),
            if (_result != null)
              Text(
                //Print result
                 'Result: ${_result?.toStringAsFixed(2)} $_unit ',
                style: TextStyle(fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }
//function to convert based on entered value and dropdown values
  void _convert() {
    double input = double.tryParse(_inputController.text) ?? 0.0;
    setState(() {
      _result = conversionMap[_selectedUnit]!(input);
    });
  }
}
