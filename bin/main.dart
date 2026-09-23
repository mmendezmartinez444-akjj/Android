import 'dart:io';

import 'package:todo_console/services/todo_service.dart';
import 'package:todo_console/utils/console_ui.dart';

void main() {
  final service = TodoService();
  var running = true;

  ConsoleUI.printTitleBox('GESTOR DE TAREAS - DART');

  while (running) {
    _mostrarMenu();
    stdout.write('Seleccione una opción: ');
    final opcion = stdin.readLineSync();

    switch (opcion) {
      case '1':
        _listarTareas(service);
        break;
      case '2':
        _agregarTarea(service);
        break;
      case '3':
        _cambiarEstadoTarea(service);
        break;
      case '4':
        _editarTarea(service);
        break;
      case '5':
        _eliminarTarea(service);
        break;
      case '6':
        _listarTareas(service, soloPendientes: true);
        break;
      case '0':
        running = false;
        print('\nSaliendo del programa. ¡Hasta luego!');
        break;
      default:
        print('\nOpción no válida, intente de nuevo.');
    }
  }
}

void _mostrarMenu() {
  print('');
  ConsoleUI.printBox([
    ' 1. Listar todas las tareas',
    ' 2. Agregar tarea',
    ' 3. Marcar tarea como completada / pendiente',
    ' 4. Editar tarea',
    ' 5. Eliminar tarea',
    ' 6. Listar solo tareas pendientes',
    ' 0. Salir',
  ]);
}

void _listarTareas(TodoService service, {bool soloPendientes = false}) {
  final tareas = soloPendientes ? service.pendingTasks() : service.tasks;

  print('');
  ConsoleUI.printTable(
    ['ID', 'Estado', 'Título', 'Descripción'],
    tareas
        .map((t) => [
              '${t.id}',
              t.completed ? 'Completada' : 'Pendiente',
              t.title,
              t.description.isEmpty ? '-' : t.description,
            ])
        .toList(),
  );
}

void _agregarTarea(TodoService service) {
  stdout.write('\nTítulo de la tarea: ');
  final titulo = stdin.readLineSync() ?? '';

  if (titulo.trim().isEmpty) {
    print('El título no puede estar vacío.');
    return;
  }

  stdout.write('Descripción (opcional): ');
  final descripcion = stdin.readLineSync() ?? '';

  final tarea = service.addTask(titulo.trim(), description: descripcion.trim());
  print('Tarea agregada correctamente: $tarea');
}

void _cambiarEstadoTarea(TodoService service) {
  final id = _leerId();
  if (id == null) return;

  final tarea = service.findById(id);
  if (tarea == null) {
    print('No existe una tarea con el ID $id.');
    return;
  }

  final ok = service.completeTask(id, completed: !tarea.completed);
  print(ok ? 'Estado actualizado: $tarea' : 'No se pudo actualizar la tarea.');
}

void _editarTarea(TodoService service) {
  final id = _leerId();
  if (id == null) return;

  final tarea = service.findById(id);
  if (tarea == null) {
    print('No existe una tarea con el ID $id.');
    return;
  }

  stdout.write('Nuevo título (Enter para mantener "${tarea.title}"): ');
  final titulo = stdin.readLineSync();

  stdout.write('Nueva descripción (Enter para mantener actual): ');
  final descripcion = stdin.readLineSync();

  final ok = service.editTask(
    id,
    title: (titulo != null && titulo.trim().isNotEmpty) ? titulo : null,
    description: (descripcion != null && descripcion.trim().isNotEmpty)
        ? descripcion
        : null,
  );

  print(ok
      ? 'Tarea actualizada correctamente.'
      : 'No se pudo actualizar la tarea.');
}

void _eliminarTarea(TodoService service) {
  final id = _leerId();
  if (id == null) return;

  final ok = service.removeTask(id);
  print(ok ? 'Tarea eliminada.' : 'No existe una tarea con ese ID.');
}

int? _leerId() {
  stdout.write('\nIngrese el ID de la tarea: ');
  final input = stdin.readLineSync();
  final id = int.tryParse(input ?? '');

  if (id == null) {
    print('ID inválido. Debe ser un número entero.');
  }
  return id;
}
