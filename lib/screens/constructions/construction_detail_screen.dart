import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/constructions_provider.dart';
import '../../widgets/detail_date_item.dart';

class ConstructionDetailScreen extends StatefulWidget {
  @override
  _ConstructionDetailScreenState createState() =>
      _ConstructionDetailScreenState();
}

class _ConstructionDetailScreenState extends State<ConstructionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final constructionId = ModalRoute.of(context).settings.arguments as String;
    final construction =
        Provider.of<ConstructionsProvider>(context, listen: false)
            .findById(constructionId);
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text(construction.title),
      centerTitle: true,
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: heightOfBody * 0.30,
              width: double.infinity,
              child: Container(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/construction_photo.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.lerp(
                    Alignment.topCenter,
                    Alignment.bottomCenter,
                    0.8,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 35,
                right: 35,
                top: 30,
                bottom: 20,
              ),
              child: Column(
                children: <Widget>[
                  DetailDateItem(
                    text: "Frá:",
                    date: construction.dateFrom,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DetailDateItem(
                    text: "Til:",
                    date: construction.dateTo,
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
                left: 30,
                right: 30,
                top: 25,
                bottom: 25,
              ),
              width: double.infinity,
              child: construction.description.isNotEmpty
                  ? Column(
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
                          construction.description,
                          style: TextStyle(
                            fontSize: 17,
                            height: 1.75,
                          ),
                          textAlign: TextAlign.justify,
                          softWrap: true,
                        ),
                      ],
                    )
                  : Text(
                      "Engar nánari upplýsingar.",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
