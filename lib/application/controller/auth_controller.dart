import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player_media/application/controller/home_screen_feed_controller.dart';
import 'package:video_player_media/application/presentation/screens/home_screen/home_screen.dart';
import 'package:video_player_media/data/service/auth_service.dart';
import 'package:video_player_media/domain/repo/auth_repo.dart';
import 'package:video_player_media/service/local_storage/shared_preference.dart';

class AuthController extends ChangeNotifier {
  AuthRepo authService = AuthService();
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Future<void> login(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      print('login called');
      final result = await authService.login(
        loginModel: {'country_code': '+91', 'phone': phoneController.text},
      );
      result.fold(
        (failure) {
          isLoading = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('invalid number'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(10),
              duration: const Duration(seconds: 3),
            ),
          );
        },
        (success) async {
          isLoading = false;
          notifyListeners();
          log('login success');
          print("tokennn ${success.token}");
          await SharedPreference.saveToken(
            tokenData: success.token?.access ?? '',
          );
          log('added to shared preference');
          print('authantication successful');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Authantification successfully done'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(10),
              duration: const Duration(seconds: 3),
            ),
          );
          context.read<HomeScreenFeedController>().getAllCategories();
          context.read<HomeScreenFeedController>().getHomeScreenFeeds();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
          );
        },
      );
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 3),
        ),
      );
      print('e main failure');
    }
  }
}
