import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../services/firestore_service.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

final tasksStreamProvider = StreamProvider<List<TaskModel>>((ref) {
  return ref.watch(firestoreServiceProvider).getTasks();
});

final pendingTasksCountProvider = Provider<int>((ref) {
  final tasksAsync = ref.watch(tasksStreamProvider);
  return tasksAsync.maybeWhen(
    data: (tasks) => tasks.where((task) => !task.isCompleted).length,
    orElse: () => 0,
  );
});

final completedTasksCountProvider = Provider<int>((ref) {
  final tasksAsync = ref.watch(tasksStreamProvider);
  return tasksAsync.maybeWhen(
    data: (tasks) => tasks.where((task) => task.isCompleted).length,
    orElse: () => 0,
  );
});
