# Caja Registradora Virtual (RegistraApp)

## Introducción

RegistraApp es una aplicación móvil en desarrollo, construida con Flutter y Dart, diseñada para funcionar como una caja registradora virtual simple. Su objetivo es ayudar a pequeños negocios a gestionar sus ventas diarias, tanto en efectivo como digitales, con un enfoque especial en la captura de montos desde comprobantes de pago digitales mediante la cámara del dispositivo (funcionalidad futura con OCR).

## Características Principales (Planificadas)

* **Gestión de Ventas:** Registro de ventas diferenciando entre Efectivo y Digital.
* **Captura OCR:** (Futuro) Usar la cámara para capturar comprobantes de pago digitales (transferencias, capturas de pantalla) y extraer automáticamente el monto (requiere validación del usuario).
* **Listado Diario:** Visualización de las ventas del día actual con un totalizador.
* **Historial:** Acceso a ventas de días anteriores mediante un calendario.
* **Almacenamiento Local:** Persistencia de datos (usuarios, ventas) en una base de datos SQLite local gestionada mediante el paquete `drift`.
* **Roles de Usuario:** Diferenciación entre roles de "Supervisor" y "Empleado".
* **Permisos:** Restricciones para empleados (ej. no pueden eliminar/modificar ventas sin autorización).
* **Autorización (MVP Local):** Mecanismo inicial para que el Supervisor autorice modificaciones mediante la generación e intercambio de un archivo/QR seguro.
* **Gestión de Establecimiento:** Posibilidad de configurar el nombre del negocio.
* **Interfaz Clara:** Diseño visual que diferencie tipos de venta y sea fácil de usar.
* **(Futuro) Periodo de Prueba:** Funcionalidad opcional de activación tras 7 días.
* **(Futuro) Backup/Exportación:** Opción para exportar datos localmente y/o realizar copias de seguridad en servicios cloud (Google Drive, OneDrive).
* **(Futuro) Autorización Remota:** Posibilidad de conectar roles Supervisor/Empleado vía internet para autorizaciones (requerirá un backend).

## Tecnologías Utilizadas

* **Framework:** Flutter (v3.x)
* **Lenguaje:** Dart (con Null Safety)
* **Base de Datos Local:** SQLite gestionada con `drift`
* **Hashing Contraseñas:** SHA-256 (`package:crypto`)
* **Gestión de Estado (Inicial):** `StatefulWidget` (`setState`), se evaluará `provider` u otro más adelante.
* **Control de Versiones:** Git / GitHub

## Estado Actual del Proyecto (11 de Abril de 2025)

* **Fase 0: Fundamentos y Configuración:** ✅ **Completada**
    * Entorno configurado, proyecto base creado y funcional.
    * Modelos de datos (`Usuario`, `Venta`, `Establecimiento`) definidos.
    * Lista de pantallas planificada.
    * Estructura de carpetas modular iniciada.

* **Fase 1: Funcionalidad Núcleo (MVP):** ⏳ **En Progreso**
    * **Autenticación Local:**
        * UI: Pantallas de Bienvenida, Login (básica), Registro (completa) implementadas.
        * Lógica Registro: **Completa** (Validación, Hashing, Guardado en DB `drift`, Feedback, Navegación).
        * Lógica Login: ⚪ **Pendiente**.
    * **Base de Datos Local:**
        * Configurada con `drift` para tabla `Usuarios`.
        * Código (`.g.dart`) generado.
        * Método `insertUsuario` funcional.
        * Métodos de consulta (ej. `getUsuarioPorEmail`) pendientes.
    * **Gestión de Ventas/Establecimiento:** ⚪ **Pendiente**.

* **Fase 2: Digital Payment & OCR:** ⚪ **Pendiente**
* **Fase 3: Roles & Permissions:** ⚪ **Pendiente**
* **Fase 4: Enhancements & Refinements:** ⚪ **Pendiente**
* **Fase 5: Advanced Features:** ⚪ **Pendiente**

* **Rama Actual de Desarrollo:** `fase-autenticacion_registro_db`

## Cómo Empezar (Configuración del Proyecto)

1.  Clonar el repositorio: `git clone https://github.com/PseudoIA/registraapp.git` (Ajusta la URL si es diferente)
2.  Asegurarse de tener Flutter SDK instalado: [Guía de Instalación Flutter](https://docs.flutter.dev/get-started/install)
3.  Navegar a la carpeta del proyecto: `cd registraap`
4.  Obtener dependencias: `flutter pub get`
5.  Generar código de base de datos: `dart run build_runner build --delete-conflicting-outputs`
6.  Ejecutar la aplicación en un emulador o dispositivo conectado: `flutter run`

## Próximos Pasos Inmediatos

* Implementar la lógica del botón "Ingresar" en `LoginScreen`.
    * Añadir método de consulta (`getUsuarioPorEmail`) a `AppDatabase`.
    * Realizar la consulta y comparación de hash de contraseña.
    * Implementar navegación a pantalla principal (placeholder) o mostrar error.

---