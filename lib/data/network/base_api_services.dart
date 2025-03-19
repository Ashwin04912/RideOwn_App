import 'package:dartz/dartz.dart';
import 'package:mini_pro_app/data/app_exceptions.dart';

abstract class BaseApiServices {

  Future<dynamic> getApi(String url);
  Future <Either<AppExceptions,Map<String, dynamic>>> postApi({required String url,required Map<String, dynamic> data});
  
}