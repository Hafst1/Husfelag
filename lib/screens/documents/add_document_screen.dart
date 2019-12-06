import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../../shared/loading_spinner.dart';
import '../../providers/current_user_provider.dart';
import '../../screens/documents/documents_list_screen.dart';
import '../../models/document.dart';
import '../../providers/documents_provider.dart';
import '../../widgets/custom_icons_icons.dart';
import '../../widgets/save_button.dart';

//ath vantar að setja í android manifest use permission og ios/Runner/Info.plist

class AddDocumentScreen extends StatefulWidget {
  static const routeName = '/add-document';

  @override
  _AddDocumentScreenState createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  String _path;
  String _extension;
  FileType _pickType;
  String fileName;
  String filePreviewName = "";
  String selectedFolder; //selected folder in dropdownbutton
  final _form = GlobalKey<FormState>();
  var _document = Document(
    id: null,
    title: '',
    description: '',
    fileName: '',
    downloadUrl: '',
    folderId: '',
    authorId: '',
  ); //Document
  var _initValues = {
    'appbar-title': 'Bæta við skjali',
    'title': '',
    'description': '',
    'save-text': 'BÆTA VIÐ',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final documentId =
          ModalRoute.of(context).settings.arguments as String;
      if (documentId != null) {
        _document =
            Provider.of<DocumentsProvider>(context, listen: false)
                .findDocumentById(documentId);
        _initValues = {
          'appbar-title': 'Breyta skjali',
          'title': _document.title,
          'downloadUrl': _document.downloadUrl,
          'description': _document.description,
          'folderId': _document.folderId,
          'save-text': 'BREYTA',
        };
        fileName = _document.fileName;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveForm(String residentAssociationId) async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true; 
    });
    if(_document.id != null) {
      try {
        await Provider.of<DocumentsProvider>(context, listen: false)
            .updateDocument(residentAssociationId, _document);
      } catch (error) {
        await printErrorDialog('Ekki tókst að breyta skjali!');
      }
    } else {
      try {
        await Provider.of<DocumentsProvider>(context, listen: false)
            .addFile(_path, _document);
        await Provider.of<DocumentsProvider>(context, listen: false)
            .addDocument(residentAssociationId, _document);
      } catch (error){
        await printErrorDialog('Ekki tókst að bæta við skjali!');
      }
    }
    setState(() {
      _isLoading = false; 
    });
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DocumentsFolderScreen(id: _document.folderId),
      )
    );
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
 
  void openFileExplorer() async {
    try {
      _path = null;
      _path = await FilePicker.getFilePath(
      type: _pickType, fileExtension: _extension);
      // unique name for a file
      fileName = DateTime.now().toString() + _path.split('/').last;
    } on PlatformException catch (e) {
      print("Óleyfileg aðgerð" + e.toString());
    }
    setState(() {
       filePreviewName =  _path.split('/').last;
    });
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final currentUserData =
        Provider.of<CurrentUserProvider>(context, listen: false);
    final residentAssociationId = currentUserData.getResidentAssociationId();
    final userId = currentUserData.getId();
    final folder = Provider.of<DocumentsProvider>(context, listen: false).getAllFolders();
    return Scaffold(
      appBar: AppBar(
        title: Text(_initValues['appbar-title']),
        centerTitle: true,
        actions: <Widget>[
          Platform.isIOS
              ? IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _saveForm(residentAssociationId);
                  },
                )
              : Container(),
        ],
      ),
      body: _isLoading
          ? LoadingSpinner()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    OutlineButton(
                      onPressed: () => openFileExplorer(),
                      child: new Text("Velja skjal"),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      child: filePreviewName == ""? Container(height: 10,)
                        : Text(filePreviewName,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 15,
                            ),
                          ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        hintText: "Titill...",
                        prefixIcon: Icon(CustomIcons.pencil),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Fylla þarf út titil skjals!";
                        }
                        if (value.length > 40) {
                          return "Titill skjals getur ekki verið meira en 40 stafir á lengd!";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _document = Document(
                          id: _document.id,
                          title: value,
                          description: _document.description,
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
                      height: 15.0,
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Nánari lýsing (valfrjálst)...",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        _document = Document(
                          id: _document.id,
                          title: _document.title,
                          description: value,
                          fileName: _document.fileName,
                          downloadUrl: _document.downloadUrl,
                          folderId: _document.folderId,
                          authorId: _document.authorId,
                        );
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    DropdownButtonFormField(
                      value: selectedFolder,
                      hint: Text("Veldu möppu"),
                      onChanged: ((newValue) =>
                        setState(() {
                          selectedFolder = newValue;
                        })
                      ),
                      onSaved: (value) {
                        _document = Document(
                          id: _document.id,
                          title: _document.title,
                          description: _document.description,
                          fileName: fileName,
                          downloadUrl: _document.downloadUrl,
                          folderId: Provider.of<DocumentsProvider>(context, listen: false).findFolderIdByTitle(value),
                          authorId: _document.authorId,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Veldu möppu";
                        }
                        return null;
                      },
                      items: folder.map((item) {
                        return DropdownMenuItem(
                          value: item.title,
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Platform.isAndroid
                        ? SaveButton(
                            text: _initValues['save-text'],
                            saveFunc: () => _saveForm(residentAssociationId),
                          )
                        : Container(),
                ],
              ),
            ),
          ),
    );
  }
}
