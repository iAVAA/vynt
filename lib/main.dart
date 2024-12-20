import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vynt/controllers/theme_controller.dart';
import 'package:vynt/screens/login_pages/login_page.dart';
import 'package:vynt/screens/login_pages/main_login_page.dart';
import 'package:vynt/screens/splash_screen.dart';
import 'controllers/scroll_monitor.dart';
import 'firebase_options.dart';
import 'constants/constants.dart' as constants;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'Vynt',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScrollMonitor()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return MaterialApp(
      title: constants.appName,
      theme: themeController.lightTheme,
      darkTheme: themeController.darkTheme,
      themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MainLoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
