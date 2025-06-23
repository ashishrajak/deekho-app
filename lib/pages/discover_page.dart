



import 'package:flutter/material.dart';
import 'package:my_flutter_app/main.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/pages/StoreDetailPage.dart';
import 'package:my_flutter_app/pages/product-detail-page.dart';
import 'package:my_flutter_app/pages/service-detail.dart';


// Design System - Colors



// Main Discover Page
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // Dummy Data
  final List<Map<String, dynamic>> offersList = [
    {
      "id": 1,
      "title": "50% OFF",
      "subtitle": "First Order",
      "description": "On services above ₹500",
      "color": AppColors.accentOrange,
    },
    {
      "id": 2,
      "title": "30% OFF",
      "subtitle": "Electronics",
      "description": "On selected items",
      "color": AppColors.primaryBlue,
    },
    {
      "id": 3,
      "title": "Buy 2 Get 1",
      "subtitle": "Groceries",
      "description": "On household items",
      "color": AppColors.accentGreen,
    },
  ];

final List<OfferingServiceDTO> servicesList = [
 
    OfferingServiceDTO(
      id: '1',
      offeringCode: 'BIKE-001',
      title: 'Bike Repair & Maintenance',
      description: 'Professional bike repair and maintenance services',
      category: 'vehicle_service+bike+repair',
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
          mediaUrl: 'https://example.com/bike.jpg',
          mediaType: 'IMAGE',
          displayOrder: 1,
        ),
      ],
    ),
    OfferingServiceDTO(
      id: '2',
      offeringCode: 'AC-001',
      title: 'AC Installation & Service',
      description: 'AC installation, repair and maintenance services',
      category: 'home_service+ac+repair',
      status: 'INACTIVE',
      verified: false,
      timing: ServiceTiming(
        durationMinutes: 480, // 8 hours in minutes
        estimatedCompletion: null,
        availableDays: ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'],
        startTime: null,
        endTime: null,
        emergencyService: false,
      ),
      geography: ServiceGeography(
        latitude: 18.5204,
        longitude: 73.8567,
        serviceArea: 'Pune',
      ),
      tags: {'ac', 'cooling', 'repair'},
      primaryPricing: OfferingPricingDTO(
        basePrice: MoneyDTO(amount: 25.0, currency: 'USD'),
        type: PricingType.FIXED,
      ),
      mediaItems: [
        OfferingMediaDTO(
          mediaUrl: 'https://example.com/ac.jpg',
          mediaType: 'IMAGE',
          displayOrder: 1,
        ),
      ],
    ),
    OfferingServiceDTO(
      id: '3',
      offeringCode: 'MASON-001',
      title: 'Masonry Work - 5 Days',
      description: 'Professional masonry and construction work',
      category: 'contract_service+masonry',
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
        latitude: 12.9716,
        longitude: 77.5946,
        serviceArea: 'Bangalore',
      ),
      tags: {'construction', 'masonry', 'contract'},
      primaryPricing: OfferingPricingDTO(
        basePrice: MoneyDTO(amount: 25.0, currency: 'USD'),
        type: PricingType.FIXED,
      ),
      mediaItems: [
        OfferingMediaDTO(
          mediaUrl: 'https://example.com/masonry.jpg',
          mediaType: 'IMAGE',
          displayOrder: 1,
        ),
      ],
    ),
    OfferingServiceDTO(
      id: '4',
      offeringCode: 'MAID-001',
      title: 'Full Time Home Maid',
      description: 'Professional home cleaning and maintenance',
      category: 'home_service+maid',
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
        latitude: 28.6139,
        longitude: 77.2090,
        serviceArea: 'Delhi',
      ),
      tags: {'cleaning', 'maid', 'home'},
      primaryPricing: OfferingPricingDTO(
        basePrice: MoneyDTO(amount: 25.0, currency: 'USD'),
        type: PricingType.FIXED,
      ),
      mediaItems: [
        OfferingMediaDTO(
          mediaUrl: 'https://example.com/maid.jpg',
          mediaType: 'IMAGE',
          displayOrder: 1,
        ),
      ],
    ),
  ];
  


  final List<Map<String, dynamic>> productsList = [
    {
      "id": 1,
      "title": "Smartphone",
      "price": "₹15,999",
      "originalPrice": "₹19,999",
      "rating": 4.4,
      "badge": "BESTSELLER",
      "image": "phone",
    },
    {
      "id": 2,
      "title": "Laptop",
      "price": "₹45,999",
      "rating": 4.6,
      "badge": "TRENDING",
      "image": "laptop",
    },
    {
      "id": 3,
      "title": "Headphones",
      "price": "₹2,999",
      "originalPrice": "₹3,999",
      "rating": 4.2,
      "badge": "DEAL",
      "image": "headphones",
    },
    {
      "id": 4,
      "title": "Smart Watch",
      "price": "₹8,999",
      "rating": 4.5,
      "badge": "NEW",
      "image": "watch",
    },
  ];

  final List<Map<String, dynamic>> vendorsList = [
    {
      "id": 1,
      "name": "TechWorld Electronics",
      "rating": 4.7,
      "reviews": 1250,
      "verified": true,
      "category": "Electronics",
      "distance": "2.3 km",
    },
    {
      "id": 2,
      "name": "QuickFix Services",
      "rating": 4.5,
      "reviews": 856,
      "verified": true,
      "category": "Home Services",
      "distance": "1.8 km",
    },
    {
      "id": 3,
      "name": "Fresh Grocery Store",
      "rating": 4.6,
      "reviews": 2100,
      "verified": true,
      "category": "Groceries",
      "distance": "0.9 km",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _hasAnyContent {
    return offersList.isNotEmpty || 
           servicesList.isNotEmpty || 
           productsList.isNotEmpty || 
           vendorsList.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
    
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _hasAnyContent ? _buildContent() : _buildEmptyState(),
          ),
        ],
      ),
    );
  }


