import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/enums.dart';
import '../model/screen_info.dart';
import '../root.dart';
import '../services/theme_provider.dart';

bool isTaskDark = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('isTaskDark')) {
    isTaskDark = prefs.getBool('isTaskDark') ?? false;
  } else {
    prefs.setBool('isTaskDark', false);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData getTheme() => isTaskDark ? ThemeData.dark() : ThemeData.light();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ThemeProvider(getTheme())),
        ChangeNotifierProvider<ScreenInfo>(
            create: (ctx) => ScreenInfo(screenType: ScreenType.tasktodo)),
      ],
      child: const MainRoot(),
    );
  }
}

class MainRoot extends StatefulWidget {
  const MainRoot({Key? key}) : super(key: key);

  @override
  State<MainRoot> createState() => _MainRootState();
}

class _MainRootState extends State<MainRoot> {
  final Future<FirebaseApp> _initFire = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.getTheme(),
      home: FutureBuilder(
          future: _initFire,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const Root();
            }
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
