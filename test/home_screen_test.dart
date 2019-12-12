import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/screens/home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('should display the four main option buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
        ),
      );
      var constructionButton = find.text('Framkvæmdir');
      expect(constructionButton, findsOneWidget);

      var meetingButton = find.text('Fundir');
      expect(meetingButton, findsOneWidget);

      var documentButton = find.text('Skjöl');
      expect(documentButton, findsOneWidget);

      var cleaningButton = find.text('Þrif');
      expect(cleaningButton, findsOneWidget);
  });
}