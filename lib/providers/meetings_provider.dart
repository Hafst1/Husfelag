import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/meeting.dart';
import '../shared/constants.dart' as Constants;

enum MeetingStatus { ahead, old }

class MeetingsProvider with ChangeNotifier {
  List<Meeting> _meetings = [];

  // collection reference to the resident associations.
  CollectionReference _associationRef =
      Firestore.instance.collection(Constants.RESIDENT_ASSOCIATIONS_COLLECTION);

  // function which fetches meetings from a resident association and stores
  // them in the _meetings list.
  Future<void> fetchMeetings(
      String residentAssociationId, BuildContext context) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.MEETINGS_COLLECTION)
          .orderBy(Constants.DATE)
          .getDocuments();
      final List<Meeting> loadedMeetings = [];
      response.documents.forEach((meeting) {
        loadedMeetings.add(Meeting(
          id: meeting.documentID,
          title: meeting.data[Constants.TITLE],
          date: DateTime.fromMillisecondsSinceEpoch(meeting.data[Constants.DATE]),
          duration: parseDuration(meeting.data[Constants.DURATION]),
          location: meeting.data[Constants.LOCATION],
          description: meeting.data[Constants.DESCRIPTION],
          authorId: meeting.data[Constants.AUTHOR_ID],
        ));
      });
      _meetings = loadedMeetings;
      notifyListeners();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Villa kom upp'),
          content: Text('Ekki tókst að hlaða upp fundum!'),
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
  }

  // function whichs adds meeting to a resident association.
  Future<void> addMeeting(String residentAssociationId, Meeting meeting) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection(Constants.MEETINGS_COLLECTION)
          .add({
        Constants.TITLE: meeting.title,
        Constants.DATE: meeting.date.millisecondsSinceEpoch,
        Constants.DURATION: meeting.duration.toString(),
        Constants.LOCATION: meeting.location,
        Constants.DESCRIPTION: meeting.description,
        Constants.AUTHOR_ID: meeting.authorId,
      });
      final newMeeting = Meeting(
        title: meeting.title,
        date: meeting.date,
        duration: meeting.duration,
        location: meeting.location,
        description: meeting.description,
        authorId: meeting.authorId,
        id: response.documentID,
      );
      _meetings.add(newMeeting);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // function which deletes a meeting in a resident association.
  Future<void> deleteMeeting(
      String residentAssociationId, String meetingId) async {
    final deleteIndex =
        _meetings.indexWhere((meeting) => meeting.id == meetingId);
    var deletedMeeting = _meetings[deleteIndex];
    _meetings.removeAt(deleteIndex);
    notifyListeners();
    try {
      await _associationRef
          .document(residentAssociationId)
          .collection(Constants.MEETINGS_COLLECTION)
          .document(meetingId)
          .delete();
      deletedMeeting = null;
    } catch (error) {
      _meetings.insert(deleteIndex, deletedMeeting);
      notifyListeners();
    }
  }

  // function whichs returns a meeting which has the id taken in as parameter, if found.
  Meeting findById(String id) {
    return _meetings.firstWhere((meeting) => meeting.id == id);
  }

  // function which updates a meeting in a resident association.
  Future<void> updateMeeting(
      String residentAssociationId, Meeting editedMeeting) async {
    try {
      await _associationRef
          .document(residentAssociationId)
          .collection(Constants.MEETINGS_COLLECTION)
          .document(editedMeeting.id)
          .updateData({
        Constants.TITLE: editedMeeting.title,
        Constants.DATE: editedMeeting.date.millisecondsSinceEpoch,
        Constants.DURATION: editedMeeting.duration.toString(),
        Constants.LOCATION: editedMeeting.location,
        Constants.DESCRIPTION: editedMeeting.description,
        Constants.AUTHOR_ID: editedMeeting.authorId,
      });
      final meetingIndex =
          _meetings.indexWhere((meeting) => meeting.id == editedMeeting.id);
      if (meetingIndex >= 0) {
        final dateOfOldObject = _meetings[meetingIndex].date;
        _meetings[meetingIndex] = editedMeeting;

        // if date has changed the meetings list has to be sorted again.
        if (dateOfOldObject != editedMeeting.date) {
          _meetings.sort((a, b) => a.date.compareTo(b.date));
        }
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // function which filters meetings whether they are ahead or already taken place.
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

  // functions which returns a list of meetings which satisfies the query string and
  // a given status filter (ahead or old).
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

  // function which parses a duration-like string to a Duration.
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

  // function which returns all meeting items.
  List<Meeting> getAllMeetings() {
    return [..._meetings];
  }
}