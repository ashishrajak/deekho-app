import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/main.dart';


enum OrderStatus {
  all,
  pending,
  shipped,
  delivered,
  cancelled,
  returned,
}







class OrderModel {
  final String orderId;
  final String productImage; // <-- NEW field
  final String productName;
  final int quantity;
  final OrderStatus status;
  final double price;
  final double totalAmount;
  final DateTime orderDate;

  OrderModel({
    required this.orderId,
    required this.productImage,
    required this.productName,
    required this.quantity,
    required this.status,
    required this.price,
    required this.totalAmount,
    required this.orderDate,
  });
}




class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('My Orders', style: AppTheme.headlineSmall),
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Shipped'),
            Tab(text: 'Delivered'),
          ],
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.textMedium,
          indicatorColor: AppTheme.primaryBlue,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(OrderStatus.all),
          _buildOrdersList(OrderStatus.pending),
          _buildOrdersList(OrderStatus.shipped),
          _buildOrdersList(OrderStatus.delivered),
        ],
      ),
    );
  }

  Widget _buildOrdersList(OrderStatus filter) {
    List<OrderModel> orders = _getOrdersByStatus(filter);
    
    if (orders.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order #${order.orderId}', style: AppTheme.bodyLarge),
              _buildStatusChip(order.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 60,
                  height: 60,
                  color: AppTheme.backgroundColor,
                  child: Icon(Icons.shopping_bag, color: AppTheme.primaryBlue),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.productName, style: AppTheme.bodyMedium),
                    Text('Qty: ${order.quantity}', style: AppTheme.bodySmall),
                    Text('₹${order.totalAmount.toStringAsFixed(2)}', 
                         style: AppTheme.bodyLarge.copyWith(color: AppTheme.primaryBlue)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ordered on ${_formatDate(order.orderDate)}', 
                   style: AppTheme.bodySmall.copyWith(color: AppTheme.textMedium)),
              Row(
                children: [
                  TextButton(
                    onPressed: () => _showOrderDetails(order),
                    child: Text('View Details'),
                  ),
                  if (order.status == OrderStatus.delivered)
                    TextButton(
                      onPressed: () => _reorderItem(order),
                      child: Text('Reorder'),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case OrderStatus.pending:
        color = AppTheme.accentOrange;
        text = 'Pending';
        break;
      case OrderStatus.shipped:
        color = AppTheme.primaryBlue;
        text = 'Shipped';
        break;
      case OrderStatus.delivered:
        color = AppTheme.successColor;
        text = 'Delivered';
        break;
      case OrderStatus.cancelled:
        color = AppTheme.errorColor;
        text = 'Cancelled';
        break;
      default:
        color = AppTheme.textMedium;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: AppTheme.bodySmall.copyWith(color: color)),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 64, color: AppTheme.textLight),
          const SizedBox(height: 16),
          Text('No orders found', style: AppTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Start shopping to see your orders here', 
               style: AppTheme.bodyMedium.copyWith(color: AppTheme.textMedium)),
        ],
      ),
    );
  }

  List<OrderModel> _getOrdersByStatus(OrderStatus filter) {
    // Sample data - replace with actual API call
    List<OrderModel> allOrders = [
      OrderModel(
        orderId: '12345',
        productImage: '',
        productName: 'Premium Headphones',
        quantity: 1,
        status: OrderStatus.delivered,
        price: 2999.0,
        totalAmount: 2999.0,
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      OrderModel(
        orderId: '12346',
        productImage: '',
        productName: 'Wireless Mouse',
        quantity: 2,
        status: OrderStatus.shipped,
        price: 1499.0,
        totalAmount: 2998.0,
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    if (filter == OrderStatus.all) return allOrders;
    return allOrders.where((order) => order.status == filter).toList();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showOrderDetails(OrderModel order) {
    // Navigate to order details screen
  }

  void _reorderItem(OrderModel order) {
    // Add to cart logic
  }
}

// Favorites Screen - Complete Implementation



class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<FavoriteModel> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Favorites', style: AppTheme.headlineSmall),
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all, color: AppTheme.textDark),
              onPressed: _clearAllFavorites,
            ),
        ],
      ),
      body: favorites.isEmpty 
          ? _buildEmptyState() 
          : Column(
              children: [
                _buildBusinessMetrics(),
                Expanded(
                  child: _buildFavoritesList(isPortrait),
                ),
              ],
            ),
    );
  }

  Widget _buildFavoritesList(bool isPortrait) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isPortrait ? 2 : 3,
        childAspectRatio: isPortrait ? 0.75 : 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return _buildFavoriteCard(favorites[index]);
      },
    );
  }

  Widget _buildFavoriteCard(FavoriteModel favorite) {
    return GestureDetector(
      onTap: () => _viewProductDetails(favorite),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: favorite.productImage.isNotEmpty
                        ? Image.network(
                            favorite.productImage,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildPlaceholderIcon(),
                          )
                        : _buildPlaceholderIcon(),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _toggleFavorite(favorite),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: AppTheme.errorColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  if (favorite.discountBadge != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          favorite.discountBadge!,
                          style: AppTheme.bodySmall.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      favorite.productName,
                      style: AppTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (favorite.brandName != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        favorite.brandName!,
                        style: AppTheme.caption.copyWith(color: AppTheme.primaryBlue),
                      ),
                    ],
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (favorite.originalPrice != null)
                              Text(
                                '₹${favorite.originalPrice!.toStringAsFixed(2)}',
                                style: AppTheme.caption.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppTheme.textLight,
                                ),
                              ),
                            Text(
                              '₹${favorite.price.toStringAsFixed(2)}',
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => _addToCart(favorite),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
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

  Widget _buildPlaceholderIcon() {
    return Center(
      child: Icon(
        Icons.shopping_bag,
        size: 48,
        color: AppTheme.primaryBlue.withOpacity(0.5),
    ));
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
                    Icon(
            Icons.favorite,
            size: MediaQuery.of(context).size.width * 0.6,
            color: Colors.grey[400],
          ),
            const SizedBox(height: 24),
            Text(
              'Your Favorite List is Empty',
              style: AppTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Items you favorite appear here. Start exploring our best deals!',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.textMedium),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildRecommendationChip('Trending Now', onTap: () => _navigateToCategory('trending')),
                _buildRecommendationChip('Best Deals', onTap: () => _navigateToCategory('deals')),
                _buildRecommendationChip('New Arrivals', onTap: () => _navigateToCategory('new')),
                _buildRecommendationChip('Top Picks', onTap: () => _navigateToCategory('top')),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Start Shopping',
                style: AppTheme.buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationChip(String text, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3))),
        child: Text(
          text,
          style: AppTheme.bodySmall.copyWith(color: AppTheme.primaryBlue),
        ),
      ),
    );
  }

  Widget _buildBusinessMetrics() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildMetricChip(
              icon: Icons.shopping_bag,
              value: '₹${_calculateTotalValue().toStringAsFixed(2)}',
              label: 'Total Value',
              color: AppTheme.primaryBlue,
            ),
            const SizedBox(width: 8),
            _buildMetricChip(
              icon: Icons.discount,
              value: '₹${_calculatePotentialSavings().toStringAsFixed(2)}',
              label: 'You Save',
              color: AppTheme.accentGreen,
            ),
            const SizedBox(width: 8),
            _buildMetricChip(
              icon: Icons.star,
              value: favorites.length.toString(),
              label: 'Items',
              color: AppTheme.accentOrange,
            ),
            const SizedBox(width: 8),
            _buildMetricChip(
              icon: Icons.local_offer,
              value: '${_calculateDiscountPercentage().toStringAsFixed(0)}%',
              label: 'Avg Discount',
              color: AppTheme.errorColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2))),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: AppTheme.caption.copyWith(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Business logic methods
  double _calculateTotalValue() {
    return favorites.fold(0, (sum, item) => sum + item.price);
  }

  double _calculatePotentialSavings() {
    return favorites.fold(0, (sum, item) {
      if (item.originalPrice != null) {
        return sum + (item.originalPrice! - item.price);
      }
      return sum;
    });
  }

  double _calculateDiscountPercentage() {
    double totalOriginal = 0;
    double totalDiscounted = 0;
    int count = 0;

    for (var item in favorites) {
      if (item.originalPrice != null) {
        totalOriginal += item.originalPrice!;
        totalDiscounted += item.price;
        count++;
      }
    }

    if (count == 0) return 0;
    return ((totalOriginal - totalDiscounted) / totalOriginal) * 100;
  }

  // Action methods
  void _loadFavorites() {
    // In a real app, this would come from an API or local database
    setState(() {
      favorites = [
        FavoriteModel(
          id: '1',
          productImage: 'https://example.com/headphones.jpg',
          productName: 'Premium Wireless Headphones',
          brandName: 'SoundMaster',
          price: 2999.0,
          originalPrice: 3749.0,
          isFavorite: true,
          discountBadge: '20% OFF',
        ),
        FavoriteModel(
          id: '2',
          productImage: 'https://example.com/smartwatch.jpg',
          productName: 'Smart Watch Series 5',
          brandName: 'TechGadgets',
          price: 15999.0,
          originalPrice: 19999.0,
          isFavorite: true,
          discountBadge: '25% OFF',
        ),
        FavoriteModel(
          id: '3',
          productImage: 'https://example.com/shoes.jpg',
          productName: 'Running Shoes Pro',
          brandName: 'SportFit',
          price: 3499.0,
          isFavorite: true,
        ),
      ];
    });
  }

  void _toggleFavorite(FavoriteModel favorite) {
    setState(() {
      favorites.removeWhere((item) => item.id == favorite.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed from favorites'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              favorites.add(favorite);
            });
          },
        ),
      ),
    );
  }

  void _addToCart(FavoriteModel favorite) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${favorite.productName} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => _navigateToCart(),
        ),
      ),
    );
  }

  void _clearAllFavorites() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear all favorites?', style: AppTheme.headlineSmall),
        content: Text('This will remove all ${favorites.length} items from your favorites list.', 
                     style: AppTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTheme.bodyMedium),
          ),
          TextButton(
            onPressed: () {
              final removedItems = List<FavoriteModel>.from(favorites);
              setState(() {
                favorites.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cleared all favorites'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        favorites.addAll(removedItems);
                      });
                    },
                  ),
                ),
              );
            },
            child: Text('Clear All', 
                       style: AppTheme.bodyMedium.copyWith(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }

  void _viewProductDetails(FavoriteModel favorite) {
    // Navigation to product details
  }

  void _navigateToCategory(String category) {
    // Navigation to category
  }

  void _navigateToCart() {
    // Navigation to cart
  }
}

