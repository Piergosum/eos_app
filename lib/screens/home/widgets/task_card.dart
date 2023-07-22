import 'package:eos_app/screens/home/controller/home_screen_controller.dart';
import 'package:eos_app/screens/home/widgets/confirm_delete_task_popup.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class TaskCard extends StatelessWidget {
  const TaskCard(
      {super.key,
      required this.title,
      required this.description,
      required this.date,
      required this.status,
      required this.homeScreenController});

  final String title;
  final String description;
  final String date;
  final String status;
  final HomeScreenController homeScreenController;

  @override
  Widget build(BuildContext context) {
    Color checkDateColor() {
      DateTime convertedDate = DateTime.utc(int.parse(date.substring(6, 10)),
          int.parse(date.substring(4, 5)), int.parse(date.substring(0, 2)));
      if ((convertedDate.year == DateTime.now().year &&
              convertedDate.month == DateTime.now().month &&
              convertedDate.day == DateTime.now().day) ||
          convertedDate.isBefore(DateTime.now())) {
        return Colors.red;
      } else {
        return Colors.black45;
      }
    }

    ConfirmDeleteTaskPopup confirmDeleteTaskPopup = ConfirmDeleteTaskPopup();
    return ValueListenableBuilder(
      valueListenable: homeScreenController.updatStatusLoading,
      builder: (context, value, child) {
        if (value && homeScreenController.titleToUpdate == title) {
          return const Center(
            child: Column(
              children: [
                Text('Atualizando...'),
                SizedBox(
                  height: 5,
                ),
                CircularProgressIndicator.adaptive(),
              ],
            ),
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                title.toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: status == 'PENDENTE'
                                      ? Colors.red
                                      : Colors.green),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () async {
                                bool result = await homeScreenController
                                    .updateTaskStatus(title);
                                if (result) {
                                  await homeScreenController.loadTasks();
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            'Não foi possível atualizar o status'),
                                        //backgroundColor: (Colors.black12),
                                        action: SnackBarAction(
                                          label: 'fechar',
                                          onPressed: () {},
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Icon(LineAwesomeIcons.edit),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Vencimento:',
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              date,
                              style: TextStyle(
                                color: checkDateColor(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(description),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  confirmDeleteTaskPopup.showCustomPopup(
                      context, title, homeScreenController);
                },
                icon: const Icon(LineAwesomeIcons.trash),
              ),
            ],
          );
        }
      },
    );
  }
}
