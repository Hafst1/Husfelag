import 'package:flutter/material.dart';

class AddFolderDialog extends StatefulWidget {
  final Function addFunc;

  AddFolderDialog({
    @required this.addFunc,
  });

  @override
  _AddFolderDialogState createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends State<AddFolderDialog> {
  final _form = GlobalKey<FormState>();
  var _folderTitle = '';

  void _saveForm(BuildContext context) {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    Navigator.of(context).pop();
    widget.addFunc(_folderTitle);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 100,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: _form,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Nafn á möppu...',
                    prefixIcon: Icon(Icons.folder_open),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Útvega þarf nafn á möppu!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _folderTitle =
                        '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'HÆTTA VIÐ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            'BÆTA VIÐ',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          onPressed: () => _saveForm(context),
        ),
      ],
    );
  }
}
