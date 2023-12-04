import 'package:get/get.dart';
import 'package:orbit/db/db_helper.dart';
import 'package:orbit/models/task.dart';
import 'package:supabase/supabase.dart'; // Import the Supabase package

class TaskController extends GetxController {
   final SupabaseClient supabase = SupabaseClient(
    'https://indnhahbtxnhnpnoiall.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImluZG5oYWhidHhuaG5wbm9pYWxsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE3MTUyMjksImV4cCI6MjAxNzI5MTIyOX0.lQCNgB-Xe5Keh0FaX8KCDm0eqxNtE8aT-LTF6YPCp70',
  ); 
  //this will hold the data and update the ui

  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  final taskList = <Task>[].obs;

  // add data to table
  //second brackets means they are named optional parameters
  Future<int> addTask({required Task task}) async {
    return await DBHelper.insert(task);
  }

  // get all the data from table
 Future<void> getTasks() async {
    final response = await supabase.from('tasks').select().execute();
    print(response.data);
    if (response.error != null) {
      // Handle error fetching tasks from Supabase
      print('Error fetching tasks: ${response.error!.message}');
      return;
    }

    // If tasks are fetched successfully, update your taskList
    List<Task> tasks = (response.data as List)
        .map((task) => Task.fromJson(task as Map<String, dynamic>))
        .toList();
    

  taskList.assignAll(tasks);
  }

  // delete data from table
  void deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  // update data int table
  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
