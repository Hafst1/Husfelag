import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meeting.dart';

enum MeetingStatus { ahead, old }

class MeetingsProvider with ChangeNotifier {
  List<Meeting> _meetings = [];

  // collection reference to the resident associations.
  CollectionReference _associationRef =
      Firestore.instance.collection('ResidentAssociation');

  // function which fetches meetings from a resident association and stores
  // them in the _meetings list.
  Future<void> fetchMeetings(
      String residentAssociationId, BuildContext context) async {
    try {
      final response = await _associationRef
          .document(residentAssociationId)
          .collection('MeetingItems')
          .orderBy('date')
          .getDocuments();
      final List<Meeting> loadedMeetings = [];
      response.documents.forEach((meeting) {
        loadedMeetings.add(Meeting(
          id: meeting.documentID,
          title: meeting.data['title'],
          date: DateTime.fromMillisecondsSinceEpoch(meeting.data['date']),
          duration: parseDuration(meeting.data['duration']),
          location: meeting.data['location'],
          description: meeting.data['description'],
          authorId: meeting.data['authorId'],
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
          .collection('MeetingItems')
          .add({
        'title': meeting.title,
        'date': meeting.date.millisecondsSinceEpoch,
        'duration': meeting.duration.toString(),
        'location': meeting.location,
        'description': meeting.description,
        'authorId': meeting.authorId,
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
          .collection('MeetingItems')
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
          .collection('MeetingItems')
          .document(editedMeeting.id)
          .updateData({
        'title': editedMeeting.title,
        'date': editedMeeting.date.millisecondsSinceEpoch,
        'duration': editedMeeting.duration.toString(),
        'location': editedMeeting.location,
        'description': editedMeeting.description,
        'authorId': editedMeeting.authorId,
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

  Map<DateTime, List> mergeMeetingsAndConstructions(
      Map<DateTime, List> constructions) {
    List<Meeting> meetings = [..._meetings];
    String stringDate = '';
    String newTimeForMeetings = '';
    String hoursMinutesSecond = "00:00:00";
    if (meetings == []) {
      return null;
    } else {
      meetings.forEach((item) {
        stringDate = item.date.toString().substring(0, 11) + hoursMinutesSecond;
        DateTime newDate = DateTime.parse(stringDate);
        print(item.date);
        newTimeForMeetings =
            "Klukkan: " + item.date.toString().substring(12, 16);
        if (constructions.containsKey(newDate)) {
          constructions[newDate].add(
            ["Fundur:    ", item.title, item.description, newTimeForMeetings],
          );
        } else {
          constructions[newDate] = [
            ["Fundur:    ", item.title, item.description, newTimeForMeetings],
          ];
        }
        return constructions;
      });
      return constructions;
    }
  }
}
