import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dazz_camera_ui/main.dart';

void main() {
  testWidgets('home page does not overflow on short screens', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(375, 667));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const DazzPrototypeApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const ValueKey('selected-camera-option-title')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('open-camera-menu-button')),
      findsOneWidget,
    );
  });

  testWidgets('camera menu confirm updates the home preview', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DazzPrototypeApp());

    final selectedOptionTitle = find.byKey(
      const ValueKey('selected-camera-option-title'),
    );

    expect(selectedOptionTitle, findsOneWidget);
    expect(tester.widget<Text>(selectedOptionTitle).data, 'Classic');

    await tester.ensureVisible(
      find.byKey(const ValueKey('open-camera-menu-button')),
    );
    await tester.tap(find.byKey(const ValueKey('open-camera-menu-button')));
    await tester.pumpAndSettle();

    expect(find.text('Camera Menu'), findsOneWidget);

    final dazzOption = find.byKey(const ValueKey('camera-option-item-dazz'));
    await tester.tap(dazzOption);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('confirm-camera-option-button')),
      findsOneWidget,
    );
    await tester.tap(
      find.byKey(const ValueKey('confirm-camera-option-button')),
    );
    await tester.pumpAndSettle();

    expect(tester.widget<Text>(selectedOptionTitle).data, 'Dazz');
  });
}
