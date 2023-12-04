import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:orbit/db/db_helper.dart';
import 'package:orbit/services/theme_services.dart';
import 'package:orbit/ui/pages/home_page.dart';
import 'package:orbit/ui/theme.dart';
import 'package:orbit/ui/pages/login_page.dart';
import 'package:orbit/ui/pages/signup_page.dart';
import 'package:supabase/supabase.dart'; // Import the Supabase package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SupabaseClient supabase = SupabaseClient(
    'https://indnhahbtxnhnpnoiall.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImluZG5oYWhidHhuaG5wbm9pYWxsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE3MTUyMjksImV4cCI6MjAxNzI5MTIyOX0.lQCNgB-Xe5Keh0FaX8KCDm0eqxNtE8aT-LTF6YPCp70',
  ); // Initialize Supabase here

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LoginPage(supabase: supabase)), // Pass supabase instance to login page
        GetPage(name: '/home', page: () => HomePage(supabase: supabase)), // Pass supabase instance to home page
        GetPage(name: '/signup', page: () => SignUpPage(supabase: supabase)), // Pass supabase instance to sign-up page
      ],
    );
  }
}
