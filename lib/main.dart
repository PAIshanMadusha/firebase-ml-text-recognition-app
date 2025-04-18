import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_text_recognition_app/firebase_options.dart';
import 'package:firebase_ml_text_recognition_app/pages/splash_page.dart';
import 'package:firebase_ml_text_recognition_app/provider/premium_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Load the .env
  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env["PUBLISHABLE_KEY"] ?? "";

  //Firebase Initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PremiumProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Firebase ML Text Recognition App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(color: Colors.greenAccent),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.greenAccent),
          ),
        ),
      ),
      home: SplashPage(),
    );
  }
}
