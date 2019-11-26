import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meeting.dart';

enum MeetingStatus { ahead, old }

class MeetingsProvider with ChangeNotifier {
  List<Meeting> _meetings = [];

  Future<void> fetchMeetings() async {
    DocumentReference meetingRef = Firestore.instance
        .collection('ResidentAssociation')
        .document('09fnlNxhgYk70dMpaRJB');
    try {
      final response =
          await meetingRef.collection('MeetingItems').getDocuments();
      final List<Meeting> loadedMeetings = [];
      response.documents.forEach((meeting) {
        loadedMeetings.add(Meeting(
          id: meeting.documentID,
          title: meeting.data['title'],
          date: DateTime.fromMillisecondsSinceEpoch(meeting.data['date']),
          duration: parseDuration(meeting.data['duration']),
          location: meeting.data['location'],
          description: meeting.data['description'],
        ));
      });
      _meetings = loadedMeetings;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addMeeting(Meeting meeting) async {
    DocumentReference meetingRef = Firestore.instance
        .collection('ResidentAssociation')
        .document('09fnlNxhgYk70dMpaRJB');
    final response = await meetingRef.collection('MeetingItems').add({
      'date': meeting.date.millisecondsSinceEpoch,
      'title': meeting.title,
      'description': meeting.description,
      'location': meeting.location,
      'duration': meeting.duration.toString(),
    });
    final newMeeting = Meeting(
      title: meeting.title,
      date: meeting.date,
      duration: meeting.duration,
      location: meeting.location,
      description: meeting.description,
      id: response.documentID,
    );
    _meetings.add(newMeeting);
    notifyListeners();
  }

  Future<void> deleteMeeting(String id) async {
    DocumentReference meetingRef = Firestore.instance
        .collection('ResidentAssociation')
        .document('09fnlNxhgYk70dMpaRJB');
    final deleteIndex = _meetings.indexWhere((meeting) => meeting.id == id);
    var deletedMeeting = _meetings[deleteIndex];
    _meetings.removeAt(deleteIndex);
    notifyListeners();
    try {
      await meetingRef.collection('MeetingItems').document(id).delete();
      deletedMeeting = null;
    } catch (error) {
      _meetings.insert(deleteIndex, deletedMeeting);
      notifyListeners();
    }
  }

  Meeting findById(String id) {
    return _meetings.firstWhere((meeting) => meeting.id == id);
  }

  Future<void> updateMeeting(String id, Meeting editedMeeting) async {
    DocumentReference meetingRef = Firestore.instance
        .collection('ResidentAssociation')
        .document('09fnlNxhgYk70dMpaRJB');
    await meetingRef.collection('MeetingItems').document(id).updateData({
      'title': editedMeeting.title,
      'date': editedMeeting.date.millisecondsSinceEpoch,
      'duration': editedMeeting.duration.toString(),
      'location': editedMeeting.location,
      'description': editedMeeting.description,
    });
    final meetingIndex = _meetings.indexWhere((meeting) => meeting.id == id);
    if (meetingIndex >= 0) {
      _meetings[meetingIndex] = editedMeeting;
    }
    notifyListeners();
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
    List<Meeting> constructions = [..._meetings];
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

  Duration parseDuration(String durationString) {
    int hours = 0;
    int minutes = 0;

    List<String> parts = durationString.split(':');
    if (parts.length == 3) {
      hours = int.parse(parts[0]);
      minutes = int.parse(parts[1]);
    }
    return Duration(hours: hours, minutes: minutes);
  }
}
