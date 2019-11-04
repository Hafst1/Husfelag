import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/constructions_provider.dart';

class ConstructionDetailScreen extends StatelessWidget {
  final String id;

  ConstructionDetailScreen({
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    final loadedConstruction =
        Provider.of<ConstructionsProvider>(context).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedConstruction.title),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Text(loadedConstruction.id),
          Text(loadedConstruction.title),
          Text(loadedConstruction.dateFrom.toString()),
          Text(loadedConstruction.dateTo.toString()),
          Text(loadedConstruction.description),
        ],
      ),
    );
  }
}
