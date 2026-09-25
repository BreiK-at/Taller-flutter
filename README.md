# Taller 1: StatefulWidget, setState y Flujo de Trabajo en Git

Este repositorio contiene la solución completa para el **Taller 1** de la asignatura **Electiva Profesional I**, enfocado en la construcción de interfaces reactivas en **Flutter** utilizando `StatefulWidget` y `setState()`, junto con un flujo de trabajo estructurado en **Git (Git Flow)**.

---

## 👤 Datos del Estudiante

* **Estudiante:** Michael Stiven Vasco Cárdenas
* **Código:** 230231047
* **Asignatura:** Electiva Profesional I
* **Docente / Institución:** UCEVA (Unidad Central del Valle del Cauca)
* **Rama de desarrollo del taller:** `feature/taller1`

---

## 🎯 Objetivo del Taller

1. Construir una pantalla básica en Flutter aplicando el manejo del estado reactivo mutable con `StatefulWidget` y `setState()`.
2. Aplicar buenas prácticas de control de versiones con Git, respetando la arquitectura de ramas:
   - `main`: Rama de producción / estable.
   - `dev`: Rama de desarrollo base.
   - `feature/taller1`: Rama de características para este taller.
3. Integrar los cambios mediante Pull Requests (`feature/taller1` ➔ `dev` y posteriormente `dev` ➔ `main`).

---

## 🛠️ Requisitos Técnicos Implementados

1. **Pantalla Principal (`HomePage`):**
   - Implementada con `StatefulWidget`.
   - `AppBar` con título inicial variable `"Hola, Flutter"`.
   - `Text` centrado con el nombre completo del estudiante: **Michael Stiven Vasco Cárdenas**, código y materia.
2. **Row con Imágenes:**
   - `Image.network()`: Cargando el isotipo oficial de Flutter desde almacenamiento en la nube con indicadores de carga y gestión de errores.
   - `Image.asset()`: Cargando recurso local configurado en `assets/images/flutter_logo.png` y declarado en `pubspec.yaml`.
3. **Botón Interactivo y `setState()`:**
   - `ElevatedButton.icon`: Alterna el título de la AppBar entre `"Hola, Flutter"` y `"¡Título cambiado!"`.
   - Despliegue de un `SnackBar` flotante con el mensaje: **"Título actualizado"**.
4. **Widgets Adicionales Implementados (3 widgets para enriquecer la interfaz):**
   - **`Container`:** Diseñado con bordes redondeados (`BorderRadius`), sombra suave (`BoxShadow`), padding y márgenes decorativos.
   - **`Stack`:** Superposición de un badge de estado activo (`Positioned`) y textos sobre un fondo con gradiente visual.
   - **`ListView`:** Lista informativa vertical estructurada con `ListTile`, avatars circulares e iconos alusivos al taller.

---

## 🚀 Pasos para Ejecutar el Proyecto

Sigue estos pasos en tu terminal para clonar y ejecutar la aplicación en cualquier entorno (Linux, Web, Android, iOS o Windows):

```bash
# 1. Clonar el repositorio
git clone https://github.com/BreiK-at/Taller-flutter.git
cd Taller-flutter

# 2. Cambiar a la rama del taller (si deseas revisar la rama feature)
git checkout feature/taller1

# 3. Obtener las dependencias de Flutter
flutter pub get

# 4. Ejecutar pruebas unitarias y de widgets
flutter test

# 5. Ejecutar la aplicación
flutter run
```

---

## 🌿 Flujo de Ramas en Git (Git Flow)

Siguiendo el esquema del taller:
```
[main] ◄────── PR #2 Merge ────── [dev] ◄────── PR #1 Merge ────── [feature/taller1]
(Producción)                     (Desarrollo)                     (Taller 1)
```

1. **Ramas Base:**
   - `main`: Código probado y estable en producción.
   - `dev`: Rama integradora de desarrollo.
2. **Rama del Taller:**
   - `feature/taller1`: Rama donde se realizaron todos los commits y desarrollos del taller.
3. **Pull Requests:**
   - **PR #1:** `feature/taller1` ➔ `dev` (Aprobado e integrado).
   - **PR #2:** `dev` ➔ `main` (Aprobado e integrado a producción).

---

## 📸 Evidencias de Ejecución

Las capturas de pantalla de la aplicación y del flujo en GitHub se encuentran organizadas en `docs/screenshots/` y detalladas en el informe PDF entregable:
1. **Estado Inicial:** Título "Hola, Flutter", datos del estudiante e imágenes en Row.
2. **Estado Reactivo:** Cambio de título a "¡Título cambiado!" tras presionar el botón y visualización del `SnackBar` flotante.
3. **Widgets Adicionales:** Visualización del `Container` estilizado, el widget `Stack` con gradiente y el `ListView` informativo.
4. **Pull Requests en GitHub:** Evidencias de los PRs cerrados y fusionados hacia `dev` y `main`.