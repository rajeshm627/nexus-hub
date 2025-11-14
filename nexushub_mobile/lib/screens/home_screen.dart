import 'package:flutter/material.dart';
import 'package:nexushub/screens/visitor_approval_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NexusHub Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to NexusHub!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const VisitorApprovalScreen(
                      visitorName: 'John Doe',
                      flatNumber: 'A-101',
                    ),
                  ),
                );
              },
              child: const Text('Simulate Visitor Arrival'),
            ),
          ],
        ),
      ),
    );
  }
}
