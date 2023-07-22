import 'package:brasil_fields/brasil_fields.dart';
import 'package:eos_app/screens/home/controller/home_screen_controller.dart';
import 'package:eos_app/screens/home/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class NewTaskRegistrationWidget extends StatelessWidget {
  const NewTaskRegistrationWidget(
      {super.key,
      required this.homeScreenController,
      required this.registerTaskFormKey,
      required this.taskTitleController,
      required this.taskDateController,
      required this.taskDescriptionController});

  final HomeScreenController homeScreenController;
  final GlobalKey<FormState> registerTaskFormKey;
  final TextEditingController taskTitleController;
  final TextEditingController taskDateController;
  final TextEditingController taskDescriptionController;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
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
            key: registerTaskFormKey,
            child: Column(
              children: [
                CustomTextFormField(
                  label: 'Título',
                  controller: taskTitleController,
                  validator: homeScreenController.taskTitleFormValidator,
                  inputFormatters: const [],
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  label: 'Data',
                  controller: taskDateController,
                  validator: homeScreenController.taskDateFormValidator,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  label: 'Descrição',
                  controller: taskDescriptionController,
                  validator: homeScreenController.taskDescriptionFormValidator,
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
                  valueListenable: homeScreenController.registerLoading,
                  builder: (context, value, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        if (registerTaskFormKey.currentState!.validate()) {
                          await homeScreenController.registerTask(
                              taskTitleController.text,
                              taskDescriptionController.text,
                              taskDateController.text);
                        }
                        taskTitleController.clear();
                        taskDescriptionController.clear();
                        taskDateController.clear();
                      },
                      child: value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Registrar'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
