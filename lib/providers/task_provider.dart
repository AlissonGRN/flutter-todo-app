import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // Carregar task de SharedPreferences
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksData = prefs.getStringList('tasks');
    if (tasksData != null) {
      _tasks =
          tasksData
              .map(
                (taskStr) => Task(
                  id: taskStr.split('||')[0],
                  title: taskStr.split('||')[1],
                  isComplete: taskStr.split('||')[2] == 'true',
                ),
              )
              .toList();
    }
    notifyListeners();
  }

  // salvar task em SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksData =
        _tasks
            .map((task) => '${task.id}||${task.title}||${task.isComplete}')
            .toList();

    await prefs.setStringList('tasks', tasksData);
  }

  // adcionar task
  void addTask(String title) {
    _tasks.add(Task(id: DateTime.now.toString(), title: title));
    _saveTasks();
    notifyListeners();
  }

  // remover task
  void removeTask(String id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    _tasks[taskIndex].isComplete = !_tasks[taskIndex].isComplete;
    _saveTasks();
    notifyListeners();
  }

  // Marcar task como concluída
  void toggleTask(String id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    _tasks[taskIndex].isComplete = !_tasks[taskIndex].isComplete;
    _saveTasks();
    notifyListeners();
  }
}
