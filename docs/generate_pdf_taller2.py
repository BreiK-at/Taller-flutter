import os
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Image, Table, TableStyle, PageBreak, HRFlowable
)
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.pdfgen import canvas

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super(NumberedCanvas, self).__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_decorations(num_pages)
            super(NumberedCanvas, self).showPage()
        super(NumberedCanvas, self).save()

    def draw_page_decorations(self, page_count):
        if self._pageNumber == 1:
            return  # Portada sin encabezado ni pie

        self.saveState()
        self.setFont("Helvetica-Bold", 8)
        self.setFillColor(colors.HexColor("#C2410C"))

        # Encabezado
        self.drawString(54, 752, "TALLER 2: ASINCRONÍA, TIMER E ISOLATE EN FLUTTER")
        self.setFont("Helvetica", 8)
        self.setFillColor(colors.HexColor("#57534E"))
        self.drawRightString(558, 752, "ELECTIVA PROFESIONAL I — UCEVA")
        self.setStrokeColor(colors.HexColor("#FDBA74"))
        self.setLineWidth(0.8)
        self.line(54, 745, 558, 745)

        # Pie de página
        self.line(54, 42, 558, 42)
        self.drawString(54, 30, "Michael Stiven Vasco Cárdenas — Código: 230231047")
        page_text = f"Página {self._pageNumber} de {page_count}"
        self.drawRightString(558, 30, page_text)
        self.restoreState()

