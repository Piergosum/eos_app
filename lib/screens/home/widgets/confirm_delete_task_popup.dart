import 'package:eos_app/screens/home/controller/home_screen_controller.dart';
import 'package:flutter/material.dart';

class ConfirmDeleteTaskPopup {
  Future<void> showCustomPopup(BuildContext context, String title,
      HomeScreenController homeScreenController) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          title: const Text(
            'Tem certeza que deseja excluir a tarefa?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          titlePadding: const EdgeInsets.all(10),
          insetPadding: const EdgeInsets.all(30),
          contentPadding:
              const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30,
              ),
              ValueListenableBuilder(
                valueListenable: homeScreenController.deleteLoading,
                builder: (context, value, child) {
                  if (value) {
                    return const Column(
                      children: [
                        Text('Excluíndo...'),
                        SizedBox(
                          height: 20,
                        ),
                        CircularProgressIndicator()
                      ],
                    );
                  } else {
                    if (homeScreenController.deleteErrorMessage.isNotEmpty) {
                      return Text(homeScreenController.deleteErrorMessage);
                    } else {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () async {
                                bool result = await homeScreenController
                                    .onDeleteTask(title);
                                if (result) {
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                  await homeScreenController.loadTasks();
                                }
                              },
                              child: const Text('Sim'),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Não'),
                            ),
                          )
                        ],
                      );
                    }
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}
