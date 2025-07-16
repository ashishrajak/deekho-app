// lib/screens/offering_service_form_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/pages/home/responsive-helper.dart';
import 'package:my_flutter_app/pages/offered-services/basic-info.dart';
import 'package:my_flutter_app/pages/offered-services/category.-tab.dart';
import 'package:my_flutter_app/pages/offered-services/media-tab.dart';
import 'package:my_flutter_app/pages/offered-services/pricing.dart';
import 'package:my_flutter_app/pages/offered-services/time-location.dart';
import 'package:my_flutter_app/services/CommonDataService.dart';
import 'package:my_flutter_app/services/offering_service.dart';

class OfferingServiceFormScreen extends StatefulWidget {
  final OfferingServiceDTO? existingService;
  final bool isEditing;

  const OfferingServiceFormScreen({
    Key? key,
    this.existingService,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<OfferingServiceFormScreen> createState() => _OfferingServiceFormScreenState();
}

class _OfferingServiceFormScreenState extends State<OfferingServiceFormScreen> {
  late OfferingServiceDTO _formData;
  final PageController _pageController = PageController();
  final OfferingService offeringService = OfferingService();
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    if (widget.existingService != null) {
      _formData = widget.existingService!;
    } else {
      _formData = OfferingServiceDTO(
        id: '',
        title: '',
        description: '',
        category: ServiceCategoryDto(
          id: '',
          name: '',
          description: '',
        ),
        status: 'ACTIVE',
        verified: false,
        timing: ServiceTiming(
          availableDays: [],
          emergencyService: false,
        ),
        geography: ServiceGeography(),
        tags: <String>{},
        primaryPricing: OfferingPricingDTO(
          type: PricingType.FIXED,
          basePrice: MoneyDTO(amount: 0, currency: 'USD'),
        ),
        mediaItems: [],
      );
    }
  }

  void _updateFormData(OfferingServiceDTO updatedData) {
    setState(() {
      _formData = updatedData;
    });
  }

  void _nextTab() {
    if (_currentTabIndex < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousTab() {
    if (_currentTabIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }


Future<void> _saveService() async {
  try {
    // API call to save or update service
    if (widget.isEditing) {
      // Update existing service
      print('Updating service: ${_formData.toJson()}');
      
      // Make API call to update service
      final updatedService = await offeringService.saveOfferingService(_formData);
      
      // Update _formData with the returned service
      setState(() {
        _formData = updatedService;
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Service updated successfully'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      
      // Navigate back
      Navigator.of(context).pop(_formData);
    } else {
      // Create new service
      print('Creating new service: ${_formData.toJson()}');
      
      // Make API call to create service
      final createdService = await offeringService.saveOfferingService(_formData);
      
      // Update _formData with the returned service that includes ID
      setState(() {
        _formData = createdService;
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Service created successfully'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      
      // Update the widget state to editing mode since we now have an ID
      setState(() {
        // This will unlock the media tab
      });
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error saving service: $e'),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Service' : 'Add New Service'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        actions: [
          if (ResponsiveHelper.isDesktop(context))
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton.icon(
                onPressed: _saveService,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: ResponsiveHelper.responsiveBuilder(
        context,
        mobile: _buildMobileLayout(),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      ),
      bottomNavigationBar: ResponsiveHelper.isMobile(context) 
          ? _buildMobileBottomBar() 
          : null,
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildTabIndicator(),
        Expanded(
          child: OfferingFormTabs(
            pageController: _pageController,
            formData: _formData,
            onFormDataChanged: _updateFormData,
            onTabChanged: (index) {
              setState(() {
                _currentTabIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        SizedBox(
          width: ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 280,
            tablet: 320,
            desktop: 360,
          ),
          child: _buildSideNavigationTabs(),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 1),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: AppTheme.dividerColor),
              ),
            ),
            child: OfferingFormTabs(
              pageController: _pageController,
              formData: _formData,
              onFormDataChanged: _updateFormData,
              onTabChanged: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        SizedBox(
          width: 400,
          child: _buildSideNavigationTabs(),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 1),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: AppTheme.dividerColor),
              ),
            ),
            child: OfferingFormTabs(
              pageController: _pageController,
              formData: _formData,
              onFormDataChanged: _updateFormData,
              onTabChanged: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabIndicator() {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        children: List.generate(5, (index) {
          final isActive = index == _currentTabIndex;
          final isCompleted = index < _currentTabIndex;
          
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isActive || isCompleted 
                    ? AppTheme.primaryColor 
                    : AppTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

Widget _buildSideNavigationTabs() {
  final tabs = [
    {'title': 'Basic Info', 'icon': Icons.info_outline},
    {'title': 'Category', 'icon': Icons.category_outlined},
    {'title': 'Timing & Location', 'icon': Icons.schedule_outlined},
    {'title': 'Pricing', 'icon': Icons.attach_money_outlined},
    {'title': 'Media', 'icon': Icons.image_outlined},
  ];

  return Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Service Details',
            style: AppTheme.headlineMedium,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tabs.length,
            itemBuilder: (context, index) {
              final tab = tabs[index];
              final isActive = index == _currentTabIndex;
              final isCompleted = index < _currentTabIndex;
              
              // Media tab logic
              final isMediaTab = index == 4; // Media tab is at index 4
              final isMediaTabLocked = isMediaTab && !widget.isEditing && (_formData.id.isEmpty || _formData.id == '');
              
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? AppTheme.primaryColor.withOpacity(0.1) : null,
                  borderRadius: BorderRadius.circular(8),
                  border: isActive ? Border.all(color: AppTheme.primaryColor) : null,
                ),
                child: ListTile(
                  leading: Icon(
                    isMediaTabLocked ? Icons.lock_outline : tab['icon'] as IconData,
                    color: isMediaTabLocked 
                        ? AppTheme.textSecondary.withOpacity(0.5)
                        : isActive 
                            ? AppTheme.primaryColor 
                            : isCompleted 
                                ? AppTheme.successColor 
                                : AppTheme.textSecondary,
                  ),
                  title: Text(
                    tab['title'] as String,
                    style: AppTheme.bodyMedium.copyWith(
                      color: isMediaTabLocked 
                          ? AppTheme.textSecondary.withOpacity(0.5)
                          : isActive 
                              ? AppTheme.primaryColor 
                              : AppTheme.textPrimary,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isCompleted 
                      ? const Icon(Icons.check_circle, color: AppTheme.successColor)
                      : isMediaTabLocked 
                          ? const Icon(Icons.lock_outline, color: AppTheme.textSecondary)
                          : null,
                  onTap: isMediaTabLocked ? null : () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _getButtonAction(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _getButtonText(),
                style: AppTheme.buttonText,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

String _getButtonText() {
  // If we're on media tab
  if (_currentTabIndex == 4) {
    // Check if service has ID (saved to DB)
    if (_formData.id.isNotEmpty) {
      return _formData.mediaItems.isEmpty ? 'Add Media' : 'Edit Media';
    } else {
      return 'Save Service First';
    }
  }
  
  // For other tabs
  return widget.isEditing ? 'Update Service' : 'Create Service';
}

VoidCallback? _getButtonAction() {
  // If we're on media tab
  if (_currentTabIndex == 4) {
    // Check if service has ID (saved to DB)
    if (_formData.id.isNotEmpty) {
      return _addOrEditMedia;
    } else {
      return _saveServiceBeforeMedia;
    }
  }
  
  // For other tabs, normal save/update
  return _saveService;
}

// Future<void> _saveService() async {
//   try {
//     // API call to save or update service
//     if (widget.isEditing) {
//       // Update existing service
//       print('Updating service: ${_formData.toJson()}');
      
//       // Make API call to update service
//       // final updatedService = await serviceRepository.updateService(_formData);
      
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Service updated successfully'),
//           backgroundColor: AppTheme.successColor,
//         ),
//       );
      
//       // Navigate back
//       Navigator.of(context).pop(_formData);
//     } else {
//       // Create new service
//       print('Creating new service: ${_formData.toJson()}');
      
//       // Make API call to create service
//       // final createdService = await serviceRepository.createService(_formData);
      
//       // Update _formData with the returned service that includes ID
//       // _formData = createdService;
      
//       // For demo purposes, simulate getting an ID back
//       _formData = _formData.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString());
      
//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Service created successfully'),
//           backgroundColor: AppTheme.successColor,
//         ),
//       );
      
//       // Update the widget state to editing mode since we now have an ID
//       setState(() {
//         // This will unlock the media tab
//       });
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Error saving service: $e'),
//         backgroundColor: AppTheme.errorColor,
//       ),
//     );
//   }
// }

Future<void> _saveServiceBeforeMedia() async {
  // This is called when user tries to access media tab without saving first
  try {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    // Create new service first
    print('Creating new service before media: ${_formData.toJson()}');
    
    // Make API call to create service
    // final createdService = await serviceRepository.createService(_formData);
    
    // Update _formData with the returned service that includes ID
    // _formData = createdService;
    
    // For demo purposes, simulate getting an ID back
    _formData = _formData.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString());
    
    // Close loading dialog
    Navigator.of(context).pop();
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Service saved successfully. You can now add media.'),
        backgroundColor: AppTheme.successColor,
      ),
    );
    
    // Update the state to reflect changes
    setState(() {
      // This will unlock the media tab and change button text
    });
    
  } catch (e) {
    // Close loading dialog
    Navigator.of(context).pop();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error saving service: $e'),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }
}

Future<void> _addOrEditMedia() async {
  // This is called when user wants to add/edit media
  // try {
  //   // Show media picker/editor
  //   //await _showMediaPicker();
    
  // } catch (e) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Error managing media: $e'),
  //       backgroundColor: AppTheme.errorColor,
  //     ),
  //   );
  // }
}

Future<void> _showMediaPicker() async {
  // Implement media picker logic here
  // This could be a bottom sheet or dialog with options to:
  // - Take photo
  // - Pick from gallery
  // - Record video
  // - etc.
  
  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add Media',
            style: AppTheme.headlineSmall,
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Take Photo'),
            onTap: () {
              Navigator.pop(context);
              _pickImageFromCamera();
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              _pickImageFromGallery();
            },
          ),
          ListTile(
            leading: Icon(Icons.videocam),
            title: Text('Record Video'),
            onTap: () {
              Navigator.pop(context);
              _pickVideoFromCamera();
            },
          ),
        ],
      ),
    ),
  );
}

Future<void> _pickImageFromCamera() async {
  // Implement image picker from camera
  // Use image_picker package
}

Future<void> _pickImageFromGallery() async {
  // Implement image picker from gallery
  // Use image_picker package
}

Future<void> _pickVideoFromCamera() async {
  // Implement video picker from camera
  // Use image_picker package
}

bool _isMediaTabAccessible() {
  // Media tab is accessible if:
  // 1. We're in editing mode (existing service)
  // 2. OR we're in create mode but service has been saved (has ID)
  return widget.isEditing || (_formData.id.isNotEmpty && _formData.id != '');
}

// Helper method to check if we should show media tab as locked
bool _shouldShowMediaTabLocked() {
  return _currentTabIndex == 4 && !_isMediaTabAccessible();
}
  Widget _buildMobileBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppTheme.dividerColor),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentTabIndex > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousTab,
                  child: const Text('Previous'),
                ),
              ),
            if (_currentTabIndex > 0) const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _currentTabIndex == 4 ? _saveService : _nextTab,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(_currentTabIndex == 4 ? 'Save' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}


class OfferingFormTabs extends StatefulWidget {
  final PageController pageController;
  final OfferingServiceDTO formData;
  final Function(OfferingServiceDTO) onFormDataChanged;
  final Function(int) onTabChanged;

  const OfferingFormTabs({
    Key? key,
    required this.pageController,
    required this.formData,
    required this.onFormDataChanged,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  State<OfferingFormTabs> createState() => _OfferingFormTabsState();
}

class _OfferingFormTabsState extends State<OfferingFormTabs> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.pageController,
      onPageChanged: widget.onTabChanged,
      children: [
        BasicInfoTab(
          formData: widget.formData,
          onFormDataChanged: widget.onFormDataChanged,
        ),
        CategoryTab(
          formData: widget.formData,
          onFormDataChanged: widget.onFormDataChanged,
        ),
        TimingLocationTab(
          formData: widget.formData,
          onFormDataChanged: widget.onFormDataChanged,
        ),
        PricingTab(
          formData: widget.formData,
          onFormDataChanged: widget.onFormDataChanged,
        ),
        MediaTab(
          formData: widget.formData,
          onFormDataChanged: widget.onFormDataChanged,
        ),
      ],
    );
  }
}


// lib/widgets/form_tabs/category_tab.dart

