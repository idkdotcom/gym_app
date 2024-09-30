import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_app/firebase_options.dart';
import 'package:gym_app/screens/auth.dart';
import 'package:gym_app/screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.oswald(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: GoogleFonts.oswald(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    displaySmall: GoogleFonts.oswald(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headlineMedium: GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    headlineSmall: GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    titleLarge: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    bodyLarge: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    labelLarge: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFFFFFFFF),        // Primary color
          secondary: Color(0xFF36454F),      // Accent or secondary color
          background: Color(0xFFDDDDDD),     // Background color
          surface: Color(0xFF36454F),        // Surface color
          onPrimary: Colors.black,           // Text color for primary elements
          onSecondary: Colors.white,         // Text color for secondary elements
          onBackground: Colors.black,        // Text color for background
          onSurface: Colors.white,           // Text color for surface elements
          error: Colors.red,                 // Error color
          onError: Colors.white,             // Text color for errors
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 225, 225, 225),
        useMaterial3: true,
        textTheme: lightTextTheme,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if(snapshot.hasData){
            return Homepage();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}