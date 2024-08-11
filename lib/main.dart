import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gemini/core/firebase_app_check.dart';
import 'package:gemini/core/routes/go_router.dart';
import 'package:gemini/features/authentication/presentation/providers/token.dart';
import 'package:gemini/features/search_text/presentation/provider/search_type_provider.dart';
import 'package:gemini/features/teacher/presentation/providers/teacher.dart';
import 'package:gemini/features/user/presentation/providers/user_provider.dart';
import 'package:gemini/locator.dart';
import 'package:gemini/features/sqlite_database/database/text_database.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

/// import 'firebase_options.dart';

AppDatabase? database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheckHelper.initialiseAppCheck();

  initDependencies();
  database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => TeacherProvider()),
        ChangeNotifierProvider(create: (context) => TokenProvider()),
        ChangeNotifierProvider(create: (context) => SearchTypeProvider())
      ],
      child: MaterialApp.router(
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColorDark: Colors.white,
            useMaterial3: true,
            fontFamily: "Kodchasan"),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: "Kodchasan",
        ),
        // home: const SignupPage(),
      ),
    );
  }
}
