import 'package:flutter/material.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/main.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';




class Offer {
  final String id;
  final String title;
  final String description;
  final String discount;
  final String originalPrice;
  final String discountedPrice;
  final String validUntil;
  final bool isBestOffer;

  Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.discount,
    required this.originalPrice,
    required this.discountedPrice,
    required this.validUntil,
    this.isBestOffer = false,
  });
}

class Vendor {
  final String id;
  final String name;
  final String distance;
  final double rating;
  final int reviewCount;
  final String specialty;
  final String imageUrl;
  final bool isVerified;
  final List<String> servicesProvided;

  Vendor({
    required this.id,
    required this.name,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.specialty,
    required this.imageUrl,
    this.isVerified = false,
    required this.servicesProvided,
  });
}

// Mock Data
class MockData {
  static List<OfferingServiceDTO> offerings = [
    OfferingServiceDTO(
      id: '1',
      offeringCode: 'BIKE-SER-001',
      title: 'Bike Service',
      description: 'Professional bike servicing including oil change, brake check, and full inspection',
      category: ServiceCategoryDto(id: 'id', name: 'name'),
      status: 'ACTIVE',
      verified: true,
      timing: ServiceTiming(
        durationMinutes: 480, // 8 hours in minutes
        estimatedCompletion: null,
        availableDays: ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'],
        startTime: null,
        endTime: null,
        emergencyService: false,
      ),
      geography: ServiceGeography(
        latitude: 19.0760,
        longitude: 72.8777,
        serviceArea: 'Mumbai',
      ),
      tags: {'bike', 'service', 'maintenance'},
      primaryPricing: OfferingPricingDTO(
        basePrice: MoneyDTO(amount: 25.0, currency: 'USD'),
        type: PricingType.FIXED,
      ),
      mediaItems: [
        OfferingMediaDTO(
          mediaUrl: 'https://via.placeholder.com/200x120/1E88E5/FFFFFF?text=Bike+Service',
          mediaType: 'IMAGE',
          displayOrder: 1,
        ),
      ],
    ),
    OfferingServiceDTO(
      id: '2',
      offeringCode: 'BIKE-WASH-001',
      title: 'Bike Wash',
      description: 'Complete bike washing and polishing service',
      category: ServiceCategoryDto(id: 'id', name: 'name'),
      status: 'ACTIVE',
      verified: true,
      timing: ServiceTiming(
        durationMinutes: 480, // 8 hours in minutes
        estimatedCompletion: null,
        availableDays: ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'],
        startTime: null,
        endTime: null,
        emergencyService: false,
      ),
      geography: ServiceGeography(
        latitude: 19.0760,
        longitude: 72.8777,
        serviceArea: 'Mumbai',
      ),
      tags: {'bike', 'wash', 'cleaning'},
      primaryPricing: OfferingPricingDTO(
        basePrice: MoneyDTO(amount: 25.0, currency: 'USD'),
        type: PricingType.FIXED,
      ),
      mediaItems: [
        OfferingMediaDTO(
          mediaUrl: 'https://via.placeholder.com/200x120/4CAF50/FFFFFF?text=Bike+Wash',
          mediaType: 'IMAGE',
          displayOrder: 1,
        ),
      ],
    ),
    OfferingServiceDTO(
      id: '3',
      offeringCode: 'BIKE-REP-001',
      title: 'Bike Repair',
      description: 'All types of bike repair services',
      category: ServiceCategoryDto(id: 'id', name: 'name'),
      status: 'ACTIVE',
      verified: true,
      timing: ServiceTiming(
        durationMinutes: 480, // 8 hours in minutes
        estimatedCompletion: null,
        availableDays: ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'],
        startTime: null,
        endTime: null,
        emergencyService: false,
      ),
      geography: ServiceGeography(
        latitude: 19.0760,
        longitude: 72.8777,
        serviceArea: 'Mumbai',
      ),
      tags: {'bike', 'repair', 'maintenance'},
      primaryPricing: OfferingPricingDTO(
        basePrice: MoneyDTO(amount: 25.0, currency: 'USD'),
        type: PricingType.FIXED,
      ),
      mediaItems: [
        OfferingMediaDTO(
          mediaUrl: 'https://via.placeholder.com/200x120/F9A825/FFFFFF?text=Bike+Repair',
          mediaType: 'IMAGE',
          displayOrder: 1,
        ),
      ],
    ),
    OfferingServiceDTO(
      id: '4',
      offeringCode: 'BIKE-ACC-001',
      title: 'Bike Accessories',
      description: 'Bike accessories installation and sales',
      category: ServiceCategoryDto(id: 'id', name: 'name'),
      status: 'ACTIVE',
      verified: true,
      timing: ServiceTiming(
        durationMinutes: 480, // 8 hours in minutes
        estimatedCompletion: null,
        availableDays: ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'],
        startTime: null,
        endTime: null,
        emergencyService: false,
      ),
      geography: ServiceGeography(
        latitude: 19.0760,
        longitude: 72.8777,
        serviceArea: 'Mumbai',
      ),
      tags: {'bike', 'accessories', 'parts'},
      primaryPricing: OfferingPricingDTO(
        basePrice: MoneyDTO(amount: 25.0, currency: 'USD'),
        type: PricingType.FIXED,
      ),
      mediaItems: [
        OfferingMediaDTO(
          mediaUrl: 'https://via.placeholder.com/200x120/E53935/FFFFFF?text=Accessories',
          mediaType: 'IMAGE',
          displayOrder: 1,
        ),
      ],
    ),
  ];

