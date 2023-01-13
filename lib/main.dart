import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saf_user/providers/user_provider.dart';
import 'package:saf_user/screens/bottom_navigation_bar_screen.dart';
import 'package:saf_user/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Safeibala',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.blue),
            ),
            textTheme: const TextTheme(
              headline1: TextStyle(color: Color.fromARGB(95, 18, 18, 18)),
              headline2: TextStyle(color: Color.fromARGB(95, 18, 18, 18)),
              subtitle1: TextStyle(color: Color.fromARGB(95, 18, 18, 18)),
              bodyText1: TextStyle(fontSize: 20.0),
              bodyText2: TextStyle(fontSize: 16.0),
              button: TextStyle(fontSize: 15.0),
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.white,
              secondary: const Color.fromARGB(255, 1, 149, 211),
            ),
          ),
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return BottomNavigationBarScreen();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  const CircularProgressIndicator();
                }

                return SignInScreen();
              })
              ),
    );
  }
}