class FavoriteModel {
  final String id;
  final String productImage;
  final String productName;
  final String? brandName;
  final double price;
  final double? originalPrice;
  final bool isFavorite;
  final String? discountBadge;

  FavoriteModel({
    required this.id,
    required this.productImage,
    required this.productName,
    this.brandName,
    required this.price,
    this.originalPrice,
    required this.isFavorite,
    this.discountBadge,
  });
}

// Addresses Screen - Complete Implementation



class ErrorRetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorRetryWidget({
    required this.message,
    required this.onRetry,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Icon(
    Icons.error_outline,
    size: 64,
    color: AppTheme.errorColor,
  ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Retry',
              style: AppTheme.buttonText,
            ),
          ),
        ],
      ),
    );
  }
}

class AddressModel {
  final String id;
  final String fullName;
  final String addressLine;
  final String city;
  final String state;
  final String pincode;
  final String phoneNumber;
  bool isDefault;
  final String addressType;

  AddressModel({
    required this.id,
    required this.fullName,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.pincode,
    required this.phoneNumber,
    this.isDefault = false,
    required this.addressType,
  });
}



class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Sample notification data
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Order Shipped',
      message: 'Your order #12345 has been shipped and will arrive soon.',
      icon: Icons.local_shipping,
      time: DateTime.now().subtract(const Duration(minutes: 30))
    ),
    NotificationItem(
      id: '2',
      title: 'Special Offer',
      message: 'Get 20% off on all electronics this weekend only!',
      icon: Icons.discount,
      time:DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false),
    NotificationItem(
      id: '3',
      title: 'Payment Received',
      message: 'Your refund of \$25.00 has been processed.',
      icon: Icons.payment,
      time: DateTime.now().subtract(const Duration(days: 1))),
    NotificationItem(
      id: '4',
      title: 'New Arrivals',
      message: 'Check out our new summer collection just for you!',
      icon: Icons.new_releases,
      time: DateTime.now().subtract(const Duration(days: 2))),
    NotificationItem(
      id: '5',
      title: 'Review Request',
      message: 'How was your recent purchase? Share your experience.',
      icon: Icons.star,
      time: DateTime.now().subtract(const Duration(days: 3))),
  ];

  bool _showOnlyUnread = false;

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _showOnlyUnread
        ? _notifications.where((n) => !n.isRead).toList()
        : _notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_showOnlyUnread ? Icons.filter_alt : Icons.filter_alt_outlined),
            onPressed: () {
              setState(() {
                _showOnlyUnread = !_showOnlyUnread;
              });
            },
            tooltip: _showOnlyUnread ? 'Show all' : 'Show unread only',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with clear all action
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Notifications',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (filteredNotifications.isNotEmpty)
                  TextButton(
                    onPressed: _markAllAsRead,
                    child: const Text('Mark all as read'),
                  ),
              ],
            ),
          ),
          // Notifications list
          Expanded(
            child: filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    itemCount: filteredNotifications.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return _buildNotificationItem(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    final timeAgo = _formatTimeAgo(notification.time);
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Notification'),
            content: const Text('Are you sure you want to delete this notification?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        setState(() {
          _notifications.removeWhere((n) => n.id == notification.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notification deleted')),
        );
      },
      child: InkWell(
        onTap: () {
          setState(() {
            notification.isRead = true;
          });
          // Handle notification tap (e.g., navigate to order details)
          _handleNotificationTap(notification);
        },
        child: Container(
          color: notification.isRead
              ? Colors.transparent
              : colorScheme.primary.withOpacity(0.05),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification.icon,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification.title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: notification.isRead
                                    ? Colors.grey[600]
                                    : colorScheme.onBackground,
                              ),
                        ),
                        Text(
                          timeAgo,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: notification.isRead
                                ? Colors.grey[600]
                                : colorScheme.onBackground,
                          ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
              'https://cdn-icons-png.flaticon.com/512/1827/1827304.png', // example notification off icon png
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              color: Colors.grey[400],
            ),
          const SizedBox(height: 24),
          Text(
            'No Notifications',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _showOnlyUnread
                ? 'You have no unread notifications'
                : 'Your notifications will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return 'Unknown time';
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  void _handleNotificationTap(NotificationItem notification) {
    // Here you would typically handle navigation based on notification type
    // For example:
    // if (notification.title.contains('Order')) {
    //   Navigator.push(context, MaterialPageRoute(
    //     builder: (context) => OrderDetailsScreen(orderId: extractOrderId(notification.message)),
    //   );
    // }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Handling notification: ${notification.title}')),
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final IconData icon;
  final DateTime time;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.time,
    this.isRead = true,
  });
}




// ======================
// Settings Screen
// ======================

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricAuthEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';

  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'INR'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTheme.headlineMedium.copyWith(color: AppTheme.primaryDark),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.backgroundColor,
        iconTheme: const IconThemeData(color: AppTheme.primaryDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings Section
            _buildSectionHeader('Account Settings'),
            _buildSettingsCard(
              children: [
                _buildSettingsItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () => _navigateToEditProfile(),
                ),
                _buildDivider(),
                _buildSettingsItem(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  onTap: () => _navigateToChangePassword(),
                ),
                _buildDivider(),
                _buildSettingsItem(
                  icon: Icons.credit_card,
                  title: 'Payment Methods',
                  onTap: () => _navigateToPaymentMethods(),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // App Preferences Section
            _buildSectionHeader('App Preferences'),
            _buildSettingsCard(
              children: [
                _buildSettingsItem(
                  icon: Icons.notifications_none,
                  title: 'Notifications',
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    activeColor: AppTheme.accentGreen,
                  ),
                ),
                _buildDivider(),
                _buildSettingsItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: _darkModeEnabled,
                    onChanged: (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                    },
                    activeColor: AppTheme.accentGreen,
                  ),
                ),
                _buildDivider(),
                _buildSettingsItem(
                  icon: Icons.fingerprint,
                  title: 'Biometric Authentication',
                  trailing: Switch(
                    value: _biometricAuthEnabled,
                    onChanged: (value) {
                      setState(() {
                        _biometricAuthEnabled = value;
                      });
                    },
                    activeColor: AppTheme.accentGreen,
                  ),
                ),
                _buildDivider(),
                _buildSettingsItem(
                  icon: Icons.language,
                  title: 'Language',
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    underline: Container(),
                    icon: const Icon(Icons.arrow_drop_down, color: AppTheme.textMedium),
                    items: _languages.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: AppTheme.bodyMedium),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage = newValue!;
                      });
                    },
                  ),
                ),
                _buildDivider(),
                _buildSettingsItem(
                  icon: Icons.attach_money,
                  title: 'Currency',
                  trailing: DropdownButton<String>(
                    value: _selectedCurrency,
                    underline: Container(),
                    icon: const Icon(Icons.arrow_drop_down, color: AppTheme.textMedium),
                    items: _currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: AppTheme.bodyMedium),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCurrency = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // More Section
            _buildSectionHeader('More'),
            _buildSettingsCard(
              children: [
                _buildSettingsItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                )),
                _buildDivider(),
                _buildSettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => _openPrivacyPolicy(),
                ),
                _buildDivider(),
                _buildSettingsItem(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () => _openTermsOfService(),
                ),
                _buildDivider(),
                _buildSettingsItem(
                  icon: Icons.star_border,
                  title: 'Rate Our App',
                  onTap: () => _rateApp(),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Logout Button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _confirmLogout,
                  child: Text(
                    'Logout',
                    style: AppTheme.buttonText,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // App Version
            Center(
              child: Text(
                'Version 1.2.3 (Build 456)',
                style: AppTheme.caption.copyWith(color: AppTheme.textLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: AppTheme.headlineSmall.copyWith(color: AppTheme.primaryDark),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.dividerColor, width: 1),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue),
      title: Text(title, style: AppTheme.bodyLarge),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppTheme.textLight),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 24,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: AppTheme.dividerColor),
    );
  }

  void _navigateToEditProfile() {
    // Navigation to edit profile screen
  }

  void _navigateToChangePassword() {
    // Navigation to change password screen
  }

  void _navigateToPaymentMethods() {
    // Navigation to payment methods screen
  }

  void _openPrivacyPolicy() async {
    const url = 'https://yourwebsite.com/privacy';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _openTermsOfService() async {
    const url = 'https://yourwebsite.com/terms';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _rateApp() async {
    const url = 'https://play.google.com/store/apps/details?id=your.package.name';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout', style: AppTheme.headlineSmall),
        content: Text('Are you sure you want to logout?', style: AppTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTheme.bodyMedium.copyWith(color: AppTheme.primaryBlue)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout logic
            },
            child: Text('Logout', style: AppTheme.bodyMedium.copyWith(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
  
  canLaunchUrl(Uri parse) {}
  
  launchUrl(Uri parse) {}
}

// ======================
// Help & Support Screen
// ======================

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);



  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: AppTheme.headlineSmall.copyWith(color: AppTheme.primaryDark),
      ),
    );
  }
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: AppTheme.dividerColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: AppTheme.headlineMedium.copyWith(color: AppTheme.primaryDark),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.backgroundColor,
        iconTheme: const IconThemeData(color: AppTheme.primaryDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FAQ Section
            _buildSectionHeader('FAQs'),
            _buildHelpCard(
              children: [
                _buildHelpItem(
                  title: 'How to track my order?',
                  onTap: () => _showFaqAnswer(context, 
                    'You can track your order in the "My Orders" section. Once shipped, you\'ll receive tracking details via email and in the app.'),
                ),
                _buildDivider(),
                _buildHelpItem(
                  title: 'What is your return policy?',
                  onTap: () => _showFaqAnswer(context,
                    'We accept returns within 30 days of purchase. Items must be unused with original packaging.'),
                ),
                _buildDivider(),
                _buildHelpItem(
                  title: 'How do I cancel an order?',
                  onTap: () => _showFaqAnswer(context,
                    'Orders can be cancelled within 1 hour of placement from the "My Orders" section.'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Contact Support Section
            _buildSectionHeader('Contact Support'),
            _buildHelpCard(
              children: [
                _buildContactItem(
                  icon: Icons.chat_bubble_outline,
                  title: 'Live Chat',
                  subtitle: 'Get instant help from our support team',
                  onTap: () => _startLiveChat(context),
                ),
                _buildDivider(),
                _buildContactItem(
                  icon: Icons.email_outlined,
                  title: 'Email Us',
                  subtitle: 'support@yourapp.com',
                  onTap: () => _sendEmail(context),
                ),
                _buildDivider(),
                _buildContactItem(
                  icon: Icons.phone_outlined,
                  title: 'Call Us',
                  subtitle: '+1 (800) 123-4567',
                  onTap: () => _makePhoneCall(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Help Resources Section
            _buildSectionHeader('Help Resources'),
            _buildHelpCard(
              children: [
                _buildHelpItem(
                  icon: Icons.video_library_outlined,
                  title: 'Video Tutorials',
                  onTap: () => _openVideoTutorials(context),
                ),
                _buildDivider(),
                _buildHelpItem(
                  icon: Icons.article_outlined,
                  title: 'User Guides',
                  onTap: () => _openUserGuides(context),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Report a Problem
            Center(
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.errorColor),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _reportProblem(context),
                  child: Text(
                    'Report a Problem',
                    style: AppTheme.buttonText.copyWith(color: AppTheme.errorColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCard({required List<Widget> children}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.dividerColor, width: 1),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildHelpItem({
    IconData? icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: AppTheme.primaryBlue) : null,
      title: Text(title, style: AppTheme.bodyLarge),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textLight),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue),
      title: Text(title, style: AppTheme.bodyLarge),
      subtitle: Text(subtitle, style: AppTheme.bodySmall),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textLight),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  void _showFaqAnswer(BuildContext context, String answer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('FAQ Answer', style: AppTheme.headlineSmall),
        content: Text(answer, style: AppTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: AppTheme.bodyMedium.copyWith(color: AppTheme.primaryBlue)),
          ),
        ],
      ),
    );
  }

  void _startLiveChat(BuildContext context) {
    // Implement live chat functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connecting you to live chat...')),
    );
  }

  void _sendEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@yourapp.com',
      queryParameters: {'subject': 'App Support Request'},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email client')),
      );
    }
  }

  void _makePhoneCall(BuildContext context) async {
    const url = 'tel:+18001234567';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone app')),
      );
    }
  }

  void _openVideoTutorials(BuildContext context) async {
    const url = 'https://yourwebsite.com/tutorials';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _openUserGuides(BuildContext context) async {
    const url = 'https://yourwebsite.com/guides';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _reportProblem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportProblemScreen()),
    );
  }
  
  canLaunchUrl(Uri emailLaunchUri) {}
  
  launchUrl(Uri parse) {}
}

