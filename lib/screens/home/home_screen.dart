import 'package:eos_app/screens/home/controller/home_screen_controller.dart';
import 'package:eos_app/screens/home/widgets/custom_checkbox.dart';
import 'package:eos_app/screens/home/widgets/new_task_registration_widget.dart';
import 'package:eos_app/screens/home/widgets/tasks_list.dart';
import 'package:eos_app/storage/models/task.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  late HomeScreenController _homeScreenController;
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final TextEditingController _taskDateController = TextEditingController();
  final _registerTaskFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _homeScreenController = HomeScreenController();
  }

  @override
  void dispose() {
    super.dispose();
    _homeScreenController.dispose();
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    _taskDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Task> taskListFilter() {
      if (_homeScreenController.selectedCheckBox == 'Todas') {
        return _homeScreenController.tasksList;
      } else {
        List<Task> filteredList = [];
        for (Task task in _homeScreenController.tasksList) {
          if (task.status ==
              _homeScreenController.selectedCheckBox
                  .substring(
                      0, _homeScreenController.selectedCheckBox.length - 1)
                  .toUpperCase()) {
            filteredList.add(task);
          }
        }
        return filteredList;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(
              height: 50,
              child: Image.asset(
                'images/eos_logo.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text('Lista de Tarefas'),
          ],
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomCheckBox(
                      type: 'Pendentes',
                      onChanged: _homeScreenController.changeCheckBoxValue,
                      valueListenable:
                          _homeScreenController.pendingTasksCheckBox,
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Expanded(
                    child: CustomCheckBox(
                      type: 'Concluídas',
                      onChanged: _homeScreenController.changeCheckBoxValue,
                      valueListenable:
                          _homeScreenController.completedTasksCheckBox,
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Expanded(
                    child: CustomCheckBox(
                      type: 'Todas',
                      onChanged: _homeScreenController.changeCheckBoxValue,
                      valueListenable: _homeScreenController.allTasksCheckBox,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _homeScreenController.loadTasks(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ValueListenableBuilder(
                            valueListenable: _homeScreenController.tasksLoading,
                            builder: (context, value, child) {
                              if (value) {
                                return const CircularProgressIndicator();
                              } else {
                                List<Task> filteredTaskList = taskListFilter();
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child: Column(
                                    children: [
                                      filteredTaskList.isNotEmpty
                                          ? TasksList(
                                              list: filteredTaskList,
                                              homeScreenController:
                                                  _homeScreenController)
                                          : Center(
                                              child: _homeScreenController
                                                          .selectedCheckBox !=
                                                      'Todas'
                                                  ? Text(
                                                      'Nenhuma tarefa ${_homeScreenController.selectedCheckBox.toLowerCase().substring(0, _homeScreenController.selectedCheckBox.length - 1)} registrada',
                                                    )
                                                  : const Text(
                                                      'Nenhuma tarefa registrada'),
                                            ),
                                    ],
                                  ),
                                );
                              }
                            },
                          );
                        } else {
                          return const Center(
                              child: Column(
                            children: [
                              Text('Carregando minhas tarefas'),
                              CircularProgressIndicator(),
                            ],
                          ));
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    NewTaskRegistrationWidget(
                        homeScreenController: _homeScreenController,
                        registerTaskFormKey: _registerTaskFormKey,
                        taskTitleController: _taskTitleController,
                        taskDateController: _taskDateController,
                        taskDescriptionController: _taskDescriptionController),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
