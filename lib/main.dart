import 'package:elevata/screens/BotomNavBar.dart';
import 'package:elevata/screens/CreateCampaignPage.dart';
import 'package:elevata/screens/DetailCampagnePage.dart';
import 'package:elevata/screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
        (_) => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    // Sample campaign data (replace with your actual data source)
    final Map<String, dynamic> sampleCampaign = {
      'title': 'Example Campaign',
      'description': 'This is an example campaign description.',
      'images': ['assets/image1.jpg', 'assets/image2.jpg'],
      'organization': 'Example Org',
      'organizationLogo': 'assets/logo.png',
      'location': 'Kinshasa',
      'progress': 0.75,
      'amountRaised': '750€',
      'goalAmount': '1000€',
      'daysLeft': 10,
      'isUrgent': true,
      'recentDonors': [
        {'name': 'Donor 1', 'amount': '50€', 'timeAgo': '1h'},
        {'name': 'Donor 2', 'amount': '25€', 'timeAgo': '2h'},
      ],
      'organizer': {
        'description': 'About the organizer',
        'phone': '+243...',
        'email': 'organizer@example.com',
        'website': 'www.example.com',
      },
    };

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'), // Français
      ],
      locale: const Locale('fr', 'FR'),
      debugShowCheckedModeBanner: false,
      home:CreateCampaignPage()
      //CampaignDetailPage(campaign: sampleCampaign),
    );
  }
}
