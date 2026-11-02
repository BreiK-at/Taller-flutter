# Talleres de Desarrollo Móvil en Flutter

**Estudiante:** Michael Stiven Vasco Cárdenas  
**Código Estudiantil:** 230231047  
**Asignatura:** Electiva Profesional I  
**Institución:** UCEVA (Unidad Central del Valle del Cauca)  
**Repositorio Oficial:** https://github.com/BreiK-at/Taller-flutter  

---

## Estructura de Talleres en el Repositorio

El proyecto integra los talleres de la asignatura mediante una barra de navegacion principal organizada en cuatro modulos:

1. **Taller 1 (Widgets y Estado Base):** Demostracion de `StatefulWidget`, mutacion con `setState()`, `Row` de imagenes (Network y Asset), `SnackBar` y widgets complementarios (`Container`, `Stack`, `ListView`).
2. **Taller 2 (Asincronia con Future):** Consumo simulado no bloqueante con `Future.delayed`, manejo de estados (*Cargando*, *Exito*, *Error*) y orden de ejecucion en consola.
3. **Taller 3 (Cronometro con Timer):** Control temporal con `Timer.periodic`, botones de accion (*Iniciar*, *Pausar*, *Reanudar*, *Reiniciar*), formato digital y liberacion estricta de memoria en `dispose()`.
4. **Taller 4 (Isolate para Tareas Pesadas):** Computacion intensiva CPU-bound mediante `Isolate.spawn` y comunicacion por `ReceivePort`/`SendPort` sin congelar el hilo de interfaz (UI fluida a 60 FPS).

---

## Fundamentacion Teorica: Cuando usar cada mecanismo

| Mecanismo | Caso de Uso Principal | Bloquea Hilo de UI? | Como Funciona Internamente |
| :--- | :--- | :---: | :--- |
| **`Future` y `async`/`await`** | Operaciones I/O bound (peticiones HTTP, lectura de archivos, consultas SQLite, temporizadores simples). | **No** | Envia la tarea al *Event Queue* del Event Loop de Dart. El hilo principal sigue ejecutando codigo y atiende la respuesta cuando el recurso externo finaliza. |
| **`Timer` (`dart:async`)** | Eventos recurrentes basados en tiempo (cronometros, cuentas regresivas, sondeos periodicos, debouncing). | **No** | Agenda callbacks en el Event Loop en intervalos definidos. Requiere cancelacion explicita (`timer.cancel()`) en `dispose()` para evitar fugas de memoria. |
| **`Isolate` (`dart:isolate`)** | Tareas CPU-bound intensivas (calculos matematicos complejos, compresion de imagenes, procesamiento de grandes volumenes de datos o cifrado). | **No** | Crea un hilo nativo independiente con su propia memoria heap separada y su propio Event Loop. La comunicacion se realiza exclusivamente por paso de mensajes (`SendPort` / `ReceivePort`). |

---

## Diagramas de Flujo y Arquitectura

### 1. Flujo de Asincronia (Future / async / await)

```
[Usuario presiona 'Consultar']
              │
              ▼
   [Estado: Cargando (Spinner)]  <───  UI activa y reactiva
              │
   [Future.delayed (2.5s)]       <───  Event Loop atiende evento
              │
     ┌────────┴────────┐
     ▼                 ▼
  [Exito]           [Error]
(Muestra lista    (Captura en catch
 de 4 registros)   y opcion Reintentar)
```

### 2. Flujo del Cronometro (Timer.periodic)

```
[Iniciar]   ───► [Timer.periodic cada 100 ms] ───► [+100 ms en cada tick]
    │                                                      │
[Pausar]    ───► [timer.cancel()] (Conserva tiempo)        │
    │                                                      │
[Reanudar]  ───► [Nuevo Timer.periodic] ───────────────────┘
    │
[Reiniciar] ───► [timer.cancel() + Tiempo = 00:00.0]
    │
[dispose()] ───► [timer?.cancel()] (Limpieza obligatoria de recursos)
```

### 3. Flujo de Tarea Pesada en Isolate (Isolate.spawn)

```
[Hilo Principal (Main Isolate)]               [Isolate Secundario (Worker)]
             │                                               │
             ├─── Isolate.spawn(tarea, sendPort) ───────────►│ (Inicia calculo CPU-bound:
             │                                               │  evaluacion de 3M de numeros)
  (UI fluida a 60 FPS:                       │
   Rueda animada girando y clicks activos)                   │
             │                                               │
             │◄── SendPort.send(resultadoMap) ───────────────┤ (Calculo finalizado)
             │                                               │
   [ReceivePort recibe mensaje]                              X (isolate.kill / cierre)
             │
   [Muestra tiempo y primos en pantalla]
```

---

## Flujo de Ramas Git (Git Flow)

Siguiendo las directrices del curso:

```
Taller 1: [main] ◄── PR #2 Merge ── [dev] ◄── PR #1 Merge ── [feature/taller1]
Taller 2: [main] ◄── PR #4 Merge ── [dev] ◄── PR #3 Merge ── [feature/taller2]
```

1. **Ramas Base:**
   * `main`: Codigo probado y estable en produccion.
   * `dev`: Rama base integradora de desarrollo continuo.
