import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'core/theme/app_theme.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Init notifications
    await NotificationService().init();

    // Set immersive system UI
    AppTheme.setSystemUI();

    // Lock orientation to portrait
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e) {
    debugPrint('Initialization error: $e');
  } finally {
    // Small delay to ensure everything is ready for the first frame
    await Future.delayed(const Duration(milliseconds: 500));
    FlutterNativeSplash.remove();
  }

  runApp(
    const ProviderScope(
      child: MindspaceApp(),
    ),
  );
}
