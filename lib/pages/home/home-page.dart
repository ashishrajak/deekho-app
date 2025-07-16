// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/main.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/models/page.dart';
import 'package:my_flutter_app/pages/home/DealCard.dart';
import 'package:my_flutter_app/pages/home/DealsListView.dart';
import 'package:my_flutter_app/pages/home/MapView.dart';
import 'package:my_flutter_app/pages/home/common.dart';
import 'package:my_flutter_app/services/PubOfferingService.dart';

class HomeScreen extends StatefulWidget {
 

  const HomeScreen({
    super.key,
   
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final OfferingService _offeringService = OfferingService();
  PaginatedResponse<OfferingServiceDTO>? _offeringsPage;
  bool _isLoading = true;
  String? _error;
  
  // Filter controllers and variables
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  
  // Filter state variables
  List<String>? _selectedCategories;
  String? _searchQuery;
  double? _minPrice;
  double? _maxPrice;
  String? _priceType;
  List<String>? _selectedTags;
  bool? _emergencyService;
  bool? _verifiedPartnerOnly;
  bool? _onSiteService;
  bool? _willingToTravel;
  int? _radiusKm;
  String? _partnerType;
  
  int _currentPage = 0;
  static const int _pageSize = 10;
  
  String _selectedCategory = 'All';
  Position? _currentPosition;
  GoogleMapController? _mapController;
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.apps},
    {'label': 'Food & Dining', 'icon': Icons.restaurant},
    {'label': 'Shopping', 'icon': Icons.shopping_bag},
    {'label': 'Services', 'icon': Icons.build},
    {'label': 'Electronics', 'icon': Icons.devices},
    {'label': 'Fashion', 'icon': Icons.checkroom},
    {'label': 'Health & Beauty', 'icon': Icons.spa},
  ];

  final List<Map<String, String>> _offers = [
    {
      'discount': '40% OFF',
      'title': 'First Order Special',
      'subtitle': 'Valid for new customers only',
    },
    {
      'discount': '25% OFF',
      'title': 'Weekend Deals',
      'subtitle': 'Valid till Sunday midnight',
    },
    {
      'discount': 'BUY 2 GET 1',
      'title': 'Special Combo',
      'subtitle': 'On selected services',
    },
  ];

  // Price type options
  final List<String> _priceTypes = ['FIXED', 'HOURLY', 'NEGOTIABLE'];
  
  // Partner types
  final List<String> _partnerTypes = ['INDIVIDUAL', 'COMPANY', 'VERIFIED_BUSINESS'];
  
  // Available tags (you can populate this from your backend)
  final List<String> _availableTags = [
    'Popular', 'New', 'Trending', 'Best Rated', 'Quick Service', 'Professional'
  ];

