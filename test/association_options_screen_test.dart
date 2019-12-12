import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/screens/association_registration/association_options_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('should display the four main option buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AssociationOptionsScreen(),
      ),
    );

    var createAssociationButton = find.text('Stofna húsfélag');
    expect(createAssociationButton, findsOneWidget);

    var joinAssociationButton = find.text('Ganga í húsfélag');
    expect(joinAssociationButton, findsOneWidget);
  });
}
