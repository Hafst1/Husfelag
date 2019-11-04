import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/constructions_provider.dart';
import '../../widgets/detail_date_item.dart';

class ConstructionDetailScreen extends StatelessWidget {
  final String id;

  ConstructionDetailScreen({
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    final loadedConstruction =
        Provider.of<ConstructionsProvider>(context, listen: false).findById(id);
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text(loadedConstruction.title),
      centerTitle: true,
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          // Tímabundin mynd í staðinn fyrir skjöl tengd framkvæmd
          Container(
            height: heightOfBody * 0.35,
            width: double.infinity,
            child: Image(
              image: NetworkImage(
                  "https://www.irishbuildingmagazine.ie/wp-content/uploads/2017/01/Construction-Activity-2017-800x445.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 35,
              right: 35,
              top: 30,
              bottom: 20,
            ),
            child: Column(
              children: <Widget>[
                DetailDateItem(
                  text: "Frá:",
                  date: loadedConstruction.dateFrom,
                ),
                SizedBox(
                  height: 10,
                ),
                DetailDateItem(
                  text: "Til:",
                  date: loadedConstruction.dateTo,
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 35,
              right: 35,
              top: 25,
              bottom: 25,
            ),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Text(
                  "Nánari lýsing:",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  loadedConstruction.description,
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
