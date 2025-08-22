import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_dvp/main.dart';
import 'package:flutter_app_dvp/screens/user/user_form_screen.dart';
import 'package:flutter_app_dvp/screens/user/address_form_screen.dart';
import 'package:flutter_app_dvp/screens/user/user_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Integration Tests - Full User Registration Flow', () {
    setUp(() {
      // Mock SharedPreferences para testing
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Complete user registration flow', (WidgetTester tester) async {
      // 1. Iniciar la aplicación
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // 2. Verificar que estamos en la pantalla de formulario de usuario
      expect(find.byType(UserFormScreen), findsOneWidget);
      expect(find.text('Formulario de Usuario'), findsOneWidget);

      // 3. Llenar el formulario de usuario
      await tester.enterText(find.byType(TextFormField).first, 'Juan');
      await tester.enterText(find.byType(TextFormField).last, 'Pérez');

      // 4. Seleccionar fecha de nacimiento (simular configuración directa)
      // En lugar de interactuar con el DatePicker, verificamos que el campo existe
      expect(find.text('Fecha de Nacimiento'), findsOneWidget);
      expect(find.text('Seleccione una fecha'), findsOneWidget);

      // 5. Continuar al formulario de dirección
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      // 6. Verificar que estamos en la pantalla de dirección
      expect(find.byType(AddressFormScreen), findsOneWidget);
      expect(find.text('Agregar Dirección'), findsOneWidget);

      // 7. Llenar el formulario de dirección
      final addressFields = find.byType(TextFormField);
      await tester.enterText(addressFields.at(0), 'Calle 123 # 45-67');
      await tester.enterText(addressFields.at(1), 'Antioquia');
      await tester.enterText(addressFields.at(2), 'Medellín');
      await tester.enterText(addressFields.at(3), '050001');

      // 8. Finalizar registro
      await tester.tap(find.text('Finalizar'));
      await tester.pumpAndSettle();

      // 9. Verificar que llegamos al perfil del usuario
      expect(find.byType(UserProfileScreen), findsOneWidget);
      expect(find.text('Perfil del Usuario'), findsOneWidget);

      // 10. Verificar que los datos se muestran correctamente
      expect(find.text('Juan Pérez'), findsOneWidget);
      expect(find.text('Calle 123 # 45-67'), findsOneWidget);
      expect(find.text('Medellín, Antioquia- (050001)'), findsOneWidget);
    });

    testWidgets('Navigation between screens works correctly', (
      WidgetTester tester,
    ) async {
      // Iniciar la aplicación
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Verificar pantalla inicial
      expect(find.byType(UserFormScreen), findsOneWidget);

      // Llenar datos mínimos y continuar
      await tester.enterText(find.byType(TextFormField).first, 'Test');
      await tester.enterText(find.byType(TextFormField).last, 'User');

      // Verificar campo de fecha
      expect(find.text('Fecha de Nacimiento'), findsOneWidget);

      // Ir a dirección
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      expect(find.byType(AddressFormScreen), findsOneWidget);
    });

    testWidgets('Form validation works correctly', (WidgetTester tester) async {
      // Iniciar la aplicación
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Intentar continuar sin llenar campos
      await tester.tap(find.text('Continuar'));
      await tester.pump();

      // Verificar que seguimos en la misma pantalla (validación falló)
      expect(find.byType(UserFormScreen), findsOneWidget);
    });

    testWidgets('Multiple addresses can be added', (WidgetTester tester) async {
      // Completar registro inicial
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Llenar formulario de usuario
      await tester.enterText(find.byType(TextFormField).first, 'María');
      await tester.enterText(find.byType(TextFormField).last, 'García');

      // Verificar campo de fecha
      expect(find.text('Fecha de Nacimiento'), findsOneWidget);

      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      // Agregar primera dirección
      final addressFields = find.byType(TextFormField);
      await tester.enterText(addressFields.at(0), 'Primera Dirección');
      await tester.enterText(addressFields.at(1), 'Departamento1');
      await tester.enterText(addressFields.at(2), 'Ciudad1');
      await tester.enterText(addressFields.at(3), '11111');

      await tester.tap(find.text('Finalizar'));
      await tester.pumpAndSettle();

      // Verificar que estamos en el perfil
      expect(find.byType(UserProfileScreen), findsOneWidget);
      expect(find.text('Primera Dirección'), findsOneWidget);

      // Agregar segunda dirección
      await tester.tap(find.byIcon(Icons.add_location_alt_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(AddressFormScreen), findsOneWidget);
    });

    testWidgets('User data persists through app lifecycle', (
      WidgetTester tester,
    ) async {
      // Configurar datos persistentes
      SharedPreferences.setMockInitialValues({
        'user_data':
            '{"firstName":"Persisted","lastName":"User","birthDate":"1990-01-01T00:00:00.000","addresses":[{"street":"Persistent Street","city":"Persistent City","state":"Persistent State","zipCode":"12345"}]}',
      });

      // Iniciar la aplicación
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Debe navegar directamente al perfil si hay datos
      // O mostrar los datos en el formulario
      expect(find.text('Persisted'), findsOneWidget);
    });

    testWidgets('Edit user information works', (WidgetTester tester) async {
      // Completar registro inicial
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Completar formularios
      await tester.enterText(find.byType(TextFormField).first, 'Original');
      await tester.enterText(find.byType(TextFormField).last, 'Name');

      // Verificar campo de fecha
      expect(find.text('Fecha de Nacimiento'), findsOneWidget);

      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      final addressFields = find.byType(TextFormField);
      await tester.enterText(addressFields.at(0), 'Original Address');
      await tester.enterText(addressFields.at(1), 'Original Dept');
      await tester.enterText(addressFields.at(2), 'Original City');
      await tester.enterText(addressFields.at(3), '00000');

      await tester.tap(find.text('Finalizar'));
      await tester.pumpAndSettle();

      // Verificar datos originales
      expect(find.text('Original Name'), findsOneWidget);

      // Editar usuario
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(UserFormScreen), findsOneWidget);
    });

    testWidgets('Delete address functionality works', (
      WidgetTester tester,
    ) async {
      // Completar registro con dirección
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Delete');
      await tester.enterText(find.byType(TextFormField).last, 'Test');

      // Verificar campo de fecha
      expect(find.text('Fecha de Nacimiento'), findsOneWidget);

      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      final addressFields = find.byType(TextFormField);
      await tester.enterText(addressFields.at(0), 'Address to Delete');
      await tester.enterText(addressFields.at(1), 'Dept');
      await tester.enterText(addressFields.at(2), 'City');
      await tester.enterText(addressFields.at(3), '12345');

      await tester.tap(find.text('Finalizar'));
      await tester.pumpAndSettle();

      // Verificar que la dirección existe
      expect(find.text('Address to Delete'), findsOneWidget);

      // Eliminar dirección
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Confirmar eliminación
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      // Verificar que la dirección fue eliminada
      expect(find.text('No hay direcciones registradas.'), findsOneWidget);
    });
  });
}
