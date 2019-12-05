import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/current_user_provider.dart';
import '../../screens/documents/documents_list_screen.dart';
import '../../models/document.dart';
import '../../providers/documents_provider.dart';
import '../../widgets/custom_icons_icons.dart';
import '../../widgets/save_button.dart';

//ath vantar að setja í android manifest use permission og ios/Runner/Info.plist

class AddDocumentScreen extends StatefulWidget {
  AddDocumentScreen() : super();

  final String title = 'Bæta við skjali';

  static const routeName = '/add-document';

  @override
  _AddDocumentScreenState createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  String _path;
  String _extension;
  FileType _pickType;
  String fileName;
  var _isLoading = false;
  final _form = GlobalKey<FormState>();
  var _newDocument = Document(
    id: null,
    title: "",
    description: "",
    documentItem: " ",
    folderId: "",
  );
  String selectedFolder; //selected folder in dropdownbutton
 
  void _saveForm() async{
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
    try {
    await Provider.of<DocumentsProvider>(context, listen: false)
        .addDocumentItem(_path).then((_) {
        setState(() {
          _isLoading = false;
        });});
    Provider.of<DocumentsProvider>(context, listen: false)
        .addDocument(residentAssociationId, _newDocument);
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DocumentsFolderScreen(id: _newDocument.folderId),
        )
      );
    } catch (e){
      //athuga
      print('Gat ekki sett inn skjal');
    }
  }
 
  void openFileExplorer() async {
    try {
      _path = null;
      _path = await FilePicker.getFilePath(
      type: _pickType, fileExtension: _extension);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final folder = Provider.of<DocumentsProvider>(context, listen: false).getAllFolders();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  width: 100.0,
                  height: 40.0,
                  child: OutlineButton(
                      onPressed: () => openFileExplorer(),
                      child: new Text("Velja skjal"),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              if(fileName != null)
              Expanded(
                child: Text(fileName),  //virkar ekki, myndi vilja að nafnið á file komi fyrir neðan "Velja skjal" takkann þegar búið er að velja það.
              ),
              SizedBox(
                height: 10.0,
              ),
              SingleChildScrollView(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Titill...",
                      prefixIcon: Icon(CustomIcons.pencil),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(
                        top: 25,
                        bottom: 25,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Titill skjals getur ekki verið tómur strengur!";
                      }
                      if (value.length > 40) {
                        return "Titill skjals getur ekki verið meira en 40 stafir á lengd!";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _newDocument = Document(
                        id: _newDocument.id,
                        title: value,
                        description: _newDocument.description,
                        documentItem: _newDocument.documentItem,
                        folderId: _newDocument.folderId,
                      );
                    },
                  ),
                ),
              SizedBox(
                height: 15.0,
              ),
              SingleChildScrollView(
                child: TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Nánari lýsing...",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(
                      top: 25,
                      bottom: 45,
                      left: 20,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.length < 10) {
                      return "Lýsing á skjali þarf að vera a.m.k. 10 stafir á lengd!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _newDocument = Document(
                      id: _newDocument.id,
                      title: _newDocument.title,
                      description: value,
                      documentItem: _newDocument.documentItem,
                      folderId: _newDocument.folderId,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Expanded(
                child: DropdownButtonFormField(
                  hint: Text("Veldu möppu"),
                  value: selectedFolder,
                  onChanged: ((newValue) =>
                    setState(() {
                      print("newValue: " + newValue);
                      selectedFolder = newValue;
                    })
                  ),
                  onSaved: (value) {
                    _newDocument = Document(
                      id: _newDocument.id,
                      title: _newDocument.title,
                      description: _newDocument.description,
                      documentItem: _newDocument.documentItem,
                      folderId: Provider.of<DocumentsProvider>(context, listen: false).findFolderIdByTitle(value),
                    );
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Veldu möppu";
                    }
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
              ),
              SizedBox(
                height: 15.0,
              ),
              Expanded(
                child: _isLoading //virkar ekki
                  ? new Center(
                      // width: 40.0,
                      // height: 30.0,
                      child: CircularProgressIndicator(
                        value: null,
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                        //strokeWidth: 2.0,
                      ),
                    ) : 
                SaveButton(saveFunc: _saveForm, text: "Vista skjal"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
