import 'package:dartz/dartz.dart';
import 'package:video_player_media/domain/model/failure_response/failure_response.dart';
import 'package:video_player_media/domain/model/login_response/login_response.dart';

abstract class AuthRepo{
  Future<Either<Failure,LoginResponse>>login({required Map<String,dynamic>loginModel});
}