import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:truxify_driver/core/app_routes.dart';
import 'package:truxify_driver/screens/destination_picker_screen.dart';
import 'package:truxify_driver/screens/shell_screen.dart';
import 'package:truxify_driver/theme/app_theme.dart';

Widget _buildTestApp() {
  return MaterialApp(
    theme: TruxifyTheme.light(),
    home: const ShellScreen(),
    onGenerateRoute: (settings) {
      if (settings.name == AppRoutes.destinationPicker) {
        final args = settings.arguments as DestinationPickerArgs?;
        return MaterialPageRoute<void>(
          builder: (_) => DestinationPickerScreen(
            title: args?.title ?? 'Select Destination',
            initialQuery: args?.initialQuery,
            initialPoint: args?.initialPoint,
          ),
        );
      }

      return MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: SizedBox.shrink()),
      );
    },
  );
}

void main() {
  testWidgets('driver home shows a compact search bar and stats cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());

    await tester.pumpAndSettle();

    expect(find.text('Where to?'), findsOneWidget);
    expect(find.text('Profit earned'), findsOneWidget);
    expect(find.text('Since last trip'), findsOneWidget);
  });

  testWidgets('driver home expands search and opens the destination picker', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());

    await tester.pumpAndSettle();

    final destinationTile = find.text('Where to?').first;
    await tester.tap(destinationTile);
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Where are you going?'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Surat');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('Search area, landmark, or city'), findsOneWidget);
    expect(find.text('Confirm Destination'), findsOneWidget);
  });
}
