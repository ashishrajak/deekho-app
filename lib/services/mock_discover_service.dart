import '../models/discover_models.dart';

class MockDiscoverService {
  static List<Deal> getTopOffers() => [
        Deal(
          title: "20% off Fresh Mart",
          store: "Fresh Mart",
          image: "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035",
          distance: 1.2,
          discountPercent: 20,
          discountedPrice: 80,
          originalPrice: 100,
        ),
        Deal(
          title: "Buy 1 Get 1 Pizza",
          store: "Pizza Hub",
          image: "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035",
          distance: 0.8,
          discountPercent: 50,
          discountedPrice: 200,
          originalPrice: 400,
        ),
      ];

  static List<Category> getTrendingCategories() => [
        Category(name: "Food Deals", emoji: "🍔"),
        Category(name: "Salon Offers", emoji: "💇"),
        Category(name: "Quick Grocery", emoji: "🛒"),
        Category(name: "Electronics", emoji: "📱"),
      ];

  static List<Deal> getRecommended() => getTopOffers();

  static List<Deal> getFlashDeals() => getTopOffers();

  static List<Seller> getTopRatedSellers() => [
        Seller(name: "Urban Mart", image: "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035", rating: 4.8),
        Seller(name: "Healthy Basket", image: "https://www.istockphoto.com/photo/front-view-skin-care-products-on-wooden-decorative-piece-gm1546442230-526114035", rating: 4.6),
      ];
}