Widget _buildTabBar() {
  return Container(
    color: AppColors.backgroundColor,
    padding: const EdgeInsets.symmetric(horizontal: 16), // horizontal padding for better spacing
    child: Center(
      child: TabBar(
        controller: _tabController,
        isScrollable: false, // centered tabs
        labelStyle: AppTextStyles.headlineSmall,
        unselectedLabelStyle: AppTextStyles.bodyMedium,
        labelColor: AppColors.accentOrange,
        unselectedLabelColor: AppColors.textMedium,
        indicatorColor: AppColors.accentOrange,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: "All"),
          Tab(text: "Services"),
          Tab(text: "Products"),
          Tab(text: "Vendors"),
          Tab(text: "Offers"),
        ],
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
      ),
    ),
  );
}



  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Offers Section
          if (offersList.isNotEmpty && (_selectedTabIndex == 0 || _selectedTabIndex == 4))
            _buildOffersSection(),
          
          // Top Services Section
          if (servicesList.isNotEmpty && (_selectedTabIndex == 0 || _selectedTabIndex == 1))
            _buildServicesSection(),
          
          // Trending Products Section
          if (productsList.isNotEmpty && (_selectedTabIndex == 0 || _selectedTabIndex == 2))
            _buildProductsSection(),
          
          // Verified Vendors Section
          if (vendorsList.isNotEmpty && (_selectedTabIndex == 0 || _selectedTabIndex == 3))
            _buildVendorsSection(),
        ],
      ),
    );
  }


Widget _buildOffersSection() {
  final PageController _pageController = PageController(viewportFraction: 0.85);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionHeader(title: "Top Offers", seeAll: true),
      const SizedBox(height: 12),
      SizedBox(
        height: 140,
        child: PageView.builder(
          controller: _pageController,
          itemCount: offersList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: OfferCard(offer: offersList[index]),
            );
          },
        ),
      ),
      const SizedBox(height: 24),
    ],
  );
}


  Widget _buildServicesSection() {
    return Column(
      children: [
        SectionHeader(title: "Top Services", seeAll: true),
        SizedBox(height: 12),
        HorizontalScrollList(    
          items: servicesList.map((service) => ServiceCard(offering: service)).toList(),
        ),
        SizedBox(height: 24),
      ],
    );
  }


  Widget _buildProductsSection() {
    return Column(
      children: [
        SectionHeader(title: "Trending Products", seeAll: true),
        SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
          children: productsList.map((product) => ProductCard(product: product)).toList(),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildVendorsSection() {
    return Column(
      children: [
        SectionHeader(title: "Trusted Vendors", seeAll: true),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: vendorsList.length,
          itemBuilder: (context, index) => VendorTile(vendor: vendorsList[index]),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textLight,
          ),
          SizedBox(height: 16),
          Text(
            "No listings yet!",
            style: AppTextStyles.headlineMedium,
          ),
          SizedBox(height: 8),
          Text(
            "Check back later or try another location",
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Refresh logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Refresh", style: AppTextStyles.buttonText),
          ),
        ],
      ),
    );
  }
}

// UI Components

class SectionHeader extends StatelessWidget {
  final String title;
  final bool seeAll;

  const SectionHeader({Key? key, required this.title, this.seeAll = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.headlineMedium),
        if (seeAll)
          TextButton(
            onPressed: () {},
            child: Text(
              "See All",
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primaryBlue),
            ),
          ),
      ],
    );
  }
}

class HorizontalScrollList extends StatelessWidget {
  final List<Widget> items;