def build_pdf(filename):
    doc = SimpleDocTemplate(
        filename,
        pagesize=letter,
        leftMargin=54,
        rightMargin=54,
        topMargin=50,
        bottomMargin=50
    )

    styles = getSampleStyleSheet()

    # Paleta Ámbar / Naranja cálido
    primary_color = colors.HexColor("#EA580C")      # Naranja vibrante
    primary_dark = colors.HexColor("#C2410C")       # Naranja oscuro / quemado
    dark_color = colors.HexColor("#1C1917")         # Stone Dark
    text_color = colors.HexColor("#292524")         # Stone Texto
    light_bg = colors.HexColor("#FFF7ED")           # Naranja fondo tenue
    border_color = colors.HexColor("#FDBA74")       # Naranja borde

    cover_title_style = ParagraphStyle(
        'CoverTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=21,
        leading=26,
        textColor=primary_dark,
        alignment=1,
        spaceAfter=10
    )

    cover_subtitle_style = ParagraphStyle(
        'CoverSubtitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=12,
        leading=16,
        textColor=dark_color,
        alignment=1,
        spaceAfter=22
    )

    h1_style = ParagraphStyle(
        'SectionH1',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=12.5,
        leading=15.5,
        textColor=primary_dark,
        spaceBefore=7,
        spaceAfter=4,
        keepWithNext=True
    )

    h2_style = ParagraphStyle(
        'SectionH2',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=10,
        leading=13,
        textColor=dark_color,
        spaceBefore=5,
        spaceAfter=2,
        keepWithNext=True
    )

    body_style = ParagraphStyle(
        'BodyDark',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8.6,
        leading=11.8,
        textColor=text_color,
        spaceAfter=3.5
    )

    bullet_style = ParagraphStyle(
        'BulletStyle',
        parent=body_style,
        leftIndent=10,
        firstLineIndent=-7,
        spaceAfter=2
    )

    caption_style = ParagraphStyle(
        'ImgCaption',
        parent=styles['Normal'],
        fontName='Helvetica-Oblique',
        fontSize=7.8,
        leading=10,
        textColor=colors.HexColor("#57534E"),
        alignment=1,
        spaceBefore=2,
        spaceAfter=4
    )

    code_block_style = ParagraphStyle(
        'CodeBlock',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=7.3,
        leading=9.4,
        textColor=colors.HexColor("#1C1917"),
        backColor=colors.HexColor("#FFF7ED"),
        borderColor=colors.HexColor("#FDBA74"),
        borderWidth=0.6,
        borderPadding=4,
        spaceBefore=2,
        spaceAfter=3
    )

    story = []

    # ==========================================
    # PÁGINA 1: PORTADA OFICIAL
    # ==========================================
    story.append(Spacer(1, 35))
    story.append(Paragraph("UNIDAD CENTRAL DEL VALLE DEL CAUCA — UCEVA", ParagraphStyle(
        'InstHeader', fontName='Helvetica-Bold', fontSize=12, leading=16, alignment=1, textColor=colors.HexColor("#57534E"), spaceAfter=6
    )))
    story.append(Paragraph("FACULTAD DE INGENIERÍA — PROGRAMA DE INGENIERÍA DE SISTEMAS", ParagraphStyle(
        'FacultyHeader', fontName='Helvetica', fontSize=10, leading=13, alignment=1, textColor=colors.HexColor("#78716C"), spaceAfter=30
    )))

    story.append(HRFlowable(width="80%", thickness=2, color=primary_color, spaceAfter=18, spaceBefore=0))

    story.append(Paragraph("INFORME DE LABORATORIO — TALLER 2", cover_title_style))
    story.append(Paragraph("Desarrollo en Flutter con Asincronía (Future, async/await), Manejo de Tiempo con Timer y Concurrencia con Isolate", cover_subtitle_style))

    story.append(HRFlowable(width="40%", thickness=1, color=border_color, spaceAfter=28, spaceBefore=0))

    info_data = [
        [Paragraph("<b>Estudiante:</b>", body_style), Paragraph("Michael Stiven Vasco Cárdenas", body_style)],
        [Paragraph("<b>Código Estudiantil:</b>", body_style), Paragraph("230231047", body_style)],
        [Paragraph("<b>Asignatura:</b>", body_style), Paragraph("Electiva Profesional I", body_style)],
        [Paragraph("<b>Docente:</b>", body_style), Paragraph("Ingeniería de Sistemas", body_style)],
        [Paragraph("<b>Repositorio GitHub:</b>", body_style), Paragraph('<font color="#EA580C"><u>https://github.com/BreiK-at/Taller-flutter</u></font>', body_style)],
        [Paragraph("<b>Rama del Taller:</b>", body_style), Paragraph("<b>feature/taller_segundo_plano</b>", body_style)],
        [Paragraph("<b>Fecha de Entrega:</b>", body_style), Paragraph("Octubre 2026", body_style)],
    ]

    t_info = Table(info_data, colWidths=[140, 330])
    t_info.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), light_bg),
        ('BOX', (0,0), (-1,-1), 1, border_color),
        ('INNERGRID', (0,0), (-1,-1), 0.5, colors.HexColor("#FED7AA")),
        ('PADDING', (0,0), (-1,-1), 6.5),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
    ]))
    story.append(t_info)

    story.append(Spacer(1, 60))
    story.append(Paragraph("Tuluá, Valle del Cauca, Colombia<br/>2026", ParagraphStyle(
        'CityDate', fontName='Helvetica', fontSize=10, leading=14, alignment=1, textColor=colors.HexColor("#A8A29E")
    )))

    story.append(PageBreak())

    # ==========================================
    # PÁGINA 2: FUNDAMENTACIÓN TEÓRICA Y ARQUITECTURA
    # ==========================================
    story.append(Paragraph("1. Objetivo del Taller", h1_style))
    story.append(Paragraph(
        "Construir una aplicación reactiva en Flutter que demuestre el uso adecuado de mecanismos de ejecución no bloqueante: "
        "asincronía con <b>Future</b> y <code>async/await</code>, gestión de tareas recurrentes basadas en tiempo mediante <b>Timer</b>, "
        "y procesamiento concurrente intensivo de CPU con <b>Isolate.spawn</b>, garantizando en todo momento la fluidez de la interfaz (60 FPS). "
        "Asimismo, se aplica la metodología <b>Git Flow</b> con ramas protegidas y Pull Requests.",
        body_style
    ))

    story.append(Paragraph("2. Comparativa Técnica de Mecanismos de Concurrencia", h1_style))
    
    comparativa_data = [
        [Paragraph("<b>Mecanismo</b>", body_style), Paragraph("<b>Caso de Uso Principal</b>", body_style), Paragraph("<b>¿Bloquea UI?</b>", body_style), Paragraph("<b>Mecanismo Interno</b>", body_style)],
        [
            Paragraph("<b>Future</b><br/>(<code>async/await</code>)", body_style),
            Paragraph("Operaciones I/O bound (peticiones HTTP, base de datos, lectura de archivos, retardos simulados).", body_style),
            Paragraph("<b>No</b>", body_style),
            Paragraph("Agenda callbacks en el <i>Event Queue</i> del hilo principal. Permite que el framework continúe renderizando frames.", body_style)
        ],
        [
            Paragraph("<b>Timer</b><br/>(<code>dart:async</code>)", body_style),
            Paragraph("Control de intervalos temporales (cronómetros, cuentas regresivas, debouncing de búsquedas).", body_style),
            Paragraph("<b>No</b>", body_style),
            Paragraph("Encola eventos repetitivos cada tick en el Event Loop. Exige cancelación obligatoria en <code>dispose()</code> para evitar fugas.", body_style)
        ],
        [
            Paragraph("<b>Isolate</b><br/>(<code>dart:isolate</code>)", body_style),
            Paragraph("Tareas CPU-bound pesadas (cálculo matemático exhaustivo, cifrado masivo, procesamiento de video/imágenes).", body_style),
            Paragraph("<b>No</b>", body_style),
            Paragraph("Crea un hilo nativo del sistema operativo con heap de memoria propio. Comunica resultados exclusivamente vía <code>SendPort / ReceivePort</code>.", body_style)
        ]
    ]
    t_comp = Table(comparativa_data, colWidths=[85, 145, 60, 190])
    t_comp.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#FFEDD5")),
        ('BOX', (0,0), (-1,-1), 0.8, border_color),
        ('INNERGRID', (0,0), (-1,-1), 0.5, colors.HexColor("#FED7AA")),
        ('PADDING', (0,0), (-1,-1), 4),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
    ]))
    story.append(t_comp)

    story.append(Paragraph("3. Fragmentos de Código Clave Implementados", h1_style))
    story.append(Paragraph("<b>3.1 Asincronía con Future.delayed y Manejo de Estados:</b>", h2_style))
    code_async = """Future&lt;List&lt;Map&lt;String, dynamic&gt;&gt;&gt; consultarTareasRemotas({bool forzarError = false}) async {
  print('[1. ANTES DE LLAMAR AL SERVICIO] Solicitando datos remotos...');
  await Future.delayed(const Duration(milliseconds: 2500)); // Retardo no bloqueante
  if (forzarError) throw Exception('Fallo de conexion al servidor remoto');
  print('[3. DESPUES DE RECIBIR LA RESPUESTA] Datos recibidos exitosamente.');
  return _tareasSimuladas;
}"""
    story.append(Paragraph(code_async.replace('\n', '<br/>').replace(' ', '&nbsp;'), code_block_style))

    story.append(Paragraph("<b>3.2 Isolate.spawn con Comunicación por Puertos y Medición con Stopwatch:</b>", h2_style))
    code_iso = """static void _tareaPesadaTopLevel(SendPort sendPort) {
  final stopwatch = Stopwatch()..start();
  int totalPrimos = 0;
  for (int i = 2; i &lt;= 3000000; i++) {
    if (_esPrimo(i)) totalPrimos++;
  }
  stopwatch.stop();
  sendPort.send({'tiempoMs': stopwatch.elapsedMilliseconds, 'primos': totalPrimos});
}"""
    story.append(Paragraph(code_iso.replace('\n', '<br/>').replace(' ', '&nbsp;'), code_block_style))

    story.append(PageBreak())

    # ==========================================
    # PÁGINA 3: EVIDENCIAS DE ASINCRONÍA (FUTURE)
    # ==========================================
    story.append(Paragraph("4. Evidencias de Asincronía con Future y async/await", h1_style))
    story.append(Paragraph(
        "Se diseñó la pantalla <code>AsyncScreen</code> implementando una máquina de estados visual reactiva "
        "(Inicial, Cargando, Éxito, Error) acompañada de una consola en vivo integrada para verificar el orden de ejecución:",
        body_style
    ))

    img_dir = "docs/screenshots_taller2"
    img1 = os.path.join(img_dir, "01_async_cargando.png")
    img2 = os.path.join(img_dir, "02_async_exito.png")
    img3 = os.path.join(img_dir, "03_async_error.png")

    if os.path.exists(img1):
        story.append(Image(img1, width=6.2*inch, height=1.55*inch))
        story.append(Paragraph("<b>Figura 1: Estado Cargando</b> — Feedback visual inmediato con <code>CircularProgressIndicator</code> y botones deshabilitados para evitar múltiples llamadas concurrentes.", caption_style))

    story.append(Spacer(1, 2))

    async_grid = [
        [
            Image(img2, width=3.0*inch, height=3.05*inch) if os.path.exists(img2) else Paragraph("Img 2", body_style),
            Image(img3, width=3.0*inch, height=3.05*inch) if os.path.exists(img3) else Paragraph("Img 3", body_style)
        ],
        [
            Paragraph("<b>Figura 2: Estado Éxito</b><br/>4 registros obtenidos remotamente y renderizados en tarjetas individuales con badge de prioridad y registro en consola.", caption_style),
            Paragraph("<b>Figura 3: Estado Error Controlado</b><br/>Captura en bloque <code>try/catch</code> con tarjeta de alerta roja, mensaje descriptivo y botón de reintento.", caption_style)
        ]
    ]
    t_async = Table(async_grid, colWidths=[240, 240])
    t_async.setStyle(TableStyle([
        ('ALIGN', (0,0), (-1,-1), 'CENTER'),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('PADDING', (0,0), (-1,-1), 1),
    ]))
    story.append(t_async)

    story.append(Paragraph("<b>Trazabilidad del Orden de Ejecución en Consola:</b>", h2_style))
    story.append(Paragraph("• <code>[1. ANTES]</code>: El usuario activa el botón; se dispara el método asíncrono y se cambia de inmediato el estado a <i>Cargando</i>.", bullet_style))
    story.append(Paragraph("• <code>[2. DURANTE]</code>: Durante los 2.5 segundos de <code>Future.delayed</code>, el hilo principal continúa procesando animaciones sin retraso.", bullet_style))
    story.append(Paragraph("• <code>[3. DESPUES]</code>: Tras resolverse el Future, se muta el estado con <code>setState()</code> desplegando la colección de datos o capturando el error.", bullet_style))

    story.append(PageBreak())

    # ==========================================
    # PÁGINA 4: EVIDENCIAS DE CRONÓMETRO CON TIMER
    # ==========================================
    story.append(Paragraph("5. Evidencias del Cronómetro Digital con Timer", h1_style))
    story.append(Paragraph(
        "Se implementó <code>TimerScreen</code> utilizando <code>Timer.periodic</code> con intervalo de 100 milisegundos "
        "para garantizar precisión y respuesta visual fluida en tiempo real:",
        body_style
    ))

    img4 = os.path.join(img_dir, "04_timer_inicial.png")
    img5 = os.path.join(img_dir, "05_timer_corriendo.png")
    img6 = os.path.join(img_dir, "06_timer_pausado.png")

    timer_row1 = [
        [
            Image(img4, width=3.0*inch, height=1.7*inch) if os.path.exists(img4) else Paragraph("Img 4", body_style),
            Image(img5, width=3.0*inch, height=1.7*inch) if os.path.exists(img5) else Paragraph("Img 5", body_style)
        ],
        [
            Paragraph("<b>Figura 4: Estado Inicial (Detenido)</b><br/>Display en <code>00:00.0</code> y botón activo <i>Iniciar</i>.", caption_style),
            Paragraph("<b>Figura 5: Estado Activo (Corriendo)</b><br/>Tiempo transcurriendo a 100 ms por tick, botones <i>Pausar</i> y <i>Vuelta</i>.", caption_style)
        ]
    ]
    t_timer1 = Table(timer_row1, colWidths=[240, 240])
    t_timer1.setStyle(TableStyle([
        ('ALIGN', (0,0), (-1,-1), 'CENTER'),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('PADDING', (0,0), (-1,-1), 1),
    ]))
    story.append(t_timer1)

    story.append(Spacer(1, 2))

    if os.path.exists(img6):
        story.append(Image(img6, width=3.8*inch, height=2.05*inch))
        story.append(Paragraph("<b>Figura 6: Estado Pausado con Historial de Vueltas</b> — Cronómetro detenido en <code>00:07.8</code> mediante <code>_timer?.cancel()</code> conservando el acumulador y habilitando <i>Reanudar</i> y <i>Reiniciar</i>.", caption_style))

    story.append(Paragraph("<b>Gestión Estricta del Ciclo de Vida y Limpieza de Recursos:</b>", h2_style))
    story.append(Paragraph("• <b>Prevención de Fugas de Memoria (Memory Leaks):</b> Si un widget es desmontado del árbol mientras un <code>Timer.periodic</code> sigue corriendo, el callback intentará invocar <code>setState()</code> sobre un elemento inactivo arrojando excepciones en Flutter. En la solución se sobreescribió <code>dispose()</code> ejecutando obligatoriamente <code>_timer?.cancel()</code>.", bullet_style))
    story.append(Paragraph("• <b>Precisión Temporal y Formateo:</b> Se maneja un contador en milisegundos netos, calculando minutos, segundos y décimas con operaciones enteras para evitar acumulación de errores de punto flotante.", bullet_style))

    story.append(PageBreak())

    # ==========================================
    # PÁGINA 5: ISOLATE, GIT FLOW Y CONCLUSIONES
    # ==========================================
    story.append(Paragraph("6. Evidencias de Concurrencia Pesada con Isolate", h1_style))
    story.append(Paragraph(
        "Se construyó <code>IsolateScreen</code> para someter a prueba la UI ante una tarea CPU-bound masiva: "
        "comprobar la primalidad de <b>3.000.000 de enteros</b>:",
        body_style
    ))

    img7 = os.path.join(img_dir, "07_isolate_resultado.png")

    iso_table_data = [
        [
            Image(img7, width=3.3*inch, height=2.7*inch) if os.path.exists(img7) else Paragraph("Img 7", body_style),
            [
                Paragraph("<b>Demostración de No Congelamiento:</b>", h2_style),
                Paragraph("• <b>Monitor de Fluidez:</b> Se integró un icono giratorio continuo accionado por <code>AnimationController.repeat()</code>.", bullet_style),
                Paragraph("• <b>UI Interactiva:</b> El usuario puede pulsar el contador de clicks en tiempo real mientras el Isolate calcula.", bullet_style),
                Paragraph("• <b>Resultado del Worker:</b> 216.816 primos hallados en <b>1.034 ms</b>.", bullet_style),
                Paragraph("• <b>Paso de Mensajes:</b> El resultado viajó del hilo secundario al principal encapsulado en un Map vía <code>SendPort</code>.", bullet_style),
                Paragraph("• <b>Comparación Directa:</b> La misma operación en el Main Thread congela el renderizado causando <i>jank</i> severo de más de 1 segundo.", bullet_style),
            ]
        ]
    ]
    t_iso = Table(iso_table_data, colWidths=[240, 240])
    t_iso.setStyle(TableStyle([
        ('ALIGN', (0,0), (-1,-1), 'LEFT'),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('PADDING', (0,0), (-1,-1), 1),
    ]))
    story.append(t_iso)
    story.append(Paragraph("<b>Figura 7:</b> Cómputo completado en Isolate sin interrupción de los 60 FPS de la interfaz gráfica.", caption_style))

    story.append(Paragraph("7. Trazabilidad del Flujo de Trabajo (Git Flow)", h1_style))

    git_summary = [
        [Paragraph("<b>Pull Request</b>", body_style), Paragraph("<b>Ramas</b>", body_style), Paragraph("<b>Estado</b>", body_style), Paragraph("<b>Descripción</b>", body_style)],
        [
            Paragraph("<b>PR #1</b>", body_style),
            Paragraph("<code>feature/taller1</code> -&gt; <code>dev</code>", body_style),
            Paragraph("<font color=\"#16A34A\"><b>Merged</b></font>", body_style),
            Paragraph("Integración inicial de pantallas y widgets de Taller 1.", body_style)
        ],
        [
            Paragraph("<b>PR #2</b>", body_style),
            Paragraph("<code>dev</code> -&gt; <code>main</code>", body_style),
            Paragraph("<font color=\"#16A34A\"><b>Merged</b></font>", body_style),
            Paragraph("Pase a producción de release inicial Taller 1.", body_style)
        ],
        [
            Paragraph("<b>PR #3</b>", body_style),
            Paragraph("<code>feature/taller_segundo_plano</code> -&gt; <code>dev</code>", body_style),
            Paragraph("<font color=\"#16A34A\"><b>Merged</b></font>", body_style),
            Paragraph("Integración de módulos Future, Timer e Isolate.", body_style)
        ],
        [
            Paragraph("<b>PR #4</b>", body_style),
            Paragraph("<code>dev</code> -&gt; <code>main</code>", body_style),
            Paragraph("<font color=\"#2563EB\"><b>Merged</b></font>", body_style),
            Paragraph("Pase a producción final de Taller 2 con documentación.", body_style)
        ]
    ]
    t_git = Table(git_summary, colWidths=[65, 140, 65, 210])
    t_git.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#FFEDD5")),
        ('BOX', (0,0), (-1,-1), 0.8, border_color),
        ('INNERGRID', (0,0), (-1,-1), 0.5, colors.HexColor("#FED7AA")),
        ('PADDING', (0,0), (-1,-1), 2.5),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
    ]))
    story.append(t_git)

    story.append(Paragraph("8. Conclusiones", h1_style))
    story.append(Paragraph(
        "• La asincronía con <code>Future</code> y <code>async/await</code> es la vía óptima para tareas I/O dependientes de la red o disco, delegando la espera al Event Loop sin sobrecargar los núcleos de la CPU.<br/>"
        "• Los <code>Timer</code> deben administrarse con extrema rigurosidad dentro del ciclo de vida del widget, implementando siempre <code>cancel()</code> en <code>dispose()</code>.<br/>"
        "• Para tareas intensivas de CPU, el uso de <code>Isolate.spawn</code> es indispensable para evitar el bloqueo del hilo de interfaz gráfica, aislando la memoria y garantizando 60 FPS estables.",
        body_style
    ))

    doc.build(story, canvasmaker=NumberedCanvas)
    print(f"PDF generado exitosamente en: {filename}")

if __name__ == '__main__':
    output_pdf = "docs/Taller2_Segundo_Plano_Michael_Vasco_230231047.pdf"
    os.makedirs(os.path.dirname(output_pdf), exist_ok=True)
    build_pdf(output_pdf)
