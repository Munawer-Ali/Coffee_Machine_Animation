// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:coffee_animation/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Coffee Animation App', () {
    testWidgets('should build app without crashing',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that the app builds successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should display coffee app title', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that the app title is displayed
      expect(find.text('Caramel Frappuccino'), findsOneWidget);
    });

    testWidgets('should display theme toggle button',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that the theme toggle button is present
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('should display shopping cart icon',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that the shopping cart icon is present
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('should display back button', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that the back button is present
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });

    testWidgets('should toggle theme when theme button is tapped',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Find the theme toggle button
      final themeButton = find.byIcon(Icons.dark_mode);
      expect(themeButton, findsOneWidget);

      // Tap the theme toggle button
      await tester.tap(themeButton);
      await tester.pump();

      // Verify that the icon changed to light mode
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode), findsNothing);
    });

    testWidgets('should have proper app structure',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify the main structural elements
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should display coffee machine widget',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that coffee machine related widgets are present
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should handle app initialization',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Wait for any async operations to complete
      await tester.pumpAndSettle();

      // Verify that the app is fully loaded
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should have proper theme configuration',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Get the MaterialApp widget
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      // Verify that theme is properly configured
      expect(materialApp.theme, isNotNull);
      expect(materialApp.title, 'Coffee Animation');
    });

    testWidgets('should display quantity selector',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Wait for the app to fully load
      await tester.pumpAndSettle();

      // Look for quantity-related UI elements
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display action button', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Wait for the app to fully load
      await tester.pumpAndSettle();

      // Look for the main action button (should contain "Fill" text initially)
      expect(find.textContaining('Fill'), findsOneWidget);
    });

    group('Responsive Design', () {
      testWidgets('should handle different screen sizes',
          (WidgetTester tester) async {
        // Set a specific screen size
        await tester.binding.setSurfaceSize(const Size(400, 800));

        // Build our app and trigger a frame.
        await tester.pumpWidget(const MyApp());

        // Verify that the app renders correctly
        expect(find.byType(MaterialApp), findsOneWidget);

        // Reset to default size
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('should handle tablet size', (WidgetTester tester) async {
        // Set a tablet screen size
        await tester.binding.setSurfaceSize(const Size(800, 1200));

        // Build our app and trigger a frame.
        await tester.pumpWidget(const MyApp());

        // Verify that the app renders correctly
        expect(find.byType(MaterialApp), findsOneWidget);

        // Reset to default size
        await tester.binding.setSurfaceSize(null);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle widget disposal gracefully',
          (WidgetTester tester) async {
        // Build our app and trigger a frame.
        await tester.pumpWidget(const MyApp());

        // Verify initial state
        expect(find.byType(MaterialApp), findsOneWidget);

        // Dispose the widget by building a different widget
        await tester.pumpWidget(Container());

        // Verify that disposal happened without errors
        expect(find.byType(MaterialApp), findsNothing);
      });
    });
  });
}
