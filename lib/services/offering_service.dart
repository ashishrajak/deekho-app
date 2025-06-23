import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/config/env.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';

class OfferingService {
  final http.Client client;

  OfferingService({http.Client? client}) : client = client ?? http.Client();

  Future<List<OfferingServiceDTO>> fetchOfferings({
    List<String>? categories,
    String? name,
    String? description,
    int page = 0,
    int size = 10,
  }) async {
    try {
      // Build query parameters with support for repeated `categories`
      final queryParams = <String, dynamic>{
        if (categories != null)
          for (var category in categories) 'categories': category,
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        'page': page.toString(),
        'size': size.toString(),
      };

      // Manually build URI with repeated parameters for `categories`
      final uri = Uri.parse('${Env.baseUrl}/offerings/filter');
      final uriWithQuery = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.port,
        path: uri.path,
        query: Uri(queryParameters: {
          ...queryParams.entries.fold<Map<String, List<String>>>(
              {}, (map, entry) {
            if (map.containsKey(entry.key)) {
              map[entry.key]!.add(entry.value.toString());
            } else {
              map[entry.key] = [entry.value.toString()];
            }
            return map;
          }),
        }).query,
      );

      final response = await client.get(
        uriWithQuery,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>;
        final offeringsList = data['content'] as List<dynamic>;

        return offeringsList.map((item) {
          try {
            return OfferingServiceDTO.fromJson(item as Map<String, dynamic>);
          } catch (e, stack) {
            print('Error parsing item: $item');
            print('Error details: $e\n$stack');
            throw FormatException('Failed to parse offering: ${e.toString()}');
          }
        }).toList();
      } else {
        throw HttpException(
          'Request failed with status: ${response.statusCode}\n'
              'Body: ${response.body}',
        );
      }
    } catch (e) {
      print('Fetch offerings error: $e');
      rethrow;
    } finally {
      //client.close();
    }
  }


  Future<OfferingServiceDTO> saveOfferingService(OfferingServiceDTO dto) async {
    try {
      final uri = Uri.parse('${Env.baseUrl}/offerings');

      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

        // Check if response has a 'data' wrapper or is direct DTO
        final dtoData = jsonData.containsKey('data')
            ? jsonData['data'] as Map<String, dynamic>
            : jsonData;

        return OfferingServiceDTO.fromJson(dtoData);
      } else {
        throw HttpException(
          'Save failed with status: ${response.statusCode}\n'
              'Body: ${response.body}',
        );
      }
    } catch (e) {
      print('Save offering error: $e');
      rethrow;
    }
  }

  // Method to update existing offering service
  Future<OfferingServiceDTO> updateOfferingService(String id, OfferingServiceDTO dto) async {
    try {
      final uri = Uri.parse('${Env.baseUrl}/offerings/$id');

      final response = await client.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

        // Check if response has a 'data' wrapper or is direct DTO
        final dtoData = jsonData.containsKey('data')
            ? jsonData['data'] as Map<String, dynamic>
            : jsonData;

        return OfferingServiceDTO.fromJson(dtoData);
      } else {
        throw HttpException(
          'Update failed with status: ${response.statusCode}\n'
              'Body: ${response.body}',
        );
      }
    } catch (e) {
      print('Update offering error: $e');
      rethrow;
    }
  }

  void dispose() {
    client.close();
  }

  Future<void> deleteOfferingService(String id) async {
    try {
      final uri = Uri.parse('${Env.baseUrl}/offerings/$id');

      final response = await client.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Successfully deleted
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

        // You can optionally check the success message if needed
        // final message = jsonData['message'] as String?;
        // print('Delete success: $message');

        return;
      } else {
        throw HttpException(
          'Delete failed with status: ${response.statusCode}\n'
              'Body: ${response.body}',
        );
      }
    } catch (e) {
      print('Delete offering error: $e');
      rethrow;
    }
  }


  Future<List<String>> uploadMedia(String offerId, List<File> mediaFiles) async {
    try {
      final uri = Uri.parse('${Env.baseUrl}/media/upload');

      // Create multipart request
      final request = http.MultipartRequest('POST', uri);

      // Add offerId parameter
      request.fields['offerId'] = offerId;

      // Add media files
      for (int i = 0; i < mediaFiles.length; i++) {
        final file = mediaFiles[i];
        final multipartFile = await http.MultipartFile.fromPath(
          'files', // This matches the @RequestParam("files") in your backend
          file.path,
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      // Send request
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

        // Extract URLs from response
        final data = jsonData['data'];
        if (data is List) {
          return List<String>.from(data);
        } else {
          throw FormatException('Unexpected response format: expected List but got ${data.runtimeType}');
        }
      } else {
        throw HttpException(
          'Media upload failed with status: ${response.statusCode}\n'
              'Body: ${response.body}',
        );
      }
    } catch (e) {
      print('Upload media error: $e');
      rethrow;
    }
  }


}