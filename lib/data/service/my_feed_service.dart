import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:video_player_media/core/api_end_points.dart';
import 'package:video_player_media/domain/model/failure_response/failure_response.dart';
import 'package:video_player_media/domain/model/home_page_feed/home_page_feed.dart';
import 'package:video_player_media/domain/model/success_response/success_response.dart';
import 'package:video_player_media/domain/repo/my_feed_repo.dart';
import 'package:video_player_media/service/local_storage/shared_preference.dart';

class MyFeedService implements MyFeedRepo {
  late Dio apiService;
  ApiEndPoints apiEndPoints = ApiEndPoints();

  MyFeedService() {
    apiService = Dio(BaseOptions(baseUrl: ApiEndPoints.baseUrl));

    apiService.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token =
              await SharedPreference.getToken(); // 👈 fetch token here
          if (token.isNotEmpty) {
            log(token);
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );

    apiService.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      ),
    );
  }
  @override
  Future<Either<Failure, SuccessResponse>> postMyFeed({
    required File video,
    required File image,
    required String desc,
    required List<int> categoryIds,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'video': await MultipartFile.fromFile(
          video.path,
          filename: video.path.split('/').last,
        ),
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
        'desc': desc,
        'category': categoryIds, // can be [23,24] etc
      });

      // Send POST request
      final response = await apiService.post(
        apiEndPoints.myFeed,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201 ||response.statusCode == 202) {
        return Right(SuccessResponse(message: 'success')); // success
      } else {
        return Left(Failure(message: 'Upload failed: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      log('Error: $e');
      return Left(Failure(message: 'Something went wrong'));
    } catch (e) {
      log('Error: $e');
      return Left(Failure(message: 'Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, HomeResponse>> getMyFeeds() async {
    try {
      final response = await apiService.get(apiEndPoints.myFeed);
      return Right(HomeResponse.fromJson(response.data));
    } on DioException catch (e) {
      log('Error: $e');
      return Left(Failure(message: 'Something went wrong'));
    } catch (e) {
      log('Error: $e');
      return Left(Failure(message: 'Something went wrong'));
    }
  }
}
