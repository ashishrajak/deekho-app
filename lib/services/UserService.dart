// First add dio to your pubspec.yaml:
// dependencies:
//   dio: ^5.3.2

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:my_flutter_app/config/env.dart';
import 'package:my_flutter_app/models/address_dto.dart';
import 'package:my_flutter_app/models/endpoint_response.dart';

class UserService {
  static const String baseUrl = '${Env.baseUrl}/user/users';
  
  late final Dio _dio;

  UserService() {
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
    // Token interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add token to requests
          String? token = await _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle token refresh on 401
          if (error.response?.statusCode == 401) {
            try {
              bool refreshed = await _refreshToken();
              if (refreshed) {
                // Retry the original request
                String? newToken = await _getToken();
                if (newToken != null) {
                  error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                  final response = await _dio.fetch(error.requestOptions);
                  return handler.resolve(response);
                }
              }
            } catch (e) {
              // Refresh failed, redirect to login
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
        logPrint: (obj) {
          print(obj); // You can replace this with your logging solution
        },
      ),
    );
  }

  /// Add address to user
  /// POST /{userId}/addresses
  Future<AddressDTO> addAddress(String userId, AddressDTO addressDTO) async {
    try {
      final response = await _dio.post(
        '/$userId/addresses',
        data: addressDTO.toJson(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        
        // Extract data from EndpointResponse wrapper
        final AddressDTO addressData = AddressDTO.fromJson(jsonResponse['data']);
        return addressData;
      } else {
        throw Exception('Failed to add address: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        // Handle validation errors
        final Map<String, dynamic> errorResponse = e.response?.data;
        final List<String> validationErrors = 
            List<String>.from(errorResponse['error']['validationErrors'] ?? []);
        throw ValidationException('Validation failed', validationErrors);
      }
      throw Exception('Error adding address: ${e.message}');
    } catch (e) {
      throw Exception('Error adding address: $e');
    }
  }

  /// Update user address
  /// PUT /{userId}/addresses/{addressId}
  Future<AddressDTO> updateAddress(
    String userId, 
    int addressId, 
    AddressDTO addressDTO
  ) async {
    try {
      final response = await _dio.put(
        '/$userId/addresses/$addressId',
        data: addressDTO.toJson(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        
        // Extract data from EndpointResponse wrapper
        final AddressDTO addressData = AddressDTO.fromJson(jsonResponse['data']);
        return addressData;
      } else {
        throw Exception('Failed to update address: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        // Handle validation errors
        final Map<String, dynamic> errorResponse = e.response?.data;
        final List<String> validationErrors = 
            List<String>.from(errorResponse['error']['validationErrors'] ?? []);
        throw ValidationException('Validation failed', validationErrors);
      }
      throw Exception('Error updating address: ${e.message}');
    } catch (e) {
      throw Exception('Error updating address: $e');
    }
  }

  /// Delete user address
  /// DELETE /{userId}/addresses/{addressId}
  Future<String> deleteAddress(String userId, int addressId) async {
    try {
      final response = await _dio.delete('/$userId/addresses/$addressId');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        
        // Extract message from EndpointResponse wrapper
        return jsonResponse['message'] ?? 'Address deleted successfully';
      } else {
        throw Exception('Failed to delete address: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error deleting address: ${e.message}');
    } catch (e) {
      throw Exception('Error deleting address: $e');
    }
  }

  // Token management methods
  Future<String?> _getToken() async {
    // For now, return null - requests will work without token
    // Later implement: SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.getString('auth_token');
    return null;
  }

  Future<bool> _refreshToken() async {
    // For now, return false - no token refresh logic
    // Later implement your token refresh logic here
    return false;
  }

  void _redirectToLogin() {
    // For now, just print - no navigation logic
    print('Token expired, redirect to login needed');
    // Later implement: Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  /// GET /{userId}/addresses
  Future<List<AddressDTO>> getUserAddresses(String userId) async {
    try {
      final response = await _dio.get('/16d9da82-a6ba-4c5f-a63b-61c3b5b8ed76/addresses');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        
        // Extract data from EndpointResponse wrapper
        final List<dynamic> addressesData = jsonResponse['data'] ?? [];
        final List<AddressDTO> addresses = addressesData
            .map((addressJson) => AddressDTO.fromJson(addressJson))
            .toList();
        
        return addresses;
      } else {
        throw Exception('Failed to fetch addresses: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching addresses: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching addresses: $e');
    }
  }


}

/// Custom exception for validation errors
class ValidationException implements Exception {
  final String message;
  final List<String> validationErrors;

  ValidationException(this.message, this.validationErrors);

  @override
  String toString() => 'ValidationException: $message - ${validationErrors.join(', ')}';
}