// First add dio to your pubspec.yaml:
// dependencies:
//   dio: ^5.3.2

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:my_flutter_app/config/env.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/models/page.dart';

class OfferingService {
  static const String baseUrl = '${Env.baseUrl}'+'/search';
  
  late final Dio _dio;

  OfferingService() {
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

  Future<PaginatedResponse<OfferingServiceDTO>> filterOfferings({
    List<String>? categories,
    String? name,
    String? description,
    int page = 0,
    int size = 10,
  }) async {
    try {
      // Build query parameters
      Map<String, dynamic> queryParams = {
        'page': page,
        'size': size,
      };
      
      if (categories != null && categories.isNotEmpty) {
        queryParams['categories'] = categories;
      }
      
      if (name != null && name.isNotEmpty) {
        queryParams['name'] = name;
      }
      
      if (description != null && description.isNotEmpty) {
        queryParams['description'] = description;
      }

      final response = await _dio.get(
        '/offerings/filter',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        
        // Extract data from EndpointResponse wrapper
        final Map<String, dynamic> data = jsonResponse['data'];
        return PaginatedResponse.fromJson(data, (json) => OfferingServiceDTO.fromJson(json));
      } else {
        throw Exception('Failed to load offerings: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching offerings: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching offerings: $e');
    }
  }

  // Token management methods (implement these based on your auth system)
  Future<String?> _getToken() async {
    // Implement token retrieval from storage
    // Example: return await SharedPreferences.getInstance().getString('token');
    return null;
  }

  Future<bool> _refreshToken() async {
    // Implement token refresh logic
    // Return true if refresh was successful
    return false;
  }

  void _redirectToLogin() {
    // Implement navigation to login screen
    // Example: Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }


  Future<PaginatedResponse<OfferingServiceDTO>> discoverOfferings({
    // Category filtering
    String? category,
    List<String>? categories,
    
    // Location filtering
    String? latitude,
    String? longitude,
    int? radiusKm,
    String? serviceArea,
    String? city,
    String? state,
    bool? onSiteService,
    bool? willingToTravel,
    int? maxTravelRadius,
    
    // Pricing filtering
    double? minPrice,
    double? maxPrice,
    String? priceType,
    
    // Service filtering
    List<String>? tags,
    bool? emergencyService,
    int? minDuration,
    int? maxDuration,
    List<String>? availableDays,
    
    // Partner filtering
    String? partnerName,
    bool? verifiedPartnerOnly,
    String? partnerType,
    
    // Search
    String? searchQuery,
    
    // Pagination & Sorting
    int page = 0,
    int size = 20,
    String sortBy = 'lastUpdated',
    String sortDirection = 'DESC',
  }) async {
    try {
      // Build query parameters
      Map<String, dynamic> queryParams = {
        'page': page,
        'size': size,
        'sortBy': sortBy,
        'sortDirection': sortDirection,
      };
      
      // Category filtering
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (categories != null && categories.isNotEmpty) {
        queryParams['categories'] = categories;
      }
      
      // Location filtering
      if (latitude != null && latitude.isNotEmpty) {
        queryParams['latitude'] = latitude;
      }
      if (longitude != null && longitude.isNotEmpty) {
        queryParams['longitude'] = longitude;
      }
      if (radiusKm != null) {
        queryParams['radiusKm'] = radiusKm;
      }
      if (serviceArea != null && serviceArea.isNotEmpty) {
        queryParams['serviceArea'] = serviceArea;
      }
      if (city != null && city.isNotEmpty) {
        queryParams['city'] = city;
      }
      if (state != null && state.isNotEmpty) {
        queryParams['state'] = state;
      }
      if (onSiteService != null) {
        queryParams['onSiteService'] = onSiteService;
      }
      if (willingToTravel != null) {
        queryParams['willingToTravel'] = willingToTravel;
      }
      if (maxTravelRadius != null) {
        queryParams['maxTravelRadius'] = maxTravelRadius;
      }
      
      // Pricing filtering
      if (minPrice != null) {
        queryParams['minPrice'] = minPrice;
      }
      if (maxPrice != null) {
        queryParams['maxPrice'] = maxPrice;
      }
      if (priceType != null && priceType.isNotEmpty) {
        queryParams['priceType'] = priceType;
      }
      
      // Service filtering
      if (tags != null && tags.isNotEmpty) {
        queryParams['tags'] = tags;
      }
      if (emergencyService != null) {
        queryParams['emergencyService'] = emergencyService;
      }
      if (minDuration != null) {
        queryParams['minDuration'] = minDuration;
      }
      if (maxDuration != null) {
        queryParams['maxDuration'] = maxDuration;
      }
      if (availableDays != null && availableDays.isNotEmpty) {
        queryParams['availableDays'] = availableDays;
      }
      
      // Partner filtering
      if (partnerName != null && partnerName.isNotEmpty) {
        queryParams['partnerName'] = partnerName;
      }
      if (verifiedPartnerOnly != null) {
        queryParams['verifiedPartnerOnly'] = verifiedPartnerOnly;
      }
      if (partnerType != null && partnerType.isNotEmpty) {
        queryParams['partnerType'] = partnerType;
      }
      
      // Search
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['searchQuery'] = searchQuery;
      }

      final response = await _dio.get(
        '/offerings/discover',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        
        // Extract data from EndpointResponse wrapper
        final Map<String, dynamic> data = jsonResponse['data'];
        return PaginatedResponse.fromJson(data, (json) => OfferingServiceDTO.fromJson(json));
      } else {
        throw Exception('Failed to discover offerings: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error discovering offerings: ${e.message}');
    } catch (e) {
      throw Exception('Error discovering offerings: $e');
    }
  }
}