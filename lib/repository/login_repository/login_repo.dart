import 'package:dartz/dartz.dart';
import 'package:mini_pro_app/data/app_exceptions.dart';
import 'package:mini_pro_app/data/network/network_api_services.dart';

class LoginRepository {
  final NetworkApiServices _api = NetworkApiServices();

  Future<Either<AppExceptions, Unit>> loginApi({
    required String email,
    required String password,
  }) async {
    return _api.loginApi(email: email, password: password);
  }
}
