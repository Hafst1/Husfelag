import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart'; 
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
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
  //Map<String, String> _paths;
  String _extension;
  FileType _pickType;
  //bool _multiPick = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  var _newDocument = Document(
    id: "5",
    title: "",
    description: "",
    documentItem: File(''),
    folderId: "2",
  );
 
  void _saveForm() {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    Provider.of<DocumentsProvider>(context, listen: false)
        .addDocument(_newDocument);
    Navigator.of(context).pop();
  }

  void openFileExplorer() async {
    try {
      _path = null;
      _path = await FilePicker.getFilePath(
      type: _pickType, fileExtension: _extension);
      print("path: " + _path);
      uploadToFirebase();
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
  }
 
  uploadToFirebase() {
    String fileName = _path.split('/').last;
    String filePath = _path;
    upload(fileName, filePath);
  }
 
  upload(fileName, filePath) {
    _extension = fileName.toString().split('.').last;
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask uploadTask = storageRef.putFile(
      File(filePath),
      StorageMetadata(
        contentType: '$_pickType/$_extension',
      ),
    );
    setState(() {
      _tasks.add(uploadTask);
    });
  }

  dropDown() {
    return DropdownButton(
      hint: new Text('Select'),
      value: _pickType,
      items: <DropdownMenuItem>[
        new DropdownMenuItem(
          child: new Text('Audio'),
          value: FileType.AUDIO,
        ),
        new DropdownMenuItem(
          child: new Text('Image'),
          value: FileType.IMAGE,
        ),
        new DropdownMenuItem(
          child: new Text('Video'),
          value: FileType.VIDEO,
        ),
        new DropdownMenuItem(
          child: new Text('Any'),
          value: FileType.ANY,
        ),
      ],
      onChanged: (value) => setState(() {
            _pickType = value;
          }),
    );
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }
 
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    _tasks.forEach((StorageUploadTask task) {
      final Widget tile = UploadTaskListTile(
        task: task,
        onDismissed: () => setState(() => _tasks.remove(task)),
        onDownload: () => downloadFile(task.lastSnapshot.ref),
      );
      children.add(tile);
    });
 
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text(widget.title),
        ),
        body: Form(
          key: _form,
          child:Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
               // dropDown(),
                OutlineButton(
                  onPressed: () => openFileExplorer(),
                  child: new Text("Velja skjal"),
                ),
                Expanded(
                  child: ListView(
                    children: children,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Titill...",
                      prefixIcon: Icon(CustomIcons.pencil),
                      border: OutlineInputBorder(),
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
                Expanded(
                  child: TextFormField(
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Nánari lýsing...",
                      border: OutlineInputBorder(),
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
                SaveButton(saveFunc: _saveForm, text: "Vista skjal"),
              ],
            ),
          ),
        ),
      );
  }
 
  Future<void> downloadFile(StorageReference ref) async {
    final String url = await ref.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/tmp.jpg');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task.future).totalByteCount;
    var bodyBytes = downloadData.bodyBytes;
    final String name = await ref.getName();
    final String path = await ref.getPath();
    print(
      'Success!\nDownloaded $name \nUrl: $url'
      '\npath: $path \nBytes Count :: $byteCount',
    );
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Image.memory(
          bodyBytes,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
 
class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);
 
  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;
 
  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }
 
  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }
 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status: ${_bytesTransferred(snapshot)} bytes sent');
        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('Hleður niður #${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
