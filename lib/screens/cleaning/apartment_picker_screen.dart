import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/apartment_picker_item.dart';
import '../../providers/current_user_provider.dart';
import '../../shared/loading_spinner.dart';

class ApartMentPickerScreen extends StatefulWidget {
  @override
  _ApartMentPickerScreenState createState() => _ApartMentPickerScreenState();
}

class _ApartMentPickerScreenState extends State<ApartMentPickerScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final currentUserData = Provider.of<CurrentUserProvider>(context);
      currentUserData
          .fetchApartments(currentUserData.getResidentAssociationId())
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  selectApartment(BuildContext context, String apartmentNumber) {
    Navigator.of(context).pop(apartmentNumber);
  }

  @override
  Widget build(BuildContext context) {
    final apartmentData = Provider.of<CurrentUserProvider>(context);
    final apartments = apartmentData.getApartments();
    return Scaffold(
      appBar: AppBar(
        title: Text("Veldu íbúð"),
        centerTitle: true,
      ),
      body: _isLoading
          ? LoadingSpinner()
          : GridView(
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
                maxCrossAxisExtent:
                    (MediaQuery.of(context).size.width - 50) / 3,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 30,
              ),
            ),
    );
  }
}
