import 'package:flutter/material.dart';
import '../services/data_service.dart';

enum EstadoCarga { inicial, cargando, exito, error }

class AsyncScreen extends StatefulWidget {
  const AsyncScreen({super.key});

  @override
  State<AsyncScreen> createState() => _AsyncScreenState();
}

class _AsyncScreenState extends State<AsyncScreen> {
  EstadoCarga _estado = EstadoCarga.inicial;
  List<TareaAsincrona> _tareas = [];
  String _mensajeError = '';
  final List<String> _logsConsola = [];

  void _agregarLog(String log) {
    setState(() {
      _logsConsola.add(log);
    });
  }

  Future<void> _ejecutarConsulta({bool simularError = false}) async {
    setState(() {
      _estado = EstadoCarga.cargando;
      _mensajeError = '';
      _logsConsola.clear();
    });

    final inicio = DateTime.now().toIso8601String().substring(11, 19);
    _agregarLog('[$inicio] [1. ANTES] Solicitando datos con Future...');
    _agregarLog('[$inicio] [2. DURANTE] Esperando 2.5s con await (UI activa)...');

    try {
      // Invocacion asincrona no bloqueante
      final resultado = await DataService.consultarTareasRemotas(forzarError: simularError);

      if (!mounted) return;

      final fin = DateTime.now().toIso8601String().substring(11, 19);
      _agregarLog('[$fin] [3. DESPUES] Datos recibidos con exito: ${resultado.length} registros.');

      setState(() {
        _tareas = resultado;
        _estado = EstadoCarga.exito;
      });
    } catch (e) {
      if (!mounted) return;

      final fin = DateTime.now().toIso8601String().substring(11, 19);
      _agregarLog('[$fin] [3. DESPUES] Excepcion capturada: ${e.toString()}');

      setState(() {
        _mensajeError = e.toString().replaceAll('Exception: ', '');
        _estado = EstadoCarga.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asincronia (Future / await)'),
        backgroundColor: const Color(0xFFEA580C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarjeta explicativa con acento calido
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEA580C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.bolt, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Peticiones No Bloqueantes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9A3412),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Consulta simulada a servicio remoto con Future.delayed (2.5s) sin congelar la interfaz.',
                          style: TextStyle(fontSize: 12.5, color: Color(0xFF7C2D12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botones de accion
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _estado == EstadoCarga.cargando
                        ? null
                        : () => _ejecutarConsulta(simularError: false),
                    icon: const Icon(Icons.cloud_download),
                    label: const Text('Consultar (Exito)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEA580C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _estado == EstadoCarga.cargando
                        ? null
                        : () => _ejecutarConsulta(simularError: true),
                    icon: const Icon(Icons.error_outline),
                    label: const Text('Simular Error'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFFCA5A5), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Caja de Consola / Logs en vivo
            if (_logsConsola.isNotEmpty) ...[
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
                          'Trazabilidad en Consola (Orden de ejecucion):',
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
                    ..._logsConsola.map((log) => Padding(
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
              const SizedBox(height: 22),
            ],

            // Contenedor dinamico segun el estado
            _construirContenidoEstado(),
          ],
        ),
      ),
    );
  }

  Widget _construirContenidoEstado() {
    switch (_estado) {
      case EstadoCarga.inicial:
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFED7AA)),
          ),
          child: Column(
            children: [
              Icon(Icons.touch_app_outlined, size: 54, color: Colors.orange.shade300),
              const SizedBox(height: 12),
              const Text(
                'Presiona "Consultar (Exito)" o "Simular Error"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF44403C),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Observa como la interfaz reacciona con Future y async/await.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF78716C)),
              ),
            ],
          ),
        );

      case EstadoCarga.cargando:
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
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
          child: Column(
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEA580C)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Cargando datos remotos...',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9A3412),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Esperando resolucion de Future.delayed (2.5 s)...',
                style: TextStyle(fontSize: 13, color: Color(0xFF78716C)),
              ),
            ],
          ),
        );

      case EstadoCarga.error:
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFCA5A5)),
          ),
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 52, color: Color(0xFFDC2626)),
              const SizedBox(height: 12),
              const Text(
                'Ocurrio un error en la consulta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF991B1B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _mensajeError,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFFB91C1C)),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _ejecutarConsulta(simularError: false),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar consulta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );

      case EstadoCarga.exito:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tareas Remotas Cargadas:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C1917),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: const Text(
                    'Estado: Exito',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tareas.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final tarea = _tareas[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFED7AA)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withAlpha(15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFFEDD5)),
                        ),
                        child: Icon(tarea.icono, color: const Color(0xFFEA580C), size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    tarea.titulo,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1C1917),
                                    ),
                                  ),
                                ),
                                Text(
                                  tarea.tiempoEstimado,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFEA580C),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tarea.descripcion,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF78716C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
    }
  }
}
