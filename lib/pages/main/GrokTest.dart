// lib/config/app_colors.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_flutter_app/pages/bidpost/BidPostScreen.dart';
import 'package:my_flutter_app/pages/bidpost/post-service.dart';
import 'package:particles_flutter/particles_flutter.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryBlueDark = Color(0xFF1E40AF);
  static const Color primaryBlueLight = Color(0xFF3B82F6);
  
  // Secondary Colors
  static const Color secondaryOrange = Color(0xFFF59E0B);
  static const Color secondaryOrangeLight = Color(0xFFFBBF24);
  static const Color secondaryGreen = Color(0xFF10B981);
  static const Color secondaryRed = Color(0xFFEF4444);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);
  
  // Background Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF1F5F9);
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

// lib/models/service_list.dart
class ServiceList {
  final String id;
  final String title;
  final String descriptionSnippet;
  final String? imageUrl;
  final String partnerName;
  final double amount;
  final double latitude;
  final double longitude;
  final String? serviceAddress;
  final String category;

  ServiceList({
    required this.id,
    required this.title,
    required this.descriptionSnippet,
    this.imageUrl,
    required this.partnerName,
    required this.amount,
    required this.latitude,
    required this.longitude,
    this.serviceAddress,
    required this.category,
  });
}

// lib/models/service_request_dto.dart
enum ServiceRequestStatus { pending, active, completed, cancelled }
enum BudgetType { fixed, hourly, negotiable }
enum UrgencyLevel { low, medium, high, urgent }

class ServiceRequestDto {
  final int id;
  final CategoryDto category;
  final String title;
  final String description;
  final ServiceRequestStatus status;
  final int serviceRadiusKm;
  final double latitude;
  final double longitude;
  final String serviceAddress;
  final double budgetMin;
  final double budgetMax;
  final BudgetType budgetType;
  final DateTime? preferredDate;
  final DateTime? preferredTime;
  final bool isFlexibleTiming;
  final UrgencyLevel urgencyLevel;
  final DateTime biddingExpiresAt;
  final DateTime createdAt;
  final Map<String, dynamic> serviceData;
  final RequirementDataDto requirements;

  ServiceRequestDto({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.status,
    required this.serviceRadiusKm,
    required this.latitude,
    required this.longitude,
    required this.serviceAddress,
    required this.budgetMin,
    required this.budgetMax,
    required this.budgetType,
    this.preferredDate,
    this.preferredTime,
    required this.isFlexibleTiming,
    required this.urgencyLevel,
    required this.biddingExpiresAt,
    required this.createdAt,
    required this.serviceData,
    required this.requirements,
  });
}

class CategoryDto {
  final String id;
  final String name;
  final String icon;
  final String description;

