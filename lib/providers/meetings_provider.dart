import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meeting.dart';
import '../services/api.dart';
enum MeetingStatus { ahead, old }

class MeetingsProvider with ChangeNotifier {
  Api _api = new Api("MeetingItems");

  List<Meeting> _meetingItems;
  QuerySnapshot meetings;

  Future<List<Meeting>> fetchProducts() async {
    var result = await _api.getDataCollection();
    _meetingItems = result.documents
        .map((doc) => Meeting.fromMap(doc.data, doc.documentID))
        .toList();
    return _meetingItems;
  }

  Stream<QuerySnapshot> fetchProductsAsStream() {
    return _api.streamDataCollection();
  }

  Future<Meeting> getProductById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Meeting.fromMap(doc.data, doc.documentID) ;
  }


  Future removeProduct(String id) async{
     await _api.removeDocument(id) ;
     return ;
  }
  Future updateProduct(Meeting data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addProduct(Meeting data) async{
    var result  = await _api.addDocument(data.toJson()) ;

    return ;

  }

  List<Meeting> get items {
    return [..._meetingItems];
  }

  bool _meetingStatusFilter(int filterIndex, DateTime date) {
    MeetingStatus status = MeetingStatus.values[filterIndex];
    DateTime currentDate = DateTime.now();
    switch (status) {
      case MeetingStatus.ahead:
        return date.isAfter(currentDate);
      case MeetingStatus.old:
        return date.isBefore(currentDate);
      default:
        return true;
    }
  }

  List<Meeting> filteredItems(String query, int filterIndex) {
    List<Meeting> constructions = [..._meetingItems];
    String searchQuery = query.toLowerCase();
    List<Meeting> displayList = [];
    if (query.isNotEmpty) {
      constructions.forEach((item) {
        if (item.title.toLowerCase().contains(searchQuery) &&
            _meetingStatusFilter(
              filterIndex,
              item.date,
            )) {
          displayList.add(item);
        }
      });
    } else {
      constructions.forEach((item) {
        if (_meetingStatusFilter(
          filterIndex,
          item.date,
        )) {
          displayList.add(item);
        }
      });
    }
    return displayList;
  }

  void addMeeting(Meeting meeting) {
    final newMeeting = Meeting(
      title: meeting.title,
      date: meeting.date,
      duration: meeting.duration,
      location: meeting.location,
      description: meeting.description,
      id: DateTime.now().toString(),
    );
    _meetingItems.add(newMeeting);
    notifyListeners();

    //add to Firebase
    DocumentReference meetingRef = Firestore.instance
        .collection("ResidentAssociation")
        .document("09fnlNxhgYk70dMpaRJB");
     meetingRef.collection("MeetingItems").add({
      'date:': meeting.date,
      'title:': meeting.title,
      'description:': meeting.description,
      'location:': meeting.location,
      'duration' : meeting.duration.toString()
    });
  }

  void deleteMeeting(String id) {
    _meetingItems.removeWhere((meeting) => meeting.id == id);
    notifyListeners();
  }
}
