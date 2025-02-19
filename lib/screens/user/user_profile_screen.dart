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
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

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

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Perfil del Usuario')),
      body:
          user == null
              ? Center(child: Text('No hay datos del usuario.'))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          //contenedor cuadrado de full ancho  de fondo con un gradiend morado y azul con bordes redondeados solo abajo y sombra
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: .5),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Colors.purple, Colors.blue],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                image != null ? FileImage(image!) : null,
                            child:
                                image == null
                                    ? Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    )
                                    : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: pickImage,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Datos',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (ctx) => UserFormScreen(isEditing: true),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                    // Información del usuario
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Fecha de Nac: ${DateFormat.yMd().format(user.birthDate!)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),

                    // Título de las direcciones
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Direcciones:',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (ctx) => AddressFormScreen(isEditing: true),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.add_location_alt_outlined,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Lista de direcciones
                    Expanded(
                      child:
                          user.addresses.isEmpty
                              ? Center(
                                child: Text('No hay direcciones registradas.'),
                              )
                              : ListView.builder(
                                itemCount: user.addresses.length,
                                itemBuilder: (context, index) {
                                  final address = user.addresses[index];
                                  return Card(
                                    shadowColor: Colors.grey.withValues(
                                      alpha: .5,
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 2,
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        address.street,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${address.city}, ${address.state}- (${address.zipCode})',
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: errorColor,
                                        ),
                                        onPressed: () {
                                          // Eliminar dirección
                                          _showDialog(
                                            context,
                                            userProvider,
                                            address,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
    );
  }

  _showDialog(BuildContext context, UserProvider userProvider, address) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Eliminar Dirección'),
            content: Text(
              '¿Estás seguro de que quieres eliminar esta dirección?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  userProvider.removeAddress(address); // Eliminar dirección
                  Navigator.pop(ctx); // Cerrar el diálogo
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Dirección eliminada.')),
                  );
                },
                child: Text('Eliminar', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
