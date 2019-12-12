import 'package:flutter_test/flutter_test.dart';

import '../lib/providers/meetings_provider.dart';
import '../lib/models/meeting.dart';

// old meeting 
final meeting1 = Meeting(
  id: 'meeting_id_1',
  title: 'title_1',
  date: DateTime.now().subtract(
    Duration(days: 5),
  ),
  duration: Duration(hours: 2),
  location: 'location_1',
  description: 'description_1',
  authorId: 'author_1',
);

// ahead meeting
final meeting2 = Meeting(
  id: 'meeting_id_2',
  title: 'title_2',
  date: DateTime.now().add(
    Duration(days: 5),
  ),
  duration: Duration(hours: 2),
  location: 'location_2',
  description: 'description_2',
  authorId: 'author_2',
);

void main() {
  group('meetings testing:', () {
    test('should return meeting by id', () {
      final meetingsProvider = MeetingsProvider();
      meetingsProvider.meetings.add(meeting1);
      meetingsProvider.meetings.add(meeting2);
      expect(meetingsProvider.findById('meeting_id_2'), meeting2);
    });

    test('should return old meeting', () {
      final meetingsProvider = MeetingsProvider();
      meetingsProvider.meetings.add(meeting1);
      meetingsProvider.meetings.add(meeting2);
      // 1 is the index for filtering for old meetings
      expect(meetingsProvider.filteredItems('title', 1), [meeting1]);
    });

    test('should return ahead meeting', () {
      final meetingsProvider = MeetingsProvider();
      meetingsProvider.meetings.add(meeting1);
      meetingsProvider.meetings.add(meeting2);
      // 0 is the index for filtering for ahead meetings
      expect(meetingsProvider.filteredItems('title', 0), [meeting2]);
    });

    test('should parse duration string correctly', () {
      final meetingsProvider = MeetingsProvider();
      final stringDuration = '08:33:00.000000';
      expect(meetingsProvider.parseDuration(stringDuration).inHours, 8);
      expect(meetingsProvider.parseDuration(stringDuration).inMinutes, 8*60 + 33);
    });

    test('should return list of all meetings', () {
      final meetingsProvider = MeetingsProvider();
      meetingsProvider.meetings.add(meeting1);
      meetingsProvider.meetings.add(meeting2);
      expect(meetingsProvider.getAllMeetings(), [meeting1, meeting2]);
    });

    test('should return empty list', () {
      expect(MeetingsProvider().meetings, []);
    });
  });
}
