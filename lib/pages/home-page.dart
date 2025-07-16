// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:my_flutter_app/main.dart';
// import 'package:my_flutter_app/pages/ViewDealPage.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HomeScreen extends StatefulWidget {
//   final List<Deal> deals;

//   const HomeScreen({
//     super.key,
//     required this.deals,
//   });

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//   int _selectedRadius = 5;
//   String _selectedCategory = 'All';
//   bool _showMap = false;
//   String _sortBy = 'Distance';
//   Position? _currentPosition;
//   GoogleMapController? _mapController;
//   late TabController _tabController;
  
//   final List<int> _radiusOptions = [1, 2, 5, 10, 20];
//   final List<String> _categories = [
//     'All', 'Food & Dining', 'Shopping', 'Services', 'Electronics', 'Fashion', 'Health & Beauty'
//   ];
//   final List<String> _sortOptions = ['Distance', 'Rating', 'Price', 'Newest'];

//   // Urban Company style service categories
//   final List<Map<String, dynamic>> _serviceCategories = [
//     {'name': 'Salon at Home', 'icon': Icons.content_cut, 'color': Color(0xFF667EEA)},
//     {'name': 'Massage', 'icon': Icons.spa, 'color': Color(0xFF764BA2)},
//     {'name': 'Cleaning', 'icon': Icons.cleaning_services, 'color': Color(0xFF4F46E5)},
//     {'name': 'Appliance Repair', 'icon': Icons.build, 'color': Color(0xFF7C3AED)},
//     {'name': 'Painting', 'icon': Icons.format_paint, 'color': Color(0xFF3B82F6)},
//     {'name': 'Pest Control', 'icon': Icons.bug_report, 'color': Color(0xFF10B981)},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _getCurrentLocation();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
      
//       if (permission == LocationPermission.whileInUse || 
//           permission == LocationPermission.always) {
//         Position position = await Geolocator.getCurrentPosition();
//         setState(() {
//           _currentPosition = position;
//         });
//       }
//     } catch (e) {
//       print('Error getting location: $e');
//     }
//   }

//   List<Deal> get _filteredDeals {
//     List<Deal> filtered = widget.deals;
    
//     if (_selectedCategory != 'All') {
//       filtered = filtered.where((deal) => deal.category == _selectedCategory).toList();
//     }
    
//     return filtered;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildUrbanCompanyHeader(),
//             _buildServiceCategories(),
//             _buildTabBar(),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _buildDealsListView(),
//                   _buildMapView(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUrbanCompanyHeader() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Good Morning',
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         color: Colors.white,
//                         size: 16,
//                       ),
//                       const SizedBox(width: 4),
//                       const Text(
//                         'Bhopal, MP',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       Icon(
//                         Icons.keyboard_arrow_down,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(
//                       Icons.notifications_outlined,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   CircleAvatar(
//                     radius: 18,
//                     backgroundColor: Colors.white.withOpacity(0.2),
//                     child: const Icon(
//                       Icons.person_outline,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.white.withOpacity(0.3)),
//             ),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.percent,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 12),
//                 const Expanded(
//                   child: Text(
//                     'Up to 40% off on services today!',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Text(
//                     'VIEW ALL',
//                     style: TextStyle(
//                       color: Color(0xFF667EEA),
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }


// Widget _buildServiceCategories() {
//   return LayoutBuilder(
//     builder: (context, constraints) {
//       double screenWidth = constraints.maxWidth;
//       int columns = (screenWidth / 120).floor(); // 120 is approximate tile width
//       columns = columns.clamp(2, 6); // Min 2, Max 6 columns

//       return GridView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: _serviceCategories.length,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(), // let outer scroll view handle
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: columns,
//           crossAxisSpacing: 12,
//           mainAxisSpacing: 12,
//           childAspectRatio: 0.9,
//         ),
//         itemBuilder: (context, index) {
//           final service = _serviceCategories[index];
//           final isSelected = _selectedCategory == service['name'];

//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _selectedCategory = service['name'];
//               });
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: isSelected ? service['color'] : Colors.grey[300]!,
//                   width: isSelected ? 2 : 1,
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(service['icon'], color: service['color'], size: 30),
//                   const SizedBox(height: 8),
//                   Text(service['name'], textAlign: TextAlign.center),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }







