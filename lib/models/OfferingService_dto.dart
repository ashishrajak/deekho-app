
class OfferingServiceDTO {
  final String id;
  final String? offeringCode;
  final String title;
  final String description;
  final ServiceCategoryDto category;

  final String status;
  final bool verified;
  final ServiceTiming timing;
  final ServiceGeography geography;
  final Set<String> tags;
  final OfferingPricingDTO primaryPricing;
  final AdvancePolicy? advancePolicy;
  final List<OfferingMediaDTO> mediaItems;

  OfferingServiceDTO({
    required this.id,
     this.offeringCode,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.verified,
    required this.timing,
    required this.geography,
    required this.tags,
    required this.primaryPricing,
    this.advancePolicy,
    required this.mediaItems,
  });

  factory OfferingServiceDTO.fromJson(Map<String, dynamic> json) {
    return OfferingServiceDTO(
      id: json['id']?.toString() ?? '',
      offeringCode: json['offeringCode']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: ServiceCategoryDto.fromJson(json['category'] ?? {}),
      status: json['status']?.toString() ?? 'ACTIVE',
      verified: json['verified'] as bool? ?? false,
      timing: ServiceTiming.fromJson(json['timing'] ?? {}),
      geography: ServiceGeography.fromJson(json['geography'] ?? {}),
      tags: Set<String>.from((json['tags'] as List?)?.map((e) => e.toString()) ?? []),
      primaryPricing: OfferingPricingDTO.fromJson(json['primaryPricing'] ?? {}),
      advancePolicy: json['advancePolicy'] != null
          ? AdvancePolicy.fromJson(json['advancePolicy'])
          : null,
      mediaItems: (json['mediaItems'] as List?)
          ?.map((item) => OfferingMediaDTO.fromJson(item ?? {}))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offeringCode': offeringCode,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'verified': verified,
      'timing': timing.toJson(),
      'geography': geography.toJson(),
      'tags': tags.toList(),
      'primaryPricing': primaryPricing.toJson(),
      if (advancePolicy != null) 'advancePolicy': advancePolicy!.toJson(),
      'mediaItems': mediaItems.map((item) => item.toJson()).toList(),
    };
  }

  OfferingServiceDTO copyWith({
    String? id,
    String? offeringCode,
    String? displayName,
    String? shortDescription,
    ServiceCategoryDto? category,
    String? status,
    bool? verified,
    ServiceTiming? timing,
    ServiceGeography? geography,
    Set<String>? tags,
    OfferingPricingDTO? primaryPricing,
    AdvancePolicy? advancePolicy,
    List<OfferingMediaDTO>? mediaItems,
  }) {
    return OfferingServiceDTO(
      id: id ?? this.id,
      offeringCode: offeringCode ?? this.offeringCode,
      title: displayName ?? this.title,
      description: shortDescription ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      verified: verified ?? this.verified,
      timing: timing ?? this.timing,
      geography: geography ?? this.geography,
      tags: tags ?? this.tags,
      primaryPricing: primaryPricing ?? this.primaryPricing,
      advancePolicy: advancePolicy ?? this.advancePolicy,
      mediaItems: mediaItems ?? this.mediaItems,
    );
  }
}






class ServiceTiming {
  final int? durationMinutes;
  final DateTime? estimatedCompletion;
  final List<String> availableDays;
  final String? startTime;
  final String? endTime;
  final bool emergencyService;

  ServiceTiming({
    this.durationMinutes,
    this.estimatedCompletion,
    required this.availableDays,
    this.startTime,
    this.endTime,
    required this.emergencyService,
  });

  factory ServiceTiming.fromJson(Map<String, dynamic> json) {
    return ServiceTiming(
      durationMinutes: json['durationMinutes'] as int?,
      estimatedCompletion: json['estimatedCompletion'] != null
          ? DateTime.tryParse(json['estimatedCompletion'])
          : null,
      availableDays: List<String>.from(json['availableDays'] ?? []),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      emergencyService: json['emergencyService'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'durationMinutes': durationMinutes,
      'estimatedCompletion': estimatedCompletion?.toIso8601String(),
      'availableDays': availableDays,
      'startTime': startTime,
      'endTime': endTime,
      'emergencyService': emergencyService,
    };
  }

  ServiceTiming copyWith({
    int? durationMinutes,
    DateTime? estimatedCompletion,
    List<String>? availableDays,
    String? startTime,
    String? endTime,
    bool? emergencyService,
  }) {
    return ServiceTiming(
      durationMinutes: durationMinutes ?? this.durationMinutes,
      estimatedCompletion: estimatedCompletion ?? this.estimatedCompletion,
      availableDays: availableDays ?? List.from(this.availableDays),
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      emergencyService: emergencyService ?? this.emergencyService,
    );
  }
}
class ServiceGeography {
  final double? latitude;
  final double? longitude;
  final String? serviceArea;
  final bool? onSiteService;
  final bool? willingToTravel;
  final double? travelRadius;

  ServiceGeography({
    this.latitude,
    this.longitude,
    this.serviceArea,
    this.onSiteService,
    this.willingToTravel,
    this.travelRadius,
  });

