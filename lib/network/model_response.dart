/// A blueprint for a result with a generic type T.
class Result<T> {
  final T? data;
  final String? error;
  final int? statusCode;

  Result.success(this.data)
      : error = null,
        statusCode = null;

  Result.failure(this.error, [this.statusCode]) : data = null;

  bool get isSuccess => data != null;
}