  const HorizontalScrollList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(right: 12),
          child: items[index],
        ),
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final Map<String, dynamic> offer;

  const OfferCard({Key? key, required this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: (offer['color'] as Color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: offer['color'], width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: offer['color'],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                offer['title'],
                style: AppTextStyles.buttonText,
              ),
            ),
            SizedBox(height: 8),
            Text(
              offer['subtitle'],
              style: AppTextStyles.headlineSmall,
            ),
            Text(
              offer['description'],
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final OfferingServiceDTO offering;
  final VoidCallback? onTap;

  const ServiceCard({
    Key? key,
    required this.offering,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceDetailScreen(service: offering),
          ),
        );
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon/Image container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: offering.mediaItems.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          offering.mediaItems.first.mediaUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildDefaultIcon(),
                        ),
                      )
                    : _buildDefaultIcon(),
              ),
              const SizedBox(height: 12),
              // Service title
              Text(
                offering.title,
                style: AppTextStyles.headlineSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Pricing information
              Text(
                '${offering.primaryPricing.basePrice.currency} ${offering.primaryPricing.basePrice}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.accentGreen,
                ),
              ),
              const SizedBox(height: 4),
              // Rating information
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.accentOrange, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    '4.8', // You might want to add rating to your DTO
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Center(
      child: Icon(
        _getCategoryIcon(offering.category),
        color: AppColors.primaryBlue,
        size: 20,
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    if (category.contains('bike')) return Icons.pedal_bike;
    if (category.contains('car')) return Icons.directions_car;
    if (category.contains('home')) return Icons.home;
    if (category.contains('repair')) return Icons.build;
    return Icons.category;
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(),
        ),
      );
    },
    child: Container( // ✅ This was the missing piece
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.dividerColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      _getProductIcon(product['image']),
                      size: 40,
                      color: AppColors.textMedium,
                    ),
                  ),
                  if (product['badge'] != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getBadgeColor(product['badge']),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product['badge'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'],
                    style: AppTextStyles.headlineSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  if (product['originalPrice'] != null) ...[
                    Text(
                      product['originalPrice'],
                      style: AppTextStyles.bodyMedium.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      product['price'],
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accentGreen),
                    ),
                  ] else
                    Text(
                      product['price'],
                      style: AppTextStyles.bodyMedium,
                    ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.accentOrange, size: 12),
                      SizedBox(width: 2),
                      Text(
                        product['rating'].toString(),
                        style: TextStyle(fontSize: 12, color: AppColors.textMedium),
                      ),
                    ],
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
}


  IconData _getProductIcon(String image) {
    switch (image) {
      case 'phone':
        return Icons.smartphone;
      case 'laptop':
        return Icons.laptop;
      case 'headphones':
        return Icons.headphones;
      case 'watch':
        return Icons.watch;
      default:
        return Icons.shopping_bag;
    }
  }

  Color _getBadgeColor(String badge) {
    switch (badge) {
      case 'BESTSELLER':
        return AppColors.accentGreen;
      case 'TRENDING':
        return AppColors.accentOrange;
      case 'DEAL':
        return Colors.red;
      case 'NEW':
        return AppColors.primaryBlue;
      default:
        return AppColors.textMedium;
    }
  }


class VendorTile extends StatelessWidget {
  final Map<String, dynamic> vendor;

  const VendorTile({Key? key, required this.vendor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreDetailPage(
              store: Store(
                    id: 'store1',
                    name: 'Fresh Mart',
                    image: 'https://example.com/images/store1.jpg',
                    rating: 4.5,
                    reviewCount: 120,
                    distanceKm: 2.3,
                    openUntil: '9:00 PM',
                    isOpen: true,
                    offers: ['10% off on fruits', 'Buy 1 Get 1 Free on snacks'],
                    products: [
                      Product(id: 'p1', name: 'Apple', price: 1.5),
                      Product(id: 'p2', name: 'Banana', price: 0.99),
                    ],
                    description: 'Your local grocery store with fresh produce and daily essentials.',
                  ), // assuming vendor and store are the same
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12), // for ripple effect
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.store,
                color: AppColors.primaryBlue,
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vendor['name'],
                          style: AppTextStyles.headlineSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (vendor['verified'])
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified, color: Colors.white, size: 12),
                              SizedBox(width: 2),
                              Text(
                                'VERIFIED',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    vendor['category'],
                    style: AppTextStyles.bodyMedium,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.accentOrange, size: 14),
                      SizedBox(width: 2),
                      Text(
                        vendor['rating'].toString(),
                        style: AppTextStyles.bodyMedium,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '(${vendor['reviews']} reviews)',
                        style: AppTextStyles.bodyMedium,
                      ),
                      Spacer(),
                      Text(
                        vendor['distance'],
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
