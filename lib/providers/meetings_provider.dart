import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meeting.dart';

enum MeetingStatus { ahead, old }

class MeetingsProvider with ChangeNotifier {
  List<Meeting> _dummyData = [
    Meeting(
      id: "firebasekey1",
      title: "Árlegur húsfundur",
      date: DateTime.now().add(Duration(days: 4)),
      duration: Duration(hours: 2),
      location: "Egilshöll",
      description: "",
    ),
    Meeting(
      id: "firebasekey2",
      title: "Neyðarfundur",
      date: DateTime.now(),
      duration: Duration(hours: 1),
      location: "Egilshöll",
      description: "",
    ),
    Meeting(
      id: "firebasekey3",
      title: "Fundað um húsið",
      date: DateTime.now().add(Duration(days: 4)),
      duration: Duration(hours: 2),
      location: "Egilshöll",
      description: "",
    ),
    Meeting(
      id: "firebasekey4",
      title: "Stórfundur",
      date: DateTime.now(),
      duration: Duration(hours: 1),
      location: "Egilshöll",
      description: "",
    ),
    Meeting(
      id: "firebasekey5",
      title: "Fundur",
      date: DateTime.now().add(Duration(days: 4)),
      duration: Duration(hours: 2),
      location: "Egilshöll",
      description: "",
    ),
    Meeting(
      id: "firebasekey6",
      title: "Örfundur",
      date: DateTime.now(),
      duration: Duration(hours: 1),
      location: "Egilshöll",
      description: "",
    ),
  ];

  List<Meeting> get items {
    return [..._dummyData];
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
    List<Meeting> constructions = [..._dummyData];
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
    _dummyData.add(newMeeting);
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
    _dummyData.removeWhere((meeting) => meeting.id == id);
    notifyListeners();
  }
}
