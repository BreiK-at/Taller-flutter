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
        self.setFillColor(colors.HexColor("#475569"))

        # Encabezado
        self.drawString(54, 752, "TALLER 1: STATEFULWIDGET, SETSTATE Y FLUJO GIT")
        self.setFont("Helvetica", 8)
        self.drawRightString(558, 752, "ELECTIVA PROFESIONAL I — UCEVA")
        self.setStrokeColor(colors.HexColor("#CBD5E1"))
        self.setLineWidth(0.6)
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

    primary_color = colors.HexColor("#3F51B5")      # Indigo principal
    dark_color = colors.HexColor("#0F172A")         # Slate Dark
    text_color = colors.HexColor("#334155")         # Slate Body

    cover_title_style = ParagraphStyle(
        'CoverTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=23,
        leading=29,
        textColor=primary_color,
        alignment=1,
        spaceAfter=12
    )

    cover_subtitle_style = ParagraphStyle(
        'CoverSubtitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=13,
        leading=17,
        textColor=dark_color,
        alignment=1,
        spaceAfter=25
    )

    h1_style = ParagraphStyle(
        'SectionH1',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=13.5,
        leading=17,
        textColor=primary_color,
        spaceBefore=8,
        spaceAfter=5,
        keepWithNext=True
    )

    h2_style = ParagraphStyle(
        'SectionH2',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=10.5,
        leading=14,
        textColor=dark_color,
        spaceBefore=6,
        spaceAfter=3,
        keepWithNext=True
    )

    body_style = ParagraphStyle(
        'BodyDark',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8.8,
        leading=12.2,
        textColor=text_color,
        spaceAfter=4
    )

    bullet_style = ParagraphStyle(
        'BulletStyle',
        parent=body_style,
        leftIndent=12,
        firstLineIndent=-8,
        spaceAfter=2.5
    )

    caption_style = ParagraphStyle(
        'ImgCaption',
        parent=styles['Normal'],
        fontName='Helvetica-Oblique',
        fontSize=8,
        leading=10.5,
        textColor=colors.HexColor("#475569"),
        alignment=1,
        spaceBefore=2,
        spaceAfter=6
    )

    code_block_style = ParagraphStyle(
        'CodeBlock',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=7.8,
        leading=10.2,
        textColor=colors.HexColor("#1E293B"),
        backColor=colors.HexColor("#F8FAFC"),
        borderColor=colors.HexColor("#CBD5E1"),
        borderWidth=0.5,
        borderPadding=5,
        spaceBefore=3,
        spaceAfter=4
    )

    story = []

    # ==========================================
    # PÁGINA 1: PORTADA OFICIAL
    # ==========================================
    story.append(Spacer(1, 40))
    story.append(Paragraph("UNIDAD CENTRAL DEL VALLE DEL CAUCA — UCEVA", ParagraphStyle(
        'InstHeader', fontName='Helvetica-Bold', fontSize=12, leading=16, alignment=1, textColor=colors.HexColor("#475569"), spaceAfter=8
    )))
    story.append(Paragraph("FACULTAD DE INGENIERÍA — PROGRAMA DE INGENIERÍA DE SISTEMAS", ParagraphStyle(
        'FacultyHeader', fontName='Helvetica', fontSize=10, leading=13, alignment=1, textColor=colors.HexColor("#64748B"), spaceAfter=35
    )))

    story.append(HRFlowable(width="80%", thickness=2, color=primary_color, spaceAfter=20, spaceBefore=0))

    story.append(Paragraph("INFORME DE LABORATORIO — TALLER 1", cover_title_style))
    story.append(Paragraph("Construcción de Pantalla Básica con StatefulWidget, setState() y Control de Versiones con Git Flow", cover_subtitle_style))

    story.append(HRFlowable(width="40%", thickness=1, color=colors.HexColor("#CBD5E1"), spaceAfter=30, spaceBefore=0))

    info_data = [
        [Paragraph("<b>Estudiante:</b>", body_style), Paragraph("Michael Stiven Vasco Cárdenas", body_style)],
        [Paragraph("<b>Código Estudiantil:</b>", body_style), Paragraph("230231047", body_style)],
        [Paragraph("<b>Asignatura:</b>", body_style), Paragraph("Electiva Profesional I", body_style)],
        [Paragraph("<b>Docente:</b>", body_style), Paragraph("Ingeniería de Sistemas", body_style)],
        [Paragraph("<b>Repositorio GitHub:</b>", body_style), Paragraph('<font color="#2563EB"><u>https://github.com/BreiK-at/Taller-flutter</u></font>', body_style)],
        [Paragraph("<b>Rama del Taller:</b>", body_style), Paragraph("<b>feature/taller1</b>", body_style)],
        [Paragraph("<b>Fecha:</b>", body_style), Paragraph("Septiembre 2026", body_style)],
    ]

    t_info = Table(info_data, colWidths=[140, 330])
    t_info.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F8FAFC")),
        ('BOX', (0,0), (-1,-1), 1, colors.HexColor("#CBD5E1")),
        ('INNERGRID', (0,0), (-1,-1), 0.5, colors.HexColor("#E2E8F0")),
        ('PADDING', (0,0), (-1,-1), 7),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
    ]))
    story.append(t_info)

    story.append(Spacer(1, 60))
    story.append(Paragraph("Tuluá, Valle del Cauca, Colombia<br/>2026", ParagraphStyle(
        'CityDate', fontName='Helvetica', fontSize=10, leading=14, alignment=1, textColor=colors.HexColor("#94A3B8")
    )))

    story.append(PageBreak())

    # ==========================================
    # PÁGINA 2: OBJETIVO Y FUNDAMENTACIÓN TEÓRICA (COMPLETA)
    # ==========================================
    story.append(Paragraph("1. Objetivo del Taller", h1_style))
    story.append(Paragraph(
        "El objetivo primordial de esta práctica es diseñar y construir una pantalla funcional en <b>Flutter</b> implementando "
        "la gestión del estado reactivo mutable con un <code>StatefulWidget</code> y la invocación de <code>setState()</code>. "
        "Adicionalmente, se consolida la aplicación rigurosa de buenas prácticas de control de versiones con <b>Git Flow</b>, "
        "empleando ramas base (<code>main</code>, <code>dev</code>), ramas de taller (<code>feature/taller1</code>) y flujos de integración "
        "mediante Pull Requests.",
        body_style
    ))

    story.append(Paragraph("2. Fundamentación Técnica: StatefulWidget y setState()", h1_style))
    story.append(Paragraph(
        "En Flutter, la interfaz es declarativa y reactiva. Los widgets representan la configuración inmutable de la vista. "
        "Para gestionar componentes dinámicos con ciclo de vida mutable, se utiliza <b>StatefulWidget</b>.",
        body_style
    ))

    story.append(Paragraph("<b>2.1 Arquitectura de StatefulWidget:</b>", h2_style))
    story.append(Paragraph("• <b>Widget (Clase inmutable):</b> Hereda de <code>StatefulWidget</code> y solo actúa como plantilla externa. Sobreescribe <code>createState()</code> para instanciar la clase de estado asociada.", bullet_style))
    story.append(Paragraph("• <b>State (Clase de lógica y estado mutable):</b> Hereda de <code>State&lt;T&gt;</code>, almacena los datos en memoria a lo largo del tiempo y describe el árbol visual dentro del método <code>build(BuildContext context)</code>.", bullet_style))

    story.append(Paragraph("<b>2.2 Funcionamiento interno de setState():</b>", h2_style))
    story.append(Paragraph(
        "El método <code>setState(VoidCallback fn)</code> es el núcleo de la reactividad local en Flutter. Su mecanismo opera en 4 fases:",
        body_style
    ))
    story.append(Paragraph("1. <b>Mutación de Estado:</b> Ejecuta el callback sincrónico pasado por parámetro, actualizando las variables (como <code>_titulo</code> y <code>_contadorClicks</code>).", bullet_style))
    story.append(Paragraph("2. <b>Marcado de Elemento:</b> Notifica al framework que este nodo del árbol de elementos está <b>dirty</b> (modificado).", bullet_style))
    story.append(Paragraph("3. <b>Programación de Frame:</b> El motor de renderizado de Flutter agenda la ejecución del método <code>build()</code> en el siguiente refresco de pantalla.", bullet_style))
    story.append(Paragraph("4. <b>Reconciliación (Diffing):</b> Flutter compara el nuevo árbol con el anterior y redibuja en la GPU exclusivamente los widgets que sufrieron alteraciones, preservando un rendimiento óptimo de 60/120 FPS.", bullet_style))

    story.append(Paragraph("<b>2.3 Fragmento de Código Implementado:</b>", h2_style))
    code_snippet = """void _alternarTitulo() {
  setState(() {
    _tituloModificado = !_tituloModificado;
    _titulo = _tituloModificado ? '¡Título cambiado!' : 'Hola, Flutter';
    _contadorClicks++;
  });

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Row(children: [
        Icon(Icons.check_circle, color: Colors.white),
        SizedBox(width: 12),
        Text('Título actualizado', style: TextStyle(fontWeight: FontWeight.bold)),
      ]),
      backgroundColor: Colors.indigo.shade700,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );
}"""
    story.append(Paragraph(code_snippet.replace('\n', '<br/>').replace(' ', '&nbsp;'), code_block_style))

    story.append(PageBreak())

    # ==========================================
    # PÁGINA 3: EVIDENCIAS DE LA APLICACIÓN FLUTTER
    # ==========================================
    story.append(Paragraph("3. Evidencias de la Aplicación en Ejecución", h1_style))
    story.append(Paragraph(
        "A continuación se presentan las capturas de la aplicación en ejecución sobre el escritorio nativo Linux, "
        "evidenciando el cumplimiento de los requerimientos visuales y funcionales:",
        body_style
    ))

    img_dir = "/home/michaelsvc/.gemini/antigravity/scratch/Taller-flutter/docs/screenshots"
    img1_path = os.path.join(img_dir, "01_estado_inicial.png")
    img2_path = os.path.join(img_dir, "02_titulo_cambiado_y_snackbar.png")
    img3_path = os.path.join(img_dir, "03_widgets_adicionales.png")
    img4_path = os.path.join(img_dir, "04_github_pull_requests.png")

    app_imgs_data = [
        [
            Image(img1_path, width=2.4*inch, height=3.5*inch),
            Image(img2_path, width=2.4*inch, height=3.5*inch)
        ],
        [
            Paragraph("<b>Figura 1: Estado Inicial</b><br/>AppBar con 'Hola, Flutter', tarjeta centrada con datos del estudiante y Row de imágenes (Image.network + Image.asset).", caption_style),
            Paragraph("<b>Figura 2: Estado Tras Botón + SnackBar</b><br/>Título reactivo '¡Título cambiado!' actualizado con setState() y SnackBar flotante con 'Título actualizado'.", caption_style)
        ]
    ]
    t_app = Table(app_imgs_data, colWidths=[240, 240])
    t_app.setStyle(TableStyle([
        ('ALIGN', (0,0), (-1,-1), 'CENTER'),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 1),
        ('TOPPADDING', (0,0), (-1,-1), 1),
    ]))
    story.append(t_app)

    story.append(Spacer(1, 4))
    story.append(Paragraph("<b>Detalle de Componentes Evaluados:</b>", h2_style))
    story.append(Paragraph("• <b>AppBar Dinámica:</b> Título sincronizado con la variable reactiva <code>_titulo</code>.", bullet_style))
    story.append(Paragraph("• <b>Identificación Centrada:</b> Tarjeta decorada con nombre <b>Michael Stiven Vasco Cárdenas</b>, código <b>230231047</b> y materia <b>Electiva Profesional I</b>.", bullet_style))
    story.append(Paragraph("• <b>Row con Imágenes:</b> Integración de <code>Image.network()</code> (remota) e <code>Image.asset('assets/images/flutter_logo.png')</code> (local).", bullet_style))
    story.append(Paragraph("• <b>Botón de Acción:</b> <code>ElevatedButton.icon</code> que invoca <code>_alternarTitulo()</code> con retroalimentación visual.", bullet_style))

    story.append(PageBreak())

    # ==========================================
    # PÁGINA 4: WIDGETS ADICIONALES, GIT FLOW Y CONCLUSIÓN (TODO EN 1 PÁGINA)
    # ==========================================
    story.append(Paragraph("4. Widgets Adicionales Implementados", h1_style))
    story.append(Paragraph(
        "Se implementaron <b>tres widgets adicionales</b> (superando el mínimo de 2 requeridos):",
        body_style
    ))
    story.append(Paragraph("• <b>Container:</b> Tarjeta decorada con bordes redondeados (<code>BorderRadius.circular(16)</code>), sombra difusa y padding interno.", bullet_style))
    story.append(Paragraph("• <b>Stack:</b> Superposición de badge informativo (<i>'StatefulWidget Activo'</i>), texto y marca de agua sobre gradiente.", bullet_style))
    story.append(Paragraph("• <b>ListView:</b> Lista vertical con 4 elementos (<code>ListTile</code>), cada uno con avatar temático, título y subtítulo.", bullet_style))

    if os.path.exists(img3_path):
        story.append(Spacer(1, 2))
        story.append(Image(img3_path, width=4.7*inch, height=1.45*inch))
        story.append(Paragraph("<b>Figura 3:</b> Widgets Adicionales: Stack con gradiente interactivo y ListView informativo estructurado.", caption_style))

    story.append(Paragraph("5. Evidencia del Flujo de Trabajo en Git (Git Flow)", h1_style))
    story.append(Paragraph(
        "Flujo de ramas y Pull Requests implementado de acuerdo al diagrama oficial del docente:",
        body_style
    ))

    git_flow_summary = [
        [Paragraph("<b>Rama</b>", body_style), Paragraph("<b>Propósito / Rol</b>", body_style), Paragraph("<b>Estado en Repositorio</b>", body_style)],
        [Paragraph("<code>main</code>", body_style), Paragraph("Rama estable de producción.", body_style), Paragraph("Integrada vía PR #2.", body_style)],
        [Paragraph("<code>dev</code>", body_style), Paragraph("Rama base de desarrollo continuo.", body_style), Paragraph("Integrada vía PR #1.", body_style)],
        [Paragraph("<code>feature/taller1</code>", body_style), Paragraph("Rama de desarrollo del Taller 1.", body_style), Paragraph("Commits y PR originados aquí.", body_style)]
    ]
    t_git = Table(git_flow_summary, colWidths=[95, 235, 150])
    t_git.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#EEF2F6")),
        ('BOX', (0,0), (-1,-1), 0.8, colors.HexColor("#CBD5E1")),
        ('INNERGRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('PADDING', (0,0), (-1,-1), 3),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
    ]))
    story.append(t_git)

    if os.path.exists(img4_path):
        story.append(Spacer(1, 2))
        story.append(Image(img4_path, width=4.7*inch, height=0.95*inch))
        story.append(Paragraph("<b>Figura 4:</b> Pull Requests en GitHub: PR #1 (feature/taller1 ➔ dev) y PR #2 (dev ➔ main) cerrados y fusionados (Merged).", caption_style))

    story.append(Paragraph("6. Enlace de Repositorio y Conclusiones", h1_style))
    story.append(Paragraph(
        "• <b>URL Repositorio Público:</b> <font color=\"#2563EB\"><u>https://github.com/BreiK-at/Taller-flutter</u></font><br/>"
        "• <b>Rama del Taller:</b> <code>feature/taller1</code><br/>"
        "• <b>Conclusión:</b> Se validó exitosamente la reactividad en Flutter con <code>StatefulWidget</code> y <code>setState()</code>, "
        "comprobando que la arquitectura desacoplada de Widgets y State garantiza un renderizado eficiente. "
        "Asimismo, se demostró la efectividad de Git Flow para la entrega controlada de código.",
        body_style
    ))

    doc.build(story, canvasmaker=NumberedCanvas)
    print(f"PDF generado exitosamente en: {filename}")

if __name__ == '__main__':
    output_pdf = "/home/michaelsvc/.gemini/antigravity/scratch/Taller-flutter/docs/Taller1_Michael_Vasco_230231047.pdf"
    os.makedirs(os.path.dirname(output_pdf), exist_ok=True)
    build_pdf(output_pdf)
