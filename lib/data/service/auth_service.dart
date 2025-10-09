
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:video_player_media/core/api_end_points.dart';
import 'package:video_player_media/domain/model/failure_response/failure_response.dart';
import 'package:video_player_media/domain/model/login_response/login_response.dart';
import 'package:video_player_media/domain/repo/auth_repo.dart';

class AuthService implements AuthRepo {
  Dio apiService = Dio(
    BaseOptions(
      baseUrl: ApiEndPoints.baseUrl,
      connectTimeout: const Duration(
        seconds: 10,
      ), // wait 10s before connection timeout
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  ApiEndPoints apiEndPoints = ApiEndPoints();
  @override
  Future<Either<Failure, LoginResponse>> login({
    required Map<String, dynamic> loginModel,
  }) async {
    try {
      print('service called');

      final formData = FormData.fromMap(loginModel);

      // Print full URL
      final fullUrl = '${apiService.options.baseUrl}${apiEndPoints.login}';
      print('POST URL: $fullUrl');

      // Print data being sent
      print('Request Data: ${loginModel.toString()}');

      final response = await apiService.post(
        apiEndPoints.login,
        data: formData,
      );
      if (response.data != null && response.data['status'] == true) {
        print('Response Data: ${response.data}');

        return Right(LoginResponse.fromJson(response.data));
      } else {
        return Left(
          Failure(message: response.data['message'] ?? 'something went wrong'),
        );
      }
    } catch (e) {
      print('Error: $e');
      return Left(Failure(message: 'Something went wrong'));
    }
  }
}
