import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/screens/authenticate/sign_in.dart';

void main() {
  testWidgets('should display appropriate error messages on wrong input',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SignIn(),
      ),
    );

    var button = find.text('SKRÁ INN');
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump();

    expect(find.text('Sláðu inn netfang'), findsOneWidget);
    expect(
        find.text('Lykilorð þarf að vera að minnsta kosti 6 stafir á lengd!'),
        findsOneWidget);
  });

  testWidgets('should display no error messages validated input',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SignIn(),
      ),
    );
    var textFormFields = find.byType(TextFormField);
    expect(textFormFields, findsNWidgets(2));

    var emailTextField = textFormFields.at(0);
    var passwordTextField = textFormFields.at(1);

    await tester.enterText(emailTextField, 'siggi@simnet.is');
    await tester.enterText(passwordTextField, 'test1234');
    expect(find.text('siggi@simnet.is'), findsOneWidget);
    expect(find.text('test1234'), findsOneWidget);

    var button = find.text('SKRÁ INN');
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump();

    expect(find.text('Sláðu inn netfang'), findsNothing);
    expect(
        find.text('Lykilorð þarf að vera að minnsta kosti 6 stafir á lengd!'),
        findsNothing);
  });
}
