import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/screens/meetings/meetings_screen.dart';

void main() {
  testWidgets('should display main options in meetings section',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MeetingsScreen(),
      ),
    );

    var addMeetingButton = find.text('Bóka fund');
    expect(addMeetingButton, findsOneWidget);

    var viewMeetingsListButton = find.text('Yfirlit funda');
    expect(viewMeetingsListButton, findsOneWidget);
  });
}
