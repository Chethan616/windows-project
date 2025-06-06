import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import screens
import 'screens/welcome_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_app_screen.dart';

// Import models
import 'models/privacy_controller.dart';
import 'models/auth_controller.dart';
import 'models/theme_controller.dart';
import 'models/model_controller.dart';

// Add this import
import 'models/chat_controller.dart';

// Import theme
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize hotkey manager
  await hotKeyManager.unregisterAll();
  
  // Initialize window manager for desktop
  await windowManager.ensureInitialized();
  
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 800),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  
  // Register hotkey
  HotKey hotKey = HotKey(
    KeyCode.keyH,
    modifiers: [Platform.isMacOS ? KeyModifier.meta : KeyModifier.control],
    scope: HotKeyScope.system,
  );
  
  await hotKeyManager.register(
    hotKey,
    keyDownHandler: (hotKey) {
      // Toggle app visibility
      print('Hotkey pressed: ${hotKey.keyCode}');
      // Add your toggle logic here
      _toggleAppVisibility();
    },
  );
  
  runApp(const MyApp());
}

// Function to toggle app visibility
void _toggleAppVisibility() async {
  if (await windowManager.isVisible()) {
    await windowManager.hide();
  } else {
    await windowManager.show();
    await windowManager.focus();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Remove the provider access from here
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PrivacyController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => ModelController()),
        ChangeNotifierProvider(create: (_) => ChatController()), // Add this line
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, _) {
          return MaterialApp(
            title: 'WizardOS',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const WelcomeScreen(),
              '/signup': (context) => const SignupScreen(),
              '/main': (context) => const MainAppScreen(),
            },
            // Add this builder to initialize auth after MaterialApp is built
            // In the MaterialApp builder section
            builder: (context, child) {
              // Initialize auth once when the app starts
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Provider.of<AuthController>(context, listen: false).initAuth().then((_) {
                  // Load API keys from Firestore after authentication
                  if (Provider.of<AuthController>(context, listen: false).isLoggedIn) {
                    Provider.of<ModelController>(context, listen: false).loadApiKeysFromFirestore();
                  }
                });
              });
              return child!;
            },
          );
        },
      ),
    );
  }
}