// lib/services/mock_data_service.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/serviceRequest.dart';



class MockDataService {
  static List<ServiceRequestDto> getMockServiceRequests() {
    return [
      ServiceRequestDto(
        id: 1,
        category: CategoryDto(
          id: 1,
          name: 'plumber',
          displayName: 'Plumber',
          iconUrl: Icons.plumbing,
          isActive: true,
          sortOrder: 1,
          configData: CategoryConfig(
            requiresLocation: true,
            supportsEquipment: true,
            allowsGroupBooking: false,
            biddingEnabled: true,
            commonFields: ['location', 'timing', 'budget'],
            fields: [
              FieldDefinition(name: 'plumbingType', type: 'String', required: true, options: ['Kitchen', 'Bathroom', 'General']),
              FieldDefinition(name: 'urgencyLevel', type: 'String', required: true, options: ['Emergency', 'Same Day', 'Within Week']),
              FieldDefinition(name: 'hasTools', type: 'Boolean', required: false),
            ],
          ),
        ),
        title: "Kitchen Sink Repair",
        description: "Need a plumber to fix a leaking kitchen sink.",
        status: ServiceRequestStatus.OPEN,
        serviceAddress: "123, Bhopal Colony, MP",
        location: LatLng(23.2599, 77.4126),
        budgetMin: 1500.0,
        budgetType: BudgetType.FIXED,
        serviceRadiusKm: 5,
        preferredDate: DateTime.now().add(Duration(days: 2)),
        preferredTime: TimeOfDay(hour: 10, minute: 0),
        isFlexibleTiming: true,
        urgencyLevel: UrgencyLevel.MEDIUM,
        biddingExpiresAt: DateTime.now().add(Duration(days: 3)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
        requirements: RequirementDataDto(
          mustHave: ["Pipe repair experience"],
          niceToHave: ["Own tools"],
          dealBreakers: ["Unlicensed"],
          qualifications: {"Experience": "5+ years"},
        ),
        serviceData: {
          "plumbingType": "Kitchen",
          "urgencyLevel": "Same Day",
          "hasTools": true,
        },
        posterName: "John Doe",
        posterImage: "assets/images/user1.jpg",
        posterRating: 4.5,
        currentBid: 1500.0,
        bids: [
          Bid(id: 1, bidderName: "Jane Smith", amount: 1400.0, bidTime: DateTime.now().subtract(Duration(hours: 2)), message: "Experienced plumber, can start immediately"),
          Bid(id: 2, bidderName: "Mike Johnson", amount: 1500.0, bidTime: DateTime.now().subtract(Duration(hours: 1)), message: "Licensed with own tools"),
        ],
      ),
      ServiceRequestDto(
        id: 2,
        category: CategoryDto(
          id: 2,
          name: 'bike_service',
          displayName: 'Bike Service',
          iconUrl: Icons.motorcycle,
          isActive: true,
          sortOrder: 2,
          configData: CategoryConfig(
            requiresLocation: true,
            supportsEquipment: false,
            allowsGroupBooking: true,
            biddingEnabled: false,
            commonFields: ['location', 'timing'],
            fields: [
              FieldDefinition(name: 'fromLocation', type: 'String', required: true),
              FieldDefinition(name: 'toLocation', type: 'String', required: true),
              FieldDefinition(name: 'departureTime', type: 'DateTime', required: true),
              FieldDefinition(name: 'maxPassengers', type: 'Integer', required: true),
              FieldDefinition(name: 'farePerPerson', type: 'Double', required: false),
              FieldDefinition(name: 'allowsLuggage', type: 'Boolean', required: false),
            ],
          ),
        ),
        title: "Bike Service from Delhi to Mumbai",
        description: "Group bike ride from Delhi to Mumbai, join if interested.",
        status: ServiceRequestStatus.OPEN,
        serviceAddress: "Delhi Start Point",
        location: LatLng(28.7041, 77.1025),
        endPoint: LatLng(19.0760, 72.8777),
        budgetMin: 4000.0,
        budgetMax: 6000.0,
        budgetType: BudgetType.RANGE,
        serviceRadiusKm: 10,
        preferredDate: DateTime.now().add(Duration(days: 5)),
        preferredTime: TimeOfDay(hour: 8, minute: 0),
        isFlexibleTiming: false,
        urgencyLevel: UrgencyLevel.LOW,
        biddingExpiresAt: DateTime.now().add(Duration(days: 7)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
        requirements: RequirementDataDto(
          mustHave: ["Group travel experience"],
          niceToHave: ["Luggage space"],
          dealBreakers: ["No helmet"],
          qualifications: {"Riding Experience": "3+ years"},
        ),
        serviceData: {
          "fromLocation": "Delhi",
          "toLocation": "Mumbai",
          "departureTime": DateTime.now().add(Duration(days: 5)),
          "maxPassengers": 4,
          "farePerPerson": 1250.0,
          "allowsLuggage": true,
        },
        geoConfig: GeoConfigDto(
          serviceRoutes: ["Delhi to Mumbai"],
          movementPattern: "Linear",
          updateFrequencySec: 60,
          routeDistanceKm: 1400.0,
          coverageType: "Route",
        ),
        posterName: "Alice Brown",
        posterImage: "assets/images/user2.jpg",
        posterRating: 4.8,
        currentBid: 5000.0,
        bids: [],
      ),
      ServiceRequestDto(
        id: 3,
        category: CategoryDto(
          id: 3,
          name: 'thele_vala',
          displayName: 'Thele Vala (Fruit Vendor)',
          iconUrl: Icons.shopping_cart,
          isActive: true,
          sortOrder: 3,
          configData: CategoryConfig(
            requiresLocation: true,
            supportsEquipment: false,
            allowsGroupBooking: false,
            biddingEnabled: false,
            commonFields: ['location', 'timing'],
            fields: [
              FieldDefinition(name: 'vendorType', type: 'String', required: true, options: ['Fruits', 'Vegetables', 'Both']),
              FieldDefinition(name: 'startTime', type: 'Time', required: true),
              FieldDefinition(name: 'endTime', type: 'Time', required: true),
              FieldDefinition(name: 'route', type: 'String', required: true),
              FieldDefinition(name: 'liveTracking', type: 'Boolean', required: false),
              FieldDefinition(name: 'contactNumber', type: 'String', required: true),
            ],
          ),
        ),
        title: "Fruit Vendor in Colony",
        description: "Selling fresh fruits in Bhopal colony from 10 AM to 3 PM.",
        status: ServiceRequestStatus.OPEN,
        serviceAddress: "Bhopal Colony, MP",
        location: LatLng(23.2599, 77.4126),
        budgetType: BudgetType.NEGOTIABLE,
        serviceRadiusKm: 2,
        preferredDate: DateTime.now(),
        preferredTime: TimeOfDay(hour: 10, minute: 0),
        isFlexibleTiming: false,
        urgencyLevel: UrgencyLevel.LOW,
        biddingExpiresAt: DateTime.now().add(Duration(days: 1)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: 1,
        trackingIntervalSec: 30,
        trackingDurationMin: 300,
        requirements: RequirementDataDto(
          mustHave: ["Fresh produce"],
          niceToHave: ["Variety of fruits"],
          dealBreakers: ["Non-hygienic"],
          qualifications: {"Vendor Experience": "2+ years"},
        ),
        serviceData: {
          "vendorType": "Fruits",
          "startTime": TimeOfDay(hour: 10, minute: 0),
          "endTime": TimeOfDay(hour: 15, minute: 0),
          "route": "Bhopal Colony Route",
          "liveTracking": true,
          "contactNumber": "9876543210",
        },
        geoConfig: GeoConfigDto(
          serviceRoutes: ["Bhopal Colony Route"],
          movementPattern: "Circular",
          updateFrequencySec: 30,
          routeDistanceKm: 5.0,
          coverageType: "Area",
          coveragePolygon: [
            LatLng(23.2599, 77.4126),
            LatLng(23.2600, 77.4130),
            LatLng(23.2595, 77.4120),
          ],
        ),
        posterName: "Rahul Sharma",
        posterImage: "assets/images/user3.jpg",
        posterRating: 4.2,
        currentBid: 0.0,
        bids: [],
      ),
    ];
  }

  static ServiceRequestDto? getServiceRequestById(String serviceId) {
    final serviceRequests = getMockServiceRequests();
    try {
      return serviceRequests.firstWhere((request) => request.id.toString() == serviceId);
    } catch (e) {
      return null;
    }
  }
}