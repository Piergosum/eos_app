import 'package:eos_app/screens/home/controller/home_screen_controller.dart';
import 'package:eos_app/screens/home/widgets/custom_checkbox.dart';
import 'package:eos_app/screens/home/widgets/custom_text_form_field.dart';
import 'package:eos_app/screens/home/widgets/tasks_list.dart';
import 'package:eos_app/storage/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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

  //CRIAR GETTERS E SETTERS
  //DISPOSE
  //DATA BRASILFIELDS

  @override
  Widget build(BuildContext context) {
    List<Task> taskListFilter() {
      print('ENTROU NO FILTRO');
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lista de Tarefas'),
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
                        type: 'Todas',
                        onChanged: _homeScreenController.changeCheckBoxValue,
                        valueListenable: _homeScreenController.allTasksCheckBox,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomCheckBox(
                              type: 'Concluídas',
                              onChanged:
                                  _homeScreenController.changeCheckBoxValue,
                              valueListenable:
                                  _homeScreenController.completedTasksCheckBox,
                            ),
                          ),
                          Expanded(
                            child: CustomCheckBox(
                              type: 'Pendentes',
                              onChanged:
                                  _homeScreenController.changeCheckBoxValue,
                              valueListenable:
                                  _homeScreenController.pendingTasksCheckBox,
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Minhas tarefas:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 6,
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
                              print('BUILDOU');
                              if (value) {
                                print('CHAMOUUUU');
                                return const CircularProgressIndicator();
                              } else {
                                List<Task> filteredTaskList = taskListFilter();
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    filteredTaskList.isNotEmpty
                                        ? TasksList(list: filteredTaskList)
                                        : const Center(
                                            child: Text(
                                                'Nenhuma tarefa registrada'),
                                          ),
                                  ],
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
                    ExpansionTile(
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(LineAwesomeIcons.tasks),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Registrar nova tarefa'),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 40),
                          child: Form(
                            key: _registerTaskFormKey,
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  label: 'Título',
                                  controller: _taskTitleController,
                                  validator: _homeScreenController
                                      .taskTitleFormValidator,
                                  inputFormatters: const [],
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomTextFormField(
                                  label: 'Data',
                                  controller: _taskDateController,
                                  validator: _homeScreenController
                                      .taskDateFormValidator,
                                  inputFormatters: [
                                    //DataInputFormatter(),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomTextFormField(
                                  label: 'Descrição',
                                  controller: _taskDescriptionController,
                                  validator: _homeScreenController
                                      .taskDescriptionFormValidator,
                                  inputFormatters: const [],
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                ValueListenableBuilder(
                                  valueListenable:
                                      _homeScreenController.registerLoading,
                                  builder: (context, value, child) {
                                    return ElevatedButton(
                                      onPressed: () async {
                                        if (_registerTaskFormKey.currentState!
                                            .validate()) {
                                          await _homeScreenController
                                              .registerTask(
                                                  _taskTitleController.text,
                                                  _taskDescriptionController
                                                      .text,
                                                  _taskDateController.text);
                                        }
                                        _taskTitleController.clear();
                                        _taskDescriptionController.clear();
                                        _taskDateController.clear();
                                      },
                                      child: value
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : const Text('Registrar'),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
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