// ======================
// Report Problem Screen (Nested in Help & Support)
// ======================

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({Key? key}) : super(key: key);

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _problemController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedProblemType;

  final List<String> _problemTypes = [
    'Order Issue',
    'Payment Problem',
    'App Bug',
    'Account Problem',
    'Other'
  ];

  @override
  void dispose() {
    _problemController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Report a Problem',
          style: AppTheme.headlineMedium.copyWith(color: AppTheme.primaryDark),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.backgroundColor,
        iconTheme: const IconThemeData(color: AppTheme.primaryDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Help us understand the problem',
                style: AppTheme.bodyLarge,
              ),
              const SizedBox(height: 16),

              // Problem Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedProblemType,
                decoration: InputDecoration(
                  labelText: 'Problem Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                items: _problemTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: AppTheme.bodyMedium),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedProblemType = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a problem type';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Problem Description
              TextFormField(
                controller: _problemController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Describe your problem',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your problem';
                  }
                  if (value.length < 20) {
                    return 'Please provide more details (at least 20 characters)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Your Email (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty && !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Screenshot Attachment
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Screenshot (optional)',
                    style: AppTheme.bodyMedium.copyWith(color: AppTheme.textMedium),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _attachScreenshot,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.attach_file, color: AppTheme.primaryBlue),
                        const SizedBox(width: 8),
                        Text(
                          'Attach File',
                          style: AppTheme.bodyMedium.copyWith(color: AppTheme.primaryBlue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitProblemReport,
                  child: Text(
                    'Submit Report',
                    style: AppTheme.buttonText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _attachScreenshot() {
    // Implement screenshot attachment logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Screenshot attachment functionality would be implemented here')),
    );
  }

  void _submitProblemReport() {
    if (_formKey.currentState!.validate()) {
      // Submit the problem report
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your report! We\'ll get back to you soon.')),
      );
      Navigator.pop(context);
    }
  }
}