//   Widget _buildTabBar() {
//     return Container(
//       margin: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TabBar(
//         controller: _tabController,
//         indicator: BoxDecoration(
//           color: const Color(0xFF667EEA),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         labelColor: Colors.white,
//         unselectedLabelColor: Colors.grey[600],
//         labelStyle: const TextStyle(fontWeight: FontWeight.w600),
//         tabs: const [
//           Tab(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.list, size: 18),
//                 SizedBox(width: 8),
//                 Text('Services'),
//               ],
//             ),
//           ),
//           Tab(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.map, size: 18),
//                 SizedBox(width: 8),
//                 Text('Map View'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDealsListView() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Available Services (${_filteredDeals.length})',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF10B981).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.circle,
//                       color: Color(0xFF10B981),
//                       size: 8,
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       'Live',
//                       style: TextStyle(
//                         color: Color(0xFF065F46),
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: _filteredDeals.isEmpty
//                 ? _buildEmptyState()
//                 : ListView.builder(
//                     itemCount: _filteredDeals.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 16),
//                         child: _buildUrbanCompanyDealCard(_filteredDeals[index]),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUrbanCompanyDealCard(Deal deal) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[200]!),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 160,
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//               gradient: LinearGradient(
//                 colors: [Colors.grey[200]!, Colors.grey[100]!],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Stack(
//               children: [
//                 Center(
//                   child: Icon(
//                     Icons.image,
//                     size: 40,
//                     color: Colors.grey[400],
//                   ),
//                 ),
//                 Positioned(
//                   top: 12,
//                   left: 12,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF667EEA),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: Text(
//                       '${deal.discountPercentage}% OFF',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 11,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 12,
//                   right: 12,
//                   child: GestureDetector(
//                     onTap: () => _openGoogleMaps(deal),
//                     child: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.directions,
//                         size: 18,
//                         color: Color(0xFF667EEA),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   deal.title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF1E293B),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   deal.description,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 13,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.store_outlined,
//                       size: 14,
//                       color: Colors.grey[600],
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       deal.vendorName,
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const Spacer(),
//                     Icon(
//                       Icons.location_on_outlined,
//                       size: 14,
//                       color: Colors.grey[600],
//                     ),
//                     const SizedBox(width: 2),
//                     Text(
//                       '${deal.distance} km',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               '₹${deal.originalPrice}',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey[500],
//                                 decoration: TextDecoration.lineThrough,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF10B981).withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Text(
//                                 '${deal.discountPercentage}% off',
//                                 style: const TextStyle(
//                                   color: Color(0xFF065F46),
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           '₹${deal.discountedPrice}',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1E293B),
//                           ),
//                         ),
//                       ],
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ViewDealPage(deal: deal),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF667EEA),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         elevation: 0,
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       ),
//                       child: const Text(
//                         'Book Now',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMapView() {
//     return Container(
//       margin: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: GoogleMap(
//           onMapCreated: (GoogleMapController controller) {
//             _mapController = controller;
//           },
//           initialCameraPosition: CameraPosition(
//             target: _currentPosition != null 
//                 ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
//                 : const LatLng(23.2599, 77.4126), // Bhopal coordinates
//             zoom: 14.0,
//           ),
//           markers: _createMarkers(),
//           mapType: MapType.normal,
//           myLocationEnabled: true,
//           myLocationButtonEnabled: true,
//           zoomControlsEnabled: false,
//           mapToolbarEnabled: false,
//           compassEnabled: true,
//           onTap: (LatLng position) {
//             _showNearbyServices(position);
//           },
//         ),
//       ),
//     );
//   }

//   Set<Marker> _createMarkers() {
//     Set<Marker> markers = {};
    
//     // Add current location marker
//     if (_currentPosition != null) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId('current_location'),
//           position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
//           infoWindow: const InfoWindow(title: 'Your Location'),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//         ),
//       );
//     }
    
//     // Add deal markers
//     markers.addAll(_filteredDeals.map((deal) {
//       return Marker(
//         markerId: MarkerId(deal.hashCode.toString()),
//         position: LatLng(deal.latitude, deal.longitude),
//         infoWindow: InfoWindow(
//           title: deal.title,
//           snippet: '₹${deal.discountedPrice} • ${deal.discountPercentage}% OFF',
//           onTap: () => _openGoogleMaps(deal),
//         ),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         onTap: () => _showDealBottomSheet(deal),
//       );
//     }).toSet());
    
//     return markers;
//   }

//   void _showDealBottomSheet(Deal deal) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.4,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               margin: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       deal.title,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       deal.description,
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Icon(Icons.store, color: Colors.grey[600], size: 16),
//                         const SizedBox(width: 8),
//                         Text(deal.vendorName),
//                         const Spacer(),
//                         Icon(Icons.location_on, color: Colors.grey[600], size: 16),
//                         const SizedBox(width: 4),
//                         Text('${deal.distance} km away'),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Text(
//                           '₹${deal.discountedPrice}',
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF059669),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           '₹${deal.originalPrice}',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[500],
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Spacer(),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton.icon(
//                             onPressed: () => _openGoogleMaps(deal),
//                             icon: const Icon(Icons.directions),
//                             label: const Text('Get Directions'),
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: const Color(0xFF667EEA),
//                               side: const BorderSide(color: Color(0xFF667EEA)),
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ViewDealPage(deal: deal),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF667EEA),
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: const Text('Book Now'),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showNearbyServices(LatLng position) {
//     // Show nearby services when map is tapped
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Services near this location',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Lat: ${position.latitude.toStringAsFixed(4)}, '
//               'Lng: ${position.longitude.toStringAsFixed(4)}',
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF667EEA),
//                 minimumSize: const Size(double.infinity, 48),
//               ),
//               child: const Text('Search Here'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _openGoogleMaps(Deal deal) async {
//     if (_currentPosition != null) {
//       final String url = 'https://www.google.com/maps/dir/'
//           '${_currentPosition!.latitude},${_currentPosition!.longitude}/'
//           '${deal.latitude},${deal.longitude}';
      
//       if (await canLaunch(url)) {
//         await launch(url);
//       } else {
//         // Fallback to showing directions in a dialog
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Directions'),
//             content: Text('Navigate to ${deal.vendorName}'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Close'),
//               ),
//             ],
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Location permission required for directions'),
//           backgroundColor: Color(0xFF667EEA),
//         ),
//       );
//     }
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(32),
//             decoration: BoxDecoration(
//               color: const Color(0xFF667EEA).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.search_off,
//               size: 64,
//               color: Color(0xFF667EEA),
//             ),
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'No services found',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF475569),
//             ),
//           ),
//           const SizedBox(height: 8),
//                       Text(
//             'Try adjusting your filters or search in a different area',
//             style: TextStyle(
//               color: Colors.grey[600],
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Additional required classes and models

