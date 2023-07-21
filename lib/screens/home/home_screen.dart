import 'package:eos_app/screens/home/controller/home_screen_controller.dart';
import 'package:eos_app/screens/home/widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  //CRIAR GETTERS E SETTERS

  @override
  Widget build(BuildContext context) {
    HomeScreenController homeScreenController = HomeScreenController();
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
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              CustomCheckBox(
                  type: 'Todas',
                  value: homeScreenController.allTasksCheckBox.value,
                  onChanged: homeScreenController.changeCheckBoxValue),
              CustomCheckBox(
                  type: 'Concluídas',
                  value: homeScreenController.completedTasksCheckBox.value,
                  onChanged: homeScreenController.changeCheckBoxValue),
              CustomCheckBox(
                  type: 'Pendentes',
                  value: homeScreenController.pendingTasksCheckBox.value,
                  onChanged: homeScreenController.changeCheckBoxValue)
            ]),
            FutureBuilder(
              future: homeScreenController.loadTasks(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ValueListenableBuilder(
                    valueListenable: homeScreenController.tasksLoading,
                    builder: (context, value, child) {
                      if (value) {
                        return const CircularProgressIndicator();
                      } else {
                        return ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Card(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(homeScreenController
                                      .tasksList[index].title),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Spacer();
                            },
                            itemCount: homeScreenController.tasksList.length);
                      }
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
