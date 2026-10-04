import 'package:flutter/material.dart';
import '../services/isolate_service.dart';

class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});

  @override
  State<IsolateScreen> createState() => _IsolateScreenState();
}

class _IsolateScreenState extends State<IsolateScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  bool _calculandoIsolate = false;
  bool _calculandoMainThread = false;

  Map<String, dynamic>? _resultadoIsolate;
  Map<String, dynamic>? _resultadoMainThread;

  final List<String> _logsIsolate = [];
  int _contadorClicksPrueba = 0;

  @override
  void initState() {
    super.initState();
    // Animación continua giratoria para evidenciar visualmente si la UI se congela o no
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _agregarLog(String log) {
    setState(() {
      _logsIsolate.add(log);
    });
  }

  // 1. EJECUCIÓN RECOMENDADA CON ISOLATE.SPAWN (NO BLOQUEA LA UI)
  Future<void> _ejecutarEnSegundoPlano() async {
    setState(() {
      _calculandoIsolate = true;
      _resultadoIsolate = null;
      _logsIsolate.clear();
    });

    final inicio = DateTime.now().toIso8601String().substring(11, 19);
    _agregarLog('[$inicio] [1. MAIN] Invocando Isolate.spawn() con ReceivePort...');
    _agregarLog('[$inicio] [2. ISOLATE] Ejecutando cálculo CPU-bound en núcleo independiente.');
    _agregarLog('[$inicio] [UI] Observa la rueda giratoria: ¡Gira 100% fluida!');

    try {
      final resultado = await IsolateService.ejecutarTareaEnIsolate();

      if (!mounted) return;

      final fin = DateTime.now().toIso8601String().substring(11, 19);
      _agregarLog('[$fin] [3. MAIN] Mensaje recibido vía SendPort/ReceivePort.');
      _agregarLog('[$fin] [RESULTADO] ${resultado['primos']} primos hallados en ${resultado['tiempoMs']} ms.');

      setState(() {
        _resultadoIsolate = resultado;
        _calculandoIsolate = false;
      });
    } catch (e) {
      if (!mounted) return;
      _agregarLog('[ERROR] Falló la ejecución en Isolate: $e');
      setState(() {
        _calculandoIsolate = false;
      });
    }
  }

  // 2. EJECUCIÓN COMPARATIVA EN MAIN THREAD (BLOQUEA LA UI)
  void _ejecutarEnMainThreadDirecto() {
    setState(() {
      _calculandoMainThread = true;
      _resultadoMainThread = null;
    });

    // Pequeño delay de 50ms para que la UI pinte el estado antes de congelarse
    Future.delayed(const Duration(milliseconds: 50), () {
      final resultado = IsolateService.ejecutarEnMainThread();
      if (!mounted) return;
      setState(() {
        _resultadoMainThread = resultado;
        _calculandoMainThread = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate (Tarea Pesada)'),
        backgroundColor: const Color(0xFFEA580C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner explicativo de Isolate
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDBA74)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.memory, color: Color(0xFFEA580C), size: 32),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Isolate.spawn & Paso de Mensajes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9A3412),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Cálculo intensivo CPU-bound (evaluación de 3M de números) en hilo independiente sin congelar la UI.',
                          style: TextStyle(fontSize: 12.5, color: Color(0xFF7C2D12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // MONITOR DE FLUIDEZ EN TIEMPO REAL
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFED7AA)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Rueda animada continua
                  RotationTransition(
                    turns: _animController,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const SweepGradient(
                          colors: [
                            Color(0xFFEA580C),
                            Color(0xFFFDBA74),
                            Color(0xFFEA580C),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withAlpha(40),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.sync, color: Colors.white, size: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Monitor de Fluidez de la UI',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1C1917),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _calculandoIsolate
                              ? '🟢 Isolate corriendo: ¡La animación NO se detiene!'
                              : (_calculandoMainThread
                                  ? '🔴 Main Thread: ¡UI CONGELADA!'
                                  : 'Giro continuo a 60 FPS (Prueba tocar el botón)'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _calculandoIsolate
                                ? const Color(0xFF15803D)
                                : (_calculandoMainThread
                                    ? const Color(0xFFB91C1C)
                                    : const Color(0xFF78716C)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Botón interactivo para probar clicks
                  IconButton.filledTonal(
                    onPressed: () {
                      setState(() {
                        _contadorClicksPrueba++;
                      });
                    },
                    icon: Text(
                      '$_contadorClicksPrueba',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    tooltip: 'Toca aquí durante el cálculo',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // BOTÓN PRINCIPAL: Ejecutar con Isolate.spawn
            ElevatedButton.icon(
              onPressed: (_calculandoIsolate || _calculandoMainThread)
                  ? null
                  : _ejecutarEnSegundoPlano,
              icon: _calculandoIsolate
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.flash_on),
              label: Text(
                _calculandoIsolate
                    ? 'Calculando en Isolate (UI Activa)...'
                    : 'Ejecutar Tarea Pesada con Isolate.spawn()',
                style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEA580C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),

            const SizedBox(height: 10),

            // BOTÓN COMPARATIVO: Ejecutar en Main Thread (Demostración de bloqueo)
            OutlinedButton.icon(
              onPressed: (_calculandoIsolate || _calculandoMainThread)
                  ? null
                  : _ejecutarEnMainThreadDirecto,
              icon: const Icon(Icons.warning_amber_rounded),
              label: Text(
                _calculandoMainThread
                    ? 'Bloqueando Main Thread...'
                    : 'Comparar: Ejecutar en Main Thread (Congela UI)',
                style: const TextStyle(fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626),
                side: const BorderSide(color: Color(0xFFFCA5A5)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CAJA DE CONSOLA / LOGS EN VIVO
            if (_logsIsolate.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1917),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF44403C)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.terminal, color: Color(0xFFFB923C), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Trazabilidad Isolate (Puertos y Mensajes):',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFB923C),
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF44403C), height: 16),
                    ..._logsIsolate.map((log) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            log,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFE7E5E4),
                              fontFamily: 'monospace',
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // RESULTADOS DE EJECUCIÓN
            if (_resultadoIsolate != null) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Color(0xFF15803D), size: 24),
                        SizedBox(width: 10),
                        Text(
                          'Resultado en Isolate Secundario:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF14532D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _itemResultado(
                      'Tiempo de Ejecución:',
                      '${_resultadoIsolate!['tiempoMs']} ms (~${(_resultadoIsolate!['tiempoMs'] / 1000).toStringAsFixed(2)}s)',
                      const Color(0xFF15803D),
                    ),
                    _itemResultado(
                      'Primos Encontrados:',
                      '${_resultadoIsolate!['primos']} números',
                      const Color(0xFF15803D),
                    ),
                    _itemResultado(
                      'Rango Evaluado:',
                      '2 hasta ${_resultadoIsolate!['limite']}',
                      const Color(0xFF15803D),
                    ),
                    _itemResultado(
                      'Impacto en la UI:',
                      '0 ms de congelamiento (Fluidez total)',
                      const Color(0xFF0D9488),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (_resultadoMainThread != null) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFCA5A5), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning, color: Color(0xFFDC2626), size: 24),
                        SizedBox(width: 10),
                        Text(
                          'Resultado en Main Thread (Bloqueante):',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF991B1B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _itemResultado(
                      'Tiempo de Congelamiento:',
                      '${_resultadoMainThread!['tiempoMs']} ms (UI paralizada)',
                      const Color(0xFFDC2626),
                    ),
                    _itemResultado(
                      'Primos Encontrados:',
                      '${_resultadoMainThread!['primos']} números',
                      const Color(0xFF991B1B),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _itemResultado(String titulo, String valor, Color colorValor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 13, color: Color(0xFF44403C)),
          ),
          Text(
            valor,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: colorValor,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
