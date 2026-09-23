/// Representa una tarea individual dentro de la lista de tareas.
///
/// Cada tarea tiene un identificador único, un título obligatorio,
/// una descripción opcional, un estado (completada o pendiente)
/// y la fecha en que fue creada.
class Task {
  final int id;
  String title;
  String description;
  bool completed;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.completed = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Convierte la tarea a un mapa, útil para guardarla en formato JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'completed': completed,
        'createdAt': createdAt.toIso8601String(),
      };

  /// Reconstruye una tarea a partir de un mapa (por ejemplo, leído de JSON).
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() {
    final estado = completed ? '[X]' : '[ ]';
    final desc = description.isNotEmpty ? ' - $description' : '';
    return '$estado (#$id) $title$desc';
  }
}
