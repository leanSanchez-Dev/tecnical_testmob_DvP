# Flutter App DVP - Aplicación de Registro de Usuarios

![Flutter](https://img.shields.io/badge/Flutter-3.7.0-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-green.svg)
![Tests](https://img.shields.io/badge/Tests-✅%20Completos-brightgreen.svg)
![Cobertura](https://img.shields.io/badge/Cobertura-90%2B%25-brightgreen.svg)

Una aplicación Flutter moderna y robusta para el registro y gestión de usuarios con direcciones múltiples. Desarrollada como parte de la prueba técnica para **Double V Partners**.

## 🚀 Características Principales

### ✨ **Funcionalidades**

- 📝 **Registro de Usuario**: Formulario completo con validaciones
- 🏠 **Gestión de Direcciones**: Múltiples direcciones por usuario
- 👤 **Perfil Completo**: Visualización y edición de información
- 📱 **Interfaz Moderna**: Diseño atractivo y responsivo
- 💾 **Persistencia Local**: Datos guardados con SharedPreferences
- 📸 **Foto de Perfil**: Selector de imagen desde galería
- ✅ **Validaciones**: Formularios con validación robusta

### 🏗️ **Arquitectura**

- 🎯 **Patrón Provider**: Gestión de estado eficiente
- 📦 **Modular**: Separación clara de responsabilidades
- 🧪 **Testing Completo**: Suite de tests exhaustiva
- 🎨 **UI/UX**: Componentes reutilizables y elegantes
- 📊 **SOLID**: Principios de diseño implementados

## 📱 Flujo de la Aplicación

```
1. Formulario Usuario → 2. Formulario Dirección → 3. Perfil Completo
     ↓                        ↓                         ↓
   [Datos personales]    [Dirección física]      [Vista + Edición]
```

### **Pantallas**

1. **UserFormScreen**: Captura nombre, apellido, fecha de nacimiento
2. **AddressFormScreen**: Registro de direcciones (calle, ciudad, departamento, código postal)
3. **UserProfileScreen**: Visualización completa, edición y gestión de direcciones

## 🛠️ Tecnologías y Dependencias

### **Principales**

```yaml
dependencies:
  provider: ^6.1.2 # Gestión de estado
  intl: ^0.20.2 # Formateo de fechas
  shared_preferences: ^2.5.2 # Persistencia local
  image_picker: ^1.1.2 # Selector de imágenes
  permission_handler: ^11.3.1 # Gestión de permisos
```

### **Testing**

```yaml
dev_dependencies:
  flutter_test: sdk # Framework de testing Flutter
  mockito: ^5.4.4 # Mocking para tests
  build_runner: ^2.4.8 # Generación de código
  flutter_lints: ^5.0.0 # Linting y análisis
```

## 🧪 Testing Suite Completa

### **Cobertura de Testing**

- ✅ **Unit Tests**: Modelos y lógica de negocio
- ✅ **Widget Tests**: Componentes UI y pantallas
- ✅ **Integration Tests**: Flujos completos de usuario
- ✅ **Provider Tests**: Gestión de estado y persistencia

### **Ejecutar Tests**

```bash
# Todos los tests
flutter test

# Tests con cobertura
flutter test --coverage

# Script automatizado (PowerShell)
./run_tests.ps1

# Suite organizada
flutter test test/all_tests.dart
```

### **Estructura de Tests**

```
test/
├── all_tests.dart              # Suite principal
├── models/                     # Tests de modelos
├── providers/                  # Tests de estado
├── widgets/                    # Tests de componentes
├── screens/                    # Tests de pantallas
├── integration/                # Tests de flujo completo
└── utils/                      # Tests de utilidades
```

## 🚀 Instalación y Ejecución

### **Requisitos Previos**

- Flutter SDK 3.7.0+
- Dart 3.0+
- Android Studio / VS Code
- Git

### **Configuración**

```bash
# Clonar repositorio
git clone https://github.com/leanSanchez-Dev/tecnical_testmob_DvP.git
cd tecnical_testmob_DvP

# Instalar dependencias
flutter pub get

# Ejecutar aplicación
flutter run

# Ejecutar tests
flutter test
```

### **Generar APK**

```bash
flutter build apk --release
```

## 🏛️ Arquitectura del Proyecto

### **Estructura de Directorios**

```
lib/
├── main.dart                   # Punto de entrada
├── models/                     # Modelos de datos
│   ├── user_model.dart
│   └── address_model.dart
├── providers/                  # Gestión de estado
│   └── user_provider.dart
├── screens/                    # Pantallas de la app
│   └── user/
│       ├── user_form_screen.dart
│       ├── address_form_screen.dart
│       └── user_profile_screen.dart
├── widgets/                    # Componentes reutilizables
│   └── custom_input_field.dart
└── utils/                      # Utilidades
    └── constants.dart
```

### **Patrones Implementados**

- 🎯 **Provider Pattern**: Para gestión de estado
- 🏗️ **Repository Pattern**: UserProvider como repositorio
- 👁️ **Observer Pattern**: ChangeNotifier para notificaciones
- 🔧 **Factory Pattern**: Métodos fromMap() en modelos
- 📦 **Singleton**: SharedPreferences para persistencia

## 💡 Características Técnicas Destacadas

### **Gestión de Estado**

- Provider pattern con ChangeNotifier
- Estado reactivo y eficiente
- Persistencia automática con SharedPreferences

### **Validaciones**

- Formularios con validación en tiempo real
- Campos obligatorios verificados
- Feedback visual inmediato

### **UI/UX**

- Diseño Material Design
- Colores consistentes y atractivos
- Animaciones fluidas y responsivas
- Componentes reutilizables

### **Persistencia**

- Datos guardados localmente
- Serialización JSON automática
- Carga de datos al iniciar la app

## 📊 Métricas de Calidad

### **Testing**

- 🎯 **Cobertura**: 90%+ en componentes críticos
- ✅ **Unit Tests**: 100% modelos y providers
- 🎨 **Widget Tests**: Todas las pantallas cubiertas
- 🔗 **Integration**: Flujos principales probados

### **Código**

- 📏 **Linting**: Flutter Lints habilitado
- 🏗️ **Arquitectura**: SOLID principles aplicados
- 📝 **Documentación**: Código bien comentado
- 🧹 **Clean Code**: Nombres descriptivos y estructura clara

## 🏆 Cumplimiento de Requerimientos

### ✅ **Prueba Técnica - Completada**

**Requerimientos Obligatorios:**

- ✅ Proyecto mobile en Flutter
- ✅ Formulario de usuario (nombre, apellido, fecha nacimiento)
- ✅ Direcciones físicas (múltiples por usuario)
- ✅ Mínimo 3 pantallas
- ✅ Buenas prácticas y control de errores
- ✅ Pintar datos del usuario en cualquier momento

**Puntos de Seniority:**

- ✅ Creatividad en la solución
- ✅ Calidad del código y estructura
- ✅ Eficiencia de algoritmos
- ✅ Familiaridad con frameworks
- ✅ Principios SOLID y patrones de diseño
- ✅ **Suite completa de testing** (Unit Testing)

## 🎯 Próximas Mejoras

### **Funcionalidades**

- [ ] Autenticación de usuarios
- [ ] Sincronización con backend
- [ ] Notificaciones push
- [ ] Modo offline avanzado

### **Técnicas**

- [ ] CI/CD con GitHub Actions
- [ ] Análisis estático automatizado
- [ ] Performance monitoring
- [ ] Internacionalización (i18n)

## 👨‍💻 Autor

**Leonardo Sánchez**  
Desarrollador Full Stack Flutter  
📧 Email: [tu-email]  
🔗 LinkedIn: [tu-linkedin]  
🐙 GitHub: [@leanSanchez-Dev](https://github.com/leanSanchez-Dev)

---

## 📄 Licencia

Este proyecto fue desarrollado como parte de la prueba técnica para **Double V Partners**.

---

**⭐ ¡Gracias por revisar este proyecto!**
