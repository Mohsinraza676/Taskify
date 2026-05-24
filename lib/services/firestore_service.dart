import 'package:firebase_database/firebase_database.dart';
import '../models/task_model.dart';

class FirestoreService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final String _path = 'tasks';

  // Stream of tasks
  Stream<List<TaskModel>> getTasks() {
    return _db.ref(_path).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      
      return data.entries.map((entry) {
        final taskMap = Map<String, dynamic>.from(entry.value as Map);
        return TaskModel.fromMap(taskMap);
      }).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  // Add task
  Future<void> addTask(TaskModel task) {
    return _db.ref('$_path/${task.id}').set(task.toMap());
  }

  // Delete task
  Future<void> deleteTask(String id) {
    return _db.ref('$_path/$id').remove();
  }

  // Toggle complete
  Future<void> toggleComplete(String id, bool isCompleted) {
    return _db.ref('$_path/$id').update({'isCompleted': isCompleted});
  }

  // Update task
  Future<void> updateTask(String id, String title, String description) {
    return _db.ref('$_path/$id').update({
      'title': title,
      'description': description,
    });
  }
}
