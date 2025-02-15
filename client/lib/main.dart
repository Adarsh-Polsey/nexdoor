import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nexdoor/common/core/theme/app_theme.dart';
import 'package:nexdoor/features/ai_chat/view/ai_chat_screen.dart';
import 'package:nexdoor/features/auth/view/forgot_password_screen.dart';
import 'package:nexdoor/features/auth/view/login_screen.dart';
import 'package:nexdoor/features/auth/view/signup_screen.dart';
import 'package:nexdoor/features/blog/view/discussion_screen.dart';
import 'package:nexdoor/features/business/view/view_businesses_screen.dart';
import 'package:nexdoor/features/home/view/home_screen.dart';
import 'package:nexdoor/features/settings_profile/view/create_business_screen.dart';
import 'package:nexdoor/features/settings_profile/view/manage_business_screen.dart';
import 'package:nexdoor/features/settings_profile/view/settings_screen.dart';
import 'package:nexdoor/features/settings_profile/viewmodel/business_viewmodel.dart';
import 'package:nexdoor/features/settings_profile/viewmodel/user_viewmodel.dart';
import 'package:nexdoor/features/splash/view/splash_screen.dart';
import 'package:nexdoor/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BusinessViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        // Add other providers here
   ], child: ToastificationWrapper(child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightColorTheme,
      debugShowCheckedModeBanner: false,
      routes: {
        // Splash Screen
        "/": (context) => const SplashScreen(),
        // Auth Screens
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/reset_password': (context) => ResetPasswordScreen(),
        // Bottom Navigation Screens
        '/home': (context) => HomeScreen(),
        '/settings': (context) => SettingsScreen(),
        '/ai_chat_screen':(context)=>ChatScreen(),
        '/blog':(context)=>GroupScreen(),
        '/view_businesses': (context) => PostScreen(),
        // More - Settings screens
        '/create_business': (context) => CreateBusinessScreen(),
        '/manage_business': (context) => ManageBusinessScreen(),
      },
      initialRoute: '/',
    );
  }
}
