import 'package:get/get.dart';
import 'package:orbit/db/db_helper.dart';
import 'package:orbit/models/task.dart';
import 'package:supabase/supabase.dart'; // Import the Supabase package
import 'package:shared_preferences/shared_preferences.dart';

class TaskController extends GetxController {
  // final SupabaseClient supabase;

  // TaskController({required this.supabase});
    final SupabaseClient supabase = SupabaseClient(
    'https://indnhahbtxnhnpnoiall.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImluZG5oYWhidHhuaG5wbm9pYWxsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE3MTUyMjksImV4cCI6MjAxNzI5MTIyOX0.lQCNgB-Xe5Keh0FaX8KCDm0eqxNtE8aT-LTF6YPCp70',
  ); // Initialize Supabase here

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
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  print(userId);

    final response = await supabase
      .from('tasks')
      .select()
      .eq('user_id', userId) // Filter tasks by user_id
      .execute();    
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

// Delete data from table using Supabase
void deleteTask(Task task) async {
  // Assuming 'tasks' is the table name in your Supabase database
  final response = await supabase
      .from('tasks')
      .delete()
      .eq('id', task.id) // Assuming 'id' is the identifier for the task
      .execute();

  if (response.error == null) {
    // Deletion was successful
    getTasks(); // Refresh the task list after deletion
  } 
}

  // update data int table
  void markTaskCompleted(int id) async {
    final response = await supabase
        .from('tasks')
        .update({'iscompleted': 1})
        .eq('id', id) // assuming 'id' is the unique identifier for a task
        .execute();

    if (response.error != null) {
      // Handle error while updating task
      print('Error updating task: ${response.error!.message}');
      return;
    }

    // Refresh the task list after update
    getTasks();
  }
}
