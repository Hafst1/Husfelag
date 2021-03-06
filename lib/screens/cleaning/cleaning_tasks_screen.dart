import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cleaning_provider.dart';
import '../../providers/current_user_provider.dart';
import '../../providers/association_provider.dart';
import '../../widgets/cleaning_task_item.dart';
import 'add_cleaning_task_screen.dart';
import '../../shared/loading_spinner.dart';

class CleaningTasksScreen extends StatefulWidget {
  static const routeName = '/cleaning-tasks';

  @override
  _CleaningTasksScreenState createState() => _CleaningTasksScreenState();
}

class _CleaningTasksScreenState extends State<CleaningTasksScreen> {
  var _isInit = true;
  var _isLoading = false;

  // fetch cleaning tasks, apartments and cleaning items when widget is built.
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final cleaningTaskData = Provider.of<CleaningProvider>(context);
      final residentAssociationId =
          Provider.of<CurrentUserProvider>(context).getResidentAssociationId();
      cleaningTaskData.fetchCleaningTasks(residentAssociationId).then((_) {
        Provider.of<AssociationsProvider>(context)
            .fetchApartments(residentAssociationId)
            .then((_) {
          cleaningTaskData.fetchCleaningItems(residentAssociationId).then((_) {
            setState(() {
              _isLoading = false;
            });
          }).catchError((error) {
            setState(() {
              _isLoading = false;
            });
            _printErrorDialog();
          });
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // function which presents an error dialog.
  _printErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Villa kom upp'),
        content: Text('Ekki tókst að hlaða upp verkefnalista!'),
        actions: <Widget>[
          FlatButton(
            child: Text('Halda áfram'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserData = Provider.of<CurrentUserProvider>(context);
    final apartmentData = Provider.of<AssociationsProvider>(context);
    final cleaningTaskData = Provider.of<CleaningProvider>(context);
    final cleaningTasks = cleaningTaskData.getAllTasks();
    return Scaffold(
      appBar: AppBar(
        title: Text('Verkefnalisti'),
        centerTitle: true,
      ),
      body: _isLoading
          ? LoadingSpinner()
          : (cleaningTasks.isEmpty && !currentUserData.isAdmin())
              ? Container(
                  padding: const EdgeInsets.only(
                    top: 30,
                    left: 10,
                    right: 10,
                  ),
                  width: double.infinity,
                  child: Text(
                    "Verkefnalisti yfir þrif á sameign er tómur!",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    currentUserData.isAdmin()
                        ? Card(
                            margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 5,
                            ),
                            child: MaterialButton(
                              color: Colors.white,
                              textColor: Colors.lightBlueAccent,
                              padding: EdgeInsets.all(20.0),
                              child: Text("Bæta við verkefni"),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddCleaningTaskScreen(),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cleaningTasks.length,
                        itemBuilder: (ctx, i) => CleaningTaskItem(
                          id: cleaningTasks[i].id,
                          title: cleaningTasks[i].title,
                          description: cleaningTasks[i].description,
                          taskDone: cleaningTasks[i].taskDone,
                          isAdmin: currentUserData.isAdmin(),
                          canCheck: cleaningTaskData.isUsersTurnToClean(
                            apartmentData.getApartmentNumber(
                                currentUserData.getApartmentId()),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
