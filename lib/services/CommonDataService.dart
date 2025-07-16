import 'package:dio/dio.dart';
import 'package:my_flutter_app/config/env.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';


class CommonDataService {
  final String baseUrl = Env.baseUrl+ '/user';
  
  late final Dio _dio;

  CommonDataService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    
    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Token interceptor (same as in OfferingService)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            try {
              bool refreshed = await _refreshToken();
              if (refreshed) {
                String? newToken = await _getToken();
                if (newToken != null) {
                  error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                  final response = await _dio.fetch(error.requestOptions);
                  return handler.resolve(response);
                }
              }
            } catch (e) {
              _redirectToLogin();
            }
          }
          handler.next(error);
        },
      ),
    );

    // Logging interceptor
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ),
    );
  }

  Future<List<CategoryDTO>> getCategories() async {
    try {
      final response = await _dio.get(
        '/common-data/categories',
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => CategoryDTO.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching categories: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Reuse token management from OfferingService
  Future<String?> _getToken() async {
    // Your token retrieval logic
    return null;
  }

  Future<bool> _refreshToken() async {
    // Your token refresh logic
    return false;
  }

  void _redirectToLogin() {
    // Your login redirection logic
  }
}