  Future<void> _loadOfferings({bool append = false}) async {
    if (!append) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final page = append ? _currentPage + 1 : 0;
      
      final result = await _offeringService.discoverOfferings(
        // Category filtering
        categories: _selectedCategories,
        
        // Location filtering
        latitude: _currentPosition?.latitude.toString(),
        longitude: _currentPosition?.longitude.toString(),
        radiusKm: _radiusKm,
        onSiteService: _onSiteService,
        willingToTravel: _willingToTravel,
        
        // Pricing filtering
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        priceType: _priceType,
        
        // Service filtering
        tags: _selectedTags,
        emergencyService: _emergencyService,
        
        // Partner filtering
        verifiedPartnerOnly: _verifiedPartnerOnly,
        partnerType: _partnerType,
        
        // Search
        searchQuery: _searchQuery,
        
        // Pagination & Sorting
        page: page,
        size: _pageSize,
        sortBy: 'lastUpdated',
        sortDirection: 'DESC',
      );

      setState(() {
        if (append && _offeringsPage != null) {
          // Append new offerings to existing list
          final currentContent = _offeringsPage!.content;
          final newContent = [...currentContent, ...result.content];
          
          _offeringsPage = PaginatedResponse<OfferingServiceDTO>(
            content: newContent,
            totalElements: result.totalElements,
            totalPages: result.totalPages,
            size: result.size,
            number: result.number,
            first: result.first,
            last: result.last,
            empty: result.empty,
          );
        } else {
          _offeringsPage = result;
        }
        
        _currentPage = page;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _refreshOfferings() async {
    _currentPage = 0;
    await _loadOfferings();
  }

  Future<void> _loadMore() async {
    if (_offeringsPage != null && !_offeringsPage!.last && !_isLoading) {
      await _loadOfferings(append: true);
    }
  }

  void _applyFilters() {
    _searchQuery = _searchController.text.trim().isEmpty ? null : _searchController.text.trim();
    _minPrice = _minPriceController.text.trim().isEmpty ? null : double.tryParse(_minPriceController.text.trim());
    _maxPrice = _maxPriceController.text.trim().isEmpty ? null : double.tryParse(_maxPriceController.text.trim());
    _radiusKm = _radiusController.text.trim().isEmpty ? null : int.tryParse(_radiusController.text.trim());
    
    _currentPage = 0;
    _loadOfferings();
  }

  void _clearFilters() {
    _searchController.clear();
    _minPriceController.clear();
    _maxPriceController.clear();
    _radiusController.clear();
    
    _selectedCategories = null;
    _searchQuery = null;
    _minPrice = null;
    _maxPrice = null;
    _priceType = null;
    _selectedTags = null;
    _emergencyService = null;
    _verifiedPartnerOnly = null;
    _onSiteService = null;
    _willingToTravel = null;
    _radiusKm = null;
    _partnerType = null;
    
    _currentPage = 0;
    _loadOfferings();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildFilterDialog(),
    );
  }

  Widget _buildFilterDialog() {
    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text('Filter Options'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    hintText: 'Enter search query...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Price Range
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Min Price',
                          prefixIcon: Icon(Icons.currency_rupee),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _maxPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Max Price',
                          prefixIcon: Icon(Icons.currency_rupee),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Price Type
                DropdownButtonFormField<String>(
                  value: _priceType,
                  decoration: const InputDecoration(labelText: 'Price Type'),
                  items: _priceTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) => setDialogState(() => _priceType = value),
                ),
                const SizedBox(height: 16),
                
                // Location Radius
                TextField(
                  controller: _radiusController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Search Radius (km)',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Service Options
                CheckboxListTile(
                  title: const Text('Emergency Service'),
                  value: _emergencyService ?? false,
                  onChanged: (value) => setDialogState(() => _emergencyService = value),
                ),
                CheckboxListTile(
                  title: const Text('Verified Partners Only'),
                  value: _verifiedPartnerOnly ?? false,
                  onChanged: (value) => setDialogState(() => _verifiedPartnerOnly = value),
                ),
                CheckboxListTile(
                  title: const Text('On-Site Service'),
                  value: _onSiteService ?? false,
                  onChanged: (value) => setDialogState(() => _onSiteService = value),
                ),
                CheckboxListTile(
                  title: const Text('Willing to Travel'),
                  value: _willingToTravel ?? false,
                  onChanged: (value) => setDialogState(() => _willingToTravel = value),
                ),
                const SizedBox(height: 16),
                
                // Partner Type
                DropdownButtonFormField<String>(
                  value: _partnerType,
                  decoration: const InputDecoration(labelText: 'Partner Type'),
                  items: _partnerTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) => setDialogState(() => _partnerType = value),
                ),
                const SizedBox(height: 16),
                
                // Tags
                const Text('Tags:', style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: _availableTags.map((tag) {
                    final isSelected = _selectedTags?.contains(tag) ?? false;
                    return FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) {
                        setDialogState(() {
                          if (selected) {
                            _selectedTags = [...(_selectedTags ?? []), tag];
                          } else {
                            _selectedTags = _selectedTags?.where((t) => t != tag).toList();
                            if (_selectedTags?.isEmpty ?? false) _selectedTags = null;
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearFilters();
                Navigator.pop(context);
              },
              child: const Text('Clear All'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _applyFilters();
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getCurrentLocation();
    _loadOfferings(); // Load offerings on init
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentPosition = position;
        });
        // Reload offerings with location
        _loadOfferings();
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

List<OfferingServiceDTO> get _filteredDeals {
  if (_offeringsPage == null) return [];
  
  List<OfferingServiceDTO> filtered = _offeringsPage!.content;
  
  if (_selectedCategory != 'All') {
    filtered = filtered.where((offering) => 
      offering.category.name?.contains(_selectedCategory) ?? false
    ).toList();
  }
  
  return filtered;
}
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      // Update selected categories for API call
      if (category == 'All') {
        _selectedCategories = null;
      } else {
        _selectedCategories = [category];
      }
    });
    _loadOfferings();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;
    final isMobile = screenWidth <= 768;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: isDesktop ? _buildDesktopLayout() : _buildMobileTabletLayout(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left sidebar
        Container(
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(),
              _buildOfferSection(),
              _buildCategorySection(),
              _buildSearchBar(),
              _buildTabBar(),
              Expanded(
                child: _buildOfferingsContent(),
              ),
            ],
          ),
        ),
        // Right content area
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: MapView(
              offerings: _filteredDeals,
              currentPosition: _currentPosition,
              mapController: _mapController,
              onMapCreated: (controller) => _mapController = controller,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileTabletLayout() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        _buildSliverSearchBar(),
        _buildSliverOfferSection(),
        _buildSliverCategorySection(),
        _buildSliverTabBar(),
        _buildSliverOfferingsContent(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search offerings...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _applyFilters();
                  },
                ),
              ),
              onSubmitted: (_) => _applyFilters(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.tune),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverSearchBar() {
    return SliverToBoxAdapter(
      child: _buildSearchBar(),
    );
  }

  Widget _buildOfferingsContent() {
    if (_isLoading && _offeringsPage == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshOfferings,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (_offeringsPage == null || _offeringsPage!.content.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('No offerings found'),
          ],
        ),
      );
    }
    
    return TabBarView(
      controller: _tabController,
      children: [
        RefreshIndicator(
          onRefresh: _refreshOfferings,
          child: ListView.builder(
            itemCount: _offeringsPage!.content.length + (_offeringsPage!.last ? 0 : 1),
            itemBuilder: (context, index) {
              if (index < _offeringsPage!.content.length) {
                final offering = _offeringsPage!.content[index];
                return DealCard(deal:offering);
              } else {
                // Load more indicator
                _loadMore();
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ),
        MapView(
          offerings: _filteredDeals,
          currentPosition: _currentPosition,
          mapController: _mapController,
          onMapCreated: (controller) => _mapController = controller,
        ),
      ],
    );
  }

  Widget _buildSliverOfferingsContent() {
    return SliverFillRemaining(
      child: _buildOfferingsContent(),
    );
  }

  Widget _buildOfferingCard(OfferingServiceDTO offering) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          child: Text(offering.title?.substring(0, 1).toUpperCase() ?? 'S'),
        ),
        title: Text(offering.title ?? 'Unknown Service'),
        subtitle: Text(offering.description ?? 'No description'),
        trailing: offering.primaryPricing.basePrice != null 
          ? Text('₹${offering.primaryPricing.basePrice}', style: const TextStyle(fontWeight: FontWeight.bold))
          : null,
        onTap: () {
          // Handle offering tap
        },
      ),
    );
  }

