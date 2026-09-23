/// Utilidades para dibujar cuadros y tablas en la consola usando
/// caracteres de dibujo de cajas (box-drawing characters: ┌ ─ ┐ │ └ ┘ etc.).
///
/// Se agrupó esta lógica en una clase aparte para no mezclar el formato
/// visual con la lógica del menú en `main.dart`.
class ConsoleUI {
  static const int defaultWidth = 46;

  /// Imprime un título centrado dentro de un cuadro de línea doble,
  /// pensado como encabezado principal del programa.
  static void printTitleBox(String title, {int width = defaultWidth}) {
    final top = '╔${'═' * (width - 2)}╗';
    final bottom = '╚${'═' * (width - 2)}╝';
    print(top);
    print('║${_center(title, width - 2)}║');
    print(bottom);
  }

  /// Imprime una lista de líneas (por ejemplo, las opciones del menú)
  /// dentro de un cuadro de línea simple.
  static void printBox(List<String> lines, {int width = defaultWidth}) {
    final top = '┌${'─' * (width - 2)}┐';
    final bottom = '└${'─' * (width - 2)}┘';
    print(top);
    for (final line in lines) {
      print('│${_padRight(line, width - 2)}│');
    }
    print(bottom);
  }

  /// Imprime una tabla con encabezados y filas, calculando el ancho de
  /// cada columna según el contenido más largo que deba mostrar.
  static void printTable(List<String> headers, List<List<String>> rows) {
    final widths = List<int>.generate(headers.length, (i) {
      var max = headers[i].length;
      for (final row in rows) {
        if (row[i].length > max) max = row[i].length;
      }
      return max + 2; // margen interno de un espacio a cada lado
    });

    void printSeparator(String left, String mid, String right) {
      final parts = widths.map((w) => '─' * w).join(mid);
      print('$left$parts$right');
    }

    void printRow(List<String> cells) {
      final parts = <String>[
        for (var i = 0; i < cells.length; i++) _padCell(cells[i], widths[i]),
      ];
      print('│${parts.join('│')}│');
    }

    printSeparator('┌', '┬', '┐');
    printRow(headers);
    printSeparator('├', '┼', '┤');

    if (rows.isEmpty) {
      final totalWidth = widths.reduce((a, b) => a + b) + (widths.length - 1);
      print('│${_center('(sin tareas)', totalWidth)}│');
    } else {
      for (final row in rows) {
        printRow(row);
      }
    }

    printSeparator('└', '┴', '┘');
  }

  static String _padRight(String text, int width) {
    if (text.length >= width) return text.substring(0, width);
    return text + ' ' * (width - text.length);
  }

  static String _padCell(String text, int width) {
    final content = ' $text';
    if (content.length >= width) return content.substring(0, width);
    return content + ' ' * (width - content.length);
  }

  static String _center(String text, int width) {
    if (text.length >= width) return text.substring(0, width);
    final totalPad = width - text.length;
    final left = totalPad ~/ 2;
    final right = totalPad - left;
    return ' ' * left + text + ' ' * right;
  }
}
