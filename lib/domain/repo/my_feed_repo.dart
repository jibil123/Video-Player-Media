import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:video_player_media/domain/model/failure_response/failure_response.dart';
import 'package:video_player_media/domain/model/home_page_feed/home_page_feed.dart';
import 'package:video_player_media/domain/model/success_response/success_response.dart';

abstract class MyFeedRepo {
  Future<Either<Failure, SuccessResponse>> postMyFeed({
    required File video,
    required File image,
    required String desc,
    required List<int> categoryIds,
  });
  Future<Either<Failure, HomeResponse>> getMyFeeds();
}
