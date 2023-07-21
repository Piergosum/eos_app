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

    test('should return true for tasks list saved in local storage', () {
      Task task = Task(
          title: 'Task One',
          description: 'teste',
          date: '27/07/2023',
          status: 'Pendente');
      bool registerTaskReturn = homeScreenController.registerTask(task);
      expect(registerTaskReturn, true);
    });
  });
}
