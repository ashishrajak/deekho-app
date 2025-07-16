import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/pages/home/responsive-helper.dart';

import 'package:url_launcher/url_launcher.dart';

// Import your OfferingServiceDTO and related classes
// import 'package:my_flutter_app/models/offering_service_dto.dart';

class MapView extends StatefulWidget {
  final List<OfferingServiceDTO> offerings;
  final Position? currentPosition;
  final GoogleMapController? mapController;
  final Function(GoogleMapController)? onMapCreated;

  const MapView({
    super.key,
    required this.offerings,
    this.currentPosition,
    this.mapController,
    this.onMapCreated,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = ResponsiveHelper.isTablet(context);
        final isMobile = ResponsiveHelper.isMobile(context);
        
        // Responsive margins
        final margin = isMobile 
            ? AppTheme.spacingM 
            : isTablet 
                ? AppTheme.spacingXL 
                : AppTheme.spacingXXL;
        
        return Container(
          margin: EdgeInsets.all(margin),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            border: Border.all(color: AppTheme.borderColor),
            boxShadow: const [AppTheme.cardShadow],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                // Call the external callback if provided
                if (widget.onMapCreated != null) {
                  widget.onMapCreated!(controller);
                }
              },
              initialCameraPosition: CameraPosition(
                target: widget.currentPosition != null 
                    ? LatLng(widget.currentPosition!.latitude, widget.currentPosition!.longitude)
                    : const LatLng(23.2599, 77.4126), // Bhopal coordinates
                zoom: 14.0,
              ),
              markers: _createMarkers(),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: true,
              onTap: (LatLng position) {
                _showNearbyServices(position);
              },
            ),
          ),
        );
      },
    );
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {};
    
    // Add current location marker
    if (widget.currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(widget.currentPosition!.latitude, widget.currentPosition!.longitude),
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }
    
    // Add offering markers
    markers.addAll(widget.offerings.where((offering) => 
      offering.geography.latitude != null && 
      offering.geography.longitude != null
    ).map((offering) {
      return Marker(
        markerId: MarkerId(offering.id),
        position: LatLng(offering.geography.latitude!, offering.geography.longitude!),
        infoWindow: InfoWindow(
          title: offering.title,
          snippet: _getOfferingSnippet(offering),
          onTap: () => _openGoogleMaps(offering),
        ),
        icon: _getMarkerIcon(offering),
        onTap: () => _showOfferingBottomSheet(offering),
      );
    }).toSet());
    
    return markers;
  }

  String _getOfferingSnippet(OfferingServiceDTO offering) {
    final currency = offering.primaryPricing.basePrice.currency;
    final price = offering.primaryPricing.basePrice.amount.toStringAsFixed(0);
    final priceType = offering.primaryPricing.type == PricingType.HOURLY ? '/hr' : '';
    
    return '$currency$price$priceType • ${offering.category}';
  }

  BitmapDescriptor _getMarkerIcon(OfferingServiceDTO offering) {
    // Different marker colors based on service status and verification
    if (!offering.verified) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    }
    
    switch (offering.status.toLowerCase()) {
      case 'active':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'busy':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'emergency':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      default:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }

  void _showOfferingBottomSheet(OfferingServiceDTO offering) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildOfferingBottomSheet(offering),
    );
  }

  Widget _buildOfferingBottomSheet(OfferingServiceDTO offering) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * (isTablet ? 0.7 : 0.85),
      ),
      decoration: const BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusL)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: AppTheme.spacingS),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isTablet ? AppTheme.spacingL : AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and verification badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          offering.title,
                          style: isTablet ? AppTheme.headlineLarge : AppTheme.headlineMedium,
                        ),
                      ),
                      if (offering.verified)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingS,
                            vertical: AppTheme.spacingXS,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor,
                            borderRadius: BorderRadius.circular(AppTheme.radiusS),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified, color: Colors.white, size: 12),
                              const SizedBox(width: AppTheme.spacingXS),
                              Text(
                                'Verified',
                                style: AppTheme.bodySmall.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingS),
                  
                  // Category and status
                  Row(
                    children: [
                      _buildInfoChip(offering.category.name, Icons.category),
                      const SizedBox(width: AppTheme.spacingS),
                      _buildInfoChip(offering.status, Icons.info_outline),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Description
                  Text(
                    offering.description,
                    style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Pricing
                  _buildPricingSection(offering.primaryPricing),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Timing information
                  _buildTimingSection(offering.timing),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Service area
                  if (offering.geography.serviceArea != null)
                    _buildServiceAreaSection(offering.geography),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Action buttons
                  _buildActionButtons(offering),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.textSecondary),
          const SizedBox(width: AppTheme.spacingXS),
          Text(label, style: AppTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildPricingSection(OfferingPricingDTO pricing) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        gradient: AppTheme.offerGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing',
            style: AppTheme.headlineSmall.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Row(
            children: [
              Text(
                '${pricing.basePrice.currency}${pricing.basePrice.amount.toStringAsFixed(0)}',
                style: AppTheme.headlineLarge.copyWith(color: Colors.white),
              ),
              const SizedBox(width: AppTheme.spacingXS),
              if (pricing.type == PricingType.HOURLY)
                Text(
                  '/hour',
                  style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
                ),
            ],
          ),
          if (pricing.additionalCharges != null) ...[
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              pricing.additionalCharges!,
              style: AppTheme.bodySmall.copyWith(color: Colors.white70),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimingSection(ServiceTiming timing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Availability', style: AppTheme.headlineSmall),
        const SizedBox(height: AppTheme.spacingS),
        if (timing.availableDays.isNotEmpty)
          Text(
            'Available: ${timing.availableDays.join(', ')}',
            style: AppTheme.bodyMedium,
          ),
        if (timing.startTime != null && timing.endTime != null)
          Text(
            'Hours: ${timing.startTime} - ${timing.endTime}',
            style: AppTheme.bodyMedium,
          ),
        if (timing.durationMinutes != null)
          Text(
            'Duration: ${timing.durationMinutes} minutes',
            style: AppTheme.bodyMedium,
          ),
        if (timing.emergencyService)
          Container(
            margin: const EdgeInsets.only(top: AppTheme.spacingS),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingS,
              vertical: AppTheme.spacingXS,
            ),
            decoration: BoxDecoration(
              color: AppTheme.accentColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emergency, color: Colors.white, size: 14),
                const SizedBox(width: AppTheme.spacingXS),
                Text(
                  'Emergency Service Available',
                  style: AppTheme.bodySmall.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildServiceAreaSection(ServiceGeography geography) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Service Area', style: AppTheme.headlineSmall),
        const SizedBox(height: AppTheme.spacingS),
        if (geography.serviceArea != null)
          Text(geography.serviceArea!, style: AppTheme.bodyMedium),
        if (geography.willingToTravel == true && geography.travelRadius != null)
          Text(
            'Travel radius: ${geography.travelRadius!.toStringAsFixed(1)} km',
            style: AppTheme.bodyMedium,
          ),
      ],
    );
  }

  Widget _buildActionButtons(OfferingServiceDTO offering) {
    final isTablet = ResponsiveHelper.isTablet(context);
    
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _openGoogleMaps(offering),
            icon: const Icon(Icons.directions),
            label: const Text('Get Directions'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              padding: EdgeInsets.symmetric(
                vertical: isTablet ? AppTheme.spacingL : AppTheme.spacingM,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: const Text('Close'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.textPrimary,
              side: const BorderSide(color: AppTheme.borderColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              padding: EdgeInsets.symmetric(
                vertical: isTablet ? AppTheme.spacingL : AppTheme.spacingM,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showNearbyServices(LatLng position) {
    final isTablet = ResponsiveHelper.isTablet(context);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusL)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(isTablet ? AppTheme.spacingL : AppTheme.spacingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              'Services near this location',
              style: isTablet ? AppTheme.headlineLarge : AppTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingS),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
              child: Text(
                'Lat: ${position.latitude.toStringAsFixed(4)}, '
                'Lng: ${position.longitude.toStringAsFixed(4)}',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.search),
                label: const Text('Search Here'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: isTablet ? AppTheme.spacingL : AppTheme.spacingM,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openGoogleMaps(OfferingServiceDTO offering) async {
    if (widget.currentPosition != null && 
        offering.geography.latitude != null && 
        offering.geography.longitude != null) {
      final String url = 'https://www.google.com/maps/dir/'
          '${widget.currentPosition!.latitude},${widget.currentPosition!.longitude}/'
          '${offering.geography.latitude},${offering.geography.longitude}';
      
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        _showDirectionsDialog(offering);
      }
    } else {
      _showLocationPermissionSnackBar();
    }
  }

  void _showDirectionsDialog(OfferingServiceDTO offering) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        title: Text('Directions', style: AppTheme.headlineMedium),
        content: Text(
          'Navigate to ${offering.title}',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLocationPermissionSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Location permission required for directions'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusS),
        ),
      ),
    );
  }
}