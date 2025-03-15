import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mini_pro_app/data/app_exceptions.dart';
import 'package:mini_pro_app/data/network/base_api_services.dart';

class NetworkApiServices extends BaseApiServices{


    static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  
  @override
  Future getApi(String url) {
    // TODO: implement getApi
    throw UnimplementedError();
  }
  
  @override
  Future <Map<String, dynamic>> postApi({required String url,required Map<String, dynamic> data}) async{
    debugPrint("hello");
     try {
      final response = await _dio.post(url, data: data);
      final Map<String, dynamic> responseData = json.decode(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
         return responseData;
      } else {
        throw InternetException();
      }
    } on DioException catch (e) {
      throw ServerExxeption();
    } catch (e) {
      print("Unexpected Error: $e");
      throw ServerExxeption();
    }
  }

}