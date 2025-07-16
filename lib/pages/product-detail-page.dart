import 'package:flutter/material.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/main.dart';

// ==================== DTO Classes ====================
class ProductDto {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final List<String> imageUrls;
  final int stock;
  final List<String> features;
  final Map<String, String> specifications;
  final VendorDto vendor;
  final List<OfferDto> offers;
  final List<ReviewDto> reviews;
  final List<ProductDto> relatedProducts;

  ProductDto({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.imageUrls,
    required this.stock,
    required this.features,
    required this.specifications,
    required this.vendor,
    required this.offers,
    required this.reviews,
    required this.relatedProducts,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  double get discountPercentage => hasDiscount 
      ? ((originalPrice! - price) / originalPrice! * 100) 
      : 0;
  String get stockStatus {
    if (stock <= 0) return 'Out of Stock';
    if (stock <= 5) return 'Limited Stock';
    return 'In Stock';
  }
  Color get stockColor {
    if (stock <= 0) return AppTheme.warningColor;
    if (stock <= 5) return AppTheme.accentOrange;
    return AppTheme.accentGreen;
  }
}

class VendorDto {
  final String id;
  final String name;
  final String? logoUrl;
  final double rating;
  final int reviewCount;

  VendorDto({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviewCount,
    this.logoUrl,
  });
}

class OfferDto {
  final String title;
  final String description;
  final IconData icon;

  OfferDto({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class ReviewDto {
  final String id;
  final String author;
  final String date;
  final String title;
  final String content;
  final int rating;
  final List<String>? imageUrls;

  ReviewDto({
    required this.id,
    required this.author,
    required this.date,
    required this.title,
    required this.content,
    required this.rating,
    this.imageUrls,
  });
}

// ==================== Dummy Data ====================
class DummyData {
  static ProductDto generateProduct() {
    return ProductDto(
      id: 'prod_123',
      title: 'Premium Wireless Headphones with Noise Cancellation',
      description: 'Experience premium sound quality with our latest wireless headphones. '
          'Featuring active noise cancellation, 30-hour battery life, and comfortable '
          'over-ear design for extended listening sessions.',
      price: 3499,
      originalPrice: 4999,
      rating: 4.5,
      reviewCount: 1234,
      imageUrls: [
        'https://via.placeholder.com/600x600?text=Headphones+Front',
        'https://via.placeholder.com/600x600?text=Headphones+Side',
        'https://via.placeholder.com/600x600?text=Headphones+Case',
      ],
      stock: 15,
      features: [
        'Active Noise Cancellation (ANC) technology',
        '30 hours of playtime with quick charge (5 min = 4 hrs)',
        'Bluetooth 5.0 with 10m range',
        'Built-in microphone for calls',
        'Foldable design with carrying case',
      ],
      specifications: {
        'Brand': 'AudioPro',
        'Model': 'AP-WH100',
        'Color': 'Black',
        'Battery': '30 hours',
        'Weight': '256g',
        'Connectivity': 'Bluetooth 5.0',
        'Driver Size': '40mm',
      },
      vendor: VendorDto(
        id: 'vendor_456',
        name: 'AudioPro Store',
        rating: 4.7,
        reviewCount: 2456,
        logoUrl: 'https://via.placeholder.com/100?text=AudioPro',
      ),
      offers: [
        OfferDto(
          title: 'First Order Discount',
          description: '10% off on first order. Use code WELCOME10',
          icon: Icons.local_offer,
        ),
        OfferDto(
          title: 'Free Gift',
          description: 'Get free earbuds on orders above ₹5,000',
          icon: Icons.card_giftcard,
        ),
        OfferDto(
          title: 'Free Shipping',
          description: 'Free shipping on orders above ₹500',
          icon: Icons.local_shipping,
        ),
      ],
      reviews: [
        ReviewDto(
          id: 'rev_001',
          author: 'Rahul Sharma',
          date: '2 days ago',
          title: 'Excellent sound quality',
          content: 'The noise cancellation is amazing. Battery life is as advertised. Very comfortable for long sessions.',
          rating: 5,
          imageUrls: [
            'https://via.placeholder.com/100?text=Review+1',
            'https://via.placeholder.com/100?text=Review+2',
          ],
        ),
        ReviewDto(
          id: 'rev_002',
          author: 'Priya Patel',
          date: '1 week ago',
          title: 'Good but could be better',
          content: 'Sound is great but the ear cushions could be more comfortable. Battery life is good though.',
          rating: 4,
        ),
      ],
      relatedProducts: [
        ProductDto(
          id: 'prod_124',
          title: 'Wireless Earbuds Pro',
          description: 'Premium wireless earbuds with active noise cancellation',
          price: 2499,
          originalPrice: 3999,
          rating: 4.0,
          reviewCount: 567,
          imageUrls: ['https://via.placeholder.com/600x600?text=Earbuds'],
          stock: 8,
          features: [],
          specifications: {},
          vendor: VendorDto(
            id: 'vendor_456',
            name: 'AudioPro Store',
            rating: 4.7,
            reviewCount: 2456,
          ),
          offers: [],
          reviews: [],
          relatedProducts: [],
        ),
        ProductDto(
          id: 'prod_125',
          title: 'Bluetooth Speaker',
          description: 'Portable waterproof bluetooth speaker',
          price: 1999,
          originalPrice: 2999,
          rating: 4.2,
          reviewCount: 342,
          imageUrls: ['https://via.placeholder.com/600x600?text=Speaker'],
          stock: 12,
          features: [],
          specifications: {},
          vendor: VendorDto(
            id: 'vendor_456',
            name: 'AudioPro Store',
            rating: 4.7,
            reviewCount: 2456,
          ),
          offers: [],
          reviews: [],
          relatedProducts: [],
        ),
      ],
    );
  }
}

// ==================== UI Constants ====================



class AppDimensions {
  static const double cardBorderRadius = 12;
  static const double cardElevation = 2;
  static const double cardPadding = 16;
  static const double sectionSpacing = 8;
  static const double elementSpacing = 12;
  static const double smallElementSpacing = 8;
}

// ==================== Main Widget ====================
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late ProductDto product;
  int _quantity = 1;
  final PageController _imageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    product = DummyData.generateProduct();
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Product Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareProduct,
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImages(),
            _buildProductInfo(),
            _buildOffersAndDelivery(),
            _buildProductDescription(),
            _buildVendorInfo(),
            _buildCustomerReviews(),
            _buildRecommendations(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  // ==================== UI Components ====================
  Widget _buildProductImages() {
    return Stack(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _imageController,
            itemCount: product.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showFullScreenImage(index),
                child: Container(
                  color: AppTheme.cardBackground,
                  child: Image.network(
                    product.imageUrls[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(product.imageUrls.length, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index
                      ? AppTheme.primaryBlue
                      : AppTheme.textLight,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      margin: const EdgeInsets.only(bottom: AppDimensions.sectionSpacing),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.title, style: AppTheme.headlineMedium),
          const SizedBox(height: AppDimensions.smallElementSpacing),
          Row(
            children: [
              _buildRatingStars(product.rating),
              const SizedBox(width: AppDimensions.smallElementSpacing),
              Text(
                '${product.rating} (${product.reviewCount} reviews)',
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.elementSpacing),
          Row(
            children: [
              Text(
                '₹${product.price.toInt()}',
                style: AppTheme.headlineLarge.copyWith(
                  color: AppTheme.primaryBlue,
                ),
              ),
              if (product.hasDiscount) ...[
                const SizedBox(width: AppDimensions.smallElementSpacing),
                Text(
                  '₹${product.originalPrice!.toInt()}',
                  style: AppTheme.bodyLarge.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(width: AppDimensions.smallElementSpacing),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${product.discountPercentage.toInt()}% OFF',
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.accentGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppDimensions.elementSpacing),
          Row(
            children: [
              Icon(
                product.stock > 0 ? Icons.check_circle : Icons.error,
                color: product.stockColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                product.stockStatus,
                style: AppTheme.bodyMedium.copyWith(
                  color: product.stockColor,
                ),
              ),
              const Spacer(),
              Text(
                'Delivery by Tomorrow',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.elementSpacing),
          Row(
            children: [
              Text('Quantity:', style: AppTheme.bodyLarge),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: _decrementQuantity,
                    ),
                    Text('$_quantity', style: AppTheme.bodyLarge),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: _incrementQuantity,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOffersAndDelivery() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      margin: const EdgeInsets.only(bottom: AppDimensions.sectionSpacing),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Offers & Delivery', style: AppTheme.headlineSmall),
          const SizedBox(height: AppDimensions.elementSpacing),
          ...product.offers.map((offer) => _buildOfferItem(offer)).toList(),
          const Divider(height: 24),
          _buildDeliveryInfoItem(
            Icons.calendar_today,
            'Delivery by: Tomorrow, 10 AM - 6 PM',
          ),
          _buildDeliveryInfoItem(
            Icons.location_on,
            'Deliver to: Home (Change)',
          ),
          _buildDeliveryInfoItem(
            Icons.assignment_return,
            '7-day easy returns. 1-year manufacturer warranty',
          ),
        ],
      ),
    );
  }

  Widget _buildProductDescription() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      margin: const EdgeInsets.only(bottom: AppDimensions.sectionSpacing),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: AppTheme.headlineSmall),
          const SizedBox(height: AppDimensions.elementSpacing),
          Text(product.description, style: AppTheme.bodyLarge),
          const SizedBox(height: AppDimensions.elementSpacing),
          Text('Key Features', style: AppTheme.headlineSmall),
          const SizedBox(height: AppDimensions.smallElementSpacing),
          ...product.features.map((feature) => _buildBulletPoint(feature)).toList(),
          const SizedBox(height: AppDimensions.elementSpacing),
          Text('Specifications', style: AppTheme.headlineSmall),
          const SizedBox(height: AppDimensions.smallElementSpacing),
          ...product.specifications.entries.map(
            (entry) => _buildSpecificationRow(entry.key, entry.value),
          ).toList(),
        ],
      ),
    );
  }

  Widget _buildVendorInfo() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      margin: const EdgeInsets.only(bottom: AppDimensions.sectionSpacing),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.dividerColor,
                backgroundImage: product.vendor.logoUrl != null 
                    ? NetworkImage(product.vendor.logoUrl!)
                    : null,
                child: product.vendor.logoUrl == null
                    ? const Icon(Icons.store, size: 20)
                    : null,
              ),
              const SizedBox(width: AppDimensions.elementSpacing),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.vendor.name, style: AppTheme.headlineSmall),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      _buildRatingStars(product.vendor.rating),
                      const SizedBox(width: 4),
                      Text(
                        '${product.vendor.rating} (${product.vendor.reviewCount} reviews)',
                        style: AppTheme.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.elementSpacing),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _viewVendorStore,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('View Store', style: AppTheme.bodyMedium),
                ),
              ),
              const SizedBox(width: AppDimensions.elementSpacing),
              Expanded(
                child: ElevatedButton(
                  onPressed: _toggleFollowVendor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Follow', style: AppTheme.buttonText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerReviews() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      margin: const EdgeInsets.only(bottom: AppDimensions.sectionSpacing),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Customer Reviews', style: AppTheme.headlineSmall),
              TextButton(
                onPressed: _viewAllReviews,
                child: Text(
                  'See All',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.elementSpacing),
          Row(
            children: [
              Column(
                children: [
                  Text(product.rating.toString(), style: AppTheme.headlineLarge),
                  _buildRatingStars(product.rating),
                  Text('${product.reviewCount} reviews', style: AppTheme.caption),
                ],
              ),
              const SizedBox(width: AppDimensions.elementSpacing),
              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar(5, 80),
                    _buildRatingBar(4, 15),
                    _buildRatingBar(3, 3),
                    _buildRatingBar(2, 1),
                    _buildRatingBar(1, 1),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.elementSpacing),
          ...product.reviews.take(2).map((review) => Column(
            children: [
              _buildReviewItem(review),
              if (review != product.reviews.last) const Divider(height: 24),
            ],
          )).toList(),
          const SizedBox(height: AppDimensions.elementSpacing),
          ElevatedButton(
            onPressed: _writeReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Write a Review', style: AppTheme.buttonText),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('You May Also Like', style: AppTheme.headlineSmall),
          const SizedBox(height: AppDimensions.elementSpacing),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: product.relatedProducts.length,
              itemBuilder: (context, index) {
                final relatedProduct = product.relatedProducts[index];
                return GestureDetector(
                  onTap: () => _viewProduct(relatedProduct),
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: AppDimensions.elementSpacing),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(
                                relatedProduct.imageUrls.first,
                                scale: 1.0,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.smallElementSpacing),
                        Text(
                          relatedProduct.title,
                          style: AppTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        _buildRatingStars(relatedProduct.rating),
                        const SizedBox(height: 4),
                        Text(
                          '₹${relatedProduct.price.toInt()}',
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        if (relatedProduct.hasDiscount)
                          Text(
                            '₹${relatedProduct.originalPrice!.toInt()}',
                            style: AppTheme.caption.copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppDimensions.elementSpacing),
          Text('Frequently Bought Together', style: AppTheme.headlineSmall),
          const SizedBox(height: AppDimensions.elementSpacing),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: const DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/100?text=Accessory'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text('Accessory ${index + 1}', style: AppTheme.bodyMedium),
                subtitle: Text('₹${(index + 1) * 499}', style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryBlue,
                )),
                trailing: Checkbox(
                  value: index == 0,
                  onChanged: (value) {},
                  activeColor: AppTheme.primaryBlue,
                ),
              );
            },
          ),
          const SizedBox(height: AppDimensions.elementSpacing),
          Row(
            children: [
              Text('Total:', style: AppTheme.bodyLarge),
              const Spacer(),
              Text('₹${(product.price + 499).toInt()}', style: AppTheme.headlineSmall.copyWith(
                color: AppTheme.primaryBlue,
              )),
            ],
          ),
          const SizedBox(height: AppDimensions.smallElementSpacing),
          ElevatedButton(
            onPressed: _addBundleToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentGreen,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Add All to Cart', style: AppTheme.buttonText),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _addToCart,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: AppTheme.primaryBlue),
                ),
                child: Text('Add to Cart', style: AppTheme.buttonText.copyWith(
                  color: AppTheme.primaryBlue,
                )),
              ),
            ),
            const SizedBox(width: AppDimensions.elementSpacing),
            Expanded(
              child: ElevatedButton(
                onPressed: _buyNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Buy Now', style: AppTheme.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Helper Widgets ====================
  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: AppTheme.accentOrange,
          size: 16,
        );
      }),
    );
  }

  Widget _buildOfferItem(OfferDto offer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.smallElementSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(offer.icon, color: AppTheme.primaryBlue, size: 16),
          const SizedBox(width: AppDimensions.smallElementSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer.title, style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                )),
                Text(offer.description, style: AppTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.smallElementSpacing),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textMedium, size: 16),
          const SizedBox(width: AppDimensions.smallElementSpacing),
          Text(text, style: AppTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•', style: TextStyle(fontSize: 16)),
          const SizedBox(width: AppDimensions.smallElementSpacing),
          Expanded(child: Text(text, style: AppTheme.bodyLarge)),
        ],
      ),
    );
  }

  Widget _buildSpecificationRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(title, style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textMedium,
            )),
          ),
          Text(value, style: AppTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, int percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text('$stars★', style: AppTheme.caption),
          const SizedBox(width: AppDimensions.smallElementSpacing),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppTheme.dividerColor,
              color: AppTheme.accentOrange,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: AppDimensions.smallElementSpacing),
          Text('$percentage%', style: AppTheme.caption),
        ],
      ),
    );
  }

  Widget _buildReviewItem(ReviewDto review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.dividerColor,
              child: Icon(Icons.person, size: 16, color: AppTheme.textMedium),
            ),
            const SizedBox(width: AppDimensions.smallElementSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.author, style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                )),
                Text(review.date, style: AppTheme.caption),
              ],
            ),
            const Spacer(),
            _buildRatingStars(review.rating.toDouble()),
          ],
        ),
        const SizedBox(height: AppDimensions.smallElementSpacing),
        Text(review.title, style: AppTheme.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        )),
        const SizedBox(height: 4),
        Text(review.content, style: AppTheme.bodyMedium),
        if (review.imageUrls != null && review.imageUrls!.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.smallElementSpacing),
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: review.imageUrls!.map((url) {
                return Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(right: AppDimensions.smallElementSpacing),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  // ==================== Action Handlers ====================
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _showFullScreenImage(int index) {
    // Implement full screen image viewer with zoom capability
  }

  void _shareProduct() {
    // Implement share functionality
  }

  void _toggleFavorite() {
    // Implement favorite toggle
  }

  void _viewVendorStore() {
    // Navigate to vendor store
  }

  void _toggleFollowVendor() {
    // Implement follow vendor functionality
  }

  void _viewAllReviews() {
    // Navigate to all reviews page
  }

  void _writeReview() {
    // Navigate to review writing page
  }

  void _viewProduct(ProductDto product) {
    // Navigate to product detail page
  }

  void _addToCart() {
    // Implement add to cart functionality
  }

  void _buyNow() {
    // Implement buy now functionality
  }

  void _addBundleToCart() {
    // Implement add bundle to cart functionality
  }
}