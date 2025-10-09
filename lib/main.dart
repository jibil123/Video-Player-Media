import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player_media/application/controller/auth_controller.dart';
import 'package:video_player_media/application/controller/home_screen_feed_controller.dart';
import 'package:video_player_media/application/controller/my_feed_controller.dart';
import 'package:video_player_media/application/presentation/screens/login_screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => HomeScreenFeedController()),
        ChangeNotifierProvider(create: (context) => MyFeedController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: const LoginScreen(),
      ),
    );
  }
}
