import '../model/cats.dart';

/// A blueprint for a result with a generic type T.
sealed class Result<T> {}

/// A class to represent a successful result
class Success<T> extends Result<T> {
  final T value;

  Success(this.value);
}

/// A class to represent an error result
class Error<T> extends Result<T> {
  final Exception exception;

  Error(this.exception);
}

