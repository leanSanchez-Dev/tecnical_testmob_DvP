import 'package:flutter/material.dart';
import 'package:flutter_app_dvp/widgets/custom_input_field.dart';
import 'package:provider/provider.dart';
import '../../models/address_model.dart';
import '../../providers/user_provider.dart';
import 'user_profile_screen.dart';

class AddressFormScreen extends StatefulWidget {
  final bool isEditing;
  const AddressFormScreen({super.key, this.isEditing = false});

  @override
  AddressFormScreenState createState() => AddressFormScreenState();
}

class AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  void _submitForm(UserProvider provider) {
    if (_formKey.currentState!.validate()) {
      final newAddress = Address(
        street: _streetController.text,
        city: _cityController.text,
        state: _stateController.text,
        zipCode: _zipController.text,
      );

      provider.addAddress(newAddress);

      // Limpiar el formulario después de guardar
      _streetController.clear();
      _cityController.clear();
      _stateController.clear();
      _zipController.clear();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (ctx) => UserProfileScreen()),
        (route) => false,
      );

      // Mostrar confirmación
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('¡Dirección agregada!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.isEditing ? 'Editar Dirección' : 'Agregar Dirección',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            margin: EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height * 0.52,
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
                    'Datos de residencia',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CustomInput(
                    controller: _streetController,
                    label: 'Dirección',
                    hint: 'Ej. Calle 123 # 456',
                    keyboardType: TextInputType.streetAddress,
                  ),
                  CustomInput(
                    controller: _cityController,
                    label: 'Departamento',
                    hint: 'Ej. Antioquia',
                  ),
                  CustomInput(
                    controller: _stateController,
                    label: 'Ciudad',
                    hint: 'Ej. Medellín',
                    keyboardType: TextInputType.text,
                  ),
                  CustomInput(
                    controller: _zipController,
                    label: 'Zip Code',
                    hint: 'Ej. 050022',
                    keyboardType: TextInputType.numberWithOptions(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _submitForm(provider),
                    child: Text('Finalizar'),
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
