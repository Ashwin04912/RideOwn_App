import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mini_pro_app/data/app_exceptions.dart';
import 'package:mini_pro_app/data/network/network_api_services.dart';
import 'package:mini_pro_app/res/app_urls/app_urls.dart';

class EspLocalRepo {
  final _apiServices = NetworkApiServices();

Future<Either<AppExceptions, Map<String, dynamic>>> getOtpApi(
    Map<String, dynamic> data) async {
  debugPrint("in getOtpApi");
  debugPrint(data.toString());
  return await _apiServices.postApi(url: AppUrls.espGetOtpUrl, data: data);
}

  Future<Either<AppExceptions, Map<String, dynamic>>> checkPasswordApi(
      Map<String, dynamic> data) async {
    debugPrint("in checkPasswordApi");
    debugPrint(data.toString());

    return await _apiServices.postApi(url: AppUrls.espCheckPassUrl, data: data);
  }

  Future<Either<AppExceptions, Map<String, dynamic>>> lockCycleApi(
      Map<String, dynamic> data) async {
    debugPrint("in lockCycleApi");
    debugPrint(data.toString());

    return await _apiServices.postApi(url: AppUrls.espLockCycleUrl, data: data);
  }

  Future<Either<AppExceptions, Map<String, dynamic>>> returnCycleApi(
      Map<String, dynamic> data) async {
    debugPrint("in returnCycleApi");
    debugPrint(data.toString());

    return await _apiServices.postApi(url: AppUrls.espReturnCycle, data: data);
  }
}
