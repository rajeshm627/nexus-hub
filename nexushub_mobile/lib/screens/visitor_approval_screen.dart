import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VisitorApprovalScreen extends StatelessWidget {
  final String visitorName;
  final String flatNumber;

  const VisitorApprovalScreen({
    super.key,
    required this.visitorName,
    required this.flatNumber,
  });

  Future<void> _approveVisitor(BuildContext context) async {
    _sendVisitorAction(context, 'approve-visitor', 'Visitor approved');
  }

  Future<void> _denyVisitor(BuildContext context) async {
    _sendVisitorAction(context, 'deny-visitor', 'Visitor denied');
  }

  Future<void> _sendVisitorAction(BuildContext context, String action, String successMessage) async {
    final url = Uri.parse('http://localhost:3002/$action');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'visitorId': 'simulated-visitor-id'}), // Simulate a visitor ID
      );
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(successMessage)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitor Approval'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50), // Placeholder for visitor photo
              ),
              const SizedBox(height: 20),
              Text(
                'Visitor: $visitorName',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Text(
                'For Flat: $flatNumber',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _approveVisitor(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Approve'),
                  ),
                  ElevatedButton(
                    onPressed: () => _denyVisitor(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Deny'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
