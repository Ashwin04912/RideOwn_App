class AppExceptions implements Exception {
  final _message;
  final _prefix;

  AppExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return "$_message$_prefix";
  }
}


class InternetException extends AppExceptions{
  InternetException([String? message]) : super(message, 'No Internet');
}

class RequestTimeOut extends AppExceptions{
  RequestTimeOut([String? message]): super(message, 'Request Time Out');
}

class ServerExxeption extends AppExceptions{
  ServerExxeption([String? message]): super(message, 'Server Error');
}