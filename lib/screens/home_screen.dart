import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
//import '../models/task.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega as tarefas ao inicializar a tela
    Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tarefas')),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          // Mostra loading enquanto carrega
          if (taskProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Mostra lista de tarefas
          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (ctx, index) {
              final task = taskProvider.tasks[index];
              return ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration:
                        task.isComplete ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: Checkbox(
                  value: task.isComplete,
                  onChanged: (_) => taskProvider.toggleTask(task.id),
                ),
                onLongPress: () => taskProvider.removeTask(task.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => const AddTaskScreen()),
            ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
