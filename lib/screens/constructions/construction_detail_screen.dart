import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../providers/constructions_provider.dart';
import '../../widgets/detail_date_item.dart';
import '../../widgets/custom_icons_icons.dart';
import '../../widgets/slide_dots.dart';

class DummyItem {
  final Icon icon;
  final String fileName;

  DummyItem({
    @required this.icon,
    @required this.fileName,
  });
}

class ConstructionDetailScreen extends StatefulWidget {
  @override
  _ConstructionDetailScreenState createState() =>
      _ConstructionDetailScreenState();
}

class _ConstructionDetailScreenState extends State<ConstructionDetailScreen> {
  int _currentFileIndex = 0;

  List<DummyItem> _dummyData = [
    DummyItem(
      icon: Icon(CustomIcons.doc_text),
      fileName: "thakvidgerd.txt",
    ),
    DummyItem(
      icon: Icon(
        CustomIcons.file_excel,
        color: Colors.green,
      ),
      fileName: "kostnadur.excl",
    ),
    DummyItem(
      icon: Icon(
        CustomIcons.file_pdf,
        color: Colors.red,
      ),
      fileName: "paelingar.pdf",
    ),
    DummyItem(
      icon: Icon(
        CustomIcons.file_word,
        color: Colors.blue,
      ),
      fileName: "yfirlit.docx",
    ),
  ];

  void _currentFileTracker(int index) {
    setState(() {
      _currentFileIndex = index;
    });
  }

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
              padding: _dummyData.isNotEmpty
                  ? const EdgeInsets.only(
                      left: 35,
                      right: 35,
                      top: 20,
                      bottom: 15,
                    )
                  : const EdgeInsets.all(0),
              height: heightOfBody * 0.30,
              width: double.infinity,
              child: _dummyData.isNotEmpty
                  ? CarouselSlider(
                      items: _dummyData.map((item) {
                        return Column(
                          children: <Widget>[
                            Expanded(
                              child: FittedBox(
                                child: item.icon,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              item.fileName,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      onPageChanged: (value) => _currentFileTracker(value),
                      enableInfiniteScroll: false,
                    )
                  // Tímabundin mynd í staðinn fyrir skjöl tengd framkvæmd
                  : Image(
                      image: NetworkImage(
                          "https://www.irishbuildingmagazine.ie/wp-content/uploads/2017/01/Construction-Activity-2017-800x445.jpg"),
                      fit: BoxFit.cover,
                    ),
            ),
            _dummyData.length > 1
                ? Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (var i = 0; i < _dummyData.length; i++)
                          if (i == _currentFileIndex)
                            SlideDots(isActive: true)
                          else
                            SlideDots(isActive: false)
                      ],
                    ),
                  )
                : Container(),
            _dummyData.isNotEmpty
                ? Divider(
                    color: Colors.grey,
                    thickness: 1.5,
                    indent: 20,
                    endIndent: 20,
                  )
                : Container(),
            Container(
              padding: const EdgeInsets.only(
                left: 35,
                right: 35,
                top: 20,
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
                left: 35,
                right: 35,
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
