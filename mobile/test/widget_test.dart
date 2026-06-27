import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:reverseagecode_onboarding/main.dart';

void main() {
  testWidgets('onboarding screen shows step 1 fields', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('About you'), findsOneWidget);
    expect(find.text('STEP 1 OF 3'), findsOneWidget);
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('next button is disabled until the form is valid', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    ElevatedButton nextButton() => tester.widget(find.widgetWithText(ElevatedButton, 'Next'));

    expect(nextButton().onPressed, isNull);

    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(find.byType(TextFormField).at(1), '70');
    await tester.pump();

    expect(nextButton().onPressed, isNull);
  });

  const deviceSizes = {
    'small Android (e.g. Galaxy A series)': Size(360, 640),
    'large Android (Pixel 7)': Size(412, 915),
    'iPhone SE': Size(375, 667),
    'iPhone 14/15 Pro Max': Size(430, 932),
  };

  for (final entry in deviceSizes.entries) {
    testWidgets('renders without overflow on ${entry.key}', (tester) async {
      tester.view.physicalSize = entry.value;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('About you'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });
  }
}
