import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
    // await AppUrls.resolveEspIp();
    // Get the resolved URL first
    final url = AppUrls.espGetOtpUrl;
    debugPrint("Using resolved URL: $url");
    return await _apiServices.postApi(url: url, data: data);
  }

  Future<Either<AppExceptions, Map<String, dynamic>>> checkPasswordApi(
      Map<String, dynamic> data) async {
    debugPrint("in checkPasswordApi");
    debugPrint(data.toString());
    // await AppUrls.resolveEspIp();
    final url = AppUrls.espCheckPassUrl;
    debugPrint("Using resolved URL: $url");
    return await _apiServices.postApi(url: url, data: data);
  }

  Future<Either<AppExceptions, Map<String, dynamic>>> lockCycleApi(
      Map<String, dynamic> data) async {
    debugPrint("in lockCycleApi");
    debugPrint(data.toString());
    // await AppUrls.resolveEspIp();
    final url = AppUrls.espLockCycleUrl;
    debugPrint("Using resolved URL: $url");
    return await _apiServices.postApi(url: url, data: data);
  }

 Future<Either<AppExceptions, dynamic>> returnCycleApi({
  required Map<String,dynamic> data,
  required String phoneNumber
}) async {

  debugPrint("in returnCycleApi $phoneNumber");
  debugPrint(data.toString());
  
  // await AppUrls.resolveEspIp();
  final url = AppUrls.espReturnCycle;
  debugPrint("Using resolved URL: $url");
  
  // Call the API
  final response = await _apiServices.postApi(url: url, data: data);
  
  // If API is successful, update Firebase status
  return response.fold(
    (error) {
      debugPrint("API Error: $error");
      return Left(error); // Return error response
    },
    (successData) async {
      final DatabaseReference databaseRef = 
          FirebaseDatabase.instance.ref('cycle_one');
      
      try {
        // Get current timestamp for the returned_time field
        final returnedTime = DateTime.now().toIso8601String();
        
        // First update the status within the user's node
        await databaseRef.child("users").child(phoneNumber).update({
          "status": "Returned",
          "returned_time": returnedTime
        });
        
        // Then update the isAvailable flag at root level
        await databaseRef.update({
          "isAvailable": true
        });
        
        debugPrint("Cycle status updated to 'Returned' for phone: $phoneNumber");
        debugPrint("returned_time added: $returnedTime");
      } on FirebaseException catch (e) {
        debugPrint("Firebase error: ${e.message}");
        return Left(AppExceptions(e.message ?? "Firebase Error"));
      } catch (e) {
        debugPrint("Unexpected error: $e");
        return Left(AppExceptions(e.toString()));
      }
      
      return Right(successData); // Return success response
    },
  );
}
}
