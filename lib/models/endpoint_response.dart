class EndpointResponse<T> {
  final int statusCode;
  final String message;
  final T data;

  EndpointResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory EndpointResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromDataJson,
  ) {
    return EndpointResponse<T>(
      statusCode: json['statusCode'],
      message: json['message'],
      data: fromDataJson(json['data']),
    );
  }
}
