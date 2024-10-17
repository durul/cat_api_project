// Provides a consistent error format with message, status code, and response data.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() =>
      'ApiException: $message (Status Code: ${statusCode ?? "Unknown"})';
}

