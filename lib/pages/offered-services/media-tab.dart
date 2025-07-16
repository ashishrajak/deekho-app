import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/pages/home/responsive-helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_flutter_app/services/media_service.dart';

class MediaTab extends StatefulWidget {
  final OfferingServiceDTO formData;
  final Function(OfferingServiceDTO) onFormDataChanged;

  const MediaTab({
    Key? key,
    required this.formData,
    required this.onFormDataChanged,
  }) : super(key: key);

  @override
  State<MediaTab> createState() => _MediaTabState();
}

class _MediaTabState extends State<MediaTab> {
  final ImagePicker _picker = ImagePicker();
  List<OfferingMediaDTO> _mediaItems = [];
  List<File> _selectedFiles = [];
  final List<String> _supportedImageTypes = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  final List<String> _supportedVideoTypes = ['mp4', 'mov', 'avi', 'mkv'];
  final MediaService mediaService= new MediaService();
  
  bool _isUploading = false;
  bool _isRemoving = false;
  
  // Cache for storing fetched media data
  Map<String, Uint8List> _mediaDataCache = {};
  Map<String, bool> _loadingMedia = {};

  // Replace with your actual API base URL
 

  @override
  void initState() {
    super.initState();
    _mediaItems = List.from(widget.formData.mediaItems);
    _preloadExistingMedia();
  }

  // Preload existing media data from server
  void _preloadExistingMedia() {
    for (var mediaItem in _mediaItems) {
      if (_isServerMediaId(mediaItem.mediaUrl)) {
        _loadMediaData(mediaItem.mediaUrl);
      }
    }
  }

  // Check if mediaUrl is a server ID (not a local file path or HTTP URL)
  bool _isServerMediaId(String mediaUrl) {
    return !mediaUrl.startsWith('/') && 
           !mediaUrl.startsWith('http') && 
           !mediaUrl.startsWith('file://');
  }

