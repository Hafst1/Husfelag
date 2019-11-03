import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/apartment_picker_item.dart';
import '../providers/cleaning_provider.dart';

class ApartMentPickerScreen extends StatelessWidget {
  selectApartment(BuildContext context, String apartmentNumber) {
    Navigator.of(context).pop(apartmentNumber);
  }

  @override
  Widget build(BuildContext context) {
    final apartmentData = Provider.of<CleaningProvider>(context);
    final apartments = apartmentData.apartmentItems;
    return Scaffold(
      appBar: AppBar(
        title: Text("Veldu íbúð"),
        centerTitle: true,
      ),
      body: GridView(
        padding: const EdgeInsets.all(25),
        children: apartments
            .map(
              (apartment) => ApartmentPickerItem(
                apartment: apartment.apartmentNumber,
                onClickFunc: selectApartment,
              ),
            )
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: (MediaQuery.of(context).size.width - 50) / 3,
          childAspectRatio: 2 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 30,
        ),
      ),
    );
  }
}
