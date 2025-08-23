import 'package:flutter/material.dart';
import 'package:flutter_app_dvp/screens/user/address_form_screen.dart';
import 'package:flutter_app_dvp/utils/constants.dart';
import 'package:flutter_app_dvp/utils/input_validators.dart';
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
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        birthDate = DateFormat.yMd().format(_birthDate!);
      });
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
      _birthDate = DateTime(
        1990,
        1,
        1,
      ); // Fecha por defecto válida para nacimiento
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
          'Datos Personales',
          style: AppTextStyles.h2.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading:
            widget.isEditing
                ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                )
                : null,
        automaticallyImplyLeading: widget.isEditing,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(gradient: AppGradients.surface),
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: SafeArea(
              child: Column(
                children: [
                  // const SizedBox(height: AppSpacing.md),

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
                                    padding: const EdgeInsets.all(
                                      AppSpacing.md,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.person_add,
                                      size: 40,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(
                                    widget.isEditing
                                        ? 'Editar información personal'
                                        : 'Registrar datos personales',
                                    style: AppTextStyles.h3.copyWith(
                                      color: textPrimaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    'Complete sus datos básicos para continuar',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: textSecondaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // Campos del formulario
                            CustomInput(
                              controller: _firstNameController,
                              label: 'Nombre',
                              hint: 'Ingrese su nombre',
                              prefixIcon: Icons.person_outline,
                              keyboardType: TextInputType.name,
                              validationType: ValidationType.name,
                              maxLength: 50,
                            ),
                            const SizedBox(height: AppSpacing.md),

                            CustomInput(
                              controller: _lastNameController,
                              label: 'Apellido',
                              hint: 'Ingrese su apellido',
                              prefixIcon: Icons.person_outline,
                              keyboardType: TextInputType.name,
                              validationType: ValidationType.name,
                              maxLength: 50,
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // Campo de fecha de nacimiento personalizado
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Fecha de Nacimiento',
                                      style: AppTextStyles.label.copyWith(
                                        color: textSecondaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      '*',
                                      style: AppTextStyles.label.copyWith(
                                        color: errorColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),

                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.lg,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.02),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () => _selectDate(context),
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.lg,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                        vertical: AppSpacing.md + 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: surfaceColor,
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.lg,
                                        ),
                                        border: Border.all(
                                          color: borderColor,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: AppSpacing.sm,
                                            ),
                                            child: const Icon(
                                              Icons.calendar_today_outlined,
                                              color: textMutedColor,
                                              size: 20,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              birthDate ??
                                                  'Seleccione una fecha',
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                    color:
                                                        birthDate != null
                                                            ? textPrimaryColor
                                                            : textMutedColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            color: textMutedColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: AppSpacing.xl * 2),

                            // Botón de acción
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Validar fecha de nacimiento
                                    final dateValidation =
                                        InputValidators.validateBirthDate(
                                          _birthDate,
                                        );
                                    if (dateValidation != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(dateValidation),
                                          backgroundColor: errorColor,
                                        ),
                                      );
                                      return;
                                    }

                                    final newUser = User(
                                      firstName:
                                          _firstNameController.text.trim(),
                                      lastName: _lastNameController.text.trim(),
                                      birthDate: _birthDate,
                                    );
                                    if (!widget.isEditing) {
                                      provider.createUser(newUser);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => AddressFormScreen(),
                                          settings: RouteSettings(
                                            arguments: true,
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Si estamos editando, solo actualizar y regresar
                                      provider.createUser(newUser);
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                style: AppButtonStyles.primary,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.isEditing
                                          ? 'Guardar Cambios'
                                          : 'Continuar',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Icon(
                                      widget.isEditing
                                          ? Icons.save
                                          : Icons.arrow_forward,
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
      ),
    );
  }
}
