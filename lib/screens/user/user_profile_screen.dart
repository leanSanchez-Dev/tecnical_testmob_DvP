import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_dvp/providers/user_provider.dart';
import 'package:flutter_app_dvp/screens/user/address_form_screen.dart';
import 'package:flutter_app_dvp/screens/user/user_form_screen.dart';
import 'package:flutter_app_dvp/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? image;
  XFile? pickedFile;
  final ImagePicker picker = ImagePicker();
  bool _isLoggingOut = false; // Variable para controlar el estado de logout

  Future<void> pickImage() async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile!.path);
        });
      }
    } else {
      print("Permiso denegado");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return PopScope(
      canPop: _isLoggingOut, // Permite navegación solo durante logout
      onPopInvoked: (didPop) {
        if (!didPop && !_isLoggingOut) {
          // Mostrar mensaje cuando el usuario intenta ir atrás (pero no durante logout)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Usa "Cerrar Sesión" para salir'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text(
            'Mi Perfil',
            style: AppTextStyles.h2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: null, // Quitar el botón de back
          automaticallyImplyLeading:
              false, // Prevenir que Flutter muestre automáticamente el botón back
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => _showLogoutDialog(context, userProvider),
              tooltip: 'Cerrar Sesión',
            ),
          ],
        ),
        body:
            user == null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: errorColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_off,
                          size: 64,
                          color: errorColor,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'No hay datos del usuario',
                        style: AppTextStyles.h3.copyWith(
                          color: textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Por favor, registre sus datos primero',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                )
                : Container(
                  decoration: const BoxDecoration(
                    gradient: AppGradients.surface,
                  ),
                  child: CustomScrollView(
                    slivers: [
                      // Header expandible con avatar
                      SliverToBoxAdapter(
                        child: Container(
                          key: const ValueKey(
                            'profile_header_v2',
                          ), // Clave única para forzar reconstrucción
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.xl,
                          ), // Padding en lugar de altura fija
                          decoration: const BoxDecoration(
                            gradient: AppGradients.primary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(AppRadius.xl),
                              bottomRight: Radius.circular(AppRadius.xl),
                            ),
                          ),
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.lg,
                                AppSpacing
                                    .lg, // Padding superior - NUEVO DISEÑO
                                AppSpacing.lg,
                                0,
                              ),
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize
                                        .min, // Ajustar al contenido - SIN ALTURA FIJA
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Avatar con diseño mejorado
                                  Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 20,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius:
                                              45, // Reducido para evitar overflow
                                          backgroundColor: Colors.white,
                                          backgroundImage:
                                              image != null
                                                  ? FileImage(image!)
                                                  : null,
                                          child:
                                              image == null
                                                  ? Icon(
                                                    Icons.person,
                                                    size: 45, // Reducido
                                                    color: primaryColor
                                                        .withOpacity(0.7),
                                                  )
                                                  : null,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: pickImage,
                                          child: Container(
                                            padding: const EdgeInsets.all(
                                              6,
                                            ), // Reducido
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt,
                                              color: primaryColor,
                                              size: 18, // Reducido
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: AppSpacing.sm,
                                  ), // Reducido
                                  // Nombre
                                  Text(
                                    '${user.firstName} ${user.lastName}',
                                    style: AppTextStyles.h2.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: AppSpacing.xs,
                                  ), // Reducido
                                  // Fecha de nacimiento
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm, // Reducido
                                      vertical: AppSpacing.xs, // Reducido
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.full,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.cake_outlined,
                                          size: 14, // Reducido
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: AppSpacing.xs),
                                        Text(
                                          DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(user.birthDate!),
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                // Cambiado a bodySmall
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
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

                      // Contenido principal
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            children: [
                              // Card de datos personales
                              Container(
                                decoration: AppCardDecoration.elevated,
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.lg),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(
                                              AppSpacing.sm,
                                            ),
                                            decoration: BoxDecoration(
                                              color: primaryColor.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppRadius.md,
                                                  ),
                                            ),
                                            child: const Icon(
                                              Icons.person_outline,
                                              color: primaryColor,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: AppSpacing.md),
                                          Expanded(
                                            child: Text(
                                              'Datos Personales',
                                              style: AppTextStyles.h3.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (ctx) =>
                                                          const UserFormScreen(
                                                            isEditing: true,
                                                          ),
                                                ),
                                              );
                                            },
                                            icon: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: secondaryColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppRadius.sm,
                                                    ),
                                              ),
                                              child: const Icon(
                                                Icons.edit_outlined,
                                                color: secondaryColor,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.lg),
                                      _buildInfoRow(
                                        Icons.person_outline,
                                        'Nombre completo',
                                        '${user.firstName} ${user.lastName}',
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                      _buildInfoRow(
                                        Icons.cake_outlined,
                                        'Fecha de nacimiento',
                                        DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(user.birthDate!),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: AppSpacing.lg),

                              // Card de direcciones
                              Container(
                                decoration: AppCardDecoration.elevated,
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.lg),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(
                                              AppSpacing.sm,
                                            ),
                                            decoration: BoxDecoration(
                                              color: secondaryColor.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppRadius.md,
                                                  ),
                                            ),
                                            child: const Icon(
                                              Icons.location_on_outlined,
                                              color: secondaryColor,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: AppSpacing.md),
                                          Expanded(
                                            child: Text(
                                              'Direcciones',
                                              style: AppTextStyles.h3.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (ctx) =>
                                                          const AddressFormScreen(
                                                            isEditing: true,
                                                          ),
                                                ),
                                              );
                                            },
                                            icon: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: successColor.withOpacity(
                                                  0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppRadius.sm,
                                                    ),
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: successColor,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.lg),

                                      // Lista de direcciones
                                      if (user.addresses.isEmpty)
                                        _buildEmptyAddresses()
                                      else
                                        ...user.addresses.asMap().entries.map((
                                          entry,
                                        ) {
                                          final index = entry.key;
                                          final address = entry.value;
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom:
                                                  index <
                                                          user
                                                                  .addresses
                                                                  .length -
                                                              1
                                                      ? AppSpacing.md
                                                      : 0,
                                            ),
                                            child: _buildAddressCard(
                                              address,
                                              userProvider,
                                            ),
                                          );
                                        }).toList(),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: AppSpacing.xl),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ), // Cierre del Scaffold (child del PopScope)
    ); // Cierre del PopScope
  }

  // Widget helper para mostrar información con iconos
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: 16, color: primaryColor),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: textMutedColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget para mostrar cuando no hay direcciones
  Widget _buildEmptyAddresses() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: textMutedColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off_outlined,
              size: 32,
              color: textMutedColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No hay direcciones registradas',
            style: AppTextStyles.bodyMedium.copyWith(
              color: textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Agrega tu primera dirección para completar tu perfil',
            style: AppTextStyles.bodySmall.copyWith(color: textMutedColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget para mostrar cada dirección
  Widget _buildAddressCard(address, UserProvider userProvider) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: successColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: const Icon(Icons.home_outlined, color: successColor, size: 20),
        ),
        title: Text(
          address.street,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${address.city}, ${address.state} - ${address.zipCode}',
            style: AppTextStyles.bodySmall.copyWith(color: textSecondaryColor),
          ),
        ),
        trailing: Builder(
          builder:
              (context) => IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: errorColor,
                    size: 16,
                  ),
                ),
                onPressed: () => _showDialog(context, userProvider, address),
              ),
        ),
      ),
    );
  }

  // Diálogo de confirmación para cerrar sesión
  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      barrierDismissible: false, // Evitar cerrar accidentalmente
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: errorColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout, color: errorColor, size: 24),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Cerrar Sesión',
                  style: AppTextStyles.h3.copyWith(
                    color: textPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              '¿Estás seguro de que quieres cerrar sesión? Se eliminarán todos los datos guardados.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: textSecondaryColor,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                style: AppButtonStyles.secondary,
                child: Text(
                  'Cancelar',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: textSecondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              ElevatedButton(
                onPressed: () async {
                  // Cerrar diálogo usando su contexto
                  Navigator.of(dialogContext).pop();

                  // Realizar logout de forma inmediata y directa
                  await _performLogout(userProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: errorColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: Text(
                  'Cerrar Sesión',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  // Función separada para realizar el logout de forma segura
  Future<void> _performLogout(UserProvider userProvider) async {
    try {
      // Activar estado de logout
      if (mounted) {
        setState(() {
          _isLoggingOut = true;
        });
      }

      // Limpiar datos del usuario
      await userProvider.clearUser();

      // Usar el contexto de forma segura desde el widget montado
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            // Navegar al home de forma directa
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamedAndRemoveUntil('/', (route) => false);
          }
        });
      }
    } catch (e) {
      debugPrint('Error durante logout: $e');

      // Fallback: navegar directamente sin rootNavigator
      if (mounted) {
        try {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        } catch (e2) {
          debugPrint('Error en fallback: $e2');
        }
      }
    } finally {
      // Limpiar estado
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  // Diálogo para eliminar dirección
  void _showDialog(BuildContext context, UserProvider userProvider, address) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: errorColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_outlined,
                    color: errorColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Eliminar Dirección',
                  style: AppTextStyles.h3.copyWith(
                    color: textPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              '¿Estás seguro de que quieres eliminar esta dirección? Esta acción no se puede deshacer.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: textSecondaryColor,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                style: AppButtonStyles.secondary,
                child: Text(
                  'Cancelar',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: textSecondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              ElevatedButton(
                onPressed: () {
                  userProvider.removeAddress(address);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Dirección eliminada correctamente',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: successColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: errorColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: Text(
                  'Eliminar',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
