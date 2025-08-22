import 'package:flutter/material.dart';
import 'package:flutter_app_dvp/utils/constants.dart';
import 'package:flutter_app_dvp/utils/input_validators.dart';
import 'package:flutter_app_dvp/widgets/custom_input_field.dart';

class ValidationExampleScreen extends StatefulWidget {
  const ValidationExampleScreen({super.key});

  @override
  State<ValidationExampleScreen> createState() =>
      _ValidationExampleScreenState();
}

class _ValidationExampleScreenState extends State<ValidationExampleScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers para diferentes tipos de inputs
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _zipCodeController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ ¡Todos los campos son válidos!'),
          backgroundColor: successColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Por favor, corrija los errores en el formulario'),
          backgroundColor: errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Ejemplos de Validación',
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
        decoration: const BoxDecoration(gradient: AppGradients.surface),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: AppCardDecoration.elevated,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.verified_user,
                          size: 48,
                          color: primaryColor,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Sistema de Validación de Inputs',
                          style: AppTextStyles.h3.copyWith(
                            color: textPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Cada campo tiene validaciones específicas según su tipo de dato',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: textSecondaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Ejemplos de validación
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: AppCardDecoration.elevated,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ejemplos de Validación por Tipo',
                          style: AppTextStyles.h3.copyWith(
                            color: textPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Validación de nombre
                        _buildValidationExample(
                          'Nombre (ValidationType.name)',
                          'Solo letras, acentos y espacios. Min 2, máx 50 caracteres.',
                          CustomInput(
                            controller: _nameController,
                            label: 'Nombre Completo',
                            hint: 'Ej. María José García',
                            prefixIcon: Icons.person_outline,
                            keyboardType: TextInputType.name,
                            validationType: ValidationType.name,
                            maxLength: 50,
                          ),
                        ),

                        // Validación de email
                        _buildValidationExample(
                          'Email (ValidationType.email)',
                          'Formato de email válido requerido.',
                          CustomInput(
                            controller: _emailController,
                            label: 'Correo Electrónico',
                            hint: 'ejemplo@correo.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validationType: ValidationType.email,
                          ),
                        ),

                        // Validación de teléfono
                        _buildValidationExample(
                          'Teléfono (ValidationType.phone)',
                          'Entre 7 y 15 dígitos. Permite +, espacios, guiones.',
                          CustomInput(
                            controller: _phoneController,
                            label: 'Número de Teléfono',
                            hint: '+57 300 123 4567',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validationType: ValidationType.phone,
                          ),
                        ),

                        // Validación de dirección
                        _buildValidationExample(
                          'Dirección (ValidationType.text)',
                          'Texto general. Min 5, máx 100 caracteres.',
                          CustomInput(
                            controller: _addressController,
                            label: 'Dirección',
                            hint: 'Calle 123 # 45-67',
                            prefixIcon: Icons.home_outlined,
                            keyboardType: TextInputType.streetAddress,
                            validationType: ValidationType.text,
                            minLength: 5,
                            maxLength: 100,
                          ),
                        ),

                        // Validación de código postal
                        _buildValidationExample(
                          'Código Postal (ValidationType.zipCode)',
                          'Solo números. Entre 4 y 10 dígitos.',
                          CustomInput(
                            controller: _zipCodeController,
                            label: 'Código Postal',
                            hint: '050001',
                            prefixIcon: Icons.markunread_mailbox_outlined,
                            keyboardType: TextInputType.number,
                            validationType: ValidationType.zipCode,
                          ),
                        ),

                        // Validación de número
                        _buildValidationExample(
                          'Edad (ValidationType.number)',
                          'Solo números. Entre 1 y 120.',
                          CustomInput(
                            controller: _ageController,
                            label: 'Edad',
                            hint: '25',
                            prefixIcon: Icons.cake_outlined,
                            keyboardType: TextInputType.number,
                            validator:
                                (value) => InputValidators.validateNumber(
                                  value,
                                  fieldName: 'Edad',
                                  min: 1,
                                  max: 120,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Botón de validación
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _validateForm,
                      style: AppButtonStyles.primary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Validar Formulario',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Información adicional
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Información sobre las Validaciones',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          '• Las validaciones se ejecutan en tiempo real al perder el foco\n'
                          '• Los formatters bloquean caracteres inválidos mientras escribes\n'
                          '• Los mensajes de error son específicos para cada tipo de campo\n'
                          '• Todos los datos se limpian automáticamente (trim) al guardar\n'
                          '• Las validaciones son reutilizables en toda la aplicación',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValidationExample(
    String title,
    String description,
    Widget input,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          description,
          style: AppTextStyles.bodySmall.copyWith(color: textSecondaryColor),
        ),
        const SizedBox(height: AppSpacing.sm),
        input,
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
