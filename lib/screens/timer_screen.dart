import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // Instancia de Timer para el cronómetro
  Timer? _timer;

  // Estado del cronómetro en milisegundos
  int _milisegundos = 0;
  bool _estaCorriendo = false;
  bool _estaPausado = false;

  final List<String> _vueltas = [];

  @override
  void dispose() {
    // LIMPIEZA DE RECURSOS (Requisito obligatorio):
    // Cancelar el Timer activo cuando el widget se destruye para evitar memory leaks
    _timer?.cancel();
    debugPrint('🧹 [TimerScreen] dispose(): Timer cancelado y recursos liberados correctamente.');
    super.dispose();
  }

  // 1. INICIAR CRONÓMETRO
  void _iniciarTimer() {
    _timer?.cancel(); // Cancelar cualquier timer remanente
    setState(() {
      _estaCorriendo = true;
      _estaPausado = false;
    });

    debugPrint('▶️ [Timer] Cronómetro INICIADO.');

    // Actualización periódica cada 100 milisegundos para alta precisión
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _milisegundos += 100;
      });
    });
  }

  // 2. PAUSAR CRONÓMETRO
  void _pausarTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel(); // Detener el flujo del timer
      setState(() {
        _estaCorriendo = false;
        _estaPausado = true;
      });
      debugPrint('⏸️ [Timer] Cronómetro PAUSADO en: ${_formatearTiempo(_milisegundos)}');
    }
  }

  // 3. REANUDAR CRONÓMETRO
  void _reanudarTimer() {
    setState(() {
      _estaCorriendo = true;
      _estaPausado = false;
    });

    debugPrint('⏯️ [Timer] Cronómetro REANUDADO.');

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _milisegundos += 100;
      });
    });
  }

  // 4. REINICIAR CRONÓMETRO
  void _reiniciarTimer() {
    _timer?.cancel();
    setState(() {
      _milisegundos = 0;
      _estaCorriendo = false;
      _estaPausado = false;
      _vueltas.clear();
    });
    debugPrint('🔄 [Timer] Cronómetro REINICIADO a 00:00.0.');
  }

  // Registro de vuelta / lap
  void _registrarVuelta() {
    if (_milisegundos > 0) {
      setState(() {
        _vueltas.insert(0, _formatearTiempo(_milisegundos));
      });
    }
  }

  // Función de formateo: MM:SS.d
  String _formatearTiempo(int totalMs) {
    final int minutos = (totalMs ~/ 60000);
    final int segundos = ((totalMs % 60000) ~/ 1000);
    final int decimas = ((totalMs % 1000) ~/ 100);

    final String minStr = minutos.toString().padLeft(2, '0');
    final String segStr = segundos.toString().padLeft(2, '0');

    return '$minStr:$segStr.$decimas';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronómetro con Timer'),
        backgroundColor: const Color(0xFFEA580C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner explicativo del Timer
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
                  Icon(Icons.av_timer, color: Color(0xFFEA580C), size: 32),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Timer.periodic (100 ms)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9A3412),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Control de tiempo reactivo con Iniciar, Pausar, Reanudar y Reiniciar con limpieza en dispose().',
                          style: TextStyle(fontSize: 12.5, color: Color(0xFF7C2D12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // MARCADOR DIGITAL GRANDE (ESTILO DISPLAY ÁMBAR RETRO-MODERNO)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1917), // Fondo negro carbón
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFF97316), width: 2), // Borde ámbar brillante
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEA580C).withAlpha(50),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _estaCorriendo
                              ? const Color(0xFF22C55E)
                              : (_estaPausado ? const Color(0xFFF59E0B) : const Color(0xFF78716C)),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _estaCorriendo
                            ? 'ACTIVO / CORRIENDO'
                            : (_estaPausado ? 'PAUSADO' : 'DETENIDO'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: _estaCorriendo
                              ? const Color(0xFF4ADE80)
                              : (_estaPausado ? const Color(0xFFFBBF24) : const Color(0xFFA8A29E)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Tiempo grande formateado
                  Text(
                    _formatearTiempo(_milisegundos),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Color(0xFFFB923C), // Naranja neón / ámbar
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'MINUTOS : SEGUNDOS . DÉCIMAS',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Color(0xFF78716C),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // BOTONERA DE CONTROLES: Iniciar / Pausar / Reanudar / Reiniciar
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                // Botón Iniciar (visible solo cuando está inactivo)
                if (!_estaCorriendo && !_estaPausado)
                  ElevatedButton.icon(
                    onPressed: _iniciarTimer,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Iniciar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEA580C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                // Botón Pausar (visible cuando está corriendo)
                if (_estaCorriendo)
                  ElevatedButton.icon(
                    onPressed: _pausarTimer,
                    icon: const Icon(Icons.pause),
                    label: const Text('Pausar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706), // Ámbar oscuro
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                // Botón Reanudar (visible cuando está pausado)
                if (_estaPausado)
                  ElevatedButton.icon(
                    onPressed: _reanudarTimer,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Reanudar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488), // Verde azulado
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                // Botón Vuelta / Lap (disponible si está corriendo)
                if (_estaCorriendo)
                  OutlinedButton.icon(
                    onPressed: _registrarVuelta,
                    icon: const Icon(Icons.flag_outlined),
                    label: const Text('Vuelta'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEA580C),
                      side: const BorderSide(color: Color(0xFFFDBA74)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                // Botón Reiniciar
                ElevatedButton.icon(
                  onPressed: (_milisegundos > 0 || _estaCorriendo || _estaPausado)
                      ? _reiniciarTimer
                      : null,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reiniciar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF44403C), // Gris piedra oscuro
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade200,
                    disabledForegroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Registro de vueltas / marcas de tiempo
            if (_vueltas.isNotEmpty) ...[
              const Text(
                'Marcas de Vuelta:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C1917),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFED7AA)),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _vueltas.length > 5 ? 5 : _vueltas.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (context, index) {
                    final vueltaNum = _vueltas.length - index;
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color(0xFFFFEDD5),
                        child: Text(
                          '$vueltaNum',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFEA580C)),
                        ),
                      ),
                      title: Text(
                        'Vuelta $vueltaNum',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      trailing: Text(
                        _vueltas[index],
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEA580C),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
