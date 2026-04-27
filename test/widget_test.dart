import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dazz_camera_ui/camera_menu_page.dart';
import 'package:dazz_camera_ui/camera_option.dart';
import 'package:dazz_camera_ui/main.dart';

void main() {
  test('app widget can be created', () {
    expect(const DazzPrototypeApp(), isA<Widget>());
  });

  testWidgets('camera menu shows two rows and an apply action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: CameraMenuPage(initialOption: cameraOptions.first)),
    );

    expect(find.byKey(const ValueKey('recording-options-row')), findsOneWidget);
    expect(find.byKey(const ValueKey('capture-options-row')), findsOneWidget);
    expect(find.text('Original'), findsNWidgets(2));
    expect(
      find.byKey(const ValueKey('detail-camera-option-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('apply-camera-option-button')),
      findsOneWidget,
    );
    final applyButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey('apply-camera-option-button')),
    );
    expect(applyButton.onPressed, isNotNull);
    expect(find.text('Apply'), findsOneWidget);
    expect(find.text('Detail'), findsOneWidget);
    expect(find.text('Close'), findsNothing);
    expect(find.textContaining('Choose'), findsNothing);
  });

  testWidgets(
    'all options remain selectable and apply is only enabled for Original',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CameraMenuPage(initialOption: cameraOptions.first)),
      );

      await tester.tap(
        find.byKey(const ValueKey('camera-option-item-sony-handycam-1')),
      );
      await tester.pumpAndSettle();

      final applyButton = tester.widget<FilledButton>(
        find.byKey(const ValueKey('apply-camera-option-button')),
      );
      expect(applyButton.onPressed, isNull);
    },
  );

  testWidgets('detail shows the currently selected option title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: CameraMenuPage(initialOption: cameraOptions.first)),
    );

    await tester.tap(
      find.byKey(const ValueKey('camera-option-item-sony-handycam-1')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('detail-camera-option-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('camera-detail-title')), findsOneWidget);
    expect(find.text('Sony Handycam'), findsWidgets);
  });
}
