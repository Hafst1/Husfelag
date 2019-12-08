import 'package:flutter/material.dart';

import './add_construction_screen.dart';
import './constructions_list_screen.dart';
import '../../widgets/category_option.dart';
import '../../widgets/custom_icons_icons.dart';

class ConstructionsScreen extends StatelessWidget {
  static const routeName = '/constructions';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text("Framkvæmdir"),
      centerTitle: true,
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    return Scaffold(
      appBar: appBar,
      body: Container(
        height: heightOfBody,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color.fromRGBO(186, 203, 201, 1)]
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: <Widget>[
              CategoryOption(
                optionIcon: CustomIcons.file_add,
                optionText: "Bæta við framkvæmd",
                optionRoute: AddConstructionScreen.routeName,
              ),
              SizedBox(height: 15),
              CategoryOption(
                optionIcon: CustomIcons.find_in_page,
                optionText: "Yfirlit framkvæmda",
                optionRoute: ConstructionsListScreen.routeName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}