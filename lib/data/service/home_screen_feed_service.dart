import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:video_player_media/core/api_end_points.dart';
import 'package:video_player_media/domain/model/category_list/category_list.dart';
import 'package:video_player_media/domain/model/failure_response/failure_response.dart';
import 'package:video_player_media/domain/model/home_page_feed/home_page_feed.dart';
import 'package:video_player_media/domain/repo/home_screen_feed_repo.dart';

class HomeScreenFeedService implements HomeScreenFeedRepo {
  Dio apiService = Dio(
    BaseOptions(
      baseUrl: ApiEndPoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  ApiEndPoints apiEndPoints = ApiEndPoints();
  @override
  Future<Either<Failure, CategoryResponse>> getCategoryList() async {
    try {
      final response = await apiService.get(apiEndPoints.categoryList);
      return Right(CategoryResponse.fromJson(response.data));
    } on DioException catch (e) {
      log(' getHomeFeeds${e.toString()}');
      return Left(Failure(message: 'Something went wrong'));
    } catch (e) {
      log(' getHomeFeeds${e.toString()}');
      return Left(Failure(message: 'Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, HomeResponse>> getHomeFeeds() async {
    try {
      final response = await apiService.get(apiEndPoints.homeScreenFeeds);
      return Right(HomeResponse.fromJson(response.data));
    } on DioException catch (e) {
      log(' getHomeFeeds${e.toString()}');
      return Left(Failure(message: 'getHomeFeeds Something went wrong'));
    } catch (e) {
      log(' getHomeFeeds${e.toString()}');
      return Left(Failure(message: 'Something went wrong'));
    }
  }
}
