import 'dart:convert';
import 'dart:io';

import '../models/task.dart';

/// Servicio encargado de gestionar la lista de tareas: agregar, editar,
/// eliminar, completar y persistir los datos en un archivo JSON local.
///
/// Se separa esta lógica del archivo main.dart siguiendo el principio
/// de responsabilidad única, algo habitual en un proyecto académico
/// de programación orientada a objetos.
class TodoService {
  final String filePath;
  final List<Task> _tasks = [];
  int _nextId = 1;

  TodoService({this.filePath = 'data/tasks.json'}) {
    _loadTasks();
  }

  /// Lista de solo lectura con todas las tareas actuales.
  List<Task> get tasks => List.unmodifiable(_tasks);

  void _loadTasks() {
    final file = File(filePath);
    if (!file.existsSync()) return;

    try {
      final content = file.readAsStringSync();
      if (content.trim().isEmpty) return;

      final List<dynamic> data = jsonDecode(content) as List<dynamic>;
      _tasks
        ..clear()
        ..addAll(data.map((e) => Task.fromJson(e as Map<String, dynamic>)));

      if (_tasks.isNotEmpty) {
        _nextId = _tasks.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
      }
    } catch (e) {
      stderr.writeln('Advertencia: no se pudo leer el archivo de tareas ($e).');
    }
  }

  void _saveTasks() {
    final file = File(filePath);
    file.createSync(recursive: true);
    final data = _tasks.map((t) => t.toJson()).toList();
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }

  /// Agrega una nueva tarea y la guarda de inmediato en disco.
  Task addTask(String title, {String description = ''}) {
    final task = Task(id: _nextId++, title: title, description: description);
    _tasks.add(task);
    _saveTasks();
    return task;
  }

  /// Elimina una tarea por su ID. Retorna true si se eliminó correctamente.
  bool removeTask(int id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return false;
    _tasks.removeAt(index);
    _saveTasks();
    return true;
  }

  /// Cambia el estado (completada/pendiente) de una tarea.
  bool completeTask(int id, {required bool completed}) {
    final task = findById(id);
    if (task == null) return false;
    task.completed = completed;
    _saveTasks();
    return true;
  }

  /// Edita el título y/o la descripción de una tarea existente.
  /// Los parámetros nulos se interpretan como "no modificar".
  bool editTask(int id, {String? title, String? description}) {
    final task = findById(id);
    if (task == null) return false;
    if (title != null && title.trim().isNotEmpty) task.title = title.trim();
    if (description != null) task.description = description.trim();
    _saveTasks();
    return true;
  }

  /// Busca una tarea por su ID. Retorna null si no existe.
  Task? findById(int id) {
    for (final t in _tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  List<Task> pendingTasks() => _tasks.where((t) => !t.completed).toList();

  List<Task> completedTasks() => _tasks.where((t) => t.completed).toList();
}
