import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrapdealer/firebase_options.dart';
import 'package:scrapdealer/screens/add_scrap_type_screen/add_scrap_type_screen.dart';
import 'package:scrapdealer/screens/dashboard.dart';
import 'package:scrapdealer/screens/sign_in_screens/login_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final loginIn = GetStorage().read("isLoginDealer") ?? false;
    Widget initialScreen = loginIn ? DealerDashboardScreen() : LoginScreen();

    return GetMaterialApp(
      title: 'Scrap Dealer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: initialScreen,
    );
  }
}
