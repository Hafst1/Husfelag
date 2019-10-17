import 'package:flutter/material.dart';

class CleaningTasksScreen extends StatelessWidget {
  static const routeName = '/cleaning-tasks';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verkefnalisti"),
      ),
    );
  }
}