import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

import '../../shared/loading_spinner.dart';
import '../../providers/current_user_provider.dart';
import '../../models/document.dart';
import '../../providers/documents_provider.dart';
import '../../widgets/custom_icons_icons.dart';
import '../../widgets/save_button.dart';

class AddDocumentScreen extends StatefulWidget {
  static const routeName = '/add-document';

  @override
  _AddDocumentScreenState createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  final _form = GlobalKey<FormState>();
  var _oldFolderId = '';
  var _path;
  var _errorMessage = '';
  var _document = Document(
    id: null,
    title: '',
    fileName: '',
    downloadUrl: '',
    folderId: '',
    authorId: '',
  );
  var _initValues = {
    'appbar-title': 'Bæta við skjali',
    'title': '',
    'selected-folder': '',
    'filePreviewName': '',
    'save-text': 'BÆTA VIÐ',
  };
  var _isInit = true;
  var _isLoading = false;

  // get document to edit if document id was passed through arguments.
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final documentId = ModalRoute.of(context).settings.arguments as String;
      final documentData = Provider.of<DocumentsProvider>(context);
      if (documentId != null) {
        _document = documentData.findDocumentById(documentId);
        _initValues = {
          'appbar-title': 'Breyta skjali',
          'title': _document.title,
          'selected-folder': _document.folderId,
          'filePreviewName': _document.fileName,
          'save-text': 'BREYTA',
        };
        _oldFolderId = _document.folderId;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // functions which saves the form of a new file and either updates a file
  // or adds a new one.
  void _saveForm(String residentAssociationId) async {
    var isValid = _form.currentState.validate();
    if (!isValid || _document.fileName.isEmpty) {
      if (_document.fileName.isEmpty) {
        setState(() {
          _errorMessage = 'Ekki er búið að velja skjal til að bæta við!';
        });
      }
      return;
    }
    _form.currentState.save();
    final documentData = Provider.of<DocumentsProvider>(context);
    setState(() {
      _isLoading = true;
    });
    if (_document.id != null) {
      try {
        await documentData.updateDocument(
            residentAssociationId, _document, _oldFolderId);
      } catch (error) {
        await _printErrorDialog('Ekki tókst að uppfæra skjal!');
      }
    } else {
      try {
        final uniqueFileName =
            DateTime.now().toString() + '!!' + _document.fileName;
        final downloadUrl =
            await documentData.getDownloadUrl(_path, uniqueFileName);
        if (downloadUrl == '') {
          await _printErrorDialog('Ekki tókst að hlaða upp skjali!');
        }
        await documentData.addDocument(
            residentAssociationId,
            Document(
              id: _document.id,
              title: _document.title,
              fileName: uniqueFileName,
              downloadUrl: downloadUrl,
              folderId: _document.folderId,
              authorId: _document.authorId,
            ));
      } catch (error) {
        await _printErrorDialog('Ekki tókst að bæta við skjali!');
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  // function which prints an error dialog.
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

  // function which opens a file explorer and chooses a file. It provides
  // a path to the file which is to be added.
  void openFileExplorer() async {
    try {
      _path = await FilePicker.getFilePath();
      final fileName = _path.split('/').last;
      setState(() {
        _document = Document(
          id: _document.id,
          title: _document.id,
          fileName: fileName,
          downloadUrl: _document.downloadUrl,
          folderId: _document.id,
          authorId: _document.authorId,
        );
        _initValues['filePreviewName'] = fileName;
      });
    } on PlatformException catch (e) {
      await _printErrorDialog('Óleyfileg aðgerð: ' + e.toString());
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final currentUserData = Provider.of<CurrentUserProvider>(context);
    final residentAssociationId = currentUserData.getResidentAssociationId();
    final userId = currentUserData.getId();
    final documentData = Provider.of<DocumentsProvider>(context);
    final folders = documentData.getAllFolders();
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text(_initValues['appbar-title']),
      centerTitle: true,
      actions: <Widget>[
        platform == TargetPlatform.iOS
            ? IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _saveForm(residentAssociationId);
                },
              )
            : Container(),
      ],
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? LoadingSpinner()
          : Container(
              height: heightOfBody,
              color: Color.fromRGBO(230, 230, 230, 1),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _document.id != null
                          ? Container()
                          : Column(
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () => openFileExplorer(),
                                  child: Text('Velja skjal'),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: _initValues['filePreviewName'] == ''
                                      ? _errorMessage == ''
                                          ? Container(
                                              height: 10,
                                            )
                                          : Center(
                                              child: Text(
                                                _errorMessage,
                                                style: TextStyle(
                                                  color: Colors.redAccent[700],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                      : Center(
                                          child: Text(
                                            _initValues['filePreviewName'],
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 15,
                                              height: 1.25,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          hintText: 'Titill...',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(CustomIcons.pencil),
                          errorStyle: TextStyle(
                            color: Colors.redAccent[700],
                            fontSize: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Fylla þarf út titil skjals!';
                          }
                          if (value.length > 40) {
                            return 'Titill skjals getur ekki verið meira en 40 stafir á lengd!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _document = Document(
                            id: _document.id,
                            title: value,
                            fileName: _document.fileName,
                            downloadUrl: _document.downloadUrl,
                            folderId: _document.folderId,
                            authorId: _document.authorId != ''
                                ? _document.authorId
                                : userId,
                          );
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      DropdownButtonFormField(
                        value: _initValues['selected-folder'] != ''
                            ? _initValues['selected-folder']
                            : null,
                        hint: Text('Veldu möppu...'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.folder),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: TextStyle(
                            color: Colors.redAccent[700],
                            fontSize: 12,
                          ),
                        ),
                        onChanged: (value) => setState(() {
                          _initValues['selected-folder'] = value;
                        }),
                        validator: (value) {
                          if (value == null) {
                            return 'Veldu möppu!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _document = Document(
                            id: _document.id,
                            title: _document.title,
                            fileName: _document.fileName,
                            downloadUrl: _document.downloadUrl,
                            folderId: value,
                            authorId: _document.authorId,
                          );
                        },
                        items: folders.map((folder) {
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
                      SizedBox(
                        height: 25.0,
                      ),
                      platform == TargetPlatform.android
                          ? SaveButton(
                              text: _initValues['save-text'],
                              saveFunc: () => _saveForm(residentAssociationId),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