  CategoryDto({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}

class RequirementDataDto {
  final List<String> skills;
  final List<String> materials;
  final String experience;

  RequirementDataDto({
    required this.skills,
    required this.materials,
    required this.experience,
  });
}



class ServiceService {
  // Mock categories
  static List<CategoryDto> getCategories() {
    return [
      CategoryDto(id: '1', name: 'Plumbing', icon: '🔧', description: 'Plumbing services'),
      CategoryDto(id: '2', name: 'Electrical', icon: '⚡', description: 'Electrical services'),
      CategoryDto(id: '3', name: 'Carpentry', icon: '🔨', description: 'Carpentry services'),
      CategoryDto(id: '4', name: 'Painting', icon: '🎨', description: 'Painting services'),
      CategoryDto(id: '5', name: 'Cleaning', icon: '🧹', description: 'Cleaning services'),
      CategoryDto(id: '6', name: 'Gardening', icon: '🌱', description: 'Gardening services'),
      CategoryDto(id: '7', name: 'AC Repair', icon: '❄️', description: 'AC repair services'),
      CategoryDto(id: '8', name: 'Masonry', icon: '🧱', description: 'Masonry services'),
    ];
  }

  // Mock service listings
  static List<ServiceList> getServiceListings({String? category}) {
    final Random random = Random();
    final List<ServiceList> mockServices = [
      ServiceList(
        id: '1',
        title: 'Need a skilled plumber for kitchen sink repair',
        descriptionSnippet: 'Kitchen sink is leaking and needs immediate repair. Looking for experienced plumber...',
        imageUrl: null,
        partnerName: 'John Doe',
        amount: 2500.0,
        latitude: 23.2599 + random.nextDouble() * 0.1,
        longitude: 77.4126 + random.nextDouble() * 0.1,
        serviceAddress: 'New Market, Bhopal',
        category: 'Plumbing',
      ),
      ServiceList(
        id: '2',
        title: 'Electrical wiring for new home',
        descriptionSnippet: 'Complete electrical wiring needed for 3BHK apartment. Professional electrician required...',
        imageUrl: null,
        partnerName: 'Sarah Wilson',
        amount: 15000.0,
        latitude: 23.2599 + random.nextDouble() * 0.1,
        longitude: 77.4126 + random.nextDouble() * 0.1,
        serviceAddress: 'MP Nagar, Bhopal',
        category: 'Electrical',
      ),
      ServiceList(
        id: '3',
        title: 'Custom furniture making required',
        descriptionSnippet: 'Need a carpenter to make custom wardrobe and study table. High quality wood preferred...',
        imageUrl: null,
        partnerName: 'Mike Johnson',
        amount: 25000.0,
        latitude: 23.2599 + random.nextDouble() * 0.1,
        longitude: 77.4126 + random.nextDouble() * 0.1,
        serviceAddress: 'Arera Colony, Bhopal',
        category: 'Carpentry',
      ),
      ServiceList(
        id: '4',
        title: 'House painting - interior and exterior',
        descriptionSnippet: 'Complete house painting service needed. Both interior and exterior walls...',
        imageUrl: null,
        partnerName: 'David Brown',
        amount: 18000.0,
        latitude: 23.2599 + random.nextDouble() * 0.1,
        longitude: 77.4126 + random.nextDouble() * 0.1,
        serviceAddress: 'Berasia Road, Bhopal',
        category: 'Painting',
      ),
      ServiceList(
        id: '5',
        title: 'Deep cleaning service for office',
        descriptionSnippet: 'Professional deep cleaning required for 2000 sq ft office space...',
        imageUrl: null,
        partnerName: 'Emily Davis',
        amount: 5000.0,
        latitude: 23.2599 + random.nextDouble() * 0.1,
        longitude: 77.4126 + random.nextDouble() * 0.1,
        serviceAddress: 'TT Nagar, Bhopal',
        category: 'Cleaning',
      ),
      ServiceList(
        id: '6',
        title: 'Garden landscaping and maintenance',
        descriptionSnippet: 'Complete garden makeover with plants, lawn, and regular maintenance...',
        imageUrl: null,
        partnerName: 'Robert Wilson',
        amount: 12000.0,
        latitude: 23.2599 + random.nextDouble() * 0.1,
        longitude: 77.4126 + random.nextDouble() * 0.1,
        serviceAddress: 'Shahpura, Bhopal',
        category: 'Gardening',
      ),
      ServiceList(
        id: '7',
        title: 'AC installation and repair',
        descriptionSnippet: 'Split AC installation required with maintenance contract...',
        imageUrl: null,
        partnerName: 'Tom Anderson',
        amount: 8000.0,
        latitude: 23.2599 + random.nextDouble() * 0.1,
        longitude: 77.4126 + random.nextDouble() * 0.1,
        serviceAddress: 'Kolar Road, Bhopal',
        category: 'AC Repair',
      ),
      ServiceList(
        id: '8',
        title: 'Brick work and masonry',
        descriptionSnippet: 'Construction work - brick laying and masonry for boundary wall...',
        imageUrl: null,
        partnerName: 'James Miller',
        amount: 35000.0,
        latitude: 23.2599 + random.nextDouble() * 0.1,
        longitude: 77.4126 + random.nextDouble() * 0.1,
        serviceAddress: 'Habibganj, Bhopal',
        category: 'Masonry',
      ),
    ];

    if (category != null && category.isNotEmpty) {
      return mockServices.where((service) => service.category == category).toList();
    }
    return mockServices;
  }

  // Mock service detail
  static ServiceRequestDto getServiceDetail(String id) {
    return ServiceRequestDto(
      id: int.parse(id),
      category: CategoryDto(id: '1', name: 'Plumbing', icon: '🔧', description: 'Plumbing services'),
      title: 'Need a skilled plumber for kitchen sink repair',
      description: 'I need an experienced plumber to fix my kitchen sink. The sink has been leaking for the past week and it\'s getting worse. The leak appears to be coming from the pipes underneath the sink. I need someone who can diagnose the problem and fix it properly.\n\nRequirements:\n- Must have experience with kitchen sink repairs\n- Should bring necessary tools and equipment\n- Available for emergency repairs\n- Preferably someone who can provide warranty on the work',
      status: ServiceRequestStatus.pending,
      serviceRadiusKm: 10,
      latitude: 23.2599,
      longitude: 77.4126,
      serviceAddress: 'New Market, Bhopal, Madhya Pradesh',
      budgetMin: 2000.0,
      budgetMax: 3000.0,
      budgetType: BudgetType.fixed,
      preferredDate: DateTime.now().add(const Duration(days: 2)),
      preferredTime: DateTime.now().add(const Duration(hours: 2)),
      isFlexibleTiming: true,
      urgencyLevel: UrgencyLevel.high,
      biddingExpiresAt: DateTime.now().add(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      serviceData: {
        'images': ['https://example.com/sink1.jpg', 'https://example.com/sink2.jpg'],
        'additionalNotes': 'Please contact before coming',
      },
      requirements: RequirementDataDto(
        skills: ['Plumbing', 'Pipe fitting', 'Leak detection'],
        materials: ['Pipes', 'Sealants', 'Fittings'],
        experience: '5+ years',
      ),
    );
  }
}


class CategoryChip extends StatelessWidget {
  final String name;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    Key? key,
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.gray200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? AppColors.primaryBlue.withOpacity(0.2) : AppColors.gray200.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.gray700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/widgets/service_card.dart

class ServiceCard extends StatelessWidget {
  final ServiceList service;
  final VoidCallback onTap;
  final int index;

  const ServiceCard({
    Key? key,
    required this.service,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gray200, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gray300.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              _getCategoryIcon(service.category),
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.gray800,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                service.partnerName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '₹${service.amount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      service.descriptionSnippet,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.gray600,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.gray500,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            service.serviceAddress ?? 'Location not specified',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.gray500,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            service.category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'Plumbing':
        return '🔧';
      case 'Electrical':
        return '⚡';
      case 'Carpentry':
        return '🔨';
      case 'Painting':
        return '🎨';
      case 'Cleaning':
        return '🧹';
      case 'Gardening':
        return '🌱';
      case 'AC Repair':
        return '❄️';
      case 'Masonry':
        return '🧱';
      default:
        return '🔧';
    }
  }
}

// lib/screens/service_list_screen.dart

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({Key? key}) : super(key: key);

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  String selectedCategory = '';
  List<ServiceList> services = [];
  List<CategoryDto> categories = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    categories = ServiceService.getCategories();
    services = ServiceService.getServiceListings();
  }

  void _filterServices(String category) {
    setState(() {
      selectedCategory = category;
      if (category.isEmpty) {
        services = ServiceService.getServiceListings();
      } else {
        services = ServiceService.getServiceListings(category: category);
      }
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.background,
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.primaryBlue,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Stack(
                children: [
                  CircularParticle(
                    numberOfParticles: 50,
                    speedOfParticles: 1,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    onTapAnimation: false,
                    particleColor: AppColors.white.withOpacity(0.1),
                    awayRadius: 80,
                    maxParticleSize: 8,
                    isRandSize: true,
                    isRandomColor: false,
                    connectDots: false,
                  ),
                  Positioned(
                    bottom: 60,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Find Services',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Connect with skilled professionals',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search services...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.gray500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryBlue),
                  ),
                  filled: true,
                  fillColor: AppColors.gray50,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray800,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategoryChip(
                        name: 'All',
                        icon: '🔍',
                        isSelected: selectedCategory.isEmpty,
                        onTap: () => _filterServices(''),
                      ),
                      ...categories.map((category) => CategoryChip(
                        name: category.name,
                        icon: category.icon,
                        isSelected: selectedCategory == category.name,
                        onTap: () => _filterServices(category.name),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Available Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gray800,
                      ),
                    ),
                    Text(
                      '${services.length} services',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Service Requirement Button
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostServicePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: AppColors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 24,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Post Service Requirement',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ServiceCard(
                  service: services[index],
                  index: index,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceRequestDtoDetailsScreen(serviceId: services[index].id),
                      ),
                    );
                  },
                ),
              );
            },
            childCount: services.length,
          ),
        ),
      ],
    ),
  );
}
}

