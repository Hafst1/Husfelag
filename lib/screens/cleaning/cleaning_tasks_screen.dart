import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/cleaning_task_item.dart';
import '../../providers/cleaning_task_provider.dart';
import '../../models/cleaning_task.dart';


class CleaningTasksScreen extends StatefulWidget {
  static const routeName = '/cleaning-tasks';
  @override
  _CleaningTasksScreenState createState() => 
    _CleaningTasksScreenState();
  }

class _CleaningTasksScreenState extends State<CleaningTasksScreen> {
  List<CleaningTask> products;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<CleaningTaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Verkefnalisti')),
      ),
      body: Container(
        child: StreamBuilder(
            stream: productProvider.fetchProductsAsStream(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                products = snapshot.data.documents
                    .map((doc) => CleaningTask.fromMap(doc.data, doc.documentID))
                    .toList();
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (buildContext, i) =>
                      CleaningTaskItem(
                      id: products[i].id,
                      title: products[i].title,
                      description: products[i].description,
                    ),
                );
              } else {
                return Text('fetching');
              }
            }),
      ),
    );
  
  }
}
