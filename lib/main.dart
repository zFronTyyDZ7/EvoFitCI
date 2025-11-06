import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/home_screen.dart';
import 'screens/mapa_screen.dart';
import 'screens/objetivo_screen.dart';
import 'screens/chat_ai_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedEmail = prefs.getString("userEmail");

  runApp(EvotifApp(initialRoute: savedEmail != null ? '/home' : '/'));
}

class EvotifApp extends StatelessWidget {
  final String initialRoute;
  const EvotifApp({super.key, this.initialRoute = '/'});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = ThemeData.light().textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EvoFit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(baseTextTheme),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      themeMode: ThemeMode.system,
      initialRoute: initialRoute,
      routes: {
        '/': (_) => const LoginScreen(),
        '/cadastro': (_) => const CadastroScreen(),
        '/home': (_) => const HomeScreen(),
        '/mapa': (_) => const MapaScreen(),
        '/objetivo': (_) => const ObjetivoScreen(),
        '/chat_ai': (_) => const ChatAiScreen(), // << ROTA DA IA AQUI
      },
    );
  }
}
