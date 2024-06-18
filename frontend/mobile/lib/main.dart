import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inv_mgmt_client/colors.dart';
import 'package:inv_mgmt_client/core/auth/presentation/auth_page.dart';
import 'package:inv_mgmt_client/core/home/presentation/home_page.dart';
import 'package:inv_mgmt_client/data/cache/app_cache.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await appCache.getDataFromDevice();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "InvMgmt",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor,
        ),
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: appCache.isLoggedIn() ? const HomePage() : const AuthPage(),
    );
  }
}
