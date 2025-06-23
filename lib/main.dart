import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_flutter_app/pages/ViewDealPage.dart';

import 'package:my_flutter_app/pages/discover_page.dart';
import 'package:my_flutter_app/pages/home-page.dart';
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
class AppColors {
  // Primary colors inspired by Google Pay (clean, modern)
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF212121);
    static const Color backgroundColor = Color(0xFFE0E0E0);
  
  // Accent colors inspired by Swiggy (orange) and Blinkit (green)
  static const Color accentOrange = Color(0xFFF9A825);
  static const Color accentGreen = Color(0xFF4CAF50);
  
  // Background and surface colors
  static const Color backgroundWhite = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Text colors
  static const Color textDark = Color(0xFF212121);
  static const Color textMedium = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);
  
  // Utility colors
  static const Color dividerColor = Color(0xFFEEEEEE);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFFFA000);
   static const Color errorColor = Color.fromARGB(255, 255, 60, 0);

   static Color get backgroundGrey => Colors.grey.shade200;




 
}

class AppTextStyles {

  
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textMedium,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textMedium,
    height: 1.5,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
  );

  static const TextStyle bodySmall = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: AppColors.textDark, // or whatever color you want as default
);

}

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
   final int  discountedPrice;
 final String  category; 
 final String  vendorName; 
  final int  discountPercentage; 
  final String  description;
  
   final double latitude; // Add this property
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
      required this.latitude, // Add this if missing
    required this.longitude, 

      required this.originalPrice,
    required this.validUntil,
    required this.stock,
    required this.vendorAddress,
    required this.images,
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
    this.originalPrice = 0, // Default value added
    this.discountedPrice = 0, // Default value added
    this.id = '',
    this.price = 0.0,
    this.image = '',
  });
}


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

static List<Deal> getNearbyDeals() {
  return [
    Deal(
      title: "30% off on fresh fruits",
      store: "Local Fresh Mart",
      distance: "1.2 km",
      imageAsset: "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035",
      discountedPrice: 70,
      originalPrice: 100,
      category: "GROCERY",
      vendorName: "Ashish",
      discountPercentage: 30,
      description: "Get fresh fruits at a discount",
      latitude: 27.1751,
      longitude: 78.0421,
      validUntil: "2025-06-30",
      stock: 50,
      vendorAddress: "MG Road, Bhopal",
      images: ["https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035", "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035"],
    ),
    Deal(
      title: "Buy 1 Get 1 Pizza",
      store: "Cheezy Crust",
      distance: "0.8 km",
      imageAsset: "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035",
      discountedPrice: 199,
      originalPrice: 398,
      category: "FOOD",
      vendorName: "Ashish",
      discountPercentage: 50,
      description: "Delicious pizzas with BOGO offer",
      latitude: 27.1751,
      longitude: 78.0421,
      validUntil: "2025-07-10",
      stock: 100,
      vendorAddress: "MP Nagar, Bhopal",
      images: ["https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035", "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035"],
    ),
    Deal(
      title: "50% off on summer wear",
      store: "Urban Styles",
      distance: "1.5 km",
      imageAsset: "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035",
      discountedPrice: 500,
      originalPrice: 1000,
      category: "FASHION",
      vendorName: "Ashish",
      discountPercentage: 50,
      description: "Trendy summer wear at half price",
      latitude: 27.1751,
      longitude: 78.0421,
      validUntil: "2025-08-15",
      stock: 75,
      vendorAddress: "New Market, Bhopal",
      images: ["assets/clothing.jpg"],
    ),
    Deal(
      title: "Free home delivery",
      store: "Home Essentials",
      distance: "2.1 km",
      imageAsset: "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035",
      discountedPrice: 300,
      originalPrice: 300,
      category: "HOME",
      vendorName: "Ashish",
      discountPercentage: 0,
      description: "Order essentials with no delivery charge",
      latitude: 27.1751,
      longitude: 78.0421,
      validUntil: "2025-09-01",
      stock: 120,
      vendorAddress: "TT Nagar, Bhopal",
      images: ["assets/home.jpg"],
    ),
    Deal(
      title: "Haircut + Shave ₹199",
      store: "Style Lounge",
      distance: "0.5 km",
      imageAsset: "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035",
      discountedPrice: 199,
      originalPrice: 399,
      category: "BEAUTY",
      vendorName: "Ashish",
      discountPercentage: 50,
      description: "Grooming combo at just ₹199",
      latitude: 27.1751,
      longitude: 78.0421,
      validUntil: "2025-06-15",
      stock: 30,
      vendorAddress: "DB Mall, Bhopal",
      images: ["https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035", "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035"],
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

/// ======================
/// WIDGETS
/// ======================
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'app-logo',
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.storefront,
                  size: 60,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'HyperLocal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    const OnboardingPage(
      title: 'Discover local deals near you',
      description: 'Find the best offers from shops and sellers in your neighborhood',
      icon: Icons.location_on,
      illustration: Icons.explore,
      color: AppColors.primaryBlue,
    ),
    const OnboardingPage(
      title: 'Support your local sellers',
      description: 'Connect directly with small businesses and independent creators around you',
      icon: Icons.people,
      illustration: Icons.store,
      color: AppColors.accentGreen,
    ),
    const OnboardingPage(
      title: 'Get notified when something nearby goes live',
      description: 'Instant alerts when new products or services become available in your area',
      icon: Icons.notifications,
      illustration: Icons.bolt,
      color: AppColors.accentOrange,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return _pages[index];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? AppColors.primaryBlue
                              : AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pages[_currentPage].color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1 ? 'Get Started' : 'Continue',
                        style: AppTextStyles.buttonText,
                      ),
                    ),
                  ),
                  if (_currentPage == _pages.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'By continuing, you agree to our Terms and Privacy Policy',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textMedium),
                        textAlign: TextAlign.center,
                      ),
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

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final IconData illustration;
  final Color color;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.illustration,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated illustration
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              illustration,
              size: 100,
              color: color,
            ),
          ),
          const SizedBox(height: 40),
          Icon(
            icon,
            size: 40,
            color: color,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: AppTextStyles.headlineLarge.copyWith(color: AppColors.textDark),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMedium),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class DealCard extends StatelessWidget {
  final Deal deal;

  const DealCard({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 120,
              color: AppColors.accentOrange.withOpacity(0.2),
              child: Center(
                child: Icon(
                  Icons.store,
                  size: 50,
                  color: AppColors.accentOrange,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deal.title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.store,
                      size: 16,
                      color: AppColors.textMedium,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      deal.store,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.textMedium,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      deal.distance,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Login/Signup Screen
class AuthScreen extends StatefulWidget {
  final Function(UserProfile) onAuthComplete;

  const AuthScreen({super.key, required this.onAuthComplete});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final PageController _pageController = PageController();
  bool _isLogin = true;
  
  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
    _pageController.animateToPage(
      _isLogin ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Create Account'),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _isLogin = index == 0;
          });
        },
        children: [
          LoginForm(
            onLoginSuccess: widget.onAuthComplete,
            onSwitchToSignup: _toggleAuthMode,
          ),
          SignupForm(
            onSignupSuccess: widget.onAuthComplete,
            onSwitchToLogin: _toggleAuthMode,
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final Function(UserProfile) onLoginSuccess;
  final VoidCallback onSwitchToSignup;

  const LoginForm({
    super.key,
    required this.onLoginSuccess,
    required this.onSwitchToSignup,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Mock login - create a dummy profile
      final profile = UserProfile(
        name: 'John Doe',
        email: _emailController.text,
        phone: '+91 9876543210',
        gender: 'Male',
        preferredCategories: ['Electronics', 'Clothing'],
      );
      widget.onLoginSuccess(profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: AppTextStyles.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to your account to continue',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: AppTextStyles.buttonText,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: AppTextStyles.bodyMedium,
                ),
                TextButton(
                  onPressed: widget.onSwitchToSignup,
                  child: Text(
                    'Sign Up',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  final Function(UserProfile) onSignupSuccess;
  final VoidCallback onSwitchToLogin;

  const SignupForm({
    super.key,
    required this.onSignupSuccess,
    required this.onSwitchToLogin,
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedGender = 'Male';
  final List<String> _selectedCategories = [];

  final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final List<String> _categories = MockDataService.getCategories();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      final profile = UserProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        gender: _selectedGender,
        preferredCategories: _selectedCategories,
      );
      widget.onSignupSuccess(profile);
    }
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Account',
              style: AppTextStyles.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Sign up to get started with HyperLocal',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: _genders.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Preferred Categories (Optional)',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((category) {
                final isSelected = _selectedCategories.contains(category);
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) => _toggleCategory(category),
                  selectedColor: AppColors.accentGreen.withOpacity(0.2),
                  checkmarkColor: AppColors.accentGreen,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.accentGreen : AppColors.textMedium,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create Account',
                  style: AppTextStyles.buttonText,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: AppTextStyles.bodyMedium,
                ),
                TextButton(
                  onPressed: widget.onSwitchToLogin,
                  child: Text(
                    'Login',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Profile Screen with Settings
class ProfileScreen extends StatelessWidget {
  final UserProfile? userProfile;
  final VoidCallback onLoginRequired;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    this.userProfile,
    required this.onLoginRequired,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    if (userProfile == null) {
      return _buildGuestProfile(context);
    }
    return _buildLoggedInProfile(context);
  }

  Widget _buildGuestProfile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_outline,
                size: 80,
                color: AppColors.textMedium,
              ),
              const SizedBox(height: 24),
              Text(
                'Join HyperLocal',
                style: AppTextStyles.headlineLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Create an account or login to access personalized deals, save favorites, and track your orders.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onLoginRequired,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login / Sign Up',
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoggedInProfile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: AppColors.cardBackground,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                    child: Text(
                      userProfile!.name.substring(0, 1).toUpperCase(),
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userProfile!.name,
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userProfile!.email,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Profile Options
            _buildProfileOption(
              context,
              icon: Icons.shopping_bag_outlined,
              title: 'My Orders',
              subtitle: 'Track your orders',
              onTap: () {
               Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyOrdersScreen()),
                  );
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.favorite_outline,
              title: 'Favorites',
              subtitle: 'Your saved deals',
              onTap: () {
                 Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoritesScreen()),
          );
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.location_on_outlined,
              title: 'Addresses',
              subtitle: 'Manage delivery addresses',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddressesScreen()),
                  );
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage your notifications',
              onTap: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  );
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'App preferences',
              onTap: () {
               Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help when you need it',
              onTap: () {
                 Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                    );
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onLogout();
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
              isDestructive: true,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ListTile(
          leading: Icon(
            icon,
            color: isDestructive ? Colors.red : AppColors.primaryBlue,
          ),
          title: Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              color: isDestructive ? Colors.red : AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: AppTextStyles.bodyMedium,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
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
@override
Widget build(BuildContext context) {
  final List<Widget> pages = [
    HomeScreen(deals: MockDataService.getNearbyDeals()),
    const DiscoverPage(),
    const OffersScreen(),
    ProfileScreen(
      userProfile: _userProfile,
      onLoginRequired: _showAuthScreen,
      onLogout: _handleLogout,
    ),
    const ServiceManagementScreen(),
  ];

  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          const AppHeader(), // <-- Here’s your header
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
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: AppColors.textMedium,
      backgroundColor: AppColors.cardBackground,
      elevation: 4,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          activeIcon: Icon(Icons.explore),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer_outlined),
          activeIcon: Icon(Icons.local_offer),
          label: 'Offers',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.design_services),
          activeIcon: Icon(Icons.person),
          label: 'Service',
        ),
      ],
    ),
  );
}
}






class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Offers Screen Coming Soon!',
          style: AppTextStyles.headlineMedium,
        ),
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
        primaryColor: AppColors.primaryBlue,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryBlue,
          secondary: AppColors.accentOrange,
          background: AppColors.backgroundWhite,
        ),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: AppColors.textDark),
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
                color: AppColors.textMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Location Permission Required',
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'We need your location to show nearby deals and offers. Please enable location services in your device settings.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _initializeApp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Retry',
                  style: AppTextStyles.buttonText,
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