  static List<Offer> getOffersForOffering(String offeringId) {
    if (offeringId == '1') {
      return [
        Offer(
          id: '1',
          title: 'Bike Service Package',
          description: 'Complete bike servicing with free inspection',
          discount: '25% OFF',
          originalPrice: '₹1,200',
          discountedPrice: '₹900',
          validUntil: 'Valid till 30 June',
          isBestOffer: true,
        ),
        Offer(
          id: '2',
          title: 'Premium Bike Service',
          description: 'Premium servicing with synthetic oil and parts check',
          discount: '15% OFF',
          originalPrice: '₹1,800',
          discountedPrice: '₹1,530',
          validUntil: 'Valid till 15 July',
        ),
      ];
    }
    return [];
  }

  static List<Vendor> getVendorsForOffering(String offeringId) {
    return [
      Vendor(
        id: '1',
        name: 'Speedy Bike Services',
        distance: '0.8 km away',
        rating: 4.9,
        reviewCount: 245,
        specialty: 'Bike Service Expert',
        imageUrl: 'https://via.placeholder.com/60x60/1E88E5/FFFFFF?text=SB',
        isVerified: true,
        servicesProvided: ['1', '2', '3'],
      ),
      Vendor(
        id: '2',
        name: 'Pro Bike Care',
        distance: '1.5 km away',
        rating: 4.7,
        reviewCount: 182,
        specialty: 'All Bike Services',
        imageUrl: 'https://via.placeholder.com/60x60/4CAF50/FFFFFF?text=PB',
        isVerified: true,
        servicesProvided: ['1', '2', '3', '4'],
      ),
      Vendor(
        id: '3',
        name: 'Quick Bike Fix',
        distance: '2.2 km away',
        rating: 4.5,
        reviewCount: 97,
        specialty: 'Emergency Repairs',
        imageUrl: 'https://via.placeholder.com/60x60/F9A825/FFFFFF?text=QF',
        servicesProvided: ['1', '3'],
      ),
    ];
  }

