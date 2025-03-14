import 'package:flutter/material.dart';
import 'package:mini_pro_app/data/network/network_api_services.dart';
import 'package:mini_pro_app/res/app_urls/app_urls.dart';

class DetailCollectingRepo {

  final  _apiServices = NetworkApiServices();

  Future <Map<String,dynamic>> getOtpApi(var data) async{
    debugPrint(data);
    dynamic resp = _apiServices.postApi(AppUrls.espGetOtpUrl, data);
    return resp;
  }
}