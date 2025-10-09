import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:video_player_media/data/service/home_screen_feed_service.dart';
import 'package:video_player_media/domain/model/category_list/category_list.dart';
import 'package:video_player_media/domain/model/home_page_feed/home_page_feed.dart';
import 'package:video_player_media/domain/repo/home_screen_feed_repo.dart';


class HomeScreenFeedController extends ChangeNotifier {
  CategoryResponse categories = CategoryResponse();
  HomeResponse homeScreenFeeds = HomeResponse();
  HomeScreenFeedRepo homeScreenFeedService = HomeScreenFeedService();
  bool categoryLoading = false;
  bool homeScreenFeedsLoading = false;

  // Video controllers map

  Future<void> getAllCategories() async {
    try {
      categoryLoading = true;
      notifyListeners();
      final result = await homeScreenFeedService.getCategoryList();
      result.fold(
        (failure) {
          categoryLoading = false;
          notifyListeners();
        },
        (success) {
          categories = success;
          log('getcategories success');
          categoryLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      categoryLoading = false;
      notifyListeners();
      log('getallcategories ${e.toString()}');
    }
  }

  Future<void> getHomeScreenFeeds() async {
    try {
      homeScreenFeedsLoading = true;
      notifyListeners();
      final result = await homeScreenFeedService.getHomeFeeds();
      result.fold(
        (failure) {
          homeScreenFeedsLoading = false;
          notifyListeners();
        },
        (success) {
          homeScreenFeeds = success;
          log('getHomeFeeds success');
          homeScreenFeedsLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      homeScreenFeedsLoading = false;
      notifyListeners();
      log('getHomeFeeds ${e.toString()}');
    }
  }


  /// Dispose all video controllers

  @override
  void dispose() {
    super.dispose();
  }
}