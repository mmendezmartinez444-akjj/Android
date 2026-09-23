# Gestor de Tareas (To-Do List) - Proyecto Dart de Consola (interfaz con cajas)

Variante del proyecto original con la interfaz de consola dibujada usando
caracteres de dibujo de cajas (box-drawing: `┌ ─ ┐ │ └ ┘ ├ ┤ ┬ ┴ ┼ ╔ ═ ╗ ╚ ╝`).
El menú se muestra dentro de un recuadro y la lista de tareas se presenta
como una tabla con columnas (ID, Estado, Título, Descripción).

## Estructura del proyecto

```
todo_console_cajas/
├── pubspec.yaml
├── bin/
│   └── main.dart              # Interfaz de consola con cajas y tabla
├── lib/
│   ├── models/
│   │   └── task.dart          # Clase Task (igual que en la versión base)
│   ├── services/
│   │   └── todo_service.dart  # Lógica de negocio y persistencia en JSON
│   └── utils/
│       └── console_ui.dart    # Dibuja cajas y tablas en la terminal
└── data/
    └── tasks.json             # Se genera automáticamente
```

## Funcionalidades

Las mismas que la versión base: listar, agregar, completar/pendiente,
editar, eliminar y filtrar tareas pendientes. Lo único que cambia es cómo
se presenta la información en la terminal.

## Cómo abrir el proyecto en Android Studio

1. Instalar el plugin **Dart** si no está instalado
   (`Settings > Plugins > Marketplace > Dart`).
2. Descomprimir `todo_console_cajas.zip`.
3. `File > Open...` y seleccionar la carpeta `todo_console_cajas`.
4. Ejecutar `dart pub get` (banner automático o desde la terminal).
5. Ejecutar `bin/main.dart` con el botón "Run" o:

   ```bash
   dart run bin/main.dart
   ```

## Nota sobre la visualización

Los caracteres de dibujo de cajas requieren una terminal con soporte UTF-8
(la consola integrada de Android Studio y la mayoría de terminales modernas
lo soportan por defecto). Si los bordes se ven como signos de interrogación
o caracteres sueltos, hay que configurar la codificación de la terminal en
UTF-8.
