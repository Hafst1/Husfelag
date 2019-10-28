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
      body: SingleChildScrollView(
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
    );
  }
}
