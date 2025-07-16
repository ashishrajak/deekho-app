import 'package:my_flutter_app/main.dart';
import 'package:geolocator/geolocator.dart';

class DealFilterService {
  static List<Deal> filterDeals({
    required List<Deal> deals,
    required String category,
    required int radiusKm,
    required String sortBy,
    Position? currentPosition,
  }) {
    List<Deal> filteredDeals = List.from(deals);

    // Filter by category
    if (category != 'All') {
      filteredDeals = filteredDeals
          .where((deal) => deal.category == category)
          .toList();
    }

    // Filter by radius if current position is available
    if (currentPosition != null) {
      filteredDeals = filteredDeals.where((deal) {
        double distance = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          deal.latitude,
          deal.longitude,
        ) / 1000; // Convert to km
        return distance <= radiusKm;
      }).toList();
    }

    // Sort deals
    switch (sortBy) {
      case 'Distance':
        if (currentPosition != null) {
          filteredDeals.sort((a, b) {
            double distanceA = Geolocator.distanceBetween(
              currentPosition.latitude,
              currentPosition.longitude,
              a.latitude,
              a.longitude,
            );
            double distanceB = Geolocator.distanceBetween(
              currentPosition.latitude,
              currentPosition.longitude,
              b.latitude,
              b.longitude,
            );
            return distanceA.compareTo(distanceB);
          });
        }
        break;
      case 'Price':
        filteredDeals.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      case 'Rating':
        // ← MODIFIED: Handle nullable rating
        filteredDeals.sort((a, b) {
          double ratingA = a.rating ?? 0.0;  // ← ADDED LINE
          double ratingB = b.rating ?? 0.0;  // ← ADDED LINE
          return ratingB.compareTo(ratingA); // ← MODIFIED LINE
        });
        break;
      case 'Newest':
        // ← MODIFIED: Handle nullable createdAt
        filteredDeals.sort((a, b) {
          DateTime dateA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);  // ← ADDED LINE
          DateTime dateB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);  // ← ADDED LINE
          return dateB.compareTo(dateA); // ← MODIFIED LINE
        });
        break;
      case 'Discount':
        filteredDeals.sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
        break;
    }

    return filteredDeals;
  }

  static List<String> getAvailableCategories(List<Deal> deals) {
    Set<String> categories = {'All'};
    for (var deal in deals) {
      categories.add(deal.category);
    }
    return categories.toList();
  }

  static List<Deal> searchDeals(List<Deal> deals, String query) {
    if (query.isEmpty) return deals;
    
    query = query.toLowerCase();
    return deals.where((deal) {
      return deal.title.toLowerCase().contains(query) ||
             deal.description.toLowerCase().contains(query) ||
             deal.vendorName.toLowerCase().contains(query) ||
             deal.category.toLowerCase().contains(query);
    }).toList();
  }

  static Map<String, int> getCategoryCount(List<Deal> deals) {
    Map<String, int> categoryCount = {};
    for (var deal in deals) {
      categoryCount[deal.category] = (categoryCount[deal.category] ?? 0) + 1;
    }
    return categoryCount;
  }

  static List<Deal> getPopularDeals(List<Deal> deals, {int limit = 10}) {
    List<Deal> popularDeals = List.from(deals);
    // ← MODIFIED: Handle nullable rating
    popularDeals.sort((a, b) {
      double ratingA = a.rating ?? 0.0;  // ← ADDED LINE
      double ratingB = b.rating ?? 0.0;  // ← ADDED LINE
      return ratingB.compareTo(ratingA); // ← MODIFIED LINE
    });
    return popularDeals.take(limit).toList();
  }

  static List<Deal> getRecentDeals(List<Deal> deals, {int limit = 10}) {
    List<Deal> recentDeals = List.from(deals);
    // ← MODIFIED: Handle nullable createdAt
    recentDeals.sort((a, b) {
      DateTime dateA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);  // ← ADDED LINE
      DateTime dateB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);  // ← ADDED LINE
      return dateB.compareTo(dateA); // ← MODIFIED LINE
    });
    return recentDeals.take(limit).toList();
  }

  static List<Deal> getBestDiscountDeals(List<Deal> deals, {int limit = 10}) {
    List<Deal> discountDeals = List.from(deals);
    discountDeals.sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
    return discountDeals.take(limit).toList();
  }

  static List<Deal> getNearbyDeals(
    List<Deal> deals,
    Position currentPosition,
    {double radiusKm = 5.0, int limit = 10}
  ) {
    List<Deal> nearbyDeals = deals.where((deal) {
      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        deal.latitude,
        deal.longitude,
      ) / 1000;
      return distance <= radiusKm;
    }).toList();

    nearbyDeals.sort((a, b) {
      double distanceA = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        a.latitude,
        a.longitude,
      );
      double distanceB = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        b.latitude,
        b.longitude,
      );
      return distanceA.compareTo(distanceB);
    });

    return nearbyDeals.take(limit).toList();
  }
}