import 'package:flutter/material.dart';
import 'package:mini_pro_app/data/network/network_api_services.dart';
import 'package:mini_pro_app/res/app_urls/app_urls.dart';

class EspLocalRepo {

  final  _apiServices = NetworkApiServices();

  Future <Map<String,dynamic>> getOtpApi(Map<String,dynamic> data) async{
    debugPrint(data.toString());
    Map<String,dynamic> resp =await _apiServices.postApi(url:  AppUrls.espGetOtpUrl,data:  data);
    return resp;
  }

   Future <Map<String,dynamic>> checkPasswordApi(Map<String,dynamic> data) async{
    debugPrint(data.toString());
    Map<String,dynamic> resp =await _apiServices.postApi(url:  AppUrls.espCheckPassUrl,data:  data);
    return resp;
  }

   Future <Map<String,dynamic>> lockCycleApi(Map<String,dynamic> data) async{
    debugPrint(data.toString());
    Map<String,dynamic> resp =await _apiServices.postApi(url:  AppUrls.espLockCycleUrl,data:  data);
    return resp;
  }

   Future <Map<String,dynamic>> returnCycleApi(Map<String,dynamic> data) async{
    debugPrint(data.toString());
    Map<String,dynamic> resp =await _apiServices.postApi(url:  AppUrls.espReturnCycle,data:  data);
    return resp;
  }
}