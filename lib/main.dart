import 'package:flutter/material.dart';
import 'screens/taller1_screen.dart';
import 'screens/async_screen.dart';
import 'screens/timer_screen.dart';
import 'screens/isolate_screen.dart';

void main() {
  runApp(const TallerFlutterApp());
}

class TallerFlutterApp extends StatelessWidget {
  const TallerFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller Flutter - Michael Vasco',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF97316), // Naranja cálido (Orange 500)
          primary: const Color(0xFFEA580C),   // Naranja vibrante
          secondary: const Color(0xFFD97706), // Ámbar tostado
          surface: const Color(0xFFFAFAF9),   // Fondo cálido claro
          onPrimary: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F5F2), // Tono arena / papel suave
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFFEA580C),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
            color: Colors.white,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFFED7AA), width: 1), // Borde ámbar suave
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFFFEDD5), // Píldora naranja pastel
          elevation: 4,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC2410C),
              );
            }
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF78716C),
            );
          }),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 1; // Inicia en Asincronía (Taller 2)

  final List<Widget> _screens = const [
    Taller1Screen(),
    AsyncScreen(),
    TimerScreen(),
    IsolateScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined),
            selectedIcon: Icon(Icons.widgets, color: Color(0xFFC2410C)),
            label: 'Taller 1',
          ),
          NavigationDestination(
            icon: Icon(Icons.bolt_outlined),
            selectedIcon: Icon(Icons.bolt, color: Color(0xFFC2410C)),
            label: 'Asincronía',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer, color: Color(0xFFC2410C)),
            label: 'Cronómetro',
          ),
          NavigationDestination(
            icon: Icon(Icons.precision_manufacturing_outlined),
            selectedIcon: Icon(Icons.precision_manufacturing, color: Color(0xFFC2410C)),
            label: 'Isolate',
          ),
        ],
      ),
    );
  }
}
