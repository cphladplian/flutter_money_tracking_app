import 'package:flutter/material.dart';
import 'package:flutter_money_tracking_app/views/splash_screen_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://oqeumqkkvzkdparkhclq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9xZXVtcWtrdnprZHBhcmtoY2xxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY1MTc4MDIsImV4cCI6MjA5MjA5MzgwMn0.nk_PaR2kuAc4dPBDxG1dx85VfEuwRwErqRr5hjMH5QQ',
  );

  runApp(const FlutterMoneyTrackingApp());
}

class FlutterMoneyTrackingApp extends StatelessWidget {
  const FlutterMoneyTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money App',
      theme: ThemeData(
        textTheme: GoogleFonts.kanitTextTheme(),
      ),
      home: const SplashScreenUi(),
    );
  }
}
