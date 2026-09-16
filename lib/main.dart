import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  double? _firstOperand;
  String _operator = '';
  bool _shouldResetDisplay = false;

  void _onButtonPressed(String text) {
    if (text == '') return;
    setState(() {
      if (text == 'C') {
        _display = '0';
        _firstOperand = null;
        _operator = '';
        _shouldResetDisplay = false;
      } else if (text == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
      } else if (text == '+' || text == '-' || text == '×' || text == '÷') {
        _firstOperand = double.tryParse(_display);
        _operator = text;
        _shouldResetDisplay = true;
      } else if (text == '=') {
        if (_firstOperand != null && _operator.isNotEmpty) {
          double secondOperand = double.tryParse(_display) ?? 0;
          double result = 0;
          switch (_operator) {
            case '+':
              result = _firstOperand! + secondOperand;
              break;
            case '-':
              result = _firstOperand! - secondOperand;
              break;
            case '×':
              result = _firstOperand! * secondOperand;
              break;
            case '÷':
              if (secondOperand == 0) {
                _display = 'Error';
                _firstOperand = null;
                _operator = '';
                _shouldResetDisplay = true;
                return;
              }
              result = _firstOperand! / secondOperand;
              break;
          }
          _display = result.toString();
          if (_display.endsWith('.0')) {
            _display = _display.substring(0, _display.length - 2);
          }
          _firstOperand = null;
          _operator = '';
          _shouldResetDisplay = true;
        }
      } else {
        // Numbers and decimal
        if (_shouldResetDisplay) {
          _display = text;
          _shouldResetDisplay = false;
        } else {
          if (_display == '0' && text != '.') {
            _display = text;
          } else {
            if (text == '.' && _display.contains('.')) {
              return;
            }
            _display += text;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Display
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: Text(
                  _display,
                  style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Buttons
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildButtonRow(['C', '⌫', '÷', '×']),
                  _buildButtonRow(['7', '8', '9', '-']),
                  _buildButtonRow(['4', '5', '6', '+']),
                  _buildButtonRow(['1', '2', '3', '=']),
                  _buildButtonRow(['0', '.', '', '']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((btn) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: _buildButton(btn),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButton(String text) {
    if (text == '') return const SizedBox.shrink();
    
    Color bgColor;
    Color textColor = Colors.white;

    if (['+', '-', '×', '÷', '='].contains(text)) {
      bgColor = Colors.orange;
    } else if (['C', '⌫'].contains(text)) {
      bgColor = Colors.grey[850]!;
    } else {
      bgColor = Colors.grey[900]!;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => _onButtonPressed(text),
      child: Text(text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }
}
