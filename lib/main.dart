import 'package:flutter/material.dart';
import 'package:flutter_app_dvp/screens/user/address_form_screen.dart';
import 'package:flutter_app_dvp/screens/user/user_form_screen.dart';
import 'package:flutter_app_dvp/screens/user/user_profile_screen.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider()..loadUser(),
      child: MaterialApp(
        title: 'User Registration',
        initialRoute: '/',
        routes: {
          '/': (ctx) => UserFormScreen(),
          '/address': (ctx) => AddressFormScreen(),
          '/profile': (ctx) => UserProfileScreen(),
        },
      ),
    );
  }
}
