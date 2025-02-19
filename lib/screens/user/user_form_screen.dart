import 'package:flutter/material.dart';
import 'package:flutter_app_dvp/screens/user/address_form_screen.dart';
import 'package:flutter_app_dvp/screens/user/user_profile_screen.dart';
import 'package:flutter_app_dvp/utils/constants.dart';
import 'package:flutter_app_dvp/widgets/custom_input_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';

class UserFormScreen extends StatefulWidget {
  final bool isEditing;
  const UserFormScreen({super.key, this.isEditing = false});

  @override
  UserFormScreenState createState() => UserFormScreenState();
}

class UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _birthDate;
  String? birthDate;

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate!,
      firstDate: DateTime(1917, 1),
      lastDate: DateTime(2025, 5),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        birthDate = DateFormat.yMd().format(_birthDate!);
      });
    }
  }

  void _submitForm(UserProvider provider) {
    if (_formKey.currentState!.validate()) {
      final updatedUser = User(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        birthDate: _birthDate,
        addresses:
            provider.user?.addresses ??
            [], // Mantener las direcciones existentes
      );
      provider.createUser(updatedUser); // Actualizar el usuario
      Navigator.pop(context); // Regresar a la pantalla anterior
    }
  }

  @override
  void initState() {
    super.initState();
    // Cargar los datos actuales del usuario al iniciar la pantalla
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    if (user != null) {
      _firstNameController.text = user.firstName ?? '';
      _lastNameController.text = user.lastName ?? '';
      birthDate = DateFormat.yMd().format(user.birthDate!);
      _birthDate = user.birthDate;
    } else {
      _birthDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Formulario de Usuario')),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: .5),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Datos Personales',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CustomInput(
                    controller: _firstNameController,
                    label: 'Nombre',
                  ),
                  CustomInput(
                    controller: _lastNameController,
                    label: 'Apellido',
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Fecha de Nacimiento",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: secondaryColor.withValues(alpha: .9),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        // label: Text('Fecha de Nacimiento'),
                        labelStyle: const TextStyle(color: primaryColor),
                        // prefixIcon: Icon(Icons.email),
                        filled: true,
                        fillColor: accentColor,
                        hintText: 'Seleccione una fecha',
                        hintStyle: TextStyle(
                          color: Colors.grey.withValues(alpha: .75),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: 20.0,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: secondaryColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: errorColor, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      child: Text(birthDate ?? ''),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newUser = User(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          birthDate: _birthDate,
                        );
                        if (!widget.isEditing) {
                          provider.createUser(newUser);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => AddressFormScreen(),
                              settings: RouteSettings(arguments: true),
                            ),
                          );
                        } else {
                          _submitForm(provider);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => UserProfileScreen(),
                              settings: RouteSettings(arguments: true),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(widget.isEditing ? 'Guardar' : 'Continuar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
