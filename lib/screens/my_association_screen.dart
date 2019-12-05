import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/current_user_provider.dart';
import '../shared/loading_spinner.dart';
import '../widgets/custom_icons_icons.dart';
import '../widgets/user_list_item.dart';

class MyAssociationScreen extends StatefulWidget {
  @override
  _MyAssociationScreenState createState() => _MyAssociationScreenState();
}

class _MyAssociationScreenState extends State<MyAssociationScreen> {
  var _isInit = true;
  var _isLoadingAssociation = false;
  var _isLoadingResidents = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoadingAssociation = true;
        _isLoadingResidents = true;
      });
      final currentUserData = Provider.of<CurrentUserProvider>(context);
      currentUserData.fetchAssociation(context).then((_) {
        setState(() {
          _isLoadingAssociation = false;
        });
        currentUserData.fetchResidents(context).then((_) {
          setState(() {
            _isLoadingResidents = false;
          });
        }).catchError((error) {
          setState(() {
            _isLoadingAssociation = false;
            _isLoadingResidents = false;
          });
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Villa kom upp'),
              content: Text('Ekki tókst að hlaða upp þínu húsfélagi!'),
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
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text("Mitt húsfélag"),
      centerTitle: true,
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    final currentUserData = Provider.of<CurrentUserProvider>(context);
    final residentAssociation = currentUserData.getAssociationOfUser();
    final residents = currentUserData.getResidentsOfAssociation();
    return Scaffold(
      appBar: appBar,
      body: Container(
        height: heightOfBody,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: heightOfBody * 0.3,
                width: mediaQuery.size.width,
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.2,
                  vertical: 30,
                ),
                child: FittedBox(
                  child: Icon(
                    CustomIcons.apartment,
                  ),
                ),
              ),
              Text(
                residentAssociation.address,
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Aðgangskóði:',
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                residentAssociation.accessCode,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(
                thickness: 2,
                color: Colors.grey[400],
              ),
              _isLoadingResidents
                  ? LoadingSpinner()
                  : Column(
                      children: <Widget>[
                        ...residents.map(
                          (resident) => UserListItem(
                            key: ValueKey(resident.id),
                            userId: resident.id,
                            title: resident.name,
                            apartmentNumber: '103',
                            iconData: Icons.person,
                            makeAdminFunc: () {},
                            kickUserFunc: () {},
                            viewerIsAdmin: true,
                            targetIsAdmin: false,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
