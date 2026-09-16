import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const RunMyApp());
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  // Variable to manage the current theme mode
  ThemeMode _themeMode = ThemeMode.system;

  // Method to toggle the theme
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    _saveThemeMode(_themeMode);
  }

  @override
  Widget build(BuildContext context) {
    //_loadThemeMode();
    bool isDark = _themeMode == ThemeMode.dark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Theme Demo',

      // TODO: Customize these themes further if desired
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[200], // Light mode background
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        extensions: const [AppColors(success: Colors.green)],
      ),
      darkTheme: ThemeData.dark(), // Dark mode configuration

      themeMode: _themeMode, // Connects the state to the app

      home: /*AnimatedTheme(
        data: Theme.of(context),
        duration: const Duration(milliseconds: 500),
        child:*/ Scaffold(
        appBar: AppBar(title: const Text('Theme Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // PART 1 TASK: Container and Text
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 300,
                height: 200,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // Use a ternary operator to check theme brightness
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Mobile App Development Testing',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              const Text('Choose the Theme:', style: TextStyle(fontSize: 16)),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isDark ? Icons.nightlight_round : Icons.wb_sunny),
                  const SizedBox(width: 10),
                  Switch(
                    value: isDark,
                    onChanged: (bool isDark) {
                      setState(() {
                        _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
                      });
                    },
                  ),
                ],
              ),
              /*
              // PART 1 TASK: Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => changeTheme(ThemeMode.light),
                    child: const Text('Light Theme'),
                  ),
                  ElevatedButton(
                    onPressed: () => changeTheme(ThemeMode.dark),
                    child: const Text('Dark Theme'),
                  ),
                ],
              ),
              */
            ],
          ),
        ),
      ),
    );
    //);
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('themeMode');
    setState(() {
      _themeMode = ThemeMode.values.byName(saved ?? 'system');
    });
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.name);
  }
}

class AppColors extends ThemeExtension<AppColors> {
  final Color success;
  const AppColors({required this.success});

  @override
  AppColors copyWith({Color? success}) =>
      AppColors(success: success ?? this.success);

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(success: Color.lerp(success, other.success, t)!);
  }
}
