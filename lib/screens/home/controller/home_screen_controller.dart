import 'package:eos_app/storage/models/task.dart';
import 'package:eos_app/storage/shared_preferences_class.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class HomeScreenController extends ChangeNotifier {
  ValueNotifier<bool> allTasksCheckBox = ValueNotifier(false);

  ValueNotifier<bool> completedTasksCheckBox = ValueNotifier(false);

  ValueNotifier<bool> pendingTasksCheckBox = ValueNotifier(true);

  ValueNotifier<bool> registerLoading = ValueNotifier(false);

  ValueNotifier<bool> tasksLoading = ValueNotifier(false);

  String selectedCheckBox = 'Pendentes';

  List<Task> tasksList = [];

  Future<bool> changeCheckBoxValue(bool value, String type) async {
    if (selectedCheckBox != type) {
      tasksLoading.value = true;
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
      bool tasksListLoadStatus = await loadTasks();
      tasksLoading.value = false;
      return tasksListLoadStatus;
    } else {
      return true;
    }
  }

  Future<bool> loadTasks() async {
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
    registerLoading.value = true;
    Task task = Task(
        title: title, description: description, date: date, status: 'PENDENTE');
    try {
      Map taskJson = task.toJson();
      List<String> tasksStringListSaved = SharedPreferencesClass.prefsInstance!
              .getStringList('tasksStringList') ??
          [];
      tasksStringListSaved.add(jsonEncode(taskJson));
      SharedPreferencesClass.prefsInstance!
          .setStringList('tasksStringList', tasksStringListSaved);
      registerLoading.value = false;
      await changeCheckBoxValue(true, 'Todas');
      return true;
    } catch (e) {
      registerLoading.value = false;
      return false;
    }
  }
}
