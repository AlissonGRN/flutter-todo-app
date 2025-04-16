import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final tasksData = prefs.getStringList('tasks') ?? [];

    _tasks =
        tasksData.map((taskJson) {
          final taskMap = jsonDecode(taskJson);
          return Task(
            id: taskMap['id'],
            title: taskMap['title'],
            isCompleted: taskMap['isCompleted'],
          );
        }).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksData =
        _tasks
            .map(
              (task) => jsonEncode({
                'id': task.id,
                'title': task.title,
                'isCompleted': task.isCompleted,
              }),
            )
            .toList();

    await prefs.setStringList('tasks', tasksData);
  }

  void addTask(String title) {
    _tasks.add(Task.create(title));
    _saveTasks();
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks();
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      _saveTasks();
      notifyListeners();
    }
  }
}
