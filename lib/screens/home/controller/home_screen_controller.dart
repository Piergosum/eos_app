import 'package:eos_app/storage/models/task.dart';
import 'package:eos_app/storage/shared_preferences_class.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class HomeScreenController extends ChangeNotifier {
  final ValueNotifier<bool> _allTasksCheckBox = ValueNotifier(false);

  final ValueNotifier<bool> _completedTasksCheckBox = ValueNotifier(false);

  final ValueNotifier<bool> _pendingTasksCheckBox = ValueNotifier(true);

  final ValueNotifier<bool> _registerLoading = ValueNotifier(false);

  final ValueNotifier<bool> _deleteLoading = ValueNotifier(false);

  final ValueNotifier<bool> _tasksLoading = ValueNotifier(false);

  final ValueNotifier<bool> _updatStatusLoading = ValueNotifier(false);

  String _selectedCheckBox = 'Pendentes';

  final List<Task> _tasksList = [];

  String _deleteErrorMessage = '';

  String _titleToUpdate = '';

  ValueNotifier<bool> get allTasksCheckBox => _allTasksCheckBox;
  ValueNotifier<bool> get completedTasksCheckBox => _completedTasksCheckBox;
  ValueNotifier<bool> get pendingTasksCheckBox => _pendingTasksCheckBox;
  ValueNotifier<bool> get registerLoading => _registerLoading;
  ValueNotifier<bool> get deleteLoading => _deleteLoading;
  ValueNotifier<bool> get tasksLoading => _tasksLoading;
  ValueNotifier<bool> get updatStatusLoading => _updatStatusLoading;

  String get selectedCheckBox => _selectedCheckBox;
  List<Task> get tasksList => _tasksList;
  String get deleteErrorMessage => _deleteErrorMessage;
  String get titleToUpdate => _titleToUpdate;

  //Função responsável pela troca de valores do checkbox Pendentes, Concluídas e Todas
  Future<bool> changeCheckBoxValue(bool value, String type) async {
    if (_selectedCheckBox != type) {
      _selectedCheckBox = type;
      switch (type) {
        case 'Todas':
          _allTasksCheckBox.value = value;
          _completedTasksCheckBox.value = !value;
          _pendingTasksCheckBox.value = !value;
          break;
        case 'Concluídas':
          _completedTasksCheckBox.value = value;
          _allTasksCheckBox.value = !value;
          _pendingTasksCheckBox.value = !value;
          break;
        case 'Pendentes':
          _pendingTasksCheckBox.value = value;
          _allTasksCheckBox.value = !value;
          _completedTasksCheckBox.value = !value;
          break;
        default:
      }
    }
    bool tasksListLoadRestult = await loadTasks();
    return tasksListLoadRestult;
  }

  //Função responsável pelo carregamento da lista de tarefas do armanezamento local
  Future<bool> loadTasks() async {
    _tasksLoading.value = true;
    try {
      List<String> tasksStringList = SharedPreferencesClass.prefsInstance!
              .getStringList('tasksStringList') ??
          [];
      _tasksList.clear();

      tasksStringList
          .map(
            (e) => _tasksList.add(
              Task.fromJson(
                jsonDecode(e),
              ),
            ),
          )
          .toList();
      _tasksLoading.value = false;
      return true;
    } catch (e) {
      _tasksLoading.value = false;
      return false;
    }
  }

  //INÍCIO DO BLOCO DE REGISTRO DE NOVA TAREFA

  //Função responsável pela validação do input Title
  String? taskTitleFormValidator(String value) {
    if (value.isEmpty) {
      return 'Escolha um título';
    } else {
      try {
        List<String> tasksStringListSaved = SharedPreferencesClass
                .prefsInstance!
                .getStringList('tasksStringList') ??
            [];
        for (String taskString in tasksStringListSaved) {
          Map taskMap = jsonDecode(taskString);
          Task task = Task.fromJson(taskMap);
          if (task.title == value) {
            return 'Já existe uma tarefa com esse título';
          }
        }
      } catch (e) {
        return 'Erro. Tente novamente.';
      }
      return null;
    }
  }

  //Função responsável pela validação do input Description
  String? taskDescriptionFormValidator(String value) {
    return null;
  }

  //Função responsável pela validação do input Date
  String? taskDateFormValidator(String value) {
    if (value.isEmpty) {
      return 'Defina uma data';
    } else {
      return null;
    }
  }

  //Função responsável pele registro
  Future<bool> registerTask(
      String title, String description, String date) async {
    _registerLoading.value = true;

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
      _registerLoading.value = false;
      await changeCheckBoxValue(true, 'Todas');
      return true;
    } catch (e) {
      _registerLoading.value = false;
      return false;
    }
  }

  //FIM DO BLOCO DE REGISTRO

  //Função responsável pela atualização do Status da Task
  Future<bool> updateTaskStatus(String titleToUpdate) async {
    _titleToUpdate = titleToUpdate;
    _updatStatusLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    try {
      List<String> tasksStringListSaved = SharedPreferencesClass.prefsInstance!
              .getStringList('tasksStringList') ??
          [];
      _tasksList.clear();
      for (String taskString in tasksStringListSaved) {
        Map taskMap = jsonDecode(taskString);
        Task task = Task.fromJson(taskMap);
        if (task.title == titleToUpdate) {
          if (task.status == 'PENDENTE') {
            task.status = 'CONCLUÍDA';
          } else {
            task.status = 'PENDENTE';
          }
        }
        _tasksList.add(task);
      }
      List<String> taskListString = [];
      for (Task task in _tasksList) {
        Map taskMap = task.toJson();
        String taskString = jsonEncode(taskMap);
        taskListString.add(taskString);
      }
      SharedPreferencesClass.prefsInstance!
          .setStringList('tasksStringList', taskListString);
      _updatStatusLoading.value = false;
      return true;
    } catch (e) {
      return false;
    }
  }

  //Função responsável pela exclusão de uma Task
  Future<bool> onDeleteTask(String titleToDelete) async {
    _deleteLoading.value = true;
    _deleteErrorMessage = '';
    await Future.delayed(const Duration(seconds: 1));
    try {
      List<String> tasksStringListSaved = SharedPreferencesClass.prefsInstance!
              .getStringList('tasksStringList') ??
          [];
      _tasksList.clear();
      for (String taskString in tasksStringListSaved) {
        Map taskMap = jsonDecode(taskString);
        Task task = Task.fromJson(taskMap);

        if (task.title != titleToDelete) {
          _tasksList.add(task);
        }
      }
      List<String> taskListString = [];
      for (Task task in _tasksList) {
        Map taskMap = task.toJson();
        String taskString = jsonEncode(taskMap);
        taskListString.add(taskString);
      }
      SharedPreferencesClass.prefsInstance!
          .setStringList('tasksStringList', taskListString);
      _deleteLoading.value = false;
      return true;
    } catch (e) {
      _deleteErrorMessage = 'Não foi possível deletar';
      return false;
    }
  }
}
