import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mini_pro_app/data/app_exceptions.dart';
import 'package:mini_pro_app/data/network/base_api_services.dart';
import 'package:mini_pro_app/models/user_data/user_data_model.dart';

class NetworkApiServices extends BaseApiServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

 @override
Future<Either<AppExceptions, Map<String, dynamic>>> postApi({
  required String url, 
  required Map<String, dynamic> data
}) async {
  debugPrint("in post api");
  try {
    debugPrint(url);
    
    // Set a reasonable timeout
    final response = await _dio.post(
      url, 
      data: data,
      options: Options(
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    
    debugPrint("Response status: ${response.statusCode}");
    debugPrint("Response data: ${response.data}");
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return right(response.data is Map<String, dynamic> 
          ? response.data 
          : {"data": response.data});
    } else {
      // Handle different status codes with more specific exceptions
      return left(ServerException("Server responded with status code: ${response.statusCode}"));
    }
  } on DioException catch (e) {
    debugPrint("DioException: $e");
    
    // More specific error handling based on Dio exception type
    if (e.type == DioExceptionType.connectionTimeout || 
        e.type == DioExceptionType.sendTimeout || 
        e.type == DioExceptionType.receiveTimeout) {
      return left(RequestTimeOut("Request timed out. Please try again."));
    } else if (e.type == DioExceptionType.connectionError) {
      return left(InternetException("No internet connection. Please check your network."));
    } else if (e.response != null) {
      // Handle specific HTTP error codes
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      String errorMessage = "Server error";
      
      if (responseData is Map && responseData.containsKey('message')) {
        errorMessage = responseData['message'];
      }
      
      if (statusCode == 500) {
        return left(ServerException("Internal server error: $errorMessage"));
      } else if (statusCode == 404) {
        return left(ServerException("Resource not found: $errorMessage"));
      } else {
        return left(ServerException("HTTP error $statusCode: $errorMessage"));
      }
    } else {
      return left(ServerException("Network error: ${e.message}"));
    }
  } catch (e) {
    debugPrint("Unexpected Error: $e");
    return left(ServerException("Unexpected error occurred: $e"));
  }
}

  @override
  Future<Either<AppExceptions, Unit>> loginApi(
      {required String email, required password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(unit); // Login successful
    } on FirebaseAuthException catch (e) {
      return left(AppExceptions.fromFirebaseError(e));
    } catch (e) {
      return left(AppExceptions("Unexpected error: ${e.toString()}"));
    }
  }

@override
Future<Either<AppExceptions, UserData>> getAllDataFromFirebase({
  required String path,
}) async {
  // try {
    debugPrint("Fetching data from Firebase at path: $path");

    DatabaseReference ref = _database.ref(path);
    DatabaseEvent event = await ref.once(); // Fetch data once

    final snapshotValue = event.snapshot.value;
    debugPrint("Raw Data: $snapshotValue");

    if (snapshotValue == null) {
      return left(AppExceptions("No data found at path: $path"));
    }

    if (snapshotValue is Map<Object?, Object?>) {
      // Convert Map<Object?, Object?> to Map<String, dynamic>
      final Map<String, dynamic> data = snapshotValue.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      // Ensure 'users' field is properly converted if it exists
      if (data.containsKey("users") && data["users"] is Map<Object?, Object?>) {
        data["users"] = (data["users"] as Map<Object?, Object?>).map(
          (key, value) => MapEntry(key.toString(), value),
        );
      }

      debugPrint("Processed Data: $data");

      // Convert to UserData model
      final userData = UserData.fromJson(snapshotValue);

      debugPrint("Successfully fetched user data.");
      return right(userData);
    } else {
      return left(AppExceptions("Unexpected data format at path: $path"));
    }
//   } on FirebaseException catch (e) {
//     debugPrint("Firebase error: ${e.message}");
//     return left(AppExceptions("Firebase error: ${e.message}"));
//   } catch (e) {
//     debugPrint("Unexpected error: $e");
//     return left(AppExceptions("Unexpected error: ${e.toString()}"));
//   }
}

}




