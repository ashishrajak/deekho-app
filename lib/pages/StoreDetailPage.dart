import 'package:flutter/material.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/main.dart';


class StoreDetailPage extends StatelessWidget {
  final Store store;

  const StoreDetailPage({super.key, required this.store});

  @override
  Widget build(BuildContext context) {

final similarStores = [
  Store(
    id: "1",
    name: "Natural Essentials",
    image: "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035",
    rating: 4.5,
    reviewCount: 120,
    distanceKm: 2.5,
    openUntil: "9:00 PM",
    isOpen: true,
    offers: ["20% off on skincare", "Buy 1 Get 1 Free"],
    products: [],
    description: "Your go-to store for natural beauty products.",
  ),
  Store(
    id: "2",
    name: "Beauty Mart",
    image: "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035",
    rating: 4.2,
    reviewCount: 85,
    distanceKm: 3.0,
    openUntil: "8:30 PM",
    isOpen: false,
    offers: ["Flat 30% off on cosmetics"],
    products: [],
    description: "A wide range of beauty products at affordable prices.",
  ),
  Store(
    id: "3",
    name: "Glow & Shine",
    image: "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035",
    rating: 4.8,
    reviewCount: 200,
    distanceKm: 1.8,
    openUntil: "10:00 PM",
    isOpen: true,
    offers: ["Free gift on purchases above ₹500"],
    products: [],
    description: "Premium beauty products to make you shine.",
  ),
];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(store.name, style: AppTheme.headlineSmall),
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StoreBanner(image: store.image),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StoreHeader(store: store),
                  const SizedBox(height: 16),
                  StoreOffers(offers: store.offers),
                  const SizedBox(height: 24),
                  ProductList(products: store.products),
                  const SizedBox(height: 24),
                  StoreInfo(store: store),
                  const SizedBox(height: 24),
                  StoreDescription(description: store.description),
                  const SizedBox(height: 24),
                  SimilarStoresSection(stores:similarStores),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: StoreActions(store: store),
    );
  }
}

// Store Model
class Store {
  final String id;
  final String name;
  final String image;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final String openUntil;
  final bool isOpen;
  final List<String> offers;
  final List<Product> products;
  final String description;

  Store({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.openUntil,
    required this.isOpen,
    required this.offers,
    required this.products,
    required this.description,
  }); 
   String get imageUrl => image; 
}



// Mock Store Service
class MockStoreService {
  static Store getStoreDetails() {
    return Store(
      id: "store_01",
      name: "Raju Kirana",
      image: "https://media.istockphoto.com/id/1546442230/photo/front-view-skin-care-products-on-wooden-decorative-piece.jpg?s=1024x1024&w=is&k=20&c=utXxCEPrmozE0u-woUmPPVn1pzVY3JqItihbWNsERa0=",
      rating: 4.6,
      reviewCount: 120,
      distanceKm: 1.2,
      openUntil: "10:00 PM",
      isOpen: true,
      offers: [
        "20% off above ₹500",
        "Buy 1 Get 1 Free on Soap",
        "Free delivery on orders above ₹300",
      ],
      products: [
        Product(
          id: "p1",
          name: "Wheat Flour 5kg",
          price: 250,
           image: "https://media.istockphoto.com/id/1546442230/photo/front-view-skin-care-products-on-wooden-decorative-piece.jpg?s=1024x1024&w=is&k=20&c=utXxCEPrmozE0u-woUmPPVn1pzVY3JqItihbWNsERa0=",
      
        ),
        Product(
          id: "p2",
          name: "Detergent Powder",
          price: 120,
           image: "https://media.istockphoto.com/id/1546442230/photo/front-view-skin-care-products-on-wooden-decorative-piece.jpg?s=1024x1024&w=is&k=20&c=utXxCEPrmozE0u-woUmPPVn1pzVY3JqItihbWNsERa0=",
      
        ),
        Product(
          id: "p3",
          name: "Toothpaste",
          price: 85,
           image: "https://media.istockphoto.com/id/1546442230/photo/front-view-skin-care-products-on-wooden-decorative-piece.jpg?s=1024x1024&w=is&k=20&c=utXxCEPrmozE0u-woUmPPVn1pzVY3JqItihbWNsERa0=",
      
        ),
        Product(
          id: "p4",
          name: "Cooking Oil 1L",
          price: 180,
          image: "https://media.istockphoto.com/id/1546442230/photo/front-view-skin-care-products-on-wooden-decorative-piece.jpg?s=1024x1024&w=is&k=20&c=utXxCEPrmozE0u-woUmPPVn1pzVY3JqItihbWNsERa0=",
      
        ),
      ],
      description:
          "We've been serving since 1992 with a passion for quality and community care. Our family-run store takes pride in offering the freshest groceries at competitive prices.",
    );
  }
}

