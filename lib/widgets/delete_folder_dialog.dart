import 'package:flutter/material.dart';

import '../models/folder.dart';

class DeleteFolderDialog extends StatefulWidget {
  final Function deleteFunc;
  final List<Folder> folders;

  DeleteFolderDialog({
    @required this.deleteFunc,
    @required this.folders,
  });

  @override
  _DeleteFolderDialogState createState() => _DeleteFolderDialogState();
}

class _DeleteFolderDialogState extends State<DeleteFolderDialog> {
  final _form = GlobalKey<FormState>();
  var _selectedFolder = '';
  var _folderId = '';

  // function which validates and saves the form, and sends the id of the 
  // folder to delete to the widget's delete function.
  void _saveForm(BuildContext context) {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    Navigator.of(context).pop();
    widget.deleteFunc(_folderId);
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
                child: DropdownButtonFormField(
                  value: _selectedFolder != '' ? _selectedFolder : null,
                  hint: Text('Veldu möppu...'),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.folder),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(
                      color: Colors.redAccent[700],
                      fontSize: 12,
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    _selectedFolder = value;
                  }),
                  validator: (value) {
                    if (value == null) {
                      return 'Veldu möppu!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _folderId = value;
                  },
                  items: widget.folders.map((folder) {
                    return DropdownMenuItem(
                      value: folder.id,
                      child: Text(
                        folder.title,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
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
            'EYÐA',
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
