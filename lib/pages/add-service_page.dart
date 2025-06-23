// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';

// // Service DTO Class
// class Service {
//   final String id;
//   final String name;
//   final String title;
//   final String description;
//   final String category;
//   final double price;
//   final bool status;
//   final int? duration;
//   final String? imageUrl;
//   final List<String>? similarServices;

//   Service({
//     required this.id,
//     required this.name,
//     required this.title,
//     required this.description,
//     required this.category,
//     required this.price,
//     required this.status,
//     this.duration,
//     this.imageUrl,
//     this.similarServices,
//   });

//   factory Service.fromJson(Map<String, dynamic> json) {
//     return Service(
//       id: json['id'],
//       name: json['name'] ?? '',
//       title: json['title'] ?? json['name'] ?? '',
//       description: json['description'] ?? '',
//       category: json['category'],
//       price: (json['price'] ?? 0).toDouble(),
//       status: json['status'] ?? true,
//       duration: json['duration'],
//       imageUrl: json['imageUrl'],
//       similarServices: json['similarServices'] != null
//           ? List<String>.from(json['similarServices'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'title': title,
//       'description': description,
//       'category': category,
//       'price': price,
//       'status': status,
//       'duration': duration,
//       'imageUrl': imageUrl,
//       'similarServices': similarServices,
//     };
//   }

//   /// Returns a Map useful for local DB storage or manual serialization
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'title': title,
//       'description': description,
//       'category': category,
//       'price': price,
//       'status': status ? 1 : 0, // stored as int for SQLite compatibility
//       'duration': duration ?? 0,
//       'imageUrl': imageUrl ?? '',
//       'similarServices': similarServices?.join(',') ?? '', // flatten list to string
//     };
//   }

//   /// Create Service from a map (e.g. from SQLite)
//   factory Service.fromMap(Map<String, dynamic> map) {
//     return Service(
//       id: map['id'],
//       name: map['name'],
//       title: map['title'],
//       description: map['description'],
//       category: map['category'],
//       price: (map['price'] ?? 0).toDouble(),
//       status: (map['status'] ?? 1) == 1,
//       duration: map['duration'],
//       imageUrl: map['imageUrl'],
//       similarServices: map['similarServices'] != null && map['similarServices'].toString().isNotEmpty
//           ? map['similarServices'].toString().split(',')
//           : null,
//     );
//   }
// }

// // App Colors
// class AppColors {
//   static const primaryBlue = Color(0xFF2196F3);
//   static const accentGreen = Color(0xFF4CAF50);
//   static const accentOrange = Color(0xFFFF9800);
//   static const backgroundGrey = Color(0xFFF5F5F5);
//   static const cardBackground = Color(0xFFFFFFFF);
//   static const dividerColor = Color(0xFFE0E0E0);
// }

// // App Text Styles
// class AppTextStyles {
//   static const headlineLarge = TextStyle(
//     fontSize: 24,
//     fontWeight: FontWeight.bold,
//   );
  
//   static const headlineSmall = TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.w600,
//   );
  
//   static const bodyMedium = TextStyle(
//     fontSize: 14,
//   );
  
//   static const buttonText = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w500,
//   );
// }

// // Service Card Widget
// class ServiceCard extends StatelessWidget {
//   final Service service;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//   final ValueChanged<bool> onStatusChanged;

//   const ServiceCard({
//     super.key,
//     required this.service,
//     required this.onEdit,
//     required this.onDelete,
//     required this.onStatusChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 _buildCategoryIcon(),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         service.title,
//                         style: AppTextStyles.headlineSmall.copyWith(
//                           color: AppColors.primaryBlue,
//                         ),
//                       ),
//                       if (service.description.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 4),
//                           child: Text(
//                             service.description,
//                             style: AppTextStyles.bodyMedium,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 Switch(
//                   value: service.status,
//                   activeColor: AppColors.accentGreen,
//                   onChanged: onStatusChanged,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '\$${service.price.toStringAsFixed(2)}',
//                       style: AppTextStyles.bodyMedium.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     if (service.duration != null)
//                       Text(
//                         '${service.duration} days',
//                         style: AppTextStyles.bodyMedium,
//                       ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     TextButton(
//                       onPressed: onEdit,
//                       child: Text(
//                         'EDIT',
//                         style: AppTextStyles.buttonText.copyWith(
//                           color: AppColors.primaryBlue,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     TextButton(
//                       onPressed: onDelete,
//                       child: Text(
//                         'DELETE',
//                         style: AppTextStyles.buttonText.copyWith(
//                           color: AppColors.accentOrange,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryIcon() {
//     IconData icon;
//     Color color;
    
//     switch (service.category) {
//       case 'Vehicle':
//         icon = Icons.directions_car;
//         color = AppColors.primaryBlue;
//         break;
//       case 'Home':
//         icon = Icons.home;
//         color = AppColors.accentOrange;
//         break;
//       case 'Contract':
//         icon = Icons.assignment;
//         color = Colors.purple;
//         break;
//       case 'Full Time':
//         icon = Icons.person;
//         color = Colors.teal;
//         break;
//       default:
//         icon = Icons.category;
//         color = Colors.grey;
//     }

//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Icon(icon, color: color),
//     );
//   }
// }

// // Service Management Screen
// class ServiceManagementScreen extends StatefulWidget {
//   const ServiceManagementScreen({super.key});

//   @override
//   State<ServiceManagementScreen> createState() => _ServiceManagementScreenState();
// }

// class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
//   List<Service> services = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadServices();
//   }

//   Future<void> _loadServices() async {
//     setState(() => isLoading = true);
//     // Simulate network delay
//     await Future.delayed(const Duration(seconds: 1));
    
