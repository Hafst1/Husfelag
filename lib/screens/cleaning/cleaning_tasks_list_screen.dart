import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/construction.dart';
import '../../providers/CRUDmodel.dart';
import '../../widgets/cleaning_task_item.dart';


class CleaningTasksListView extends StatefulWidget {

  @override
  _CleaningTasksListViewState createState() => 
    _CleaningTasksListViewState();
  }

class _CleaningTasksListViewState extends State<CleaningTasksListView> {
  List<Construction> products;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<CRUDModel>(context);

    return Scaffold(
     /* floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addProduct');
        },
        child: Icon(Icons.add),
      ),*/
      appBar: AppBar(
        title: Center(child: Text('Verkefnalisti')),
      ),
      body: Container(
        child: StreamBuilder(
            stream: productProvider.fetchProductsAsStream(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                products = snapshot.data.documents
                    .map((doc) => Construction.fromMap(doc.data, doc.documentID))
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