import 'package:flutter/material.dart';
import 'package:flutter_app_dvp/utils/constants.dart';
import 'package:flutter_app_dvp/utils/input_validators.dart';
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
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipController.text.trim(),
      );

      provider.addAddress(newAddress);

      // Limpiar el formulario después de guardar
      _streetController.clear();
      _cityController.clear();
      _stateController.clear();
      _zipController.clear();

      // Si estamos editando, simplemente regresar a la pantalla anterior
      if (widget.isEditing) {
        Navigator.pop(context);
      } else {
        // Si es una nueva dirección, navegar al perfil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (ctx) => UserProfileScreen()),
        );
      }

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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          widget.isEditing ? 'Editar Dirección' : 'Dirección de Residencia',
          style: AppTextStyles.h2.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.surface),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.md),

                // Card principal con formulario
                Container(
                  decoration: AppCardDecoration.elevated,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header del formulario
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    size: 40,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  widget.isEditing
                                      ? 'Editar dirección de residencia'
                                      : 'Registrar dirección de residencia',
                                  style: AppTextStyles.h3.copyWith(
                                    color: textPrimaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Ingrese los datos de su dirección actual',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: textSecondaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // Campos del formulario
                          CustomInput(
                            controller: _streetController,
                            label: 'Dirección',
                            hint: 'Ej. Calle 123 # 456-789',
                            prefixIcon: Icons.home_outlined,
                            keyboardType: TextInputType.streetAddress,
                            validationType: ValidationType.text,
                            minLength: 5,
                            maxLength: 100,
                          ),
                          const SizedBox(height: AppSpacing.sm),

                          CustomInput(
                            controller: _cityController,
                            label: 'Departamento',
                            hint: 'Ej. Antioquia',
                            prefixIcon: Icons.location_city_outlined,
                            keyboardType: TextInputType.text,
                            validationType: ValidationType.text,
                            minLength: 2,
                            maxLength: 50,
                          ),
                          const SizedBox(height: AppSpacing.sm),

                          CustomInput(
                            controller: _stateController,
                            label: 'Ciudad',
                            hint: 'Ej. Medellín',
                            prefixIcon: Icons.place_outlined,
                            keyboardType: TextInputType.text,
                            validationType: ValidationType.text,
                            minLength: 2,
                            maxLength: 50,
                          ),
                          const SizedBox(height: AppSpacing.sm),

                          CustomInput(
                            controller: _zipController,
                            label: 'Código Postal',
                            hint: 'Ej. 050022',
                            prefixIcon: Icons.markunread_mailbox_outlined,
                            keyboardType: TextInputType.number,
                            validationType: ValidationType.zipCode,
                          ),

                          const SizedBox(height: AppSpacing.xl * 2),

                          // Botón de acción
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () => _submitForm(provider),
                              style: AppButtonStyles.primary,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.isEditing
                                        ? 'Guardar Cambios'
                                        : 'Finalizar Registro',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Icon(
                                    widget.isEditing
                                        ? Icons.save
                                        : Icons.check_circle,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
