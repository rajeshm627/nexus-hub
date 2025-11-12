import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LogVisitorDialog extends StatefulWidget {
  const LogVisitorDialog({super.key});

  @override
  State<LogVisitorDialog> createState() => _LogVisitorDialogState();
}

class _LogVisitorDialogState extends State<LogVisitorDialog> {
  final _formKey = GlobalKey<FormState>();
  String _visitorName = '';
  String _flatNumber = '';

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      final url = Uri.parse('http://localhost:3002/log-visitor');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'visitorName': _visitorName,
            'flatNumber': _flatNumber,
          }),
        );
        if (response.statusCode == 200) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Visitor logged successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Visitor'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              key: const ValueKey('visitorName'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the visitor\'s name.';
                }
                return null;
              },
              onSaved: (value) {
                _visitorName = value!;
              },
              decoration: const InputDecoration(
                labelText: 'Visitor Name',
              ),
            ),
            TextFormField(
              key: const ValueKey('flatNumber'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the flat number.';
                }
                return null;
              },
              onSaved: (value) {
                _flatNumber = value!;
              },
              decoration: const InputDecoration(
                labelText: 'Flat Number',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement photo capture
              },
              child: const Text('Take Photo'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
