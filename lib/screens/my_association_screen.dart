import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import '../providers/current_user_provider.dart';
import '../providers/association_provider.dart';
import '../shared/loading_spinner.dart';
import '../widgets/custom_icons_icons.dart';
import '../widgets/user_list_item.dart';
import '../models/apartment.dart';
import '../models/resident_association.dart';
import '../screens/edit_association_screen.dart';
import '../models/notification.dart';
import '../shared/constants.dart' as Constants;

class MyAssociationScreen extends StatefulWidget {
  @override
  _MyAssociationScreenState createState() => _MyAssociationScreenState();
}

class _MyAssociationScreenState extends State<MyAssociationScreen> {
  var _isInit = true;
  var _isLoadingAssociation = false;
  var _isLoadingResidents = false;

  @override
  // fetch the current association, apartments and residents before widget is built.
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoadingAssociation = true;
        _isLoadingResidents = true;
      });
      final residentAssociationId =
          Provider.of<CurrentUserProvider>(context).getResidentAssociationId();
      final associationsData = Provider.of<AssociationsProvider>(context);
      associationsData.fetchAssociation(residentAssociationId).then((_) {
        setState(() {
          _isLoadingAssociation = false;
        });
        associationsData.fetchApartments(residentAssociationId).then((_) {
          associationsData.fetchResidents(residentAssociationId).then((_) {
            setState(() {
              _isLoadingResidents = false;
            });
          }).catchError((error) {
            setState(() {
              _isLoadingAssociation = false;
              _isLoadingResidents = false;
            });
            _printErrorDialog('Ekki tókst að hlaða upp þínu húsfélagi!');
            Navigator.of(context).pop();
          });
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // functions which presents an error dialog with the error message
  // taken in as parameter.
  Future<void> _printErrorDialog(String errorMessage) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Villa kom upp'),
        content: Text(errorMessage),
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

  // function which presents an action dialog when user wants to leave the
  // resident association.
  void _presentLeaveAssociationDialog(bool userIsAdmin, Apartment apartment) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Skráning úr húsfélagi'),
        content: Text('Ertu viss um að þú viljir skrá þig úr húsfélaginu?'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Hætta við',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            child: Text(
              'Staðfesta',
            ),
            onPressed: () {
              final associationData =
                  Provider.of<AssociationsProvider>(context);
              final moreThanOneAdmin = associationData.moreThanOneAdmin();
              final numberOfResidents =
                  associationData.getResidentsOfAssociation().length;
              if (userIsAdmin && !moreThanOneAdmin) {
                Navigator.of(ctx).pop();
                if (numberOfResidents <= 1) {
                  _deleteResidentAssociation();
                } else {
                  _printErrorDialog(
                      'Ekki tókst að skrá þig úr húsfélaginu þar sem þú ert eini meðlimur húsfélagins með admin réttindi!\n\nVeittu öðrum meðlimi admin réttindi og reyndu aftur.');
                }
              } else {
                _leaveResidentAssociation(apartment);
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  // function which makes the current user leave the resident association he is
  // registered in.
  void _leaveResidentAssociation(Apartment apartment) async {
    setState(() {
      _isLoadingAssociation = true;
    });
    if (apartment.id == '') {
      await _printErrorDialog('Ekki tókst að skrá þig úr húsfélaginu!');
    }
    try {
      await Provider.of<CurrentUserProvider>(context)
          .leaveResidentAssociation(apartment);
    } catch (error) {
      await _printErrorDialog('Ekki tókst að skrá þig úr húsfélaginu!');
    }
    setState(() {
      _isLoadingAssociation = false;
    });
  }

  void _deleteResidentAssociation() async {
    setState(() {
      _isLoadingAssociation = true;
    });
    try {
      await Provider.of<CurrentUserProvider>(context)
          .deleteResidentAssociation();
    } catch (error) {
      await _printErrorDialog('Ekki tókst að skrá þig úr húsfélaginu!');
    }
    setState(() {
      _isLoadingAssociation = false;
    });
  }

  // function which sends user to a page where he can change the access
  // code and description of the resident association.
  void _goToEditPage(ResidentAssociation association) {
    if (association.id.isEmpty) {
      print('error');
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditAssociationScreen(),
        settings: RouteSettings(arguments: association),
      ),
    );
  }

  // function which makes the user with the id given as parameter an admin.
  void _makeAdmin(String userId) async {
    setState(() {
      _isLoadingAssociation = true;
    });

    final userData = Provider.of<AssociationsProvider>(context);
    final user = userData.getResident(userId);
    try {
      if (user.id.isEmpty) {
        await _printErrorDialog('Ekki tókst að veita meðlimi admin réttindi!');
        return;
      }
      await userData.makeUserAdmin(user);
    } catch (error) {
      await _printErrorDialog('Ekki tókst að veita meðlimi admin réttindi!');
    }
    try {
      await Provider.of<NotificationsProvider>(context, listen: false)
          .addNotification(
              user.residentAssociationId,
              NotificationModel(
                id: null,
                title: user.name + ' er núna stjórnandi',
                description: '',
                date: DateTime.now(),
                authorId: user.id,
                type: Constants.MADE_ADMIN,
              ));
    } catch (error) {}
    setState(() {
      _isLoadingAssociation = false;
    });
  }

  // function which kicks the user with the id given as parameter out of the
  // resident association.
  void _kickUser(String userId, String apartmentNumber) async {
    setState(() {
      _isLoadingAssociation = true;
    });
    try {
      final associationsData = Provider.of<AssociationsProvider>(context);
      final user = associationsData.getResident(userId);
      final apartment = associationsData.getApartmentByNumber(apartmentNumber);
      await associationsData.kickUser(user, apartment);
    } catch (error) {
      await _printErrorDialog('Ekki tókst að sparka meðlimi úr húsfélaginu!');
    }
    setState(() {
      _isLoadingAssociation = false;
    });
  }

  // function which presents a dialog which confirms whether user wants to
  // delete a certain resident or not.
  void _presentKickUserDialog(String userId, String apartmentNumber) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Brottrekstur'),
        content: Text(
            'Ertu viss um að þú viljir sparka tilteknum meðlimi úr húsfélaginu?'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Hætta við',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            child: Text(
              'Staðfesta',
            ),
            onPressed: () {
              _kickUser(userId, apartmentNumber);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text('Mitt húsfélag'),
      centerTitle: true,
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    final currentUserData = Provider.of<CurrentUserProvider>(context);
    final associationsData = Provider.of<AssociationsProvider>(context);
    final residentAssociation = associationsData
        .getAssociationOfUser(currentUserData.getResidentAssociationId());
    final residents = associationsData.getResidentsOfAssociation();
    return Scaffold(
      appBar: appBar,
      body: _isLoadingAssociation
          ? LoadingSpinner()
          : Container(
              height: heightOfBody,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    currentUserData.isAdmin()
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                onPressed: () =>
                                    _goToEditPage(residentAssociation),
                                icon: Icon(
                                  CustomIcons.pencil,
                                  size: 27,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 30,
                          ),
                    Container(
                      height: heightOfBody * 0.25,
                      width: mediaQuery.size.width,
                      padding: EdgeInsets.only(
                        left: mediaQuery.size.width * 0.2,
                        right: mediaQuery.size.width * 0.2,
                        bottom: 30,
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
                    residentAssociation.description.isNotEmpty
                        ? Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Lýsing: ',
                                      style: TextStyle(
                                        fontSize: 17,
                                        height: 1.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        residentAssociation.description,
                                        style: TextStyle(
                                          fontSize: 17,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                            ],
                          )
                        : Container(),
                    residents.isNotEmpty
                        ? Divider(
                            thickness: 2,
                            color: Colors.grey[400],
                          )
                        : Container(),
                    _isLoadingResidents
                        ? Container(
                            height: residentAssociation.description.isEmpty
                                ? heightOfBody * 0.5
                                : heightOfBody * 0.3,
                            child: LoadingSpinner(),
                          )
                        : Column(
                            children: <Widget>[
                              ...residents.map(
                                (resident) => UserListItem(
                                  key: ValueKey(resident.id),
                                  userId: resident.id,
                                  title: resident.name,
                                  apartmentNumber: associationsData
                                      .getApartmentNumber(resident.apartmentId),
                                  iconData: Icons.person,
                                  makeAdminFunc: (userId) => _makeAdmin(userId),
                                  kickUserFunc: (userId, apartmentNumber) =>
                                      _presentKickUserDialog(
                                          userId, apartmentNumber),
                                  viewerIsAdmin: currentUserData.isAdmin(),
                                  targetIsAdmin: resident.isAdmin,
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: heightOfBody * 0.1,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          height: 45,
                          child: FlatButton(
                            onPressed: () => _presentLeaveAssociationDialog(
                              currentUserData.isAdmin(),
                              associationsData.getApartmentById(
                                currentUserData.getApartmentId(),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  CustomIcons.user_times,
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  'Skrá mig úr húsfélagi',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            color: Colors.red[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: Colors.green[200]),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: heightOfBody * 0.1,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
