import 'package:eos_app/storage/models/task.dart';
import 'package:eos_app/storage/shared_preferences_class.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class HomeScreenController extends ChangeNotifier {
  ValueNotifier<bool> allTasksCheckBox = ValueNotifier(true);

  ValueNotifier<bool> completedTasksCheckBox = ValueNotifier(false);

  ValueNotifier<bool> pendingTasksCheckBox = ValueNotifier(false);

  ValueNotifier<bool> tasksLoading = ValueNotifier(false);

  List<Task> tasksList = [];

  void changeCheckBoxValue(bool value, String type) {}

  Future<bool> loadTasks() async {
    try {
      tasksLoading.value = true;
      List<String> tasksStringList = SharedPreferencesClass.prefsInstance!
              .getStringList('tasksStringList') ??
          [];

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

  bool registerTask(Task task) {
    try {
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
