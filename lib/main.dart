import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:waloma/core/providers/listing_providers.dart';
import 'package:waloma/core/providers/message_providers.dart';
import 'package:waloma/core/providers/notification_providers.dart';
import 'package:waloma/core/providers/review_providers.dart';
import 'package:waloma/core/services/message_services/message_services.dart';
import 'package:waloma/core/services/notification_services/notification_api_services.dart';
import 'package:waloma/views/screens/forgot_password_page.dart';
import 'package:waloma/views/screens/login_page.dart';
import 'package:waloma/views/screens/page_switcher.dart';
import 'package:waloma/views/screens/register_page.dart';
import 'constant/app_color.dart';

Widget _defaultHome = PageSwitcher();

final messageProvider = MessageProvider();
final notificationProvider = NotificationProvider();
ChatService chatService = ChatService(messageProvider: messageProvider);
NotificationAPIService notificationAPIService =
    NotificationAPIService(notificationProvider: notificationProvider);

void main() async {
  // Run the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ListingsProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => notificationProvider),
        ChangeNotifierProvider(create: (_) => messageProvider),
      ],
      child: MyApp(),
    ),
  );
}

// Initializes necessary app settings and system configurations.
Future<void> _initializeAppSettings() async {
  // // Ensuring login check.
  // bool isLoggedIn = await SharedService.isLoggedIn();
  // _defaultHome = isLoggedIn ? const LoginPage() : PageSwitcher();

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColor.primary,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Nunito',
      ),
      home: _defaultHome,
      // home: FutureBuilder(
      //   future: SharedService.isLoggedIn(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const CircularProgressIndicator(); // Display a loading spinner while awaiting login status
      //     } else if (snapshot.hasData && snapshot.data == true) {
      //       return PageSwitcher();
      //     } else {
      //       return const LoginPage(); // Otherwise, show the login page
      //     }
      //   },
      // ),
      routes: {
        '/landing': (context) => PageSwitcher(),
        '/login': (context) => const LoginPage(),
        '/forgot': (context) => const ForgotPasswordPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
