import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_flutter_app/main.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/pages/add-service_page.dart';
import 'package:my_flutter_app/pages/offered-services/edit-service.dart';
import 'package:my_flutter_app/services/offering_service.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> with SingleTickerProviderStateMixin {
  final OfferingService _offeringService = OfferingService();
  late TabController _tabController;
  final _detailsFormKey = GlobalKey<FormState>();
  final _availabilityFormKey = GlobalKey<FormState>();
  final _advancedFormKey = GlobalKey<FormState>();
  final _mediaFormKey = GlobalKey<FormState>();

  // Generated service ID from backend
  String? _serviceId;
  bool _isLoading = false;

  // Service Details (Details Page)
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Vehicle Services';
  String? _selectedSubcategory;
  final _tagsController = TextEditingController();
  Set<String> _tags = {};

  // Availability & Location (Availability Page)
  final Map<String, bool> _availableDays = {
    'MONDAY': false,
    'TUESDAY': false,
    'WEDNESDAY': false,
    'THURSDAY': false,
    'FRIDAY': false,
    'SATURDAY': false,
    'SUNDAY': false,
  };
  final _durationController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  double? _latitude;
  double? _longitude;
  final _serviceAreaController = TextEditingController();
  bool _willingToTravel = false;
  bool _onSiteService = true;
  bool _emergencyService = false;
  final _travelRadiusController = TextEditingController();

  // Pricing & Payment (Advanced Page)
  String _priceType = 'FIXED';
  final _basePriceController = TextEditingController();
  final _currencyController = TextEditingController();
  final _additionalChargesController = TextEditingController();
  final _discountController = TextEditingController();
  final Map<String, bool> _paymentMethods = {
    'CASH': false,
    'UPI': false,
    'CARD': false,
    'ONLINE': false,
  };

  // Advance Policy
  bool _advanceRequired = false;
  final _advanceAmountController = TextEditingController();
  final _advanceCurrencyController = TextEditingController();
  final _advanceTermsController = TextEditingController();

  // Status
  String _status = 'ACTIVE';
  bool _verified = false;

  // Media (Media Page)
  final List<File> _mediaFiles = [];
  final _videoUrlController = TextEditingController();

  // Categories
  final Map<String, List<String>> _categorySubcategories = {
    'Vehicle Services': [
      'Car service',
      'Bike service',
      'Auto repair',
      'Towing services'
    ],
    'Home Services': [
      'AC repair',
      'Plumbing',
      'Carpentry',
      'Electrician',
      'Cleaning services',
      'Pest control'
    ],
    'Contract-Based Services': [
      'Mason / Construction worker',
      'Painter',
      'Tile worker',
      'Roofer',
      'Laborer'
    ],
    'Additional Services': [
      'Salon at home',
      'Massage',
      'Personal tutor',
      'Language trainer',
      'Computer repair',
      'Mobile repair',
      'Decorators',
      'Caterers',
      'Tent and lighting',
      'Pet grooming',
      'Vet visits'
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _getCurrentLocation();
    _currencyController.text = 'INR';
    _advanceCurrencyController.text = 'INR';
    _durationController.text = '60'; // Default 60 minutes
    _startTimeController.text = '09:00'; // Default start time
    _endTimeController.text = '18:00'; // Default end time
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _durationController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _serviceAreaController.dispose();
    _travelRadiusController.dispose();
    _basePriceController.dispose();
    _currencyController.dispose();
    _additionalChargesController.dispose();
    _discountController.dispose();
    _advanceAmountController.dispose();
    _advanceCurrencyController.dispose();
    _advanceTermsController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // Generate temporary ID (replace with actual API call)
  String _generateTempId() {
    return 'temp_${DateTime.now().millisecondsSinceEpoch}';
  }

  // API call to save service details
  Future<bool> _saveServiceDetails() async {
    setState(() => _isLoading = true);

    try {
      final serviceData = _buildServiceDetailsDTO();
      final savedServiceData = await _offeringService.saveOfferingService(serviceData);

      // Generate service ID (in real app, this comes from backend)
      _updateControllersFromDTO(savedServiceData);

      print('Saving service details: ${serviceData.toJson()}');

      // Simulate success
      return true;
    } catch (e) {
      _showErrorSnackBar('Failed to save service details: $e');
      return false;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // API call to upload media
  Future<bool> _uploadMedia() async {

    if (_serviceId == null) return false;

    setState(() => _isLoading = true);

    try {
      // Simulate API call - replace with actual implementation
      await Future.delayed(const Duration(seconds: 2));
      final uploadedUrls = await _offeringService.uploadMedia(_serviceId!, _mediaFiles);

      print('Successfully uploaded ${uploadedUrls.length} media files');
      print('Uploaded URLs: $uploadedUrls');
      print('Uploading ${_mediaFiles.length} media files for service $_serviceId');

      // Simulate success
      return true;
    } catch (e) {
      _showErrorSnackBar('Failed to upload media: $e');
      return false;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  OfferingServiceDTO _buildServiceDetailsDTO() {
    return OfferingServiceDTO(
      id: _serviceId ?? '',
      title: _titleController.text,
      description: _descriptionController.text,
      category: _selectedCategory,
      status: _status,
      verified: _verified,
      timing: ServiceTiming(
        durationMinutes: int.tryParse(_durationController.text),
        estimatedCompletion: null, // You can calculate this based on duration
        availableDays: _availableDays.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList(),
        startTime: _startTimeController.text.isNotEmpty ? _startTimeController.text : null,
        endTime: _endTimeController.text.isNotEmpty ? _endTimeController.text : null,
        emergencyService: _emergencyService,
      ),
      geography: ServiceGeography(
        latitude: _latitude,
        longitude: _longitude,
        serviceArea: _serviceAreaController.text.isEmpty ? null : _serviceAreaController.text,
        onSiteService: _onSiteService,
        willingToTravel: _willingToTravel,
        travelRadius: _travelRadiusController.text.isNotEmpty ? double.tryParse(_travelRadiusController.text) : null,
      ),
      tags: _tags,
      primaryPricing: OfferingPricingDTO(
        type: _priceType == 'FIXED' ? PricingType.FIXED : PricingType.HOURLY,
        basePrice: MoneyDTO(
          amount: double.tryParse(_basePriceController.text) ?? 0.0,
          currency: _currencyController.text,
        ),
        additionalCharges: _additionalChargesController.text.isEmpty ? null : _additionalChargesController.text,
        discount: _discountController.text.isEmpty ? null : _discountController.text,
        conditions: {}, // Add conditions if needed
paymentMethods: _paymentMethods.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList().toSet(),
),
      advancePolicy: _advanceRequired ? AdvancePolicy(
        advanceRequired: _advanceRequired,
        advanceAmount: _advanceAmountController.text.isNotEmpty ? MoneyDTO(
          amount: double.tryParse(_advanceAmountController.text) ?? 0.0,
          currency: _advanceCurrencyController.text,
        ) : null,
        advanceTerms: _advanceTermsController.text.isNotEmpty ? _advanceTermsController.text : null,
      ) : null, mediaItems: [],


    );
  }

  OfferingServiceDTO _buildCompleteServiceDTO() {
    final dto = _buildServiceDetailsDTO();
    // Add media items if any
    final mediaItems = <OfferingMediaDTO>[];
    for (int i = 0; i < _mediaFiles.length; i++) {
      mediaItems.add(OfferingMediaDTO(
        mediaUrl: 'temp_url_${i}', // Will be replaced with actual URL after upload
        mediaType: 'IMAGE',
        displayOrder: i,
      ));
    }

    if (_videoUrlController.text.isNotEmpty) {
      mediaItems.add(OfferingMediaDTO(
        mediaUrl: _videoUrlController.text,
        mediaType: 'VIDEO',
        displayOrder: mediaItems.length,
      ));
    }

    return dto.copyWith(mediaItems: mediaItems);
  }

  String _generateOfferingCode() {
    final categoryCode = _selectedCategory.substring(0, 3).toUpperCase();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    return '${categoryCode}_$timestamp';
  }

  void _addTag() {
    final tag = _tagsController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagsController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
  }

  Future<void> _pickMultipleImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _mediaFiles.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  void _removeMedia(int index) {
    setState(() => _mediaFiles.removeAt(index));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _handleNextPage() async {
    switch (_tabController.index) {
      case 0: // Details page
        if (_detailsFormKey.currentState!.validate()) {
        /*  final success = await _saveServiceDetails();
          if (success) {*/
            _tabController.animateTo(1);
           // _showSuccessSnackBar('Service details saved successfully!');
         // }
        }
        break;
      case 1: // Availability page
        if (_availabilityFormKey.currentState!.validate()) {
          _tabController.animateTo(2);
        }
        break;
      case 2: // Advanced page
        if (_advancedFormKey.currentState!.validate()) {
          final success = await _saveServiceDetails();
          if (success) {
            _tabController.animateTo(3);
            _showSuccessSnackBar('Service data updated successfully!');
          }
        }
        break;
      case 3: // Media page
        final success = await _uploadMedia();
        if (success) {
          _showSuccessSnackBar('Service created successfully!');
          Navigator.pop(context, true);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'Availability'),
            Tab(text: 'Advanced'),
            Tab(text: 'Media'),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(), // Prevent swiping
            children: [
              _buildDetailsPage(),
              _buildAvailabilityPage(),
              _buildAdvancedPage(),
              _buildMediaPage(),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _handleNextPage,
        child: Icon(_tabController.index == 3 ? Icons.save : Icons.arrow_forward),
      ),
    );
  }

  Widget _buildDetailsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _detailsFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Service Title*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Service Description*',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category*',
                        border: OutlineInputBorder(),
                      ),
                      items: _categorySubcategories.keys.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                          _selectedSubcategory = null;
                        });
                      },
                      validator: (value) => value == null ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _selectedSubcategory,
                      decoration: const InputDecoration(
                        labelText: 'Subcategory',
                        border: OutlineInputBorder(),
                      ),
                      items: _categorySubcategories[_selectedCategory]?.map((subcategory) {
                        return DropdownMenuItem(
                          value: subcategory,
                          child: Text(subcategory),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedSubcategory = value),
                    ),
                    const SizedBox(height: 16),

                    const Text('Tags', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _tagsController,
                            decoration: const InputDecoration(
                              labelText: 'Add Tag',
                              border: OutlineInputBorder(),
                            ),
                            onFieldSubmitted: (_) => _addTag(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addTag,
                        ),
                      ],
                    ),
                    if (_tags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _tags.map((tag) {
                          return Chip(
                            label: Text(tag),
                            onDeleted: () => _removeTag(tag),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _availabilityFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Availability & Location',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Service Duration
                    TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        labelText: 'Service Duration (minutes)*',
                        hintText: '60 (1 hour), 90 (1.5 hours)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Start and End Time Pickers Only
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _startTimeController,
                            decoration: const InputDecoration(
                              labelText: 'Start Time*',
                              hintText: '09:00',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (context, child) => child!,
                              );
                              if (picked != null) {
                                // Store as HH:mm string format
                                final timeString = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                _startTimeController.text = timeString;
                              }
                            },
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _endTimeController,
                            decoration: const InputDecoration(
                              labelText: 'End Time*',
                              hintText: '18:00',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                            readOnly: true,
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (context, child) => child!,
                              );
                              if (picked != null) {
                                // Store as HH:mm string format
                                final timeString = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                _endTimeController.text = timeString;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Working Days
                    const Text('Working Days*', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _availableDays.keys.map((day) {
                        return FilterChip(
                          label: Text(day.toLowerCase()),
                          selected: _availableDays[day]!,
                          onSelected: (selected) => setState(() => _availableDays[day] = selected),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Service Options
                    SwitchListTile(
                      title: const Text('On-Site Service'),
                      value: _onSiteService,
                      onChanged: (value) => setState(() => _onSiteService = value),
                    ),

                    SwitchListTile(
                      title: const Text('Emergency Service'),
                      value: _emergencyService,
                      onChanged: (value) => setState(() => _emergencyService = value),
                    ),

                    // Service Area
                    TextFormField(
                      controller: _serviceAreaController,
                      decoration: const InputDecoration(
                        labelText: 'Service Area',
                        hintText: 'e.g., Indore, Madhya Pradesh',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Travel Options
                    SwitchListTile(
                      title: const Text('Willing to Travel'),
                      value: _willingToTravel,
                      onChanged: (value) => setState(() => _willingToTravel = value),
                    ),

                    if (_willingToTravel) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _travelRadiusController,
                        decoration: const InputDecoration(
                          labelText: 'Travel Radius (km)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Location Display
                    if (_latitude != null && _longitude != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Location: ${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _advancedFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pricing & Payment',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _priceType,
                      decoration: const InputDecoration(
                        labelText: 'Price Type*',
                        border: OutlineInputBorder(),
                      ),
                      items: ['FIXED', 'HOURLY'].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _priceType = value!),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _basePriceController,
                            decoration: const InputDecoration(
                              labelText: 'Base Price*',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _currencyController,
                            decoration: const InputDecoration(
                              labelText: 'Currency*',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _additionalChargesController,
                      decoration: const InputDecoration(
                        labelText: 'Additional Charges',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _discountController,
                      decoration: const InputDecoration(
                        labelText: 'Discount/Offers',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text('Payment Methods', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _paymentMethods.keys.map((method) {
                        return FilterChip(
                          label: Text(method),
                          selected: _paymentMethods[method]!,
                          onSelected: (selected) => setState(() => _paymentMethods[method] = selected),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Advance Policy',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    SwitchListTile(
                      title: const Text('Advance Required'),
                      value: _advanceRequired,
                      onChanged: (value) => setState(() => _advanceRequired = value),
                    ),

                    if (_advanceRequired) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _advanceAmountController,
                              decoration: const InputDecoration(
                                labelText: 'Advance Amount',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _advanceCurrencyController,
                              decoration: const InputDecoration(
                                labelText: 'Currency',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _advanceTermsController,
                        decoration: const InputDecoration(
                          labelText: 'Advance Terms',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text(
                  'Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Service Status',
                    border: OutlineInputBorder(),
                  ),
                  items: ['ACTIVE', 'INACTIVE', 'PENDING'].map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _status = value!),
                ),
                const SizedBox(height: 16),


                    SwitchListTile(
                      title: const Text('Verified Service'),
                      value: _verified,
                      onChanged: (value) => setState(() => _verified = value),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMediaPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _mediaFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Media & Documentation',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickMultipleImages,
                            icon: const Icon(Icons.add_photo_alternate),
                            label: const Text('Add Images'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${_mediaFiles.length} selected'),
                      ],
                    ),

                    if (_mediaFiles.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _mediaFiles.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _mediaFiles[index],
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _removeMedia(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Additional helper methods you'll need:

// Required variables (add these to your class):
// final GlobalKey<FormState> _mediaFormKey = GlobalKey<FormState>();
// List<File> _mediaFiles = [];


  Future<bool> _updateServiceData() async {


    setState(() => _isLoading = true);

    try {
      final serviceData = _buildServiceDetailsDTO();
      print('Updating service data: ${serviceData.toJson()}');

      // Create service instance
      final offeringService = OfferingService();

      // Call API to save/update the service
      final updatedServiceData = await offeringService.saveOfferingService(
        serviceData,
      );

      // Update all controllers with the response from server
      _updateControllersFromDTO(updatedServiceData);

      // Show success message
      _showSuccessSnackBar('Service updated successfully');

      // Dispose the service
      offeringService.dispose();

      return true;
    } catch (e) {
      _showErrorSnackBar('Failed to update service data: $e');
      return false;
    } finally {
      setState(() => _isLoading = false);
    }
  }

// Method to update controllers from server response
 void _updateControllersFromDTO(OfferingServiceDTO dto) {
   setState(() {
     // Update basic info
     _serviceId = dto.id;
     _titleController.text = dto.title;
     _descriptionController.text = dto.description;
     _selectedCategory = dto.category;
     _status = dto.status;
     _verified = dto.verified;

     // Update timing
     final timing = dto.timing;
     if (timing != null) {
       _durationController.text = timing.durationMinutes?.toString() ?? '';
       _startTimeController.text = timing.startTime ?? '';
       _endTimeController.text = timing.endTime ?? '';
       _emergencyService = timing.emergencyService;

       // Reset and update available days
       _availableDays.updateAll((key, value) => false);
       for (final day in timing.availableDays) {
         if (_availableDays.containsKey(day)) {
           _availableDays[day] = true;
         }
       }
     }

     // Update geography
     final geography = dto.geography;
     if (geography != null) {
       _latitude = geography.latitude;
       _longitude = geography.longitude;
       _serviceAreaController.text = geography.serviceArea ?? '';
       _onSiteService = geography.onSiteService ?? true;
       _willingToTravel = geography.willingToTravel ?? false;
       _travelRadiusController.text = geography.travelRadius?.toString() ?? '';
     }

     // Update tags
     _tags = Set<String>.from(dto.tags);

     // Update pricing
     final pricing = dto.primaryPricing;
     if (pricing != null) {
       _priceType = pricing.type == PricingType.FIXED ? 'FIXED' : 'HOURLY';

       _basePriceController.text = pricing.basePrice.amount.toString();
       _currencyController.text = pricing.basePrice.currency;

       _additionalChargesController.text = pricing.additionalCharges ?? '';
       _discountController.text = pricing.discount ?? '';

       // Reset and update payment methods
       _paymentMethods.updateAll((key, value) => false);
       for (final method in pricing.paymentMethods) {
         if (_paymentMethods.containsKey(method)) {
           _paymentMethods[method] = true;
         }
       }
     }

     // Update advance policy
     final advancePolicy = dto.advancePolicy;
     if (advancePolicy != null) {
       _advanceRequired = advancePolicy.advanceRequired;
       if (advancePolicy.advanceAmount != null) {
         _advanceAmountController.text = advancePolicy.advanceAmount!.amount.toString();
         _advanceCurrencyController.text = advancePolicy.advanceAmount!.currency;
       } else {
         _advanceAmountController.clear();
         _advanceCurrencyController.clear();
       }
       _advanceTermsController.text = advancePolicy.advanceTerms ?? '';
     } else {
       _advanceRequired = false;
       _advanceAmountController.clear();
       _advanceCurrencyController.clear();
       _advanceTermsController.clear();
     }
   });
 }
}