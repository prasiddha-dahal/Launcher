import 'package:flutter/material.dart';

class LauncherView extends StatelessWidget {
  const LauncherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("My launcher")
          ],
        ),
      ),
    );
  }
}