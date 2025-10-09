import 'package:dartz/dartz.dart';
import 'package:video_player_media/domain/model/category_list/category_list.dart';
import 'package:video_player_media/domain/model/failure_response/failure_response.dart';
import 'package:video_player_media/domain/model/home_page_feed/home_page_feed.dart';

abstract class HomeScreenFeedRepo {
Future<Either<Failure,CategoryResponse>>getCategoryList();
Future<Either<Failure,HomeResponse>>getHomeFeeds();
}