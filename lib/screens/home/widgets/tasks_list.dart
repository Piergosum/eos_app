import 'package:eos_app/screens/home/widgets/task_card.dart';
import 'package:eos_app/storage/models/task.dart';
import 'package:flutter/material.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key, required this.list});

  final List<Task> list;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return TaskCard(
              title: list[index].title,
              description: list[index].description,
              date: list[index].date,
              status: list[index].status);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: list.length);
  }
}