//     setState(() {
//       services = [
//         Service(
//           id: '1',
//           name: 'Bike Repair',
//           title: 'Bike Repair & Maintenance',
//           description: 'Professional bike repair and maintenance services',
//           category: 'Vehicle Services',
//           price: 25.0,
//           status: true,
//           imageUrl: 'https://example.com/bike.jpg',
//           similarServices: ['Tire Change', 'Bike Tuning'],
//         ),
//         Service(
//           id: '2',
//           name: 'AC Service',
//           title: 'AC Installation & Service',
//           description: 'AC installation, repair and maintenance services',
//           category: 'Home Services',
//           price: 50.0,
//           status: false,
//           duration: 1,
//         ),
//         Service(
//           id: '3',
//           name: 'Masonry',
//           title: 'Masonry Work - 5 Days',
//           description: 'Professional masonry and construction work',
//           category: 'Contract-Based Services',
//           price: 200.0,
//           status: true,
//           duration: 5,
//         ),
//         Service(
//           id: '4',
//           name: 'Home Maid',
//           title: 'Full Time Home Maid',
//           description: 'Professional home cleaning and maintenance',
//           category: 'FAdditional Services',
//           price: 300.0,
//           status: true,
//         ),
//       ];
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundGrey,
//       appBar: AppBar(
//         title: Text('My Services', style: AppTextStyles.headlineLarge),
//         backgroundColor: AppColors.primaryBlue,
//         foregroundColor: Colors.white,
//       ),
//       body: isLoading
//           ? _buildLoadingShimmer()
//           : services.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.handyman,
//                         size: 48,
//                         color: AppColors.dividerColor,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'No services added yet',
//                         style: AppTextStyles.bodyMedium,
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Tap the + button to add your first service',
//                         style: AppTextStyles.bodyMedium.copyWith(
//                           color: AppColors.dividerColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : RefreshIndicator(
//                   onRefresh: _loadServices,
//                   child: ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: services.length,
//                     itemBuilder: (context, index) {
//                       final service = services[index];
//                       return ServiceCard(
//                         service: service,
//                         onEdit: () => _navigateToEdit(service),
//                         onDelete: () => _confirmDelete(service),
//                         onStatusChanged: (value) => _toggleServiceStatus(service, value),
//                       );
//                     },
//                   ),
//                 ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _handleAddService(context),
//         backgroundColor: AppColors.accentOrange,
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildLoadingShimmer() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: 4,
//       itemBuilder: (context, index) {
//         return Card(
//           elevation: 2,
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           child: Container(
//             height: 120,
//             decoration: BoxDecoration(
//               color: AppColors.cardBackground,
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _handleAddService(BuildContext context) {
//     // In a real app, you would check if user is a provider here
//     final isProvider = true; // Temporary for demo
    
//     if (isProvider) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const AddServicePage()),
//       ).then((_) => _loadServices());
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Become a Provider', style: AppTextStyles.headlineSmall),
//           content: Text(
//             'Do you want to offer a service?',
//             style: AppTextStyles.bodyMedium,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel', style: AppTextStyles.buttonText),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 // In a real app, you would navigate to provider setup
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Redirecting to provider setup')),
//                 );
//               },
//               child: Text(
//                 'Enable Provider',
//                 style: AppTextStyles.buttonText.copyWith(
//                   color: AppColors.accentGreen,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   Future<void> _navigateToEdit(Service service) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditServicePage(
//           serviceData: service.toJson(),
//         ),
//       ),
//     );
    
//     if (result == true) {
//       _loadServices();
//     }
//   }

//   void _confirmDelete(Service service) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Confirm Delete', style: AppTextStyles.headlineSmall),
//         content: Text(
//           'Are you sure you want to delete this service?',
//           style: AppTextStyles.bodyMedium,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel', style: AppTextStyles.buttonText),
//           ),
//           TextButton(
//             onPressed: () {
//               // In a real app, you would call API here
//               setState(() => services.removeWhere((s) => s.id == service.id));
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Service deleted')),
//               );
//             },
//             child: Text(
//               'Delete',
//               style: AppTextStyles.buttonText.copyWith(
//                 color: AppColors.accentOrange,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _toggleServiceStatus(Service service, bool value) {
//     // In a real app, you would call API here
//     setState(() {
//       services = services.map((s) {
//         if (s.id == service.id) {
//           return Service(
//             id: s.id,
//             name: s.name,
//             title: s.title,
//             description: s.description,
//             category: s.category,
//             price: s.price,
//             status: value,
//             duration: s.duration,
//             imageUrl: s.imageUrl,
//             similarServices: s.similarServices,
//           );
//         }
//         return s;
//       }).toList();
//     });
//   }
// }











// // Assume AppColors and AppTextStyles are defined elsewhere in your project
// // For demonstration, let's include dummy definitions if they're not provided.















// class AddServicePage extends StatefulWidget {
//   const AddServicePage({super.key});

//   @override
//   State<AddServicePage> createState() => _AddServicePageState();
// }

// class _AddServicePageState extends State<AddServicePage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final _formKey = GlobalKey<FormState>();

//   // Service Details
//   final _serviceNameController = TextEditingController();
//   final _shortDescriptionController = TextEditingController();
//   final _detailedDescriptionController = TextEditingController();
//   File? _selectedImageFile;
//   final _imageUrlController = TextEditingController();
//   bool _isActive = true;
//   bool _isVerified = false;

//   // Categories
//   final Map<String, List<String>> _categorySubcategories = {
//     'Vehicle Services': ['Car service', 'Bike service', 'Auto repair', 'Towing services'],
//     'Home Services': ['AC repair', 'Plumbing', 'Carpentry', 'Electrician', 'Cleaning services', 'Pest control'],
//     'Contract-Based Services': ['Mason / Construction worker', 'Painter', 'Tile worker', 'Roofer', 'Laborer'],
//     'Additional Services': ['Salon at home', 'Massage', 'Personal tutor', 'Language trainer',
//       'Computer repair', 'Mobile repair', 'Decorators', 'Caterers',
//       'Tent and lighting', 'Pet grooming', 'Vet visits'],
//   };
//   String _selectedCategory = 'Vehicle Services';
//   String? _selectedSubcategory;

//   // Provider Details
//   final _providerNameController = TextEditingController();
//   final _businessNameController = TextEditingController();
//   final _experienceController = TextEditingController();
//   File? _licenseFile;

//   // Availability & Location
//   final Map<String, bool> _availableDays = {
//     'Monday': false,
//     'Tuesday': false,
//     'Wednesday': false,
//     'Thursday': false,
//     'Friday': false,
//     'Saturday': false,
//     'Sunday': false,
//   };
//   TimeOfDay? _startTime;
//   TimeOfDay? _endTime;
//   bool _isOnSite = true;
//   bool _willingToTravel = false;
//   String _travelRadius = '5';
//   String? _currentLatitude;
//   String? _currentLongitude;

//   // Pricing & Payment
//   String _priceType = 'Fixed';
//   final _basePriceController = TextEditingController();
//   final _additionalChargesController = TextEditingController();
//   final _discountController = TextEditingController();
//   final _estimatedTimeController = TextEditingController();
//   final Map<String, bool> _paymentMethods = {
//     'Cash': false,
//     'UPI': false,
//     'Credit/Debit Card': false,
//     'Online Payment': false,
//   };

//   // Duration & Contract
//   String _serviceType = 'One-Time';
//   final _contractStartController = TextEditingController();
//   final _contractEndController = TextEditingController();
//   bool _advanceRequired = false;
//   final _advanceAmountController = TextEditingController();

//   // Media & Documentation
//   final List<File> _serviceImages = [];
//   final _videoUrlController = TextEditingController();
//   File? _idProofFile;

//   // Advanced Options
//   final _tagsController = TextEditingController();
//   final List<String> _languages = [];
//   final _languageController = TextEditingController();
//   bool _bringsTools = true;
//   final _toolsListController = TextEditingController();
//   bool _emergencyService = false;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _getCurrentLocation();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _serviceNameController.dispose();
//     _shortDescriptionController.dispose();
//     _detailedDescriptionController.dispose();
//     _imageUrlController.dispose();
//     _providerNameController.dispose();
//     _businessNameController.dispose();
//     _experienceController.dispose();
//     _basePriceController.dispose();
//     _additionalChargesController.dispose();
//     _discountController.dispose();
//     _estimatedTimeController.dispose();
//     _contractStartController.dispose();
//     _contractEndController.dispose();
//     _advanceAmountController.dispose();
//     _videoUrlController.dispose();
//     _tagsController.dispose();
//     _languageController.dispose();
//     _toolsListController.dispose();
//     super.dispose();
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentLatitude = position.latitude.toString();
//         _currentLongitude = position.longitude.toString();
//       });
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _selectedImageFile = File(pickedFile.path);
//         _imageUrlController.clear();
//       });
//     }
//   }

//   Future<void> _pickMultipleImages() async {
//     final picker = ImagePicker();
//     final pickedFiles = await picker.pickMultiImage();

//     if (pickedFiles.isNotEmpty) {
//       setState(() {
//         _serviceImages.addAll(pickedFiles.map((file) => File(file.path)));
//       });
//     }
//   }

//   Future<void> _pickLicense() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() => _licenseFile = File(pickedFile.path));
//     }
//   }

//   Future<void> _pickIdProof() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _idProofFile = File(pickedFile.path);
//       });
//     }
//   }

//   void _saveService() {
//     if (_formKey.currentState!.validate()) {
//       final serviceData = {
//         'serviceName': _serviceNameController.text,
//         'category': _selectedCategory,
//         'subcategory': _selectedSubcategory,
//         'shortDescription': _shortDescriptionController.text,
//         'detailedDescription': _detailedDescriptionController.text,
//         'providerName': _providerNameController.text,
//         'businessName': _businessNameController.text,
//         'experience': _experienceController.text,
//         'availableDays': _availableDays.entries.where((e) => e.value).map((e) => e.key).toList(),
//         'startTime': _startTime?.format(context),
//         'endTime': _endTime?.format(context),
//         'isOnSite': _isOnSite,
//         'willingToTravel': _willingToTravel,
//         'travelRadius': _travelRadius,
//         'location': {
//           'latitude': _currentLatitude,
//           'longitude': _currentLongitude,
//         },
//         'priceType': _priceType,
//         'basePrice': _basePriceController.text,
//         'additionalCharges': _additionalChargesController.text,
//         'discount': _discountController.text,
//         'estimatedTime': _estimatedTimeController.text,
//         'paymentMethods': _paymentMethods.entries.where((e) => e.value).map((e) => e.key).toList(),
//         'serviceType': _serviceType,
//         'contractStart': _contractStartController.text,
//         'contractEnd': _contractEndController.text,
//         'advanceRequired': _advanceRequired,
//         'advanceAmount': _advanceAmountController.text,
//         'languages': _languages,
//         'bringsTools': _bringsTools,
//         'toolsList': _toolsListController.text,
//         'emergencyService': _emergencyService,
//         'isActive': _isActive,
//         'isVerified': _isVerified,
//       };

//       print(serviceData); // Replace with actual save logic

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Service saved successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//       Navigator.pop(context, true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Service'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Details'),
//             Tab(text: 'Availability & Pricing'),
//             Tab(text: 'Advanced'),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _saveService,
//           ),
//         ],
//       ),
//       body: Form(
//         key: _formKey,
//         child: TabBarView(
//           controller: _tabController,
//           children: [
//             SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildServiceDetailsSection(),
//                   const SizedBox(height: 20),
//                   _buildProviderDetailsSection(),
//                 ],
//               ),
//             ),
//             SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildAvailabilitySection(),
//                   const SizedBox(height: 20),
//                   _buildPricingSection(),
//                   const SizedBox(height: 20),
//                   _buildContractSection(),
//                 ],
//               ),
//             ),
//             SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildMediaSection(),
//                   const SizedBox(height: 20),
//                   _buildAdvancedOptionsSection(),
//                   const SizedBox(height: 20),
//                   _buildStatusSection(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: _tabController.index != 2
//           ? FloatingActionButton(
//               onPressed: () {
//                 _tabController.animateTo(_tabController.index + 1);
//               },
//               child: const Icon(Icons.arrow_forward),
//             )
//           : null, // Hide FAB on the last tab
//     );
//   }

//   Widget _buildServiceDetailsSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Service Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _serviceNameController,
//               decoration: const InputDecoration(labelText: 'Service Name*'),
//               validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             DropdownButtonFormField<String>(
//               value: _selectedCategory,
//               items: _categorySubcategories.keys.map((category) {
//                 return DropdownMenuItem(
//                   value: category,
//                   child: Text(category),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedCategory = value!;
//                   _selectedSubcategory = null;
//                 });
//               },
//               decoration: const InputDecoration(labelText: 'Category*'),
//               validator: (value) => value == null ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             DropdownButtonFormField<String>(
//               value: _selectedSubcategory,
//               items: _categorySubcategories[_selectedCategory]?.map((subcategory) {
//                 return DropdownMenuItem(
//                   value: subcategory,
//                   child: Text(subcategory),
//                 );
//               }).toList(),
//               onChanged: (value) => setState(() => _selectedSubcategory = value),
//               decoration: const InputDecoration(labelText: 'Subcategory'),
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _shortDescriptionController,
//               decoration: const InputDecoration(labelText: 'Short Description*'),
//               maxLines: 2,
//               validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _detailedDescriptionController,
//               decoration: const InputDecoration(labelText: 'Detailed Description'),
//               maxLines: 4,
//             ),
//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _pickImage,
//                     child: const Text('Upload Image'),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextFormField(
//                     controller: _imageUrlController,
//                     decoration: const InputDecoration(labelText: 'Or Image URL'),
//                   ),
//                 ),
//               ],
//             ),
//             if (_selectedImageFile != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8),
//                 child: Image.file(_selectedImageFile!, height: 100),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProviderDetailsSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Provider Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _providerNameController,
//               decoration: const InputDecoration(labelText: 'Provider Name*'),
//               validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _businessNameController,
//               decoration: const InputDecoration(labelText: 'Business/Brand Name'),
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _experienceController,
//               decoration: const InputDecoration(labelText: 'Experience (years)*'),
//               keyboardType: TextInputType.number,
//               validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             const Text('License/Certification (Optional)'),
//             ElevatedButton(
//               onPressed: _pickLicense,
//               child: const Text('Upload License'),
//             ),
//             if (_licenseFile != null)
//               Text('Selected: ${_licenseFile!.path.split('/').last}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAvailabilitySection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Availability & Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),

//             const Text('Available Days*'),
//             Wrap(
//               spacing: 8,
//               children: _availableDays.keys.map((day) {
//                 return FilterChip(
//                   label: Text(day),
//                   selected: _availableDays[day]!,
//                   onSelected: (selected) => setState(() => _availableDays[day] = selected),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 16),

//             const Text('Available Time*'),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () async {
//                       final time = await showTimePicker(
//                         context: context,
//                         initialTime: TimeOfDay.now(),
//                       );
//                       if (time != null) setState(() => _startTime = time);
//                     },
//                     child: Text(_startTime?.format(context) ?? 'Select Start Time'),
//                   ),
//                 ),
//                 const Text('to'),
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () async {
//                       final time = await showTimePicker(
//                         context: context,
//                         initialTime: TimeOfDay.now(),
//                       );
//                       if (time != null) setState(() => _endTime = time);
//                     },
//                     child: Text(_endTime?.format(context) ?? 'Select End Time'),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             SwitchListTile(
//               title: const Text('On-Site Service'),
//               value: _isOnSite,
//               onChanged: (value) => setState(() => _isOnSite = value),
//             ),

//             SwitchListTile(
//               title: const Text('Willing to Travel'),
//               value: _willingToTravel,
//               onChanged: (value) => setState(() => _willingToTravel = value),
//             ),

//             if (_willingToTravel)
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Travel Radius (km)'),
//                 keyboardType: TextInputType.number,
//                 initialValue: _travelRadius,
//                 onChanged: (value) => _travelRadius = value,
//               ),

//             const SizedBox(height: 16),
//             if (_currentLatitude != null && _currentLongitude != null)
//               Text('Location: ${_currentLatitude}, ${_currentLongitude}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPricingSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Pricing & Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),

//             DropdownButtonFormField<String>(
//               value: _priceType,
//               items: ['Fixed', 'Hourly', 'Per Visit'].map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) => setState(() => _priceType = value!),
//               decoration: const InputDecoration(labelText: 'Price Type*'),
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _basePriceController,
//               decoration: const InputDecoration(labelText: 'Base Price*'),
//               keyboardType: TextInputType.number,
//               validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _additionalChargesController,
//               decoration: const InputDecoration(labelText: 'Additional Charges'),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _discountController,
//               decoration: const InputDecoration(labelText: 'Discount/Offers'),
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _estimatedTimeController,
//               decoration: const InputDecoration(labelText: 'Estimated Time (hours)'),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 16),

//             const Text('Payment Methods Accepted'),
//             Wrap(
//               spacing: 8,
//               children: _paymentMethods.keys.map((method) {
//                 return FilterChip(
//                   label: Text(method),
//                   selected: _paymentMethods[method]!,
//                   onSelected: (selected) => setState(() => _paymentMethods[method] = selected),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContractSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Duration & Contract', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),

//             DropdownButtonFormField<String>(
//               value: _serviceType,
//               items: ['One-Time', 'Recurring', 'Contract-Based'].map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) => setState(() => _serviceType = value!),
//               decoration: const InputDecoration(labelText: 'Service Type*'),
//             ),
//             const SizedBox(height: 16),

//             if (_serviceType == 'Contract-Based')
//               Column(
//                 children: [
//                   TextFormField(
//                     controller: _contractStartController,
//                     decoration: const InputDecoration(labelText: 'Contract Start Date'),
//                     onTap: () async {
//                       final date = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime.now(),
//                         lastDate: DateTime(DateTime.now().year + 5),
//                       );
//                       if (date != null) {
//                         _contractStartController.text = "${date.day}/${date.month}/${date.year}";
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   TextFormField(
//                     controller: _contractEndController,
//                     decoration: const InputDecoration(labelText: 'Contract End Date'),
//                     onTap: () async {
//                       final date = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime.now(),
//                         lastDate: DateTime(DateTime.now().year + 5),
//                       );
//                       if (date != null) {
//                         _contractEndController.text = "${date.day}/${date.month}/${date.year}";
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),

//             SwitchListTile(
//               title: const Text('Advance Required'),
//               value: _advanceRequired,
//               onChanged: (value) => setState(() => _advanceRequired = value),
//             ),

//             if (_advanceRequired)
//               TextFormField(
//                 controller: _advanceAmountController,
//                 decoration: const InputDecoration(labelText: 'Advance Amount (%)'),
//                 keyboardType: TextInputType.number,
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMediaSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Media & Documentation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),

//             const Text('Service Images (Max 5)'),
//             ElevatedButton(
//               onPressed: _pickMultipleImages,
//               child: const Text('Add Images'),
//             ),
//             if (_serviceImages.isNotEmpty)
//               SizedBox(
//                 height: 100,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: _serviceImages.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(4),
//                       child: Image.file(_serviceImages[index], width: 100),
//                     );
//                   },
//                 ),
//               ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _videoUrlController,
//               decoration: const InputDecoration(labelText: 'Video URL (Optional)'),
//             ),
//             const SizedBox(height: 16),

//             const Text('ID Proof (Optional)'),
//             ElevatedButton(
//               onPressed: _pickIdProof,
//               child: const Text('Upload ID Proof'),
//             ),
//             if (_idProofFile != null)
//               Text('Selected: ${_idProofFile!.path.split('/').last}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAdvancedOptionsSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Advanced Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _tagsController,
//               decoration: const InputDecoration(labelText: 'Tags (comma separated)'),
//             ),
//             const SizedBox(height: 16),

//             const Text('Languages Spoken'),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _languageController,
//                     decoration: const InputDecoration(labelText: 'Add Language'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: () {
//                     if (_languageController.text.isNotEmpty) {
//                       setState(() {
//                         _languages.add(_languageController.text);
//                         _languageController.clear();
//                       });
//                     }
//                   },
//                 ),
//               ],
//             ),
//             if (_languages.isNotEmpty)
//               Wrap(
//                 spacing: 8,
//                 children: _languages.map((language) {
//                   return Chip(
//                     label: Text(language),
//                     onDeleted: () {
//                       setState(() => _languages.remove(language));
//                     },
//                   );
//                 }).toList(),
//               ),
//             const SizedBox(height: 16),

//             SwitchListTile(
//               title: const Text('Brings Own Tools'),
//               value: _bringsTools,
//               onChanged: (value) => setState(() => _bringsTools = value),
//             ),

//             if (!_bringsTools) // Changed condition to show if does not bring tools
//               TextFormField(
//                 controller: _toolsListController,
//                 decoration: const InputDecoration(labelText: 'Tools List (comma separated)'),
//               ),
//             const SizedBox(height: 16),

//             SwitchListTile(
//               title: const Text('Emergency Service Available'),
//               value: _emergencyService,
//               onChanged: (value) => setState(() => _emergencyService = value),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),

//             SwitchListTile(
//               title: const Text('Active Service'),
//               value: _isActive,
//               onChanged: (value) => setState(() => _isActive = value),
//             ),

//             SwitchListTile(
//               title: const Text('Verified Service'),
//               value: _isVerified,
//               onChanged: (value) => setState(() => _isVerified = value),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }









// class EditServicePage extends StatefulWidget {
//   final Map<String, dynamic> serviceData;

//   const EditServicePage({
//     super.key,
//     required this.serviceData,
//   });

//   @override
//   State<EditServicePage> createState() => _EditServicePageState();
// }

// class _EditServicePageState extends State<EditServicePage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final _formKey = GlobalKey<FormState>();

//   // Service Details
//   late TextEditingController _serviceNameController;
//   late TextEditingController _shortDescriptionController;
//   late TextEditingController _detailedDescriptionController;
//   File? _selectedImageFile; // For new image upload
//   late TextEditingController _imageUrlController; // For existing image URL or new URL input
//   late bool _isActive;
//   late bool _isVerified; // Assuming this might be part of serviceData for edit

//   // Categories (using the same structure as AddServicePage)
//   final Map<String, List<String>> _categorySubcategories = {
//     'Vehicle Services': ['Car service', 'Bike service', 'Auto repair', 'Towing services'],
//     'Home Services': ['AC repair', 'Plumbing', 'Carpentry', 'Electrician', 'Cleaning services', 'Pest control'],
//     'Contract-Based Services': ['Mason / Construction worker', 'Painter', 'Tile worker', 'Roofer', 'Laborer'],
//     'Additional Services': ['Salon at home', 'Massage', 'Personal tutor', 'Language trainer',
//       'Computer repair', 'Mobile repair', 'Decorators', 'Caterers',
//       'Tent and lighting', 'Pet grooming', 'Vet visits'],
//   };
//   late String _selectedCategory;
//   String? _selectedSubcategory;

//   // Provider Details (added these for consistency with AddServicePage)
//   late TextEditingController _providerNameController;
//   late TextEditingController _businessNameController;
//   late TextEditingController _experienceController;
//   File? _licenseFile;

//   // Availability & Location
//   late Map<String, bool> _availableDays;
//   TimeOfDay? _startTime;
//   TimeOfDay? _endTime;
//   late bool _isOnSite;
//   late bool _willingToTravel;
//   late String _travelRadius;
//   String? _currentLatitude;
//   String? _currentLongitude;

//   // Pricing & Payment
//   late String _priceType;
//   late TextEditingController _basePriceController;
//   late TextEditingController _additionalChargesController;
//   late TextEditingController _discountController;
//   late TextEditingController _estimatedTimeController;
//   late Map<String, bool> _paymentMethods;

//   // Duration & Contract
//   late String _serviceType;
//   late TextEditingController _contractStartController;
//   late TextEditingController _contractEndController;
//   late bool _advanceRequired;
//   late TextEditingController _advanceAmountController;

//   // Media & Documentation
//   final List<File> _serviceImages = []; // For newly picked images
//   late TextEditingController _videoUrlController;
//   File? _idProofFile; // For newly picked ID proof

//   // Advanced Options
//   late TextEditingController _tagsController;
//   late List<String> _languages;
//   final _languageController = TextEditingController(); // For adding new languages
//   late bool _bringsTools;
//   late TextEditingController _toolsListController;
//   late bool _emergencyService;


//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _initializeControllers();
//     _loadServiceData();
//     _getCurrentLocation();
//   }

//   void _initializeControllers() {
//     _serviceNameController = TextEditingController();
//     _shortDescriptionController = TextEditingController();
//     _detailedDescriptionController = TextEditingController();
//     _imageUrlController = TextEditingController();
//     _providerNameController = TextEditingController();
//     _businessNameController = TextEditingController();
//     _experienceController = TextEditingController();
//     _basePriceController = TextEditingController();
//     _additionalChargesController = TextEditingController();
//     _discountController = TextEditingController();
//     _estimatedTimeController = TextEditingController();
//     _contractStartController = TextEditingController();
//     _contractEndController = TextEditingController();
//     _advanceAmountController = TextEditingController();
//     _videoUrlController = TextEditingController();
//     _tagsController = TextEditingController();
//     _toolsListController = TextEditingController();
//   }

//   void _loadServiceData() {
//     // Service Details
//     _serviceNameController.text = widget.serviceData['serviceName'] ?? '';
//     _shortDescriptionController.text = widget.serviceData['shortDescription'] ?? '';
//     _detailedDescriptionController.text = widget.serviceData['detailedDescription'] ?? '';
//     _imageUrlController.text = widget.serviceData['imageUrl'] ?? '';
//     _isActive = widget.serviceData['isActive'] ?? true;
//     _isVerified = widget.serviceData['isVerified'] ?? false;

//     // Categories
//     _selectedCategory = widget.serviceData['category'] ?? _categorySubcategories.keys.first;
//     _selectedSubcategory = widget.serviceData['subcategory'];

//     // Provider Details
//     _providerNameController.text = widget.serviceData['providerName'] ?? '';
//     _businessNameController.text = widget.serviceData['businessName'] ?? '';
//     _experienceController.text = widget.serviceData['experience']?.toString() ?? '';

//     // Availability & Location
//     _availableDays = Map<String, bool>.from(widget.serviceData['availableDays'] != null
//         ? {for (var day in widget.serviceData['availableDays']) day: true}
//         : {
//             'Monday': false, 'Tuesday': false, 'Wednesday': false,
//             'Thursday': false, 'Friday': false, 'Saturday': false, 'Sunday': false,
//           }
//     );

//     // Parse TimeOfDay
//     if (widget.serviceData['startTime'] != null) {
//       final timeParts = widget.serviceData['startTime'].split(':');
//       _startTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
//     }
//     if (widget.serviceData['endTime'] != null) {
//       final timeParts = widget.serviceData['endTime'].split(':');
//       _endTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
//     }

//     _isOnSite = widget.serviceData['isOnSite'] ?? true;
//     _willingToTravel = widget.serviceData['willingToTravel'] ?? false;
//     _travelRadius = widget.serviceData['travelRadius']?.toString() ?? '5';
//     _currentLatitude = widget.serviceData['location']?['latitude'];
//     _currentLongitude = widget.serviceData['location']?['longitude'];


//     // Pricing & Payment
//     _priceType = widget.serviceData['priceType'] ?? 'Fixed';
//     _basePriceController.text = widget.serviceData['basePrice']?.toString() ?? '';
//     _additionalChargesController.text = widget.serviceData['additionalCharges']?.toString() ?? '';
//     _discountController.text = widget.serviceData['discount'] ?? '';
//     _estimatedTimeController.text = widget.serviceData['estimatedTime']?.toString() ?? '';
//     _paymentMethods = Map<String, bool>.from(widget.serviceData['paymentMethods'] != null
//         ? {for (var method in widget.serviceData['paymentMethods']) method: true}
//         : {
//             'Cash': false, 'UPI': false, 'Credit/Debit Card': false, 'Online Payment': false,
//           }
//     );

//     // Duration & Contract
//     _serviceType = widget.serviceData['serviceType'] ?? 'One-Time';
//     _contractStartController.text = widget.serviceData['contractStart'] ?? '';
//     _contractEndController.text = widget.serviceData['contractEnd'] ?? '';
//     _advanceRequired = widget.serviceData['advanceRequired'] ?? false;
//     _advanceAmountController.text = widget.serviceData['advanceAmount']?.toString() ?? '';

//     // Media & Documentation
//     _videoUrlController.text = widget.serviceData['videoUrl'] ?? '';
//     // Note: Handling existing image/license/idProof files would require more complex logic
//     // involving fetching from URL or having a path. For simplicity, we're not pre-populating File? objects.

//     // Advanced Options
//     _tagsController.text = widget.serviceData['tags']?.join(',') ?? '';
//     _languages = List<String>.from(widget.serviceData['languages'] ?? []);
//     _bringsTools = widget.serviceData['bringsTools'] ?? true;
//     _toolsListController.text = widget.serviceData['toolsList'] ?? '';
//     _emergencyService = widget.serviceData['emergencyService'] ?? false;
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _serviceNameController.dispose();
//     _shortDescriptionController.dispose();
//     _detailedDescriptionController.dispose();
//     _imageUrlController.dispose();
//     _providerNameController.dispose();
//     _businessNameController.dispose();
//     _experienceController.dispose();
//     _basePriceController.dispose();
//     _additionalChargesController.dispose();
//     _discountController.dispose();
//     _estimatedTimeController.dispose();
//     _contractStartController.dispose();
//     _contractEndController.dispose();
//     _advanceAmountController.dispose();
//     _videoUrlController.dispose();
//     _tagsController.dispose();
//     _languageController.dispose();
//     _toolsListController.dispose();
//     super.dispose();
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentLatitude = position.latitude.toString();
//         _currentLongitude = position.longitude.toString();
//       });
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _selectedImageFile = File(pickedFile.path);
//         _imageUrlController.clear(); // Clear URL if a new image is picked
//       });
//     }
//   }

//   Future<void> _pickMultipleImages() async {
//     final picker = ImagePicker();
//     final pickedFiles = await picker.pickMultiImage();

//     if (pickedFiles.isNotEmpty) {
//       setState(() {
//         _serviceImages.addAll(pickedFiles.map((file) => File(file.path)));
//       });
//     }
//   }

//   Future<void> _pickLicense() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() => _licenseFile = File(pickedFile.path));
//     }
//   }

//   Future<void> _pickIdProof() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _idProofFile = File(pickedFile.path);
//       });
//     }
//   }

//   void _updateService() {
//     if (_formKey.currentState!.validate()) {
//       final updatedServiceData = {
//         'serviceName': _serviceNameController.text,
//         'category': _selectedCategory,
//         'subcategory': _selectedSubcategory,
//         'shortDescription': _shortDescriptionController.text,
//         'detailedDescription': _detailedDescriptionController.text,
//         'imageUrl': _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
//         // For _selectedImageFile, you'd handle upload to storage and get URL
//         'providerName': _providerNameController.text,
//         'businessName': _businessNameController.text,
//         'experience': _experienceController.text,
//         // For _licenseFile, you'd handle upload to storage and get URL
//         'availableDays': _availableDays.entries.where((e) => e.value).map((e) => e.key).toList(),
//         'startTime': _startTime?.format(context),
//         'endTime': _endTime?.format(context),
//         'isOnSite': _isOnSite,
//         'willingToTravel': _willingToTravel,
//         'travelRadius': _travelRadius,
//         'location': {
//           'latitude': _currentLatitude,
//           'longitude': _currentLongitude,
//         },
//         'priceType': _priceType,
//         'basePrice': _basePriceController.text,
//         'additionalCharges': _additionalChargesController.text,
//         'discount': _discountController.text,
//         'estimatedTime': _estimatedTimeController.text,
//         'paymentMethods': _paymentMethods.entries.where((e) => e.value).map((e) => e.key).toList(),
//         'serviceType': _serviceType,
//         'contractStart': _contractStartController.text,
//         'contractEnd': _contractEndController.text,
//         'advanceRequired': _advanceRequired,
//         'advanceAmount': _advanceAmountController.text,
//         // For _serviceImages, you'd handle upload to storage and get URLs
//         // For _idProofFile, you'd handle upload to storage and get URL
//         'videoUrl': _videoUrlController.text,
//         'tags': _tagsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
//         'languages': _languages,
//         'bringsTools': _bringsTools,
//         'toolsList': _toolsListController.text,
//         'emergencyService': _emergencyService,
//         'isActive': _isActive,
//         'isVerified': _isVerified,
//       };

//       print(updatedServiceData); // Replace with actual update logic to your database/API

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Service updated successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//       Navigator.pop(context, true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundGrey,
//       appBar: AppBar(
//         title: const Text('Edit Service', style: AppTextStyles.headlineLarge),
//         backgroundColor: AppColors.primaryBlue,
//         foregroundColor: Colors.white,
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Details'),
//             Tab(text: 'Availability & Pricing'),
//             Tab(text: 'Advanced'),
//           ],
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: TabBarView(
//           controller: _tabController,
//           children: [
//             SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildServiceDetailsSection(),
//                   const SizedBox(height: 20),
//                   _buildProviderDetailsSection(),
//                 ],
//               ),
//             ),
//             SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildAvailabilitySection(),
//                   const SizedBox(height: 20),
//                   _buildPricingSection(),
//                   const SizedBox(height: 20),
//                   _buildContractSection(),
//                 ],
//               ),
//             ),
//             SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildMediaSection(),
//                   const SizedBox(height: 20),
//                   _buildAdvancedOptionsSection(),
//                   const SizedBox(height: 20),
//                   _buildStatusSection(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: _tabController.index != 2
//           ? FloatingActionButton(
//               onPressed: () {
//                 _tabController.animateTo(_tabController.index + 1);
//               },
//               child: const Icon(Icons.arrow_forward),
//             )
//           : FloatingActionButton( // Show update button on the last tab
//               onPressed: _updateService,
//               child: const Icon(Icons.check),
//             ),
//     );
//   }

//   Widget _buildServiceDetailsSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Service Details', style: AppTextStyles.headlineSmall),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _serviceNameController,
//               decoration: const InputDecoration(labelText: 'Service Name*', border: OutlineInputBorder()),
//               validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             DropdownButtonFormField<String>(
//               value: _selectedCategory,
//               items: _categorySubcategories.keys.map((category) {
//                 return DropdownMenuItem(
//                   value: category,
//                   child: Text(category),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedCategory = value!;
//                   _selectedSubcategory = null; // Reset subcategory when category changes
//                 });
//               },
//               decoration: const InputDecoration(labelText: 'Category*', border: OutlineInputBorder()),
//               validator: (value) => value == null ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             DropdownButtonFormField<String>(
//               value: _selectedSubcategory,
//               items: _categorySubcategories[_selectedCategory]?.map((subcategory) {
//                 return DropdownMenuItem(
//                   value: subcategory,
//                   child: Text(subcategory),
//                 );
//               }).toList(),
//               onChanged: (value) => setState(() => _selectedSubcategory = value),
//               decoration: const InputDecoration(labelText: 'Subcategory', border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _shortDescriptionController,
//               decoration: const InputDecoration(labelText: 'Short Description*', border: OutlineInputBorder()),
//               maxLines: 2,
//               validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _detailedDescriptionController,
//               decoration: const InputDecoration(labelText: 'Detailed Description', border: OutlineInputBorder()),
//               maxLines: 4,
//             ),
//             const SizedBox(height: 16),

//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _pickImage,
//                     child: const Text('Upload New Image'),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextFormField(
//                     controller: _imageUrlController,
//                     decoration: const InputDecoration(labelText: 'Or Image URL', border: OutlineInputBorder()),
//                   ),
//                 ),
//               ],
//             ),
//             if (_selectedImageFile != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8),
//                 child: Image.file(_selectedImageFile!, height: 100),
//               )
//             else if (_imageUrlController.text.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8),
//                 child: Image.network(_imageUrlController.text, height: 100, errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image)),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProviderDetailsSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Provider Details', style: AppTextStyles.headlineSmall),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _providerNameController,
//               decoration: const InputDecoration(labelText: 'Provider Name*', border: OutlineInputBorder()),
//               validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _businessNameController,
//               decoration: const InputDecoration(labelText: 'Business/Brand Name', border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _experienceController,
//               decoration: const InputDecoration(labelText: 'Experience (years)*', border: OutlineInputBorder()),
//               keyboardType: TextInputType.number,
//               validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             const Text('License/Certification (Optional)'),
//             ElevatedButton(
//               onPressed: _pickLicense,
//               child: const Text('Upload License'),
//             ),
//             if (_licenseFile != null)
//               Text('Selected: ${_licenseFile!.path.split('/').last}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAvailabilitySection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Availability & Location', style: AppTextStyles.headlineSmall),
//             const SizedBox(height: 16),

//             const Text('Available Days*'),
//             Wrap(
//               spacing: 8,
//               children: _availableDays.keys.map((day) {
//                 return FilterChip(
//                   label: Text(day),
//                   selected: _availableDays[day]!,
//                   onSelected: (selected) => setState(() => _availableDays[day] = selected),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 16),

//             const Text('Available Time*'),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () async {
//                       final time = await showTimePicker(
//                         context: context,
//                         initialTime: _startTime ?? TimeOfDay.now(),
//                       );
//                       if (time != null) setState(() => _startTime = time);
//                     },
//                     child: Text(_startTime?.format(context) ?? 'Select Start Time'),
//                   ),
//                 ),
//                 const Text('to'),
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () async {
//                       final time = await showTimePicker(
//                         context: context,
//                         initialTime: _endTime ?? TimeOfDay.now(),
//                       );
//                       if (time != null) setState(() => _endTime = time);
//                     },
//                     child: Text(_endTime?.format(context) ?? 'Select End Time'),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             SwitchListTile(
//               title: const Text('On-Site Service'),
//               value: _isOnSite,
//               onChanged: (value) => setState(() => _isOnSite = value),
//             ),

//             SwitchListTile(
//               title: const Text('Willing to Travel'),
//               value: _willingToTravel,
//               onChanged: (value) => setState(() => _willingToTravel = value),
//             ),

//             if (_willingToTravel)
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Travel Radius (km)', border: OutlineInputBorder()),
//                 keyboardType: TextInputType.number,
//                 initialValue: _travelRadius,
//                 onChanged: (value) => _travelRadius = value,
//               ),

//             const SizedBox(height: 16),
//             if (_currentLatitude != null && _currentLongitude != null)
//               Text('Current Location: Lat: ${_currentLatitude}, Long: ${_currentLongitude}'),
//             ElevatedButton(
//               onPressed: _getCurrentLocation,
//               child: const Text('Update Current Location'),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPricingSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Pricing & Payment', style: AppTextStyles.headlineSmall),
//             const SizedBox(height: 16),

//             DropdownButtonFormField<String>(
//               value: _priceType,
//               items: ['Fixed', 'Hourly', 'Per Visit'].map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) => setState(() => _priceType = value!),
//               decoration: const InputDecoration(labelText: 'Price Type*', border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _basePriceController,
//               decoration: const InputDecoration(labelText: 'Base Price*', border: OutlineInputBorder()),
//               keyboardType: TextInputType.number,
//               validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _additionalChargesController,
//               decoration: const InputDecoration(labelText: 'Additional Charges', border: OutlineInputBorder()),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _discountController,
//               decoration: const InputDecoration(labelText: 'Discount/Offers', border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _estimatedTimeController,
//               decoration: const InputDecoration(labelText: 'Estimated Time (hours)', border: OutlineInputBorder()),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 16),

//             const Text('Payment Methods Accepted'),
//             Wrap(
//               spacing: 8,
//               children: _paymentMethods.keys.map((method) {
//                 return FilterChip(
//                   label: Text(method),
//                   selected: _paymentMethods[method]!,
//                   onSelected: (selected) => setState(() => _paymentMethods[method] = selected),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContractSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Duration & Contract', style: AppTextStyles.headlineSmall),
//             const SizedBox(height: 16),

//             DropdownButtonFormField<String>(
//               value: _serviceType,
//               items: ['One-Time', 'Recurring', 'Contract-Based'].map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) => setState(() => _serviceType = value!),
//               decoration: const InputDecoration(labelText: 'Service Type*', border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 16),

//             if (_serviceType == 'Contract-Based')
//               Column(
//                 children: [
//                   TextFormField(
//                     controller: _contractStartController,
//                     decoration: const InputDecoration(labelText: 'Contract Start Date', border: OutlineInputBorder()),
//                     onTap: () async {
//                       final date = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.tryParse(_contractStartController.text.split('/').reversed.join('-')) ?? DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(DateTime.now().year + 5),
//                       );
//                       if (date != null) {
//                         _contractStartController.text = "${date.day}/${date.month}/${date.year}";
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   TextFormField(
//                     controller: _contractEndController,
//                     decoration: const InputDecoration(labelText: 'Contract End Date', border: OutlineInputBorder()),
//                     onTap: () async {
//                       final date = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.tryParse(_contractEndController.text.split('/').reversed.join('-')) ?? DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(DateTime.now().year + 5),
//                       );
//                       if (date != null) {
//                         _contractEndController.text = "${date.day}/${date.month}/${date.year}";
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),

//             SwitchListTile(
//               title: const Text('Advance Required'),
//               value: _advanceRequired,
//               onChanged: (value) => setState(() => _advanceRequired = value),
//             ),

//             if (_advanceRequired)
//               TextFormField(
//                 controller: _advanceAmountController,
//                 decoration: const InputDecoration(labelText: 'Advance Amount (%)', border: OutlineInputBorder()),
//                 keyboardType: TextInputType.number,
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMediaSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Media & Documentation', style: AppTextStyles.headlineSmall),
//             const SizedBox(height: 16),

//             const Text('Service Images (Max 5)'),
//             ElevatedButton(
//               onPressed: _pickMultipleImages,
//               child: const Text('Add Images'),
//             ),
//             if (_serviceImages.isNotEmpty) // Display newly added images
//               SizedBox(
//                 height: 100,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: _serviceImages.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(4),
//                       child: Image.file(_serviceImages[index], width: 100),
//                     );
//                   },
//                 ),
//               ),
//             // TODO: Add logic to display existing service images from serviceData if any
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _videoUrlController,
//               decoration: const InputDecoration(labelText: 'Video URL (Optional)', border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 16),

//             const Text('ID Proof (Optional)'),
//             ElevatedButton(
//               onPressed: _pickIdProof,
//               child: const Text('Upload ID Proof'),
//             ),
//             if (_idProofFile != null)
//               Text('Selected: ${_idProofFile!.path.split('/').last}'),
//             // TODO: Add logic to display existing ID proof from serviceData if any
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAdvancedOptionsSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Advanced Options', style: AppTextStyles.headlineSmall),
//             const SizedBox(height: 16),

//             TextFormField(
//               controller: _tagsController,
//               decoration: const InputDecoration(labelText: 'Tags (comma separated)', border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 16),

//             const Text('Languages Spoken'),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _languageController,
//                     decoration: const InputDecoration(labelText: 'Add Language', border: OutlineInputBorder()),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: () {
//                     if (_languageController.text.isNotEmpty) {
//                       setState(() {
//                         _languages.add(_languageController.text);
//                         _languageController.clear();
//                       });
//                     }
//                   },
//                 ),
//               ],
//             ),
//             if (_languages.isNotEmpty)
//               Wrap(
//                 spacing: 8,
//                 children: _languages.map((language) {
//                   return Chip(
//                     label: Text(language),
//                     onDeleted: () {
//                       setState(() => _languages.remove(language));
//                     },
//                   );
//                 }).toList(),
//               ),
//             const SizedBox(height: 16),

//             SwitchListTile(
//               title: const Text('Brings Own Tools'),
//               value: _bringsTools,
//               onChanged: (value) => setState(() => _bringsTools = value),
//             ),

//             if (!_bringsTools)
//               TextFormField(
//                 controller: _toolsListController,
//                 decoration: const InputDecoration(labelText: 'Tools List (comma separated)', border: OutlineInputBorder()),
//               ),
//             const SizedBox(height: 16),

//             SwitchListTile(
//               title: const Text('Emergency Service Available'),
//               value: _emergencyService,
//               onChanged: (value) => setState(() => _emergencyService = value),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusSection() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Status', style: AppTextStyles.headlineSmall),
//             const SizedBox(height: 16),

//             SwitchListTile(
//               title: const Text('Active Service'),
//               value: _isActive,
//               onChanged: (value) => setState(() => _isActive = value),
//             ),

//             SwitchListTile(
//               title: const Text('Verified Service'),
//               value: _isVerified,
//               onChanged: (value) => setState(() => _isVerified = value),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }