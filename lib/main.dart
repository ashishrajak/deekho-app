import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/pages/ViewDealPage.dart';

import 'package:my_flutter_app/pages/bidpost/post-service.dart';

import 'package:my_flutter_app/pages/discover_page.dart';
import 'package:my_flutter_app/pages/home-page.dart';
import 'package:my_flutter_app/pages/home/home-page.dart';
import 'package:my_flutter_app/pages/main/GrokTest.dart';
import 'package:my_flutter_app/pages/main/auth-screen.dart';
import 'package:my_flutter_app/pages/main/offer-screen.dart';
import 'package:my_flutter_app/pages/main/onboarding-screen.dart';
import 'package:my_flutter_app/pages/main/profile-screen.dart';
import 'package:my_flutter_app/pages/main/splash-screen.dart';
import 'package:my_flutter_app/pages/offered-services/service-home.dart';
import 'package:my_flutter_app/pages/profile_tabs.dart';
import 'package:my_flutter_app/widgets/app-header/app-header.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const HyperLocalApp());
}

/// ======================
/// THEME CONFIGURATION
/// ======================

/// ======================
/// DATA MODELS
/// ======================
class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final List<String> preferredCategories;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.preferredCategories,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'gender': gender,
    'preferredCategories': preferredCategories,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    gender: json['gender'],
    preferredCategories: List<String>.from(json['preferredCategories']),
  );
}

class Deal {
  final String title;
  final String store;
  final String distance;
  final String imageAsset;
  final int discountedPrice;
  final String category;
  final String vendorName;
  final int discountPercentage;
  final String description;
  final double? rating;
  final DateTime? createdAt;
  final double latitude;
  final double longitude;
  final int originalPrice;
  final String validUntil;
  final int stock;
  final String vendorAddress;
  final List<String> images;
  final List<Product>? products;

  Deal({
    required this.title,
    required this.store,
    required this.distance,
    required this.imageAsset,
    required this.discountedPrice,
    required this.category,
    required this.vendorName,
    required this.discountPercentage,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.originalPrice,
    required this.validUntil,
    required this.stock,
    required this.vendorAddress,
    required this.images,
    this.rating,
    this.createdAt,
    this.products,
  });
}

class Product {
  String name;
  int originalPrice;
  int discountedPrice;
  String id;
  final double price;
  final String image;

  Product({
    this.name = '',
    this.originalPrice = 0,
    this.discountedPrice = 0,
    this.id = '',
    this.price = 0.0,
    this.image = '',
  });
}

// New Bid & Post Models
class BidPost {
  final String id;
  final String title;
  final String description;
  final String category;
  final String posterName;
  final String posterImage;
  final double? posterRating;
  final int baseBudget;
  final int currentBid;
  final String location;
  final DateTime postedAt;
  final DateTime bidEndTime;
  final List<String> images;
  final PostType postType;
  final List<Bid> bids;
  final bool isActive;
  final String requirements;
  final double latitude;
  final double longitude;

  BidPost({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.posterName,
    required this.posterImage,
    this.posterRating,
    required this.baseBudget,
    required this.currentBid,
    required this.location,
    required this.postedAt,
    required this.bidEndTime,
    required this.images,
    required this.postType,
    required this.bids,
    required this.isActive,
    required this.requirements,
    required this.latitude,
    required this.longitude,
    
  });
}

class Bid {
  final String id;
  final String bidderName;
  final String bidderImage;
  final double bidderRating;
  final String bidderExperience;
  final int bidAmount;
  final DateTime bidTime;
  final String message;
  final bool isAccepted;

  Bid({
    required this.id,
    required this.bidderName,
    required this.bidderImage,
    required this.bidderRating,
    required this.bidderExperience,
    required this.bidAmount,
    required this.bidTime,
    required this.message,
    required this.isAccepted,
  });
}

enum PostType { userRequirement, partnerService }

/// ======================
/// SERVICES
/// ======================
class MockDataService {
  static List<String> getCategories() {
    return [
      "Fruits & Vegetables",
      "Electronics",
      "Clothing",
      "Home & Kitchen",
      "Beauty & Wellness",
    ];
  }

  static List<String> getBidCategories() {
    return [
      "Construction",
      "Plumbing",
      "Electrical",
      "Carpentry",
      "Painting",
      "Cleaning",
      "Gardening",
      "Repair Services",
      "Moving & Packing",
      "Home Tutoring",
    ];
  }

  static List<BidPost> getMockBidPosts() {
    return [
      BidPost(
        id: '1',
        title: 'Need Construction Workers',
        description: 'Looking for experienced construction workers for house renovation project. Work duration approximately 2 weeks.',
        category: 'Construction',
        posterName: 'Rajesh Kumar',
        posterImage: 'assets/images/avatar1.png',
        posterRating: 4.5,
        baseBudget: 50000,
        currentBid: 45000,
        location: 'Bhopal, MP',
        postedAt: DateTime.now().subtract(Duration(hours: 2)),
        bidEndTime: DateTime.now().add(Duration(hours: 22)),
        images: ['assets/images/construction1.jpg', 'assets/images/construction2.jpg'],
        postType: PostType.userRequirement,
        bids: [
          Bid(
            id: '1',
            bidderName: 'Suresh Contractor',
            bidderImage: 'assets/images/contractor1.png',
            bidderRating: 4.8,
            bidderExperience: '8 years experience',
            bidAmount: 45000,
            bidTime: DateTime.now().subtract(Duration(minutes: 30)),
            message: 'I can complete this work in 10 days with quality materials.',
            isAccepted: false,
          ),
          Bid(
            id: '2',
            bidderName: 'Ramesh Builder',
            bidderImage: 'assets/images/contractor2.png',
            bidderRating: 4.6,
            bidderExperience: '12 years experience',
            bidAmount: 48000,
            bidTime: DateTime.now().subtract(Duration(minutes: 45)),
            message: 'Quality work guaranteed with 1 year warranty.',
            isAccepted: false,
          ),
        ],
        isActive: true,
        requirements: 'Need 4-5 skilled workers, own tools preferred',
        latitude: 23.2599,
        longitude: 77.4126,
      ),
      BidPost(
        id: '2',
        title: 'Professional Plumber Available',
        description: 'Experienced plumber available for all types of plumbing work in Bhopal area.',
        category: 'Plumbing',
        posterName: 'Amit Plumber',
        posterImage: 'assets/images/plumber1.png',
        posterRating: 4.7,
        baseBudget: 2000,
        currentBid: 2200,
        location: 'Bhopal, MP',
        postedAt: DateTime.now().subtract(Duration(hours: 4)),
        bidEndTime: DateTime.now().add(Duration(hours: 20)),
        images: ['assets/images/plumbing1.jpg'],
        postType: PostType.partnerService,
        bids: [
          Bid(
            id: '3',
            bidderName: 'Priya Sharma',
            bidderImage: 'assets/images/user1.png',
            bidderRating: 4.3,
            bidderExperience: 'Verified User',
            bidAmount: 2200,
            bidTime: DateTime.now().subtract(Duration(minutes: 15)),
            message: 'Need urgent bathroom repair work.',
            isAccepted: false,
          ),
        ],
        isActive: true,
        requirements: 'Available 24/7, emergency services',
        latitude: 23.2599,
        longitude: 77.4126,
      ),
    ];
  }
}

class ProfileService {
  static const String _profileKey = 'user_profile';
  static const String _isLoggedInKey = 'is_logged_in';

  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, profile.toJson().toString());
    await prefs.setBool(_isLoggedInKey, true);
  }

  static Future<UserProfile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);
    if (profileJson != null) {
      return UserProfile.fromJson(profileJson as Map<String, dynamic>);
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    await prefs.setBool(_isLoggedInKey, false);
  }
}


// Updated Main App with Navigation
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final profile = await ProfileService.getProfile();
    setState(() {
      _userProfile = profile;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _handleAuthComplete(UserProfile profile) async {
    await ProfileService.saveProfile(profile);
    setState(() {
      _userProfile = profile;
      _currentIndex = 3; // Go to profile tab
    });
    Navigator.pop(context); // Close auth screen
  }

  void _handleLogout() async {
    await ProfileService.logout();
    setState(() {
      _userProfile = null;
    });
  }

  void _showAuthScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuthScreen(
          onAuthComplete: _handleAuthComplete,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const ServiceListScreen(),
      HomeScreen(),
      const ServiceManagementScreen(),
      ProfileScreen(
        userProfile: _userProfile,
        onLoginRequired: _showAuthScreen,
        onLogout: _handleLogout,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // const AppHeader(), // <-- Here's your header
            const Divider(height: 1),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: pages,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.textMedium,
        backgroundColor: AppTheme.cardBackground,
        elevation: 4,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel_outlined),
            activeIcon: Icon(Icons.gavel),
            label: 'Bid & Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services_outlined),
            activeIcon: Icon(Icons.design_services),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// ======================
/// MAIN APP
/// ======================
class HyperLocalApp extends StatelessWidget {
  const HyperLocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HyperLocal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppTheme.primaryBlue,
        colorScheme: ColorScheme.light(
          primary: AppTheme.primaryBlue,
          secondary: AppTheme.accentOrange,
          background: AppTheme.backgroundColor,
        ),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: AppTheme.textDark),
        ),
      ),
      home: const AppEntryPoint(),
    );
  }
}

class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({super.key});

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  bool _isLoading = true;
  bool _locationGranted = false;
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Check if first launch
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('first_launch') ?? true;
    
    // Show splash screen for 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    
    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    setState(() {
      _locationGranted = permission == LocationPermission.always || 
                        permission == LocationPermission.whileInUse;
      _showOnboarding = isFirstLaunch;
      _isLoading = false;
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }

    if (!_locationGranted) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_off,
                size: 64,
                color: AppTheme.textMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Location Permission Required',
                style: AppTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'We need your location to show nearby deals and offers. Please enable location services in your device settings.',
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _initializeApp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Retry',
                  style: AppTheme.buttonText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_showOnboarding) {
      return OnboardingScreen(onComplete: _completeOnboarding);
    }

    // Go directly to main app (no forced profile setup)
    return const MainApp();
  }
}