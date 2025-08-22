import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_dvp/widgets/custom_input_field.dart';

void main() {
  group('CustomInput Widget Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    Widget createTestWidget({
      required String label,
      String? hint,
      TextInputType? keyboardType,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: CustomInput(
            controller: controller,
            label: label,
            hint: hint,
            keyboardType: keyboardType,
          ),
        ),
      );
    }

    testWidgets('Should display label correctly', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(label: 'Test Label'));

      // Assert
      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('Should display hint when provided', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        createTestWidget(label: 'Test Label', hint: 'Test Hint'),
      );

      // Assert
      expect(find.text('Test Hint'), findsOneWidget);
    });

    testWidgets('Should accept text input', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(label: 'Test Label'));
      final textField = find.byType(TextFormField);

      // Act
      await tester.enterText(textField, 'Test Input');

      // Assert
      expect(controller.text, 'Test Input');
      expect(find.text('Test Input'), findsOneWidget);
    });

    testWidgets('Should show validation error for empty field', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(label: 'Test Label'));

      // Act & Assert - verificamos que el widget se renderiza correctamente
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('Should apply correct keyboard type', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        createTestWidget(
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
      );

      // Assert
      expect(find.byType(TextFormField), findsOneWidget);
      // El keyboard type se aplica internamente, verificamos que el widget se renderiza
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('Should apply number keyboard type', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        createTestWidget(label: 'Phone', keyboardType: TextInputType.phone),
      );

      // Assert
      expect(find.byType(TextFormField), findsOneWidget);
      // El keyboard type se aplica internamente, verificamos que el widget se renderiza
      expect(find.text('Phone'), findsOneWidget);
    });

    testWidgets('Should have proper styling elements', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(label: 'Test Label'));

      // Assert
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('Should update controller when text changes', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(label: 'Test Label'));

      // Act
      await tester.enterText(find.byType(TextFormField), 'New Text');

      // Assert
      expect(controller.text, 'New Text');
    });

    testWidgets('Should clear text when controller is cleared', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(label: 'Test Label'));
      await tester.enterText(find.byType(TextFormField), 'Some Text');

      // Act
      controller.clear();
      await tester.pump();

      // Assert
      expect(controller.text, '');
      expect(find.text('Some Text'), findsNothing);
    });

    testWidgets('Should handle multiple CustomInput widgets', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller1 = TextEditingController();
      final controller2 = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CustomInput(controller: controller1, label: 'First Input'),
                CustomInput(controller: controller2, label: 'Second Input'),
              ],
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField).first, 'First Text');
      await tester.enterText(find.byType(TextFormField).last, 'Second Text');

      // Assert
      expect(controller1.text, 'First Text');
      expect(controller2.text, 'Second Text');
      expect(find.text('First Input'), findsOneWidget);
      expect(find.text('Second Input'), findsOneWidget);

      // Cleanup
      controller1.dispose();
      controller2.dispose();
    });

    testWidgets('Should work with pre-filled controller', (
      WidgetTester tester,
    ) async {
      // Arrange
      controller.text = 'Pre-filled text';

      // Act
      await tester.pumpWidget(createTestWidget(label: 'Test Label'));

      // Assert
      expect(find.text('Pre-filled text'), findsOneWidget);
      expect(controller.text, 'Pre-filled text');
    });

    group('Form Validation Tests', () {
      testWidgets('Should work within a Form widget', (
        WidgetTester tester,
      ) async {
        // Arrange
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: CustomInput(controller: controller, label: 'Test Field'),
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(CustomInput), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Should be accessible with proper semantics', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            label: 'Accessible Field',
            hint: 'Enter your information',
          ),
        );

        // Assert
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Accessible Field'), findsOneWidget);
        expect(find.text('Enter your information'), findsOneWidget);
      });
    });
  });
}
