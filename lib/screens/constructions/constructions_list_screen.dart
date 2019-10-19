import 'package:flutter/material.dart';

class ConstructionsListScreen extends StatelessWidget {
  static const routeName = '/constructions-list';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yfirlit framkvæmda"),
      ),
    );
  }
}