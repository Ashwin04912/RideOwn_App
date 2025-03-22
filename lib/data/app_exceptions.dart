import 'package:firebase_auth/firebase_auth.dart';

class AppExceptions implements Exception {
  final String? _message;
  final String? _prefix;

  AppExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return "${_prefix ?? ''}: ${_message ?? 'An error occurred'}";
  }

  // Static method to handle Firebase authentication errors
  static AppExceptions fromFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AppExceptions("No user found with this email.", "Authentication Error");
      case 'wrong-password':
        return AppExceptions("Incorrect password.", "Authentication Error");
      case 'invalid-email':
        return AppExceptions("Invalid email format.", "Authentication Error");
      default:
        return AppExceptions("Login failed: ${e.message}", "Authentication Error");
    }
  }
}

// Custom exceptions for different error scenarios
class InternetException extends AppExceptions {
  InternetException([String? message]) : super(message, "No Internet");
}

class RequestTimeOut extends AppExceptions {
  RequestTimeOut([String? message]) : super(message, "Request Time Out");
}

class ServerException extends AppExceptions {
  ServerException([String? message]) : super(message, "Server Error");
}