2. **Ramas de Taller:**
   * `feature/taller1`: Rama de desarrollo del Taller 1 (Widgets y Reactividad).
   * `feature/taller2`: Rama de desarrollo del Taller 2 (Asincronia, Timer e Isolate).
3. **Pull Requests:**
   * **PR #1:** `feature/taller1` -> `dev` (Taller 1 integrado).
   * **PR #2:** `dev` -> `main` (Taller 1 desplegado a produccion).
   * **PR #3:** `feature/taller2` -> `dev` (Taller 2 integrado).
   * **PR #4:** `dev` -> `main` (Taller 2 desplegado a produccion).

---

## Instrucciones de Ejecucion

```bash
# 1. Clonar el repositorio
git clone https://github.com/BreiK-at/Taller-flutter.git
cd Taller-flutter

# 2. Cambiar a la rama de distribucion
git checkout feature/app_distribution

# 3. Descargar paquetes y dependencias
flutter pub get

# 4. Compilar APK en modo release
flutter build apk --release

# 5. Ejecutar la aplicacion localmente en Linux
flutter run -d linux
```

---

## Distribucion y Pruebas con Firebase App Distribution

### 1. Flujo de Trabajo
```
[Generar APK Release]
         │  (flutter build apk --release)
         ▼
[Firebase App Distribution]
         │  (Subir app-release.apk a la consola)
         ▼
[Grupo de Testers: QA_Clase]
         │  (Asignar dduran@uceva.edu.co y tester local)
         ▼
[Instalacion en Dispositivo]
         │  (Instalacion inicial v1.0.0 via enlace / App Tester)
         ▼
[Actualizacion Incremental]
         │  (Compilar v1.0.1+2, subir release y actualizar en el dispositivo)
         ▼
[Cierre de QA y Evidencias]
```

### 2. Seccion de Publicacion y Replicacion

Para replicar el proceso de distribucion dentro del equipo de desarrollo:

1. **Permisos y Manifiesto Android:**
   Asegurar los permisos de red en `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
   ```
2. **Registro de la aplicacion en Firebase Console:**
   * Crear proyecto en [Firebase Console](https://console.firebase.google.com).
   * Registrar app Android utilizando el `applicationId` configurado en `android/app/build.gradle.kts`: `com.breikat.taller_flutter`.
3. **Configuracion de Testers y Grupos:**
   * Ingresar a **App Distribution** > pestana **Testers y grupos**.
   * Crear el grupo `QA_Clase`.
   * Agregar los correos evaluadores: `dduran@uceva.edu.co` y el correo del desarrollador/tester.
4. **Carga y Distribucion de Releases:**
   * Ir a la pestana **Releases** y arrastrar el archivo `build/app/outputs/flutter-apk/app-release.apk`.
   * Redactar las Release Notes correspondientes.
   * Asignar el release al grupo `QA_Clase` y presionar **Distribuir a 1 grupo**.

---

### 3. Esquema de Versionado y Release Notes

Se utiliza versionamiento semantico `MAJOR.MINOR.PATCH+BUILD_NUMBER` en `pubspec.yaml`:

| Version | Build Code | Tipo de Release | Descripcion de Cambios |
| :---: | :---: | :--- | :--- |
| **`1.0.0`** | `1` | Release Inicial | Version base con modulos de Widgets (Taller 1), Asincronia (Taller 2), Cronometro (Taller 3) e Isolate (Taller 4). Permisos de red configurados. |
| **`1.0.1`** | `2` | Actualizacion Incremental | Optimizacion de empaquetado, badge visual de version en barra inferior e integracion de comprobacion de ciclo de vida QA. |

#### Formato estandar de Release Notes utilizado:
```text
Versión [X.Y.Z] (Build [N]) - [Fecha]
- Módulos / Cambios principales incluidos.
- Correcciones o adiciones de configuración.
- Responsable: Michael Vasco (230231047).
- Entorno de prueba: Android 10+ / QA_Clase.
```

---

### 4. Bitacora de QA (Aseguramiento de Calidad)

| Version | Fecha | Cambios Realizados | Incidencia Identificada | Resolucion Aplicada | Estado Final |
| :---: | :---: | :--- | :--- | :--- | :---: |
| **v1.0.0 (1)** | 02/11/2026 | Empaquetado release inicial de la suite completa de talleres. | Omision inicial de permisos `INTERNET` en el manifiesto Android. | Se agregaron permisos `INTERNET` y `ACCESS_NETWORK_STATE` en `AndroidManifest.xml`. | **Aprobado** |
| **v1.0.1 (2)** | 02/11/2026 | Incremento de version, barra inferior con identificador de version y compilacion release. | Necesidad de confirmacion visual in-app del salto de version. | Se anadio banner informativo con version y codigo estudiantil en la interfaz. | **Aprobado** |

---

### 5. Flujo GitFlow de esta Entrega

```
[main] ◄── PR #6 Merge ── [dev] ◄── PR #5 Merge ── [feature/app_distribution]
```
- **Rama origen:** `feature/app_distribution` (creada a partir de `dev`).
- **PR #5:** `feature/app_distribution` -> `dev`.
- **PR #6:** `dev` -> `main`.

