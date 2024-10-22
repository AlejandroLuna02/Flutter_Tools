# Phone App

Este es un proyecto de Flutter que proporciona varias funcionalidades relacionadas con el dispositivo móvil, incluyendo geolocalización, escaneo de códigos QR, sensores del dispositivo, reconocimiento de voz y conversión de texto a voz.

## Características

- **Perfil**: Pantalla principal de perfil (Home).
- **Geolocalización**: Obtén la ubicación del dispositivo utilizando la biblioteca `geolocator`.
- **QR Scanner**: Escanea códigos QR usando `qr_code_scanner`.
- **Sensores**: Accede a los sensores del dispositivo como el acelerómetro y giroscopio usando `sensor_plus`.
- **Reconocimiento de Voz**: Convierte voz en texto utilizando `speech_to_text`.
- **Texto a Voz**: Convierte texto a voz utilizando `flutter_tts`.

## Requisitos previos

Asegúrate de tener instalado lo siguiente en tu entorno de desarrollo:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versión estable más reciente)
- [Android Studio](https://developer.android.com/studio) o [Xcode](https://developer.apple.com/xcode/) (si desarrollas para iOS)
- Dispositivo o emulador Android/iOS para probar

## Instalación

Sigue estos pasos para clonar e instalar las dependencias del proyecto:

1. Clona el repositorio:

   ```bash
   git clone https://github.com/Villo29/appmovilutils.git

2. Cambia al directorio del proyecto:
    cd tu_repositorio

3. Instala las dependencias del proyecto:

4. flutter pub get
    Ejecuta la aplicación en un dispositivo o simulador:

5. flutter run

    Estructura del Proyecto
    main.dart: Punto de entrada principal del proyecto.
    Pantallas:
    Home: Pantalla principal del perfil del usuario.
    Geolocalización: Muestra la ubicación del dispositivo utilizando la API de geolocalización.
    QR Scanner: Permite escanear códigos QR.
    Sensores: Accede y visualiza los datos de los sensores del dispositivo.
    Reconocimiento de Voz: Convierte la voz en texto en tiempo real.
    Texto a Voz: Convierte el texto ingresado en audio.

    ##Dependencias
    dependencies:
  flutter:
    sdk: flutter
  geolocator: ^9.0.0 # Geolocalización
  qr_code_scanner: ^0.5.2 # Escáner de QR
  sensor_plus: ^1.2.0 # Sensores
  speech_to_text: ^3.3.0 # Reconocimiento de voz
  flutter_tts: ^3.5.0 # Texto a voz

    #Instrucciones de Uso
    ##Navegación
    Este proyecto utiliza una barra de navegación inferior (BottomNavigationBar) para navegar entre las diferentes pantallas:
    Perfil: Pantalla principal donde puedes ver la información del perfil.
    Geolocalización: Obtén y muestra la ubicación actual del dispositivo.
    QR Scanner: Escanea códigos QR usando la cámara del dispositivo.
    Sensores: Accede y visualiza los datos de los sensores del dispositivo.
    Habla (Reconocimiento de Voz): Convierte lo que dices en texto.
    Sonido (Texto a Voz): Convierte el texto que ingreses en voz.# app-movil-C2
