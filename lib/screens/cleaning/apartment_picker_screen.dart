import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/apartment_picker_item.dart';
import '../../providers/current_user_provider.dart';
import '../../providers/association_provider.dart';
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
      final residentAssociationId =
          Provider.of<CurrentUserProvider>(context).getResidentAssociationId();
      Provider.of<AssociationsProvider>(context)
          .fetchApartments(residentAssociationId)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((_) {
        setState(() {
          _isLoading = false;
        });
        _printErrorDialog();
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  selectApartment(BuildContext context, String apartmentNumber) {
    Navigator.of(context).pop(apartmentNumber);
  }

  _printErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Villa kom upp'),
        content: Text('Ekki tókst að sækja íbúðir húsfélags!'),
        actions: <Widget>[
          FlatButton(
            child: Text('Halda áfram'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final apartmentData = Provider.of<AssociationsProvider>(context);
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