  static OfferingServiceDTO? getOfferingById(String id) {
    try {
      return offerings.firstWhere((offering) => offering.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<OfferingServiceDTO> getSimilarOfferings(String offeringId) {
    final currentOffering = getOfferingById(offeringId);
    if (currentOffering == null) return [];
    
    return offerings.where((offering) => 
      offering.id != offeringId && 
      offering.category.name.split('+').first == currentOffering.category.name.split('+').first
    ).toList();
  }

  static OfferingServiceDTO? getServiceById(String serviceId) {
    try {
      return offerings.firstWhere(
        (offering) => offering.id == serviceId,
      );
    } catch (e) {
      return null; // Return null if no offering is found
    }
  }
}

// Service Detail Screen
class ServiceDetailScreen extends StatefulWidget {
  final OfferingServiceDTO service;

  const ServiceDetailScreen({Key? key, required this.service}) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  List<Offer> offers = [];
  List<Vendor> vendors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        offers = MockData.getOffersForOffering(widget.service.id);
        vendors = MockData.getVendorsForOffering(widget.service.id);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          if (isLoading) _buildLoadingState(),
          if (!isLoading) ...[
            _buildServiceInfo(),
            if (offers.isNotEmpty) _buildOffersSection(),
            _buildVendorsSection(),
            _buildSimilarServicesSection(),
          ],
        ],
      ),
    );
  }

 Widget _buildAppBar(BuildContext context) {
  return SliverAppBar(
    expandedHeight: 200,
    pinned: true,
    backgroundColor: AppTheme.cardBackground,
    elevation: 0,
    leading: IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.arrow_back_ios, size: 18, color: AppTheme.textDark),
      ),
      onPressed: () => Navigator.pop(context),
    ),
    flexibleSpace: FlexibleSpaceBar(
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryBlue.withOpacity(0.1),
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.service.mediaItems.isNotEmpty 
                    ? widget.service.mediaItems.first.mediaUrl
                    : 'https://via.placeholder.com/200x120/1E88E5/FFFFFF?text=${Uri.encodeComponent(widget.service.title)}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppTheme.primaryBlue,
                  child: Icon(
                    _getCategoryIcon(widget.service.category.name),
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

IconData _getCategoryIcon(String category) {
  if (category.contains('bike')) {
    return Icons.pedal_bike;
  } else if (category.contains('car')) {
    return Icons.directions_car;
  } else if (category.contains('home')) {
    return Icons.home;
  } else if (category.contains('repair')) {
    return Icons.build;
  }
  return Icons.category;
}

  Widget _buildLoadingState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.primaryBlue),
            const SizedBox(height: 16),
            Text('Loading service details...', style: AppTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceInfo() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.service.title, style: AppTheme.headlineMedium),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.service.category.name,
                style: AppTheme.caption.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(widget.service.description, style: AppTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.local_offer, color: AppTheme.accentOrange, size: 24),
                const SizedBox(width: 8),
                Text('Best Offers Available', style: AppTheme.headlineSmall),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...offers.map((offer) => _buildOfferCard(offer)).toList(),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Offer offer) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: offer.isBestOffer 
            ? Border.all(color: AppTheme.accentOrange, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (offer.isBestOffer)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'BEST OFFER',
                  style: AppTheme.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (offer.isBestOffer) const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(offer.title, style: AppTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(offer.description, style: AppTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Text(offer.validUntil, style: AppTheme.caption),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        offer.discount,
                        style: AppTheme.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      offer.originalPrice,
                      style: AppTheme.bodyMedium.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: AppTheme.textLight,
                      ),
                    ),
                    Text(offer.discountedPrice, style: AppTheme.headlineSmall),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle book offer
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Book This Offer', style: AppTheme.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorsSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'Service Providers for ${widget.service.title}',
              style: AppTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (vendors.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'No vendors available for this service at the moment',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.textLight),
              ),
            ),
          if (vendors.isNotEmpty)
            ...vendors.map((vendor) => _buildVendorCard(vendor)).toList(),
        ],
      ),
    );
  }

  Widget _buildVendorCard(Vendor vendor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      vendor.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppTheme.primaryBlue,
                        child: const Icon(Icons.person, color: Colors.white, size: 30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(vendor.name, style: AppTheme.headlineSmall),
                          if (vendor.isVerified) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.verified, color: AppTheme.successColor, size: 16),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(vendor.specialty, style: AppTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: AppTheme.successColor, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${vendor.rating} (${vendor.reviewCount})',
                                  style: AppTheme.caption.copyWith(
                                    color: AppTheme.successColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.location_on, color: AppTheme.textLight, size: 14),
                          const SizedBox(width: 4),
                          Text(vendor.distance, style: AppTheme.caption),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Vendor services
          if (vendor.servicesProvided.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Services Provided:',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: vendor.servicesProvided.map((serviceId) {
                      final service = MockData.getServiceById(serviceId);
                      if (service == null) return const SizedBox();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceDetailScreen(service: service),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            service.title,
                            style: AppTheme.caption.copyWith(
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle book now
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Book Now', style: AppTheme.buttonText),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle view profile
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.primaryBlue),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'View Profile',
                      style: AppTheme.buttonText.copyWith(
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


Widget _buildSimilarServicesSection() {
  // Temporary hardcoded similar offerings IDs - will be replaced with API call
  final List<String> hardcodedSimilarOfferings = [
    '1', // Bike Service
    '2', // Bike Wash
    '3', // Bike Repair
  ];

  // Get similar offerings from mock data
  final similarOfferings = hardcodedSimilarOfferings
      .map((id) => MockData.getOfferingById(id))
      .whereType<OfferingServiceDTO>() // Filters out null values
      .toList();

  if (similarOfferings.isEmpty) return const SliverToBoxAdapter();

  return SliverToBoxAdapter(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Similar Services',
            style: AppTheme.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: similarOfferings.length,
            itemBuilder: (context, index) {
              final offering = similarOfferings[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceDetailScreen(service: offering),
                    ),
                  );
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: offering.mediaItems.isNotEmpty
                            ? Image.network(
                                offering.mediaItems.first.mediaUrl,
                                height: 80,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => 
                                    _buildPlaceholderImage(),
                              )
                            : _buildPlaceholderImage(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          offering.title,
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    ),
  );
}

Widget _buildPlaceholderImage() {
  return Container(
    color: AppTheme.primaryBlue,
    height: 80,
    child: const Center(
      child: Icon(Icons.build, color: Colors.white, size: 40),
    ),
  );
}
}

