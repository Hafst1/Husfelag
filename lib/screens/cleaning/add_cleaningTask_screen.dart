import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cleaning_task.dart';
import '../../providers/cleaning_provider.dart';
import '../../providers/current_user_provider.dart';
import '../../widgets/custom_icons_icons.dart';
import '../../widgets/save_button.dart';
import '../../shared/loading_spinner.dart';

class AddCleaningTaskScreen extends StatefulWidget {
  static const routeName = '/add-cleaningTask';

  @override
  _AddCleaningTaskScreenState createState() => _AddCleaningTaskScreenState();
}

class _AddCleaningTaskScreenState extends State<AddCleaningTaskScreen> {
  final _form = GlobalKey<FormState>();
  var _cleaningTaskItem = CleaningTask(
    id: null,
    title: '',
    description: '',
    taskDone: false,
  );

  var _initValues = {
    'appbar-title': 'Bæta við verkefni',
    'save-text': 'BÆTA VIÐ',
    'title': '',
    'description': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final cleaningTaskId =
          ModalRoute.of(context).settings.arguments as String;
      if (cleaningTaskId != null) {
        _cleaningTaskItem =
            Provider.of<CleaningProvider>(context, listen: false)
                .findCleaningTaskById(cleaningTaskId);
        _initValues = {
          'appbar-title': 'Breyta verkefni',
          'save-text': 'BREYTA',
          'title': _cleaningTaskItem.title,
          'description': _cleaningTaskItem.description,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final residentAssociationId =
        Provider.of<CurrentUserProvider>(context, listen: false)
            .getResidentAssociationId();
    if (_cleaningTaskItem.id != null) {
      try {
        await Provider.of<CleaningProvider>(context, listen: false)
            .updateCleaningTaskItem(residentAssociationId, _cleaningTaskItem);
      } catch (error) {
        await printErrorDialog('Ekki tókst að breyta verkefni!');
      }
    } else {
      try {
        await Provider.of<CleaningProvider>(context, listen: false)
            .addCleaningTaskItem(residentAssociationId, _cleaningTaskItem);
      } catch (error) {
        await printErrorDialog('Ekki tókst að bæta við verkefni!');
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> printErrorDialog(String errorMessage) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_initValues['appbar-title']),
        centerTitle: true,
      ),
      body: _isLoading
          ? LoadingSpinner()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        hintText: "Titill...",
                        prefixIcon: Icon(CustomIcons.pencil),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Fylla þarf út titil verkefnis!";
                        }
                        if (value.length > 40) {
                          return "Titill verkefnis getur ekki verið meira en 40 stafir á lengd!";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _cleaningTaskItem = CleaningTask(
                          id: _cleaningTaskItem.id,
                          title: value,
                          description: _cleaningTaskItem.description,
                          taskDone: _cleaningTaskItem.taskDone,
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: "Nánari lýsing (valfrjálst)...",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        _cleaningTaskItem = CleaningTask(
                          id: _cleaningTaskItem.id,
                          title: _cleaningTaskItem.title,
                          description: value,
                          taskDone: _cleaningTaskItem.taskDone,
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SaveButton(
                      text: _initValues['save-text'],
                      saveFunc: _saveForm,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