// Component: Store Banner
class StoreBanner extends StatelessWidget {
  final String image;

  const StoreBanner({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Image.network(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}

// Component: Store Header
class StoreHeader extends StatelessWidget {
  final Store store;

  const StoreHeader({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          store.name,
          style: AppTheme.headlineMedium.copyWith(
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Quality You Can Trust",
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textMedium,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.star, color: AppTheme.accentOrange, size: 20),
            const SizedBox(width: 4),
            Text(
              "${store.rating} (${store.reviewCount} reviews)",
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(width: 16),
            Icon(Icons.location_on, color: AppTheme.primaryBlue, size: 20),
            const SizedBox(width: 4),
            Text(
              "${store.distanceKm} km away",
              style: AppTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: store.isOpen ? AppTheme.successColor.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                size: 10,
                color: store.isOpen ? AppTheme.successColor : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                store.isOpen ? "Open until ${store.openUntil}" : "Closed now",
                style: AppTheme.bodyMedium.copyWith(
                  color: store.isOpen ? AppTheme.successColor : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Component: Store Offers
class StoreOffers extends StatelessWidget {
  final List<String> offers;

  const StoreOffers({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current Offers",
          style: AppTheme.headlineSmall.copyWith(
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: offers.length,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  color: AppTheme.accentOrange.withOpacity(0.1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: AppTheme.accentOrange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.local_offer,
                          color: AppTheme.accentOrange,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          offers[index],
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Component: Product List
class ProductList extends StatelessWidget {
  final List<Product> products;

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final crossAxisCount = isWide ? 3 : 2;
    final childAspectRatio = isWide ? 0.9 : 0.8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Available Products",
          style: AppTheme.headlineSmall.copyWith(
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: AppTheme.dividerColor,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        product.image,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      product.name,
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${product.price.toStringAsFixed(2)}",
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 36),
                      ),
                      child: const Text("Add to Cart"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Component: Store Info
class StoreInfo extends StatelessWidget {
  final Store store;

  const StoreInfo({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Store Information",
              style: AppTheme.headlineSmall.copyWith(
                color: AppTheme.primaryDark,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.access_time, "Timings", "9:00 AM - ${store.openUntil}"),
            const Divider(height: 24),
            _buildInfoRow(Icons.location_on, "Address", "123 Main Street, City"),
            const Divider(height: 24),
            _buildInfoRow(Icons.phone, "Contact", "+91 9876543210"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.primaryBlue, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textMedium,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Component: Store Description
class StoreDescription extends StatelessWidget {
  final String description;

  const StoreDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Us",
          style: AppTheme.headlineSmall.copyWith(
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textMedium,
          ),
        ),
      ],
    );
  }
}

// Component: Similar Stores
class SimilarStoresSection extends StatelessWidget {
  final List<Store> stores;

  const SimilarStoresSection({super.key, required this.stores});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Similar Nearby Stores",
          style: AppTheme.headlineSmall.copyWith(
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stores.length,
            itemBuilder: (context, index) {
              final store = stores[index];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: AppTheme.dividerColor,
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreDetailPage(
                            store: store,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              store.imageUrl,
                            
                             
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            store.name,
                            style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star, color: AppTheme.accentOrange, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "${store.rating}",
                                style: AppTheme.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


// Component: Store Actions (Bottom Bar)
class StoreActions extends StatelessWidget {
  final Store store;

  const StoreActions({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat),
                label: const Text("Chat"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call),
                label: const Text("Call"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