  Widget _buildSliverAppBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 768;
    
    return SliverAppBar(
      floating: true,
      backgroundColor: AppTheme.backgroundColor,
      elevation: 0,
      expandedHeight: isMobile ? 80 : 100,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? AppTheme.spacingS : AppTheme.spacingM),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: isMobile ? 16 : 20,
                  child: Icon(
                    Icons.person,
                    color: AppTheme.primaryColor,
                    size: isMobile ? 16 : 20,
                  ),
                ),
                SizedBox(width: isMobile ? AppTheme.spacingS : AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Good Morning!',
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: isMobile ? 12 : 14,
                        ),
                      ),
                      Text(
                        'Find amazing deals near you',
                        style: AppTheme.headlineSmall.copyWith(
                          color: Colors.white,
                          fontSize: isMobile ? 14 : 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: isMobile ? 20 : 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverOfferSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 768;
    
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(height: isMobile ? AppTheme.spacingM : AppTheme.spacingL),
          SizedBox(
            height: isMobile ? 120 : 140,
            child: PageView.builder(
              itemCount: _offers.length,
              padEnds: false,
              controller: PageController(viewportFraction: isMobile ? 0.9 : 0.8),
              itemBuilder: (context, index) {
                final offer = _offers[index];
                return OfferBanner(
                  discount: offer['discount']!,
                  title: offer['title']!,
                  subtitle: offer['subtitle']!,
                  onTap: () {
                    // Handle offer tap
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverCategorySection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 768;
    
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: isMobile ? AppTheme.spacingM : AppTheme.spacingL),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? AppTheme.spacingS : AppTheme.spacingM,
            ),
            child: Text(
              'Categories',
              style: AppTheme.headlineMedium.copyWith(
                fontSize: isMobile ? 16 : 20,
              ),
            ),
          ),
          SizedBox(height: isMobile ? AppTheme.spacingS : AppTheme.spacingM),
          SizedBox(
            height: isMobile ? 36 : 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? AppTheme.spacingS : AppTheme.spacingM,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return CategoryChip(
                  label: category['label'],
                  icon: category['icon'],
                  isSelected: _selectedCategory == category['label'],
                  onTap: () => _onCategorySelected(category['label']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverTabBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 768;
    
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(height: isMobile ? AppTheme.spacingM : AppTheme.spacingL),
          CustomTabBar(tabController: _tabController),
        ],
      ),
    );
  }

  // Helper methods for desktop layout
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.primaryGradient,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Good Morning!',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      'Find amazing deals near you',
                      style: AppTheme.headlineSmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferSection() {
    return SizedBox(
      height: 120,
      child: PageView.builder(
        itemCount: _offers.length,
        controller: PageController(viewportFraction: 0.9),
        itemBuilder: (context, index) {
          final offer = _offers[index];
          return OfferBanner(
            discount: offer['discount']!,
            title: offer['title']!,
            subtitle: offer['subtitle']!,
            onTap: () {
              // Handle offer tap
            },
          );
        },
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          child: Text(
            'Categories',
            style: AppTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return CategoryChip(
                label: category['label'],
                icon: category['icon'],
                isSelected: _selectedCategory == category['label'],
                onTap: () => _onCategorySelected(category['label']),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return CustomTabBar(tabController: _tabController);
  }
}