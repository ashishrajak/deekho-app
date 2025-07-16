// lib/models/service_request_dto.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


enum BudgetType { FIXED, RANGE, HOURLY, NEGOTIABLE }
enum ServiceRequestStatus { OPEN, IN_PROGRESS, COMPLETED, CANCELLED }
enum UrgencyLevel { LOW, MEDIUM, HIGH, URGENT }

class ServiceRequestDto {
  final int id;
  final CategoryDto category;
  final String title;
  final String description;
  final ServiceRequestStatus status;
  final int? serviceRadiusKm;
  final LatLng? location;
  final LatLng? endPoint;
  final String serviceAddress;
  final double? budgetMin;
  final double? budgetMax;
  final BudgetType budgetType;
  final DateTime? preferredDate;
  final TimeOfDay? preferredTime;
  final bool isFlexibleTiming;
  final UrgencyLevel urgencyLevel;
  final DateTime? biddingExpiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? version;
  final Map<String, dynamic> serviceData;
  final RequirementDataDto requirements;
  final int? trackingIntervalSec;
  final int? trackingDurationMin;
  final GeoConfigDto? geoConfig;
  final String posterName; // Added for UI
  final String posterImage; // Added for UI
  final double? posterRating; // Added for UI
  final double currentBid; // Added for UI (not in original DTO)
  final List<Bid> bids; // Added for UI

  ServiceRequestDto({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.status,
    this.serviceRadiusKm,
    this.location,
    this.endPoint,
    required this.serviceAddress,
    this.budgetMin,
    this.budgetMax,
    required this.budgetType,
    this.preferredDate,
    this.preferredTime,
    this.isFlexibleTiming = false,
    required this.urgencyLevel,
    this.biddingExpiresAt,
    required this.createdAt,
    required this.updatedAt,
    this.version,
    required this.serviceData,
    required this.requirements,
    this.trackingIntervalSec,
    this.trackingDurationMin,
    this.geoConfig,
    required this.posterName,
    required this.posterImage,
    this.posterRating,
    required this.currentBid,
    this.bids = const [],
  });
}

class CategoryDto {
  final int id;
  final String name;
  final String displayName;
  final IconData iconUrl; // Changed to IconData for Flutter
  final bool isActive;
  final int sortOrder;
  final CategoryConfig configData;
  final CategoryDto? parent;

  CategoryDto({
    required this.id,
    required this.name,
    required this.displayName,
    required this.iconUrl,
    this.isActive = true,
    required this.sortOrder,
    required this.configData,
    this.parent,
  });
}

class CategoryConfig {
  final bool requiresLocation;
  final bool supportsEquipment;
  final bool allowsGroupBooking;
  final bool biddingEnabled;
  final List<String> commonFields;
  final List<FieldDefinition> fields;

  CategoryConfig({
    required this.requiresLocation,
    required this.supportsEquipment,
    required this.allowsGroupBooking,
    required this.biddingEnabled,
    required this.commonFields,
    required this.fields,
  });
}

class FieldDefinition {
  final String name;
  final String type;
  final bool required;
  final List<String>? options;

  FieldDefinition({
    required this.name,
    required this.type,
    required this.required,
    this.options,
  });
}

class RequirementDataDto {
  final List<String> mustHave;
  final List<String> niceToHave;
  final List<String> dealBreakers;
  final Map<String, String> qualifications;
  final Map<String, dynamic> preferences;

  RequirementDataDto({
    required this.mustHave,
    required this.niceToHave,
    required this.dealBreakers,
    required this.qualifications,
    this.preferences = const {},
  });
}

class GeoConfigDto {
  final List<String> serviceRoutes;
  final String? movementPattern;
  final int? updateFrequencySec;
  final String? polyline;
  final double? routeDistanceKm;
  final String? coverageType;
  final List<LatLng>? coveragePolygon;

  GeoConfigDto({
    required this.serviceRoutes,
    this.movementPattern,
    this.updateFrequencySec,
    this.polyline,
    this.routeDistanceKm,
    this.coverageType,
    this.coveragePolygon,
  });
}

class Bid {
  final int id;
  final String bidderName;
  final double amount;
  final DateTime bidTime;
  final String? message; // Added to support bid messages

  Bid({
    required this.id,
    required this.bidderName,
    required this.amount,
    required this.bidTime,
    this.message,
  });
}