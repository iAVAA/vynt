import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vynt/screens/login_pages/login_page.dart';
import 'package:vynt/screens/login_pages/main_login_page.dart';
import 'package:vynt/screens/splash_screen.dart';
import 'controllers/scroll_monitor.dart';
import 'firebase_options.dart';
import 'constants/constants.dart' as constants;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ScrollMonitor(),
      child: const Main(),
    ),
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: constants.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainLoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