  // Load media data from server using media service
Future<void> _loadMediaData(String mediaId) async {
  if (_mediaDataCache.containsKey(mediaId) || _loadingMedia[mediaId] == true) {
    return; // Already cached or loading
  }

  setState(() {
    _loadingMedia[mediaId] = true;
  });

  try {
    // Use the MediaService instead of direct HTTP call
    final Uint8List mediaData = await mediaService.getMediaById(mediaId);
    
    setState(() {
      _mediaDataCache[mediaId] = mediaData;
      _loadingMedia[mediaId] = false;
    });
  } catch (e) {
    setState(() {
      _loadingMedia[mediaId] = false;
    });
    print('Error loading media $mediaId: $e');
  }
}
  void _updateFormData() {
    final updatedFormData = widget.formData.copyWith(
      mediaItems: _mediaItems,
    );
    widget.onFormDataChanged(updatedFormData);
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);
        await _addMediaItem(file, 'IMAGE');
      }
    } catch (e) {
      _showErrorDialog('Error picking image: $e');
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null) {
        final file = File(video.path);
        await _addMediaItem(file, 'VIDEO');
      }
    } catch (e) {
      _showErrorDialog('Error picking video: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        final file = File(photo.path);
        await _addMediaItem(file, 'IMAGE');
      }
    } catch (e) {
      _showErrorDialog('Error taking photo: $e');
    }
  }

  Future<void> _addMediaItem(File file, String mediaType) async {
    final mediaItem = OfferingMediaDTO(
      mediaUrl: file.path,
      mediaType: mediaType,
      displayOrder: _mediaItems.length,
    );

    setState(() {
      _mediaItems.add(mediaItem);
      _selectedFiles.add(file);
    });

    _updateFormData();
  }

  Future<void> _uploadMedia() async {
    if (_selectedFiles.isEmpty) {
      _showErrorDialog('No files selected for upload');
      return;
    }

    if (widget.formData.id == null || widget.formData.id!.isEmpty) {
      _showErrorDialog('Offer ID is required for upload');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
    
      // Add offer ID
        List<String> urls = await mediaService.uploadMedia(widget.formData.id, _selectedFiles);
    

      if (urls.isNotEmpty) {
       
       
         
          // Update media items with uploaded URLs
          for (int i = 0; i < _mediaItems.length && i < urls.length; i++) {
            _mediaItems[i] = _mediaItems[i].copyWith(
              mediaUrl: urls[i],
            );
          }
          
          // Clear selected files since they're now uploaded
          _selectedFiles.clear();
          
          _updateFormData();
          _showSuccessDialog('Media uploaded successfully!');
        
      } else {
        //_showErrorDialog('Upload failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Upload error: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _removeMediaItem(int index) async {
    final mediaItem = _mediaItems[index];
    
    // If the media item has a URL (uploaded), call remove API
    if (mediaItem.mediaUrl.startsWith('http')) {
      await _removeMediaFromServer(mediaItem.mediaUrl, index);
    } else {
      // If it's just a local file, remove it directly
      _removeMediaLocally(index);
    }
  }

  Future<void> _removeMediaFromServer(String mediaUrl, int index) async {
    if (widget.formData.id == null || widget.formData.id!.isEmpty) {
      _showErrorDialog('Offer ID is required for removal');
      return;
    }

    setState(() {
      _isRemoving = true;
    });

    // try {
    //   final request = http.MultipartRequest(
    //     'POST',
    //     Uri.parse('$_baseUrl/remove'), // Replace with your actual remove endpoint
    //   );

    //   // Add offer ID and media URL/ID
    //   request.fields['offerId'] = widget.formData.id!;
    //   request.fields['mediaUrl'] = mediaUrl;

    //   mediaService.deleteMedia(mediaId)

    //   // Add headers if needed (e.g., authentication)
    //   // request.headers['Authorization'] = 'Bearer your_token_here';

    //   final response = await request.send();
    //   final responseData = await response.stream.bytesToString();

    //   if (response.statusCode == 200) {
    //     final jsonResponse = json.decode(responseData);
        
    //     if (jsonResponse['success'] == true) {
    //       // Remove from cache if it exists
    //       if (_mediaDataCache.containsKey(mediaUrl)) {
    //         _mediaDataCache.remove(mediaUrl);
    //       }
    //       if (_loadingMedia.containsKey(mediaUrl)) {
    //         _loadingMedia.remove(mediaUrl);
    //       }
          
    //       _removeMediaLocally(index);
    //       _showSuccessDialog('Media removed successfully!');
    //     } else {
    //       _showErrorDialog('Remove failed: ${jsonResponse['message'] ?? 'Unknown error'}');
    //     }
    //   } else {
    //     _showErrorDialog('Remove failed with status code: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   _showErrorDialog('Remove error: $e');
    // } finally {
    //   setState(() {
    //     _isRemoving = false;
    //   });
    // }
  }

  void _removeMediaLocally(int index) {
    setState(() {
      _mediaItems.removeAt(index);
      if (index < _selectedFiles.length) {
        _selectedFiles.removeAt(index);
      }
      // Update display orders
      for (int i = 0; i < _mediaItems.length; i++) {
        _mediaItems[i] = _mediaItems[i].copyWith(displayOrder: i);
      }
    });
    _updateFormData();
  }

  void _reorderMedia(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      final item = _mediaItems.removeAt(oldIndex);
      _mediaItems.insert(newIndex, item);
      
      if (oldIndex < _selectedFiles.length && newIndex < _selectedFiles.length) {
        final file = _selectedFiles.removeAt(oldIndex);
        _selectedFiles.insert(newIndex, file);
      }

      // Update display orders
      for (int i = 0; i < _mediaItems.length; i++) {
        _mediaItems[i] = _mediaItems[i].copyWith(displayOrder: i);
      }
    });
    _updateFormData();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),

            // Media Guidelines
            _buildGuidelines(context),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),

            // Add Media Section
            _buildAddMediaSection(context),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),

            // Upload Button Section
            if (_selectedFiles.isNotEmpty) _buildUploadSection(context),
            if (_selectedFiles.isNotEmpty) ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),

            // Media Preview Section
            _buildMediaPreviewSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Media Gallery',
          style: ResponsiveHelper.isMobile(context)
              ? AppTheme.headlineMedium
              : AppTheme.headlineLarge,
        ),
        ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
        Text(
          'Add photos and videos to showcase your service',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildGuidelines(BuildContext context) {
    return Card(
      elevation: ResponsiveHelper.getResponsiveElevation(context),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                  size: ResponsiveHelper.getResponsiveIconSize(context),
                ),
                ResponsiveSizedBox(width: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
                Text(
                  'Media Guidelines',
                  style: AppTheme.headlineSmall,
                ),
              ],
            ),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
            _buildGuidelineItem('Use high-quality images (min 800x600px)', Icons.high_quality),
            _buildGuidelineItem('Show your work in action', Icons.work),
            _buildGuidelineItem('Include before/after shots if applicable', Icons.compare),
            _buildGuidelineItem('Videos should be under 5 minutes', Icons.video_camera_back),
            _buildGuidelineItem('First image will be your main display photo', Icons.star),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineItem(String text, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.getResponsiveSpacing(context) * 0.25),
      child: Row(
        children: [
          Icon(
            icon,
            size: ResponsiveHelper.getResponsiveIconSize(context) * 0.8,
            color: AppTheme.textSecondary,
          ),
          ResponsiveSizedBox(width: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
          Expanded(
            child: Text(
              text,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMediaSection(BuildContext context) {
    return Card(
      elevation: ResponsiveHelper.getResponsiveElevation(context),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Media',
              style: AppTheme.headlineSmall,
            ),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
            ResponsiveHelper.isMobile(context)
                ? Column(
                    children: [
                      _buildAddMediaButton(
                        context,
                        'Add Photos',
                        Icons.photo_library,
                        _pickImage,
                      ),
                      ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                      _buildAddMediaButton(
                        context,
                        'Take Photo',
                        Icons.camera_alt,
                        _takePhoto,
                      ),
                      ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                      _buildAddMediaButton(
                        context,
                        'Add Video',
                        Icons.videocam,
                        _pickVideo,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildAddMediaButton(
                          context,
                          'Add Photos',
                          Icons.photo_library,
                          _pickImage,
                        ),
                      ),
                      ResponsiveSizedBox(width: ResponsiveHelper.getResponsiveSpacing(context)),
                      Expanded(
                        child: _buildAddMediaButton(
                          context,
                          'Take Photo',
                          Icons.camera_alt,
                          _takePhoto,
                        ),
                      ),
                      ResponsiveSizedBox(width: ResponsiveHelper.getResponsiveSpacing(context)),
                      Expanded(
                        child: _buildAddMediaButton(
                          context,
                          'Add Video',
                          Icons.videocam,
                          _pickVideo,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMediaButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.primaryBlue,
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.getPaddingEnhanced(context),
            horizontal: ResponsiveHelper.getPaddingEnhanced(context),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection(BuildContext context) {
    return Card(
      elevation: ResponsiveHelper.getResponsiveElevation(context),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Media',
              style: AppTheme.headlineSmall,
            ),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
            Text(
              'You have ${_selectedFiles.length} file${_selectedFiles.length == 1 ? '' : 's'} ready to upload',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadMedia,
                icon: _isUploading 
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                        ),
                      )
                    : Icon(Icons.cloud_upload),
                label: Text(_isUploading ? 'Uploading...' : 'Upload Media'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: AppTheme.primaryBlue,
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveHelper.getPaddingEnhanced(context),
                    horizontal: ResponsiveHelper.getPaddingEnhanced(context),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreviewSection(BuildContext context) {
    if (_mediaItems.isEmpty) {
      return Card(
        elevation: ResponsiveHelper.getResponsiveElevation(context),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
          child: Column(
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: ResponsiveHelper.getResponsiveIconSize(context) * 2,
                color: AppTheme.textSecondary,
              ),
              ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
              Text(
                'No media added yet',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
              Text(
                'Add photos and videos to showcase your service',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: ResponsiveHelper.getResponsiveElevation(context),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Media Preview',
                  style: AppTheme.headlineSmall,
                ),
                Text(
                  '${_mediaItems.length} item${_mediaItems.length == 1 ? '' : 's'}',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _mediaItems.length,
              onReorder: _reorderMedia,
              itemBuilder: (context, index) {
                final mediaItem = _mediaItems[index];
                return _buildMediaPreviewItem(context, mediaItem, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreviewItem(BuildContext context, OfferingMediaDTO mediaItem, int index) {
    final isLocalFile = index < _selectedFiles.length && !_isServerMediaId(mediaItem.mediaUrl);
    final isServerMedia = _isServerMediaId(mediaItem.mediaUrl);
    
    return Card(
      key: ValueKey(mediaItem.mediaUrl),
      margin: EdgeInsets.only(bottom: ResponsiveHelper.getResponsiveSpacing(context)),
      child: ListTile(
        leading: _buildMediaThumbnail(context, mediaItem, index),
        title: Text(
          mediaItem.mediaType == 'IMAGE' ? 'Image ${index + 1}' : 'Video ${index + 1}',
          style: AppTheme.bodyLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mediaItem.mediaType,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            if (index == 0)
              Text(
                'Main display photo',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              isLocalFile ? 'Local file' : isServerMedia ? 'Server media' : 'Uploaded',
              style: AppTheme.bodySmall.copyWith(
                color: isLocalFile ? Colors.orange : isServerMedia ? Colors.blue : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.drag_handle,
              color: AppTheme.textSecondary,
            ),
            if (_isRemoving)
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.errorColor),
                ),
              )
            else
              IconButton(
                onPressed: () => _removeMediaItem(index),
                icon: Icon(
                  Icons.delete_outline,
                  color: AppTheme.errorColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaThumbnail(BuildContext context, OfferingMediaDTO mediaItem, int index) {
    final size = ResponsiveHelper.getResponsiveIconSize(context) * 2;
    
    if (mediaItem.mediaType == 'IMAGE') {
      // Server media (mediaUrl is an ID)
      if (_isServerMediaId(mediaItem.mediaUrl)) {
        return _buildServerMediaThumbnail(context, mediaItem.mediaUrl, size);
      }
      // HTTP URL (uploaded media)
      else if (mediaItem.mediaUrl.startsWith('http')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            mediaItem.mediaUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.broken_image,
                  color: AppTheme.textSecondary,
                ),
              );
            },
          ),
        );
      }
      // Local file
      else if (index < _selectedFiles.length) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            _selectedFiles[index],
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.broken_image,
                  color: AppTheme.textSecondary,
                ),
              );
            },
          ),
        );
      } else {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.image,
            color: AppTheme.textSecondary,
          ),
        );
      }
    } else {
      // Video thumbnail
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.play_circle_fill,
          color: AppTheme.primaryColor,
          size: size * 0.6,
        ),
      );
    }
  }

  Widget _buildServerMediaThumbnail(BuildContext context, String mediaId, double size) {
    // Check if we're currently loading this media
    if (_loadingMedia[mediaId] == true) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SizedBox(
            width: size * 0.3,
            height: size * 0.3,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
        ),
      );
    }

    // Check if we have cached data
    final cachedData = _mediaDataCache[mediaId];
    if (cachedData != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          cachedData,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.broken_image,
                color: AppTheme.textSecondary,
              ),
            );
          },
        ),
      );
    }

    // If no cached data and not loading, try to load it
    if (_loadingMedia[mediaId] != true) {
      _loadMediaData(mediaId);
    }

    // Show placeholder while loading
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.image,
        color: AppTheme.textSecondary,
      ),
    );
  }
}