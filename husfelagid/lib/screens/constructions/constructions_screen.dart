import 'package:flutter/material.dart';

import './add_construction_screen.dart';
import './constructions_list_screen.dart';
import '../../widgets/category_option.dart';
import '../../widgets/custom_icons_icons.dart';

class ConstructionsScreen extends StatelessWidget {
  static const routeName = '/constructions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Framkvæmdir"),
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            CategoryOption(
              CustomIcons.file_add,
              "Bæta við framkvæmd",
              AddConstructionScreen.routeName,
            ),
            SizedBox(height: 15),
            CategoryOption(
              CustomIcons.find_in_page,
              "Yfirlit framkvæmda",
              ConstructionsListScreen.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
