import 'package:dartz/dartz.dart';
import 'package:mini_pro_app/data/app_exceptions.dart';
import 'package:mini_pro_app/models/user_data/user_data_model.dart';

abstract class BaseApiServices {
  Future<Either<AppExceptions, Unit>> loginApi({
    required String email,
    required password,
  });
  Future<Either<AppExceptions, Map<String, dynamic>>> postApi({
    required String url,
    required Map<String, dynamic> data,
  });
  Future<Either<AppExceptions, UserData>> getAllDataFromFirebase({
    required String path,
  });

  
}