  factory ServiceGeography.fromJson(Map<String, dynamic> json) {
    return ServiceGeography(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      serviceArea: json['serviceArea']?.toString(),
      onSiteService: json['onSiteService'] as bool?,
      willingToTravel: json['willingToTravel'] as bool?,
      travelRadius: (json['travelRadius'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'serviceArea': serviceArea,
      'onSiteService': onSiteService,
      'willingToTravel': willingToTravel,
      'travelRadius': travelRadius,
    };
  }

  ServiceGeography copyWith({
    double? latitude,
    double? longitude,
    String? serviceArea,
    bool? onSiteService,
    bool? willingToTravel,
    double? travelRadius,
  }) {
    return ServiceGeography(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      serviceArea: serviceArea ?? this.serviceArea,
      onSiteService: onSiteService ?? this.onSiteService,
      willingToTravel: willingToTravel ?? this.willingToTravel,
      travelRadius: travelRadius ?? this.travelRadius,
    );
  }
}
enum PricingType {
  HOURLY,
  FIXED,
  // Add other types as needed
}

class MoneyDTO {
  final double amount;
  final String currency;

  MoneyDTO({
    required this.amount,
    required this.currency,
  });

  factory MoneyDTO.fromJson(Map<String, dynamic> json) {
    return MoneyDTO(
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'currency': currency,
  };
}

class OfferingPricingDTO {
  final PricingType type;
  final MoneyDTO basePrice;
  final String? additionalCharges;
  final String? discount;
  final Map<String, String> conditions;
  final Set<String> paymentMethods;

  OfferingPricingDTO({
    required this.type,
    required this.basePrice,
    this.additionalCharges,
    this.discount,
    Map<String, String>? conditions,
    Set<String>? paymentMethods,
  })  : conditions = conditions ?? {},
        paymentMethods = paymentMethods ?? {};

  factory OfferingPricingDTO.fromJson(Map<String, dynamic> json) {
    return OfferingPricingDTO(
      type: _parsePricingType(json['type']),
      basePrice: MoneyDTO.fromJson(json['basePrice'] as Map<String, dynamic>),
      additionalCharges: json['additionalCharges'] as String?,
      discount: json['discount'] as String?,
      conditions: (json['conditions'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v.toString()),
      ) ?? {},
      paymentMethods: (json['paymentMethods'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toSet() ?? {},
    );
  }

  static PricingType _parsePricingType(String type) {
    return PricingType.values.firstWhere(
          (e) => e.toString().split('.').last == type,
      orElse: () => PricingType.FIXED,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'basePrice': basePrice.toJson(),
      if (additionalCharges != null) 'additionalCharges': additionalCharges,
      if (discount != null) 'discount': discount,
      'conditions': conditions,
      'paymentMethods': paymentMethods.toList(),
    };
  }
}

class OfferingMediaDTO {
  final String mediaUrl;
  final String mediaType;
  final int displayOrder;

  OfferingMediaDTO({
    required this.mediaUrl,
    required this.mediaType,
    required this.displayOrder,
  });

  factory OfferingMediaDTO.fromJson(Map<String, dynamic> json) {
    return OfferingMediaDTO(
      mediaUrl: json['mediaUrl']?.toString() ?? '',
      mediaType: json['mediaType']?.toString() ?? 'IMAGE',
      displayOrder: (json['displayOrder'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'displayOrder': displayOrder,
    };
  }

  OfferingMediaDTO copyWith({
    String? mediaUrl,
    String? mediaType,
    int? displayOrder,
  }) {
    return OfferingMediaDTO(
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }
}

class AdvancePolicy {
  final bool advanceRequired;
  final MoneyDTO? advanceAmount;
  final String? advancePaymentMethod;
  final String? advanceTerms;

  AdvancePolicy({
    required this.advanceRequired,
    this.advanceAmount,
    this.advancePaymentMethod,
    this.advanceTerms,
  });

  factory AdvancePolicy.fromJson(Map<String, dynamic> json) {
    return AdvancePolicy(
      advanceRequired: json['advanceRequired'] as bool,
      advanceAmount: json['advanceAmount'] != null
          ? MoneyDTO.fromJson(json['advanceAmount'] as Map<String, dynamic>)
          : null,
      advancePaymentMethod: json['advancePaymentMethod'] as String?,
      advanceTerms: json['advanceTerms'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'advanceRequired': advanceRequired,
    if (advanceAmount != null) 'advanceAmount': advanceAmount!.toJson(),
    if (advancePaymentMethod != null)
      'advancePaymentMethod': advancePaymentMethod,
    if (advanceTerms != null) 'advanceTerms': advanceTerms,
  };
}


class CategoryDTO {
  final String categoryName;
  final List<String> subcategories;

  CategoryDTO({
    required this.categoryName,
    required this.subcategories,
  });

  factory CategoryDTO.fromJson(Map<String, dynamic> json) {
    return CategoryDTO(
      categoryName: json['categoryName'] ?? '',
      subcategories: List<String>.from(json['subcategories'] ?? []),
    );
  }
}

class ServiceCategoryDto {
  final String id;
  final String name;
  final String? description;
  final String? parentId;
  final String? route;
  final DateTime? createdOn;

  ServiceCategoryDto({
    required this.id,
    required this.name,
    this.description,
    this.parentId,
    this.route,
    this.createdOn,
  });

  factory ServiceCategoryDto.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryDto(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      parentId: json['parentId'],
      route: json['route'],
      createdOn: json['createdOn'] != null ? DateTime.tryParse(json['createdOn']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (parentId != null) 'parentId': parentId,
      if (route != null) 'route': route,
      if (createdOn != null) 'createdOn': createdOn!.toIso8601String(),
    };
  }
}
