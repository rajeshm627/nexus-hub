import 'package:flutter/material.dart';
import 'package:nexushub/widgets/log_visitor_dialog.dart';

class SecurityGateScreen extends StatelessWidget {
  const SecurityGateScreen({super.key});

  void _showLogVisitorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LogVisitorDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Gate'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _showLogVisitorDialog(context),
              child: const Text('Log Visitor'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement View Log screen
              },
              child: const Text('View Log'),
            ),
          ],
        ),
      ),
    );
  }
}
