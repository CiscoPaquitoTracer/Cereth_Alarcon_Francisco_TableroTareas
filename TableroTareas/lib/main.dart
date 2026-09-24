import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tareas',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.teal),
      ),
      home: const ListaVivaPage(title: 'Cereth 10A - Tareas'), //97 y 115
    );
  }
}

class ListaVivaPage extends StatefulWidget {
  const ListaVivaPage({super.key, required this.title});

  final String title;

  @override
  State<ListaVivaPage> createState() => _ListaVivaPageState();
}

class _ListaVivaPageState extends State<ListaVivaPage> {
  final List<String> _tareas = ['Tarea Investigacion', 'Subir tarea cris'];
  final List<bool> _completadas = [false, false];

  bool _soloPendientes = true;
  bool _soloCompletadas = false;

  int _siguienteTarea = 3;

  void _cambiarEstado(int index, bool valor) {
    setState(() {
      _completadas[index] = valor;
    });
  }

  void _eliminar(int index) {
    setState(() {
      _tareas.removeAt(index);
    });
  }

  void _agregar() {
    setState(() {
      _tareas.add('Tarea $_siguienteTarea');
      _completadas.add(false);
      _siguienteTarea++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalCompletadas =
        _completadas.where((completada) => completada).length;

    final indicesVisibles = List<int>.generate(
      _tareas.length,
          (index) => index,
    ).where((index) {
      return !_soloPendientes || !_completadas[index];
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Completadas: $totalCompletadas / ${_tareas.length}',
                  ),
                ),
                const Text(
                  'Solo pendientes',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 4),
                Switch(
                  value: _soloPendientes,
                  onChanged: (valor) {
                    setState(() {
                      _soloPendientes = valor;
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: indicesVisibles.isEmpty
                ? Center(
              child: Text(
                _tareas.isEmpty
                    ? 'Agrega tu primera tarea'
                    : 'No hay tareas pendientes',
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(bottom: 96),
              itemCount: indicesVisibles.length,
              itemBuilder: (context, posicion) {
                final index = indicesVisibles[posicion];

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: _completadas[index],
                      onChanged: (valor) {
                        if (valor != null) {
                          _cambiarEstado(index, valor);
                        }
                      },
                    ),
                    title: Text(
                      _tareas[index],
                      style: TextStyle(
                        fontSize: 14,
                        decoration: _completadas[index]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      tooltip: 'Eliminar tarea',
                      onPressed: () => _eliminar(index),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregar,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Agregar'),
      ),
    );
  }
}