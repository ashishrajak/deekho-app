import 'package:flutter/material.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/main.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/pages/StoreDetailPage.dart';


class ViewDealPage extends StatefulWidget {
  final OfferingServiceDTO offering;

  const ViewDealPage({Key? key, required this.offering}) : super(key: key);

  @override
  _ViewDealPageState createState() => _ViewDealPageState();
}

class _ViewDealPageState extends State<ViewDealPage> {
  bool _isWishlisted = false;
  int _selectedQuantity = 1;
  int _currentImageIndex = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildOfferingInfo(),
                _buildServiceSection(),
                _buildVendorInfo(),
                _buildRatingsSection(),
                _buildSimilarOffers(),
                _buildSimilarVendors(),
                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppTheme.cardColor,
      leading: Container(
        margin: const EdgeInsets.all(AppTheme.spacingS),
        decoration: BoxDecoration(
          color: AppTheme.cardColor.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: const [AppTheme.cardShadow],
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(AppTheme.spacingS),
          decoration: BoxDecoration(
            color: AppTheme.cardColor.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: const [AppTheme.cardShadow],
          ),
          child: IconButton(
            icon: Icon(
              _isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: _isWishlisted ? AppTheme.accentColor : AppTheme.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _isWishlisted = !_isWishlisted;
              });
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(AppTheme.spacingS),
          decoration: BoxDecoration(
            color: AppTheme.cardColor.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: const [AppTheme.cardShadow],
          ),
          child: IconButton(
            icon: Icon(Icons.share, color: AppTheme.textSecondary),
            onPressed: () {
              // Share functionality
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: widget.offering.mediaItems.length > 0 ? widget.offering.mediaItems.length : 1,
              itemBuilder: (context, index) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                  ),
                  child: widget.offering.mediaItems.isNotEmpty
                      ? Image.network(
                          widget.offering.mediaItems[index].mediaUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.image, size: 64, color: Colors.white),
                        )
                      : const Icon(Icons.image, size: 64, color: Colors.white),
                );
              },
            ),
            // Discount badge
            if (widget.offering.primaryPricing.discount != null)
              Positioned(
                top: 60,
                left: AppTheme.spacingM,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingS,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppTheme.offerGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Text(
                    '${widget.offering.primaryPricing.discount} OFF',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // Image indicators
            if (widget.offering.mediaItems.length > 1)
              Positioned(
                bottom: AppTheme.spacingM,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.offering.mediaItems.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXS),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferingInfo() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: const [AppTheme.elevatedShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.offering.title,
            style: AppTheme.headlineLarge,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            widget.offering.description,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              Text(
                '₹${widget.offering.primaryPricing.basePrice.amount}',
                style: AppTheme.headlineLarge.copyWith(
                  color: AppTheme.secondaryColor,
                  fontSize: 28,
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              if (widget.offering.primaryPricing.discount != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Save ${widget.offering.primaryPricing.discount}',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.secondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          _buildOfferingDetails(),
        ],
      ),
    );
  }

  Widget _buildOfferingDetails() {
    return Column(
      children: [
        if (widget.offering.timing.durationMinutes != null)
          _buildDetailRow(
            Icons.access_time,
            'Duration',
            '${widget.offering.timing.durationMinutes} minutes',
          ),
        const SizedBox(height: AppTheme.spacingS),
        _buildDetailRow(
          Icons.verified,
          'Status',
          widget.offering.verified ? 'Verified' : 'Not Verified',
        ),
        const SizedBox(height: AppTheme.spacingS),
        if (widget.offering.geography.serviceArea != null)
          _buildDetailRow(
            Icons.location_on,
            'Service Area',
            widget.offering.geography.serviceArea!,
          ),
        if (widget.offering.timing.emergencyService)
          const SizedBox(height: AppTheme.spacingS),
        if (widget.offering.timing.emergencyService)
          _buildDetailRow(
            Icons.emergency,
            'Emergency Service',
            'Available 24/7',
          ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: AppTheme.spacingS),
        Text(
          '$label: ',
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: const [AppTheme.elevatedShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Details',
            style: AppTheme.headlineMedium,
          ),
          const SizedBox(height: AppTheme.spacingM),
          _buildServiceDetails(),
          const SizedBox(height: AppTheme.spacingM),
          _buildQuantitySelector(),
        ],
      ),
    );
  }

  Widget _buildServiceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            border: Border.all(
              color: AppTheme.borderColor,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category: ${widget.offering.category}',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                'Pricing Type: ${widget.offering.primaryPricing.type.toString().split('.').last}',
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spacingS),
              if (widget.offering.timing.availableDays.isNotEmpty)
                Text(
                  'Available Days: ${widget.offering.timing.availableDays.join(', ')}',
                  style: AppTheme.bodyMedium,
                ),
              if (widget.offering.timing.startTime != null && widget.offering.timing.endTime != null)
                const SizedBox(height: AppTheme.spacingS),
              if (widget.offering.timing.startTime != null && widget.offering.timing.endTime != null)
                Text(
                  'Hours: ${widget.offering.timing.startTime} - ${widget.offering.timing.endTime}',
                  style: AppTheme.bodyMedium,
                ),
            ],
          ),
        ),
        if (widget.offering.tags.isNotEmpty)
          const SizedBox(height: AppTheme.spacingM),
        if (widget.offering.tags.isNotEmpty)
          Wrap(
            spacing: AppTheme.spacingS,
            runSpacing: AppTheme.spacingS,
            children: widget.offering.tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
              child: Text(
                tag,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        Text(
          'Quantity:',
          style: AppTheme.headlineSmall,
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderColor),
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: _selectedQuantity > 1 ? () {
                  setState(() {
                    _selectedQuantity--;
                  });
                } : null,
                icon: const Icon(Icons.remove),
                iconSize: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingS,
                ),
                child: Text(
                  '$_selectedQuantity',
                  style: AppTheme.headlineSmall,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedQuantity++;
                  });
                },
                icon: const Icon(Icons.add),
                iconSize: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVendorInfo() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: const [AppTheme.elevatedShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Icon(
                  Icons.store,
                  size: 30,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Provider',
                      style: AppTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber[600]),
                        const SizedBox(width: AppTheme.spacingXS),
                        Text(
                          '4.5 (120 reviews)',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  // Navigate to vendor profile
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                ),
                child: Text(
                  'View Store',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          _buildVendorDetails(),
        ],
      ),
    );
  }

  Widget _buildVendorDetails() {
    return Column(
      children: [
        if (widget.offering.geography.serviceArea != null)
          _buildDetailRow(
            Icons.location_on,
            'Service Area',
            widget.offering.geography.serviceArea!,
          ),
        const SizedBox(height: AppTheme.spacingS),
        _buildDetailRow(Icons.phone, 'Contact', '+91 98765 43210'),
        const SizedBox(height: AppTheme.spacingS),
        if (widget.offering.timing.startTime != null && widget.offering.timing.endTime != null)
          _buildDetailRow(
            Icons.access_time,
            'Hours',
            '${widget.offering.timing.startTime} - ${widget.offering.timing.endTime}',
          ),
      ],
    );
  }

  Widget _buildRatingsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: const [AppTheme.elevatedShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews & Ratings',
            style: AppTheme.headlineMedium,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              Text(
                '4.5',
                style: AppTheme.headlineLarge.copyWith(
                  fontSize: 48,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (index) => Icon(
                        Icons.star,
                        size: 20,
                        color: index < 4 ? Colors.amber[600] : Colors.grey[300],
                      )),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    Text(
                      'Based on 120 reviews',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          TextButton(
            onPressed: () {
              // Show all reviews
            },
            child: Text(
              'View all reviews',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarOffers() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Similar Offers',
            style: AppTheme.headlineLarge,
          ),
          const SizedBox(height: AppTheme.spacingM),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) => _buildSimilarOfferCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarOfferCard() {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: const [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusM)),
            ),
            child: const Center(
              child: Icon(Icons.image, size: 40, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Similar Deal Title',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Row(
                  children: [
                    Text(
                      '₹299',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Text(
                      '₹199',
                      style: AppTheme.headlineSmall.copyWith(
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingS,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                      ),
                      child: Text(
                        '33% OFF',
                        style: AppTheme.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildSimilarVendors() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Similar Vendors',
            style: AppTheme.headlineLarge,
          ),
          const SizedBox(height: AppTheme.spacingM),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) => _buildSimilarVendorCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarVendorCard() {
    return GestureDetector(
      onTap: () {
        // Navigate to the store detail page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreDetailPage(
              store: MockStoreService.getStoreDetails(),
            ),
          ),
        );
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: AppTheme.spacingM),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          boxShadow: const [AppTheme.cardShadow],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.store,
                size: 24,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Store Name',
              style: AppTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '2.5 km',
              style: AppTheme.caption.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        boxShadow: const [AppTheme.elevatedShadow],
      ),
      child: SafeArea(
        child: Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _isWishlisted = !_isWishlisted;
                });
              },
              icon: Icon(
                _isWishlisted ? Icons.favorite : Icons.favorite_border,
                color: _isWishlisted ? AppTheme.accentColor : AppTheme.textSecondary,
              ),
              label: const Text('Wishlist'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textSecondary,
                side: BorderSide(color: AppTheme.borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingM,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _showOrderConfirmation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                ),
                child: Text(
                  'Order Now - ₹${(widget.offering.primaryPricing.basePrice.amount * _selectedQuantity).toStringAsFixed(0)}',
                  style: AppTheme.headlineSmall.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


void _showOrderConfirmation() {
  // Calculate the total price using basePrice from the DTO
  final double unitPrice = widget.offering.primaryPricing.basePrice.amount;
  final double totalPrice = unitPrice * _selectedQuantity;
  final String currency = widget.offering.primaryPricing.basePrice.currency;
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusL)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Confirm Your Order',
              style: AppTheme.headlineLarge,
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            // Order Summary Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: const [AppTheme.cardShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.offering.title,
                    style: AppTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  
                  // Service description
                  Text(
                    widget.offering.description,
                    style: AppTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity:',
                        style: AppTheme.bodyMedium,
                      ),
                      Text(
                        '$_selectedQuantity',
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  
                  // Unit price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Unit Price:',
                        style: AppTheme.bodyMedium,
                      ),
                      Text(
                        '$currency ${unitPrice.toStringAsFixed(2)}',
                        style: AppTheme.bodyMedium,
                      ),
                    ],
                  ),
                  
                  // Show discount if available
                  if (widget.offering.primaryPricing.discount != null && 
                      widget.offering.primaryPricing.discount!.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.spacingS),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discount:',
                          style: AppTheme.bodyMedium,
                        ),
                        Text(
                          widget.offering.primaryPricing.discount!,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  const SizedBox(height: AppTheme.spacingM),
                  Container(
                    height: 1,
                    color: AppTheme.borderColor,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: AppTheme.headlineMedium,
                      ),
                      Text(
                        '$currency ${totalPrice.toStringAsFixed(2)}',
                        style: AppTheme.headlineMedium.copyWith(
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Service Details
            Text(
              'Service Information',
              style: AppTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            // Service area
            if (widget.offering.geography.serviceArea != null) ...[
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    'Service Area: ${widget.offering.geography.serviceArea}',
                    style: AppTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingS),
            ],
            
            // Timing information
            if (widget.offering.timing.durationMinutes != null) ...[
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    'Duration: ${widget.offering.timing.durationMinutes} minutes',
                    style: AppTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingS),
            ],
            
            // Available days
            if (widget.offering.timing.availableDays.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: Text(
                      'Available: ${widget.offering.timing.availableDays.join(', ')}',
                      style: AppTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
            
            // Emergency service badge
            if (widget.offering.timing.emergencyService) ...[
              const SizedBox(height: AppTheme.spacingS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingS,
                  vertical: AppTheme.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: Text(
                  '🚨 Emergency Service Available',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            
            const Spacer(),
            
            // Confirm Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: const [AppTheme.elevatedShadow],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Order placed successfully!'),
                      backgroundColor: AppTheme.secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                ),
                child: Text(
                  'Confirm Order',
                  style: AppTheme.headlineSmall.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}