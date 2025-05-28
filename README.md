# Fatigue Control

**Aplicación Flutter** Este proyecto es una aplicación movil desarrollada en Flutter cuyo objetivo es llevar un control y analizar signos de fatiga en conductores,

---

## Requisitos Previos

- **Flutter SDK**: canal `stable` **3.29.0** (comprueba con `flutter --version`)
- **Dart**: **3.7.0** • **DevTools**: **2.42.2**
- **Java**: **OpenJDK 21.0.2** LTS (Temurin)
- **Android Studio**: versión **2024.3.2** o superior
- **Android SDK**: **35.0.1** (API Level 35)
- **Emulador recomendado**: Pixel 9 (API 35, Android 15.0)
- **Gradle**: se prueba with la versión que trae el wrapper del proyecto

> **Nota**: Si piensas ejecutar en un dispositivo físico, puede haber errores de Gradle (relacionados con versiones de Android Gradle Plugin). En versiones anteriores del proyecto funcionó correctamente; en caso de fallo, revisa el `build.gradle` y ajusta la versión del plugin o del SDK.

---

## Configuración del Backend (Appwrite)

### 1. Endpoint y credenciales
Tu `AppwriteConstants` en `lib/app/constants/constants.dart` está configurado así:

```dart
class AppwriteConstants {
  static const String endpoint = 'https://fra.cloud.appwrite.io/v1';
  static const String projectId = '681c0972002eebc346f4';
  static const String bucketId = '681c0c05002010b60ddb';
  static const String databaseId = '681c09b50017db2d2018';
  static const String usersCollectionId = '681c09c6001807741f40';
  static const String historyCollectionId = '681c0a540003f336c311';
  static const String reportsCollectionId = '681c0b2b0006214e8e0c';
}
```

### 2. Configuración de colecciones
En tu consola de Appwrite, crea (o importa) las colecciones:
- **users**: ID `681c09c6001807741f40`
- **history**: ID `681c0a540003f336c311`
- **reports**: ID `681c0b2b0006214e8e0c`

### 3. Configuración adicional
- Crea además un **bucket** para archivos si lo usas (tal como `bucketId`)
---

## Instalación

1. **Clona el repositorio**:
   ```bash
   git clone https://github.com/Andresch2/driver_fatigue.git
   cd driver_fatigue
   ```

2. **Copia tu `google-services.json`** dentro de `android/app/` (para Firebase Messaging)

3. **Desde la carpeta raíz, ejecuta**:
   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs(hive)
   ```
   Esto generará los adaptadores de Hive y cualquier otro código generado.

---

## Ejecución

### Emulador
```bash
flutter run
```
Asegúrate de seleccionar el emulador **Pixel 9 API 35** en Android Studio o desde la CLI (`flutter devices`).

### Dispositivo Físico
Conecta tu dispositivo USB, habilita **"Depuración USB"** y ejecuta:
```bash
flutter run
```
Si da errores de Gradle, revisa la versión de Android Gradle Plugin en `android/build.gradle`.

---

## Credenciales de Prueba

Puedes iniciar sesión con la siguiente cuenta de prueba:

- ** Correo**: `arevalo@gmail.com`
- ** Contraseña**: `Arevalo123`

También puedes registrarte directamente desde la app.

---

## Dependencias Principales

- `get: ^4.7.2` – Gestión de estado y navegación
- `appwrite: ^15.0.0` – Cliente Appwrite
- `camera: ^0.11.1` + `google_mlkit_face_detection: ^0.13.1` – Captura y detección facial
- `pdf: ^3.10.1` + `printing: ^5.12.0` – Generación e impresión de PDF
- `firebase_core: ^2.9.0` + `firebase_messaging: ^14.5.0` – Notificaciones push
- `hive: ^2.2.3` + `hive_flutter: ^1.1.0` – Almacenamiento local
- `flutter_web_auth_2: ^4.1.0` (override) – Autenticación OAuth
- **Otras**: `vibration`, `fl_chart`, `url_launcher`, `connectivity_plus`...

*Para ver la lista completa, consulta el `pubspec.yaml` en la raíz del proyecto.*

---

## Características Principales

- **Detección de fatiga facial** con ML Kit y Google ML
- **Almacenamiento de datos** en Appwrite (usuarios, historial, reportes)
- **Generación de reportes** en PDF con impresión
- **Notificaciones push** mediante Firebase Messaging
- **Visualización de gráficas** con `fl_chart`
- **Autenticación OAuth** con `flutter_web_auth_2`
- **Almacenamiento local** con Hive para datos offline
- **Control de vibración** para alertas táctiles
- **Interfaz intuitiva** y adaptable a distintos dispositivos

---

## Problemas Conocidos y Soluciones

- **OCR impreciso**: Si el OCR falla, usa una imagen más nítida y bien iluminada
- **Errores de Gradle en físico**: Ajustar `minSdkVersion` o la versión del plugin en `android/build.gradle`
- **flutter_web_auth**: Limpiar caché según la sección de instalación
- **Problemas de conectividad**: Verifica que Appwrite esté accesible desde tu red
- **Errores de build_runner**: Ejecuta `flutter packages pub run build_runner clean` antes de rebuild

---

## Información del Sistema

**Versiones de desarrollo utilizadas:**
```
Flutter 3.29.0 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 35c388afb5 (4 months ago) • 2025-02-10 12:48:41 -0800
Engine • revision f73bfc4522
Tools • Dart 3.7.0 • DevTools 2.42.2

Dart SDK version: 3.7.0 (stable) (Wed Feb 5 04:53:58 2025 -0800) on "windows_x64"

Java:
openjdk 21.0.2 2024-01-16 LTS
OpenJDK Runtime Environment Temurin-21.0.2+13 (build 21.0.2+13-LTS)
OpenJDK 64-Bit Server VM Temurin-21.0.2+13 (build 21.0.2+13-LTS, mixed mode, sharing)
```