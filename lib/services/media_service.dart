import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/config/env.dart';

class MediaService {
  final http.Client client;
  final String baseUrl = Env.baseUrl+'/user';

  MediaService({http.Client? client}) : client = client ?? http.Client();

  /// Upload media files for a specific offer
  Future<List<String>> uploadMedia(String offerId, List<File> mediaFiles) async {
    try {
      final uri = Uri.parse('$baseUrl/media/upload');

      final request = http.MultipartRequest('POST', uri);

      // Add offerId to the form data
      request.fields['offerId'] = offerId;

      // Attach media files
      for (File file in mediaFiles) {
        final multipartFile = await http.MultipartFile.fromPath(
          'files',
          file.path,
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'];
        if (data is List) {
          return List<String>.from(data);
        } else {
          throw FormatException('Unexpected response format: expected List but got ${data.runtimeType}');
        }
      } else {
        throw HttpException(
          'Upload failed: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      print('Upload media error: $e');
      rethrow;
    }
  }

  /// Fetch all media URLs by offerId
  Future<List<String>> getMediaList(String offerId) async {
    try {
      final uri = Uri.parse('$baseUrl/media/$offerId/list');

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'];
        if (data is List) {
          return List<String>.from(data);
        } else {
          throw FormatException('Unexpected response format: expected List but got ${data.runtimeType}');
        }
      } else {
        throw HttpException(
          'Fetch failed: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      print('Get media list error: $e');
      rethrow;
    }
  }

  /// Delete media file by mediaId
  Future<void> deleteMedia(String mediaId) async {
    try {
      final uri = Uri.parse('$baseUrl/media/$mediaId');

      final response = await client.delete(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw HttpException(
          'Delete failed: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      print('Delete media error: $e');
      rethrow;
    }
  }

  void dispose() {
    client.close();
  }

   Future<Uint8List> getMediaById(String mediaId) async {
    try {
      final uri = Uri.parse('$baseUrl/media/$mediaId');

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw HttpException(
          'Get media failed: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      print('Get media by ID error: $e');
      rethrow;
    }
  }
}
