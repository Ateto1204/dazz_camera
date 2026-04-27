import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dazz_camera_ui/camera_menu_page.dart';
import 'package:dazz_camera_ui/camera_option.dart';
import 'package:dazz_camera_ui/main.dart';

class _MenuNavigationHarness extends StatefulWidget {
  const _MenuNavigationHarness();

  @override
  State<_MenuNavigationHarness> createState() => _MenuNavigationHarnessState();
}

class _MenuNavigationHarnessState extends State<_MenuNavigationHarness> {
  CameraOption _selectedOption = cameraOptions.first;

  Future<void> _openMenu() async {
    final result = await Navigator.of(context).push<CameraOption>(
      MaterialPageRoute(
        builder: (_) => CameraMenuPage(initialOption: _selectedOption),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedOption = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_selectedOption.title, key: const ValueKey('selected-title')),
            const SizedBox(height: 12),
            ElevatedButton(
              key: const ValueKey('open-menu-button'),
              onPressed: _openMenu,
              child: const Text('Open Menu'),
            ),
          ],
        ),
      ),
    );
  }
}

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
    expect(find.text('Camera Detail'), findsOneWidget);
    expect(find.text('Sony Handycam'), findsWidgets);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Features'), findsOneWidget);
    expect(find.text('Best For'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
  });

  testWidgets(
    'camera menu can return to the previous page with back and apply',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: _MenuNavigationHarness()),
      );

      expect(find.byKey(const ValueKey('open-menu-button')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('open-menu-button')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('recording-options-row')),
        findsOneWidget,
      );

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('open-menu-button')), findsOneWidget);
      expect(find.byKey(const ValueKey('selected-title')), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('selected-title'))).data,
        'Original',
      );

      await tester.tap(find.byKey(const ValueKey('open-menu-button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('apply-camera-option-button')),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('open-menu-button')), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('selected-title'))).data,
        'Original',
      );
    },
  );

  testWidgets('detail page back returns to camera menu page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: _MenuNavigationHarness()));

    await tester.tap(find.byKey(const ValueKey('open-menu-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('detail-camera-option-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('camera-detail-title')), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('recording-options-row')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('detail-camera-option-button')),
      findsOneWidget,
    );
  });
}
