import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nexdoor/common/core/theme/app_theme.dart';
import 'package:nexdoor/common/services/api_service.dart';
import 'package:nexdoor/features/ai_chat/view/chat_screen.dart';
import 'package:nexdoor/features/auth/view/forgot_password_screen.dart';
import 'package:nexdoor/features/auth/view/login_screen.dart';
import 'package:nexdoor/features/auth/view/signup_screen.dart';
import 'package:nexdoor/features/blog/view/discussion_screen.dart';
import 'package:nexdoor/features/business/repositories/business_repository.dart';
import 'package:nexdoor/features/business/view/view_businesses_screen.dart';
import 'package:nexdoor/features/home/view/home_screen.dart';
import 'package:nexdoor/features/settings_profile/repositories/create_business_repository.dart';
import 'package:nexdoor/features/settings_profile/repositories/create_service_repository.dart';
import 'package:nexdoor/features/settings_profile/view/about_screen.dart';
import 'package:nexdoor/features/settings_profile/view/create_business_screen.dart';
import 'package:nexdoor/features/settings_profile/view/create_services_screen.dart';
import 'package:nexdoor/features/settings_profile/view/manage_business_screen.dart';
import 'package:nexdoor/features/settings_profile/view/manage_service_screen.dart';
import 'package:nexdoor/features/settings_profile/view/settings_screen.dart';
import 'package:nexdoor/features/settings_profile/view/t_and_c_screen.dart';
import 'package:nexdoor/features/settings_profile/viewmodel/business_view_model.dart';
import 'package:nexdoor/features/settings_profile/viewmodel/service_viewmodel.dart';
import 'package:nexdoor/features/settings_profile/viewmodel/user_view_model.dart';
import 'package:nexdoor/features/splash/view/splash_screen.dart';
import 'package:nexdoor/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Create service instances
  final apiService = ApiService();
  
  runApp(
    MultiProvider(
      providers: [
        // Singleton Providers
        Provider<ApiService>.value(value: apiService),
        Provider<BusinessRepository>(
          create: (context) => BusinessRepository(),
        ),
        Provider<CreateBusinessRepository>(
          create: (context) => CreateBusinessRepository(apiService),
        ),
        Provider<CreateServiceRepository>(
          create: (context) => CreateServiceRepository(apiService),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => BusinessViewModel(
            context.read<CreateBusinessRepository>()
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ServiceViewModel(CreateServiceRepository(apiService)),
        ),
        ChangeNotifierProvider(
          create: (context) => BusinessListViewModel(
            context.read<BusinessRepository>()
          ),
        ),
      ],
      child: ToastificationWrapper(child: const MyApp()),
    ),
  );
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
        '/ai_chat_screen': (context) => ChatScreen(),
        '/blog': (context) => GroupScreen(),
        
        // Business Screens
        '/view_businesses': (context) => const BusinessListProvider(child: ViewBusinessScreen(),),
        '/manage_business': (context) => ManageBusinessScreen(),
        '/manage_services': (context) => ManageServiceScreen(),
        '/create_business': (context) => CreateBusinessWithServiceScreen(),
        '/create_services': (context) => AddServiceScreen(),
        
        // Other Screens
        '/t_and_c': (context) => TermsAndConditionsScreen(),
        '/about': (context) => AboutScreen(),
      },
      initialRoute: '/',
    );
  }
}