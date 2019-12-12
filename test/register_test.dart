import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/screens/authenticate/register.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('register form testing:', () {
    testWidgets('should display error messages on no input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Register(),
        ),
      );

      var button = find.text('STOFNA AÐGANG');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(find.text('Sláðu inn fullt nafn'), findsOneWidget);
      expect(find.text('Sláðu inn netfang'), findsOneWidget);
      expect(
          find.text('Lykilorð þarf að vera að minnsta kosti 6 stafir á lengd!'),
          findsOneWidget);
    });

    testWidgets('should not display error messages on valid input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Register(),
        ),
      );

      var textFields = find.byType(TextFormField);
      expect(textFields, findsNWidgets(3));

      var nameField = textFields.at(0);
      var emailField = textFields.at(1);
      var passwordField = textFields.at(2);

      await tester.enterText(nameField, 'Sigurður Halldórsson');
      await tester.enterText(emailField, 'siggi@simnet.is');
      await tester.enterText(passwordField, 'test1234');

      var button = find.text('STOFNA AÐGANG');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(find.text('Sláðu inn fullt nafn'), findsNothing);
      expect(find.text('Sláðu inn netfang'), findsNothing);
      expect(
          find.text('Lykilorð þarf að vera að minnsta kosti 6 stafir á lengd!'),
          findsNothing);
    });

    testWidgets('should display error messages on invalid input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Register(),
        ),
      );

      var textFields = find.byType(TextFormField);
      expect(textFields, findsNWidgets(3));

      var nameField = textFields.at(0);
      var emailField = textFields.at(1);
      var passwordField = textFields.at(2);

      await tester.enterText(
          nameField, 'Sigurður Hallgrímur Þorgrímsson Johnson Pedersen');
      await tester.enterText(emailField, 'siggisimnet.is');
      await tester.enterText(passwordField, '12345');

      var button = find.text('STOFNA AÐGANG');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(
        find.text('Nafn getur ekki verið meira en 45 stafir á lengd!'),
        findsOneWidget,
      );
      expect(
        find.text('Vinsamlegast fylltu út gilt netfang!'),
        findsOneWidget,
      );
      expect(
        find.text('Lykilorð þarf að vera að minnsta kosti 6 stafir á lengd!'),
        findsOneWidget,
      );
    });
  });
}
