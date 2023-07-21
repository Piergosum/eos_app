import 'package:eos_app/storage/models/task.dart';
import 'package:eos_app/storage/shared_preferences_class.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class HomeScreenController extends ChangeNotifier {
  ValueNotifier<bool> allTasksCheckBox = ValueNotifier(true);

  ValueNotifier<bool> completedTasksCheckBox = ValueNotifier(false);

  ValueNotifier<bool> pendingTasksCheckBox = ValueNotifier(false);

  ValueNotifier<bool> tasksLoading = ValueNotifier(false);

  String selectedCheckBox = 'Todas';

  List<Task> tasksList = [];

  void changeCheckBoxValue(bool value, String type) async {
    if (selectedCheckBox != type) {
      selectedCheckBox = type;
      switch (type) {
        case 'Todas':
          allTasksCheckBox.value = value;
          completedTasksCheckBox.value = !value;
          pendingTasksCheckBox.value = !value;
          break;
        case 'Concluídas':
          completedTasksCheckBox.value = value;
          allTasksCheckBox.value = !value;
          pendingTasksCheckBox.value = !value;
          break;
        case 'Pendentes':
          pendingTasksCheckBox.value = value;
          allTasksCheckBox.value = !value;
          completedTasksCheckBox.value = !value;
          break;
        default:
      }
      await loadTasks();
    }
  }

  Future<bool> loadTasks() async {
    tasksLoading.value = true;
    try {
      List<String> tasksStringList = SharedPreferencesClass.prefsInstance!
              .getStringList('tasksStringList') ??
          [];
      tasksList.clear();

      tasksStringList
          .map(
            (e) => tasksList.add(
              Task.fromJson(
                jsonDecode(e),
              ),
            ),
          )
          .toList();
      tasksLoading.value = false;
      return true;
    } catch (e) {
      return false;
    }
  }

  String? taskTitleFormValidator(String value) {
    if (value.isEmpty) {
      return 'Escolha um título';
    } else {
      return null;
    }
  }

  String? taskDescriptionFormValidator(String value) {
    return null;
  }

  String? taskDateFormValidator(String value) {
    if (value.isEmpty) {
      return 'Defina uma data';
    } else {
      return null;
    }
  }

  Future<bool> registerTask(
      String title, String description, String date) async {
    try {
      Task task = Task(
          title: title,
          description: description,
          date: date,
          status: 'Pendente');
      Map taskJson = task.toJson();
      List<String> taskStringListToSave = [];
      taskStringListToSave.add(jsonEncode(taskJson));
      SharedPreferencesClass.prefsInstance!
          .setStringList('tasksStringList', taskStringListToSave);
      return true;
    } catch (e) {
      return false;
    }
  }
}
