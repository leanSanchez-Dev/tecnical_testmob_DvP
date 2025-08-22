import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_dvp/screens/user/user_profile_screen.dart';
import 'package:flutter_app_dvp/providers/user_provider.dart';
import 'package:flutter_app_dvp/models/user_model.dart';
import 'package:flutter_app_dvp/models/address_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('UserProfileScreen Tests', () {
    late UserProvider userProvider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      userProvider = UserProvider();
    });

    Widget createTestWidget({User? user}) {
      if (user != null) {
        userProvider.createUser(user);
      }

      return ChangeNotifierProvider<UserProvider>.value(
        value: userProvider,
        child: const MaterialApp(home: UserProfileScreen()),
      );
    }

    testWidgets('Should show no user message when user is null', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('No hay datos del usuario.'), findsOneWidget);
    });

    testWidgets('Should display user information correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final user = User(
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 5, 15),
      );

      // Act
      await tester.pumpWidget(createTestWidget(user: user));

      // Assert
      expect(find.text('Juan Pérez'), findsOneWidget);
      expect(find.text('Fecha de Nac: 5/15/1990'), findsOneWidget);
    });

    testWidgets('Should display addresses when user has addresses', (
      WidgetTester tester,
    ) async {
      // Arrange
      final addresses = [
        Address(
          street: 'Calle 123 # 45-67',
          city: 'Medellín',
          state: 'Antioquia',
          zipCode: '050001',
        ),
        Address(
          street: 'Carrera 456 # 78-90',
          city: 'Bogotá',
          state: 'Cundinamarca',
          zipCode: '110111',
        ),
      ];

      final user = User(
        firstName: 'María',
        lastName: 'García',
        birthDate: DateTime(1985, 12, 25),
        addresses: addresses,
      );

      // Act
      await tester.pumpWidget(createTestWidget(user: user));

      // Assert
      expect(find.text('Calle 123 # 45-67'), findsOneWidget);
      expect(find.text('Medellín, Antioquia- (050001)'), findsOneWidget);
      expect(find.text('Carrera 456 # 78-90'), findsOneWidget);
      expect(find.text('Bogotá, Cundinamarca- (110111)'), findsOneWidget);
    });

    testWidgets('Should show no addresses message when user has no addresses', (
      WidgetTester tester,
    ) async {
      // Arrange
      final user = User(
        firstName: 'Carlos',
        lastName: 'López',
        birthDate: DateTime(1988, 3, 10),
      );

      // Act
      await tester.pumpWidget(createTestWidget(user: user));

      // Assert
      expect(find.text('No hay direcciones registradas.'), findsOneWidget);
    });

    testWidgets('Should display edit buttons', (WidgetTester tester) async {
      // Arrange
      final user = User(
        firstName: 'Ana',
        lastName: 'Rodríguez',
        birthDate: DateTime(1992, 8, 20),
      );

      // Act
      await tester.pumpWidget(createTestWidget(user: user));

      // Assert
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.byIcon(Icons.add_location_alt_outlined), findsOneWidget);
    });

    testWidgets('Should display delete buttons for addresses', (
      WidgetTester tester,
    ) async {
      // Arrange
      final address = Address(
        street: 'Calle Test',
        city: 'Ciudad Test',
        state: 'Estado Test',
        zipCode: '12345',
      );

      final user = User(
        firstName: 'Usuario',
        lastName: 'Test',
        birthDate: DateTime(1990, 1, 1),
        addresses: [address],
      );

      // Act
      await tester.pumpWidget(createTestWidget(user: user));

      // Assert
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets(
      'Should show delete confirmation dialog when delete button is tapped',
      (WidgetTester tester) async {
        // Arrange
        final address = Address(
          street: 'Calle Para Eliminar',
          city: 'Ciudad',
          state: 'Estado',
          zipCode: '12345',
        );

        final user = User(
          firstName: 'Usuario',
          lastName: 'Test',
          birthDate: DateTime(1990, 1, 1),
          addresses: [address],
        );

        // Act
        await tester.pumpWidget(createTestWidget(user: user));
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Eliminar Dirección'), findsOneWidget);
        expect(
          find.text('¿Estás seguro de que quieres eliminar esta dirección?'),
          findsOneWidget,
        );
        expect(find.text('Cancelar'), findsOneWidget);
        expect(find.text('Eliminar'), findsOneWidget);
      },
    );

    testWidgets('Should cancel deletion when cancel button is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      final address = Address(
        street: 'Calle Para Mantener',
        city: 'Ciudad',
        state: 'Estado',
        zipCode: '12345',
      );

      final user = User(
        firstName: 'Usuario',
        lastName: 'Test',
        birthDate: DateTime(1990, 1, 1),
        addresses: [address],
      );

      // Act
      await tester.pumpWidget(createTestWidget(user: user));
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Calle Para Mantener'), findsOneWidget);
      expect(userProvider.user?.addresses.length, 1);
    });

    testWidgets('Should delete address when confirm button is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      final address = Address(
        street: 'Calle Para Eliminar',
        city: 'Ciudad',
        state: 'Estado',
        zipCode: '12345',
      );

      final user = User(
        firstName: 'Usuario',
        lastName: 'Test',
        birthDate: DateTime(1990, 1, 1),
        addresses: [address],
      );

      // Act
      await tester.pumpWidget(createTestWidget(user: user));
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      // Assert
      expect(userProvider.user?.addresses.length, 0);
      expect(find.text('No hay direcciones registradas.'), findsOneWidget);
    });

    testWidgets('Should display profile avatar', (WidgetTester tester) async {
      // Arrange
      final user = User(
        firstName: 'Usuario',
        lastName: 'Avatar',
        birthDate: DateTime(1990, 1, 1),
      );

      // Act
      await tester.pumpWidget(createTestWidget(user: user));

      // Assert
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets('Should display proper section titles', (
      WidgetTester tester,
    ) async {
      // Arrange
      final user = User(
        firstName: 'Usuario',
        lastName: 'Secciones',
        birthDate: DateTime(1990, 1, 1),
      );

      // Act
      await tester.pumpWidget(createTestWidget(user: user));

      // Assert
      expect(find.text('Datos'), findsOneWidget);
      expect(find.text('Direcciones:'), findsOneWidget);
    });

    testWidgets('Should handle multiple addresses correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final addresses = List.generate(
        3,
        (index) => Address(
          street: 'Calle ${index + 1}',
          city: 'Ciudad ${index + 1}',
          state: 'Estado ${index + 1}',
          zipCode: '0000${index + 1}',
        ),
      );

      final user = User(
        firstName: 'Usuario',
        lastName: 'MultiDirecciones',
        birthDate: DateTime(1990, 1, 1),
        addresses: addresses,
      );

      // Act
      await tester.pumpWidget(createTestWidget(user: user));

      // Assert
      for (int i = 0; i < 3; i++) {
        expect(find.text('Calle ${i + 1}'), findsOneWidget);
        expect(
          find.text('Ciudad ${i + 1}, Estado ${i + 1}- (0000${i + 1})'),
          findsOneWidget,
        );
      }
      expect(find.byIcon(Icons.delete), findsNWidgets(3));
    });

    testWidgets('Should display app bar with correct title', (
      WidgetTester tester,
    ) async {
      // Arrange
      final user = User(
        firstName: 'Usuario',
        lastName: 'AppBar',
        birthDate: DateTime(1990, 1, 1),
      );

      // Act
      await tester.pumpWidget(createTestWidget(user: user));

      // Assert
      expect(find.text('Perfil del Usuario'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
