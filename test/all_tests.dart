import 'package:flutter_test/flutter_test.dart';

// Importar todos los archivos de test
import 'models/user_model_test.dart' as user_model_tests;
import 'models/address_model_test.dart' as address_model_tests;
import 'providers/user_provider_test.dart' as user_provider_tests;
import 'widgets/custom_input_field_test.dart' as custom_input_tests;
import 'screens/user_profile_screen_test.dart' as profile_screen_tests;
import 'integration/full_flow_test.dart' as integration_tests;
import 'utils/constants_test.dart' as constants_tests;
import 'widget_test.dart' as widget_tests;

void main() {
  group('Flutter App DVP - Test Suite Completa', () {
    group('Models Tests', () {
      user_model_tests.main();
      address_model_tests.main();
    });

    group('Providers Tests', () {
      user_provider_tests.main();
    });

    group('Widgets Tests', () {
      custom_input_tests.main();
    });

    group('Screens Tests', () {
      profile_screen_tests.main();
      widget_tests.main();
    });

    group('Utils Tests', () {
      constants_tests.main();
    });

    group('Integration Tests', () {
      integration_tests.main();
    });
  });
}
