import 'package:flutter/material.dart';
import 'main.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deyelightful Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              sessionManager.signOutDevice();
            },
          )
        ],
      ),
      body: const Center(
        child: Text('Dashboard Analytics Coming Soon...'),
      ),
    );
  }
}
