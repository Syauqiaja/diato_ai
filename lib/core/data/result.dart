sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(String message) = Failure<T>;

  T? get data => this is Success<T> ? (this as Success<T>).value : null;
  String? get errorMessage => this is Failure<T> ? (this as Failure<T>).message : null;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
}

final class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);
}

final class Failure<T> extends Result<T> {
  final String message;

  const Failure(this.message);
}