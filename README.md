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
3. **Taller 2 (Cronometro con Timer):** Control temporal con `Timer.periodic`, botones de accion (*Iniciar*, *Pausar*, *Reanudar*, *Reiniciar*), formato digital y liberacion estricta de memoria en `dispose()`.
4. **Taller 2 (Isolate para Tareas Pesadas):** Computacion intensiva CPU-bound mediante `Isolate.spawn` y comunicacion por `ReceivePort`/`SendPort` sin congelar el hilo de interfaz (UI fluida a 60 FPS).

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
             │◄── SendPort.send(resultadoMap) ───────────────┤ (Cálculo finalizado)
             │                                               │
   [ReceivePort recibe mensaje]                              X (isolate.kill / cierre)
             │
   [Muestra tiempo y primos en pantalla]
```

---

## Flujo de Ramas Git (Git Flow)

Siguiendo las directrices del curso:

```
[main]  ◄─── Merge PR #4 ───  [dev]  ◄─── Merge PR #3 ───  [feature/taller_segundo_plano]
```

* `main`: Rama de produccion y entregas estables.
* `dev`: Rama de desarrollo e integracion continua.
* `feature/taller1`: Rama correspondiente al Taller 1 (Widgets).
* `feature/taller_segundo_plano`: Rama de desarrollo del Taller 2 (Asincronia, Timer, Isolate).

---

## Instrucciones de Ejecucion

```bash
# 1. Clonar el repositorio
git clone https://github.com/BreiK-at/Taller-flutter.git
cd Taller-flutter

# 2. Cambiar a la rama de caracteristicas de segundo plano
git checkout feature/taller_segundo_plano

# 3. Descargar paquetes y dependencias
flutter pub get

# 4. Ejecutar pruebas automatizadas
flutter test

# 5. Ejecutar la aplicacion
flutter run
```