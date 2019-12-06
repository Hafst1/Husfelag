import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/detail_date_item.dart';
import '../../providers/cleaning_provider.dart';
import '../../providers/current_user_provider.dart';
import '../../shared/loading_spinner.dart';

class CleaningDetailScreen extends StatefulWidget {
  static const routeName = '/cleaning-tasks';

  @override
  _CleaningDetailScreenState createState() => _CleaningDetailScreenState();
}

class _CleaningDetailScreenState extends State<CleaningDetailScreen> {
  var _isInit = true;
  var _isLoading = false;

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final residentAssociationId =
          Provider.of<CurrentUserProvider>(context, listen: false)
              .getResidentAssociationId();
      Provider.of<CleaningProvider>(context)
          .fetchCleaningTasks(residentAssociationId)
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

  void _printErrorDialog() {
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
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cleaningId = ModalRoute.of(context).settings.arguments as String;
    final cleaning = Provider.of<CleaningProvider>(context, listen: false)
        .findById(cleaningId);
    final tasks =
        Provider.of<CleaningProvider>(context, listen: false).getAllTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text("Þrif á sameign"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: 35,
                right: 35,
                top: 30,
                bottom: 25,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.home,
                    size: 40,
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'Íbúð ' + cleaning.apartmentNumber,
                      style: TextStyle(fontSize: 25),
                      overflow: TextOverflow.ellipsis,
                    ),
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
                top: 15,
                bottom: 15,
              ),
              child: Column(
                children: <Widget>[
                  DetailDateItem(
                    text: "Frá:",
                    date: cleaning.dateFrom,
                  ),
                  SizedBox(height: 10),
                  DetailDateItem(
                    text: "Til:",
                    date: cleaning.dateTo,
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
              child: _isLoading
                  ? LoadingSpinner()
                  : tasks.isNotEmpty
                      ? Column(
                          children: <Widget>[
                            Text(
                              "Verkefnalisti:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            ...tasks
                                .map((task) => Container(
                                      margin: EdgeInsets.only(bottom: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.check_circle_outline,
                                            size: 30,
                                            color: Colors.purple,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Text(
                                              task.title,
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ],
                        )
                      : Text(
                          "Verkefnalisti yfir þrif á sameign er tómur!",
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
