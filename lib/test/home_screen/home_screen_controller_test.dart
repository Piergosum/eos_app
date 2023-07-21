import 'package:eos_app/screens/home/controller/home_screen_controller.dart';
import 'package:eos_app/storage/models/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HomeScreenController homeScreenController;

  setUp(() {
    homeScreenController = HomeScreenController();
  });
  group('Home Screen Controller Test', () {
    test('should return true for tasks list loaded from local storage',
        () async {
      bool loadTasksReturn = await homeScreenController.loadTasks();
      expect(loadTasksReturn, true);
    });

    test('should return true for tasks list saved in local storage', () async {
      bool registerTaskReturn = await homeScreenController.registerTask(
          'Task 1', 'Descrição Teste', '27/07/2023');
      expect(registerTaskReturn, true);
    });

    test('should return true for Pending checkbox marked', () async {
      homeScreenController.changeCheckBoxValue(true, 'Pendentes');
      expect(homeScreenController.pendingTasksCheckBox.value, true);
    });

    test('should validate taskTitle form and return a validate error message',
        () async {
      String? validadeErrorMessage =
          homeScreenController.taskTitleFormValidator('');
      expect(validadeErrorMessage, 'Escolha um título');
    });
  });
}
