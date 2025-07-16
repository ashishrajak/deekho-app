import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/pages/bidpost/MockDataService.dart';
import 'package:my_flutter_app/pages/home/responsive-helper.dart';
import 'package:particles_flutter/particles_flutter.dart';

import '../../models/serviceRequest.dart';

class Bid {
  final int id;
  final String bidderName;
  final double amount;
  final DateTime bidTime;
  final String? message;

  Bid({
    required this.id,
    required this.bidderName,
    required this.amount,
    required this.bidTime,
    this.message,
  });
}

class ServiceRequestDtoDetailsScreen extends StatefulWidget {
  final String serviceId;

  const ServiceRequestDtoDetailsScreen({super.key, required this.serviceId});

  @override
  State<ServiceRequestDtoDetailsScreen> createState() => _ServiceRequestDtoDetailsScreenState();
}

class _ServiceRequestDtoDetailsScreenState extends State<ServiceRequestDtoDetailsScreen> {
  final TextEditingController _bidController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  ServiceRequestDto? post;
  String? errorMessage;
  int index = 0;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _loadServiceRequest();
  }

  void _loadServiceRequest() {
    try {
      final serviceRequests = MockDataService.getMockServiceRequests();
      if (index >= 0 && index < serviceRequests.length) {
        post = serviceRequests[index];
        _setupMapData();
        if (post!.budgetType == BudgetType.FIXED) {
          _bidController.text = post!.budgetMin?.toStringAsFixed(0) ?? '';
        } else if (post!.budgetType == BudgetType.RANGE) {
          _bidController.text = post!.budgetMin?.toStringAsFixed(0) ?? '';
        } else {
          _bidController.text = post!.currentBid.toStringAsFixed(0);
        }
      } else {
        setState(() {
          errorMessage = 'Invalid service request index';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching service request: $e';
      });
    }
  }

  void _setupMapData() {
    if (post == null) return;

    _markers.clear();
    _polylines.clear();

    if (post!.location != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('start_location'),
          position: post!.location!,
          infoWindow: InfoWindow(
            title: 'Service Location',
            snippet: post!.serviceAddress,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }

    if (post!.endPoint != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('end_location'),
          position: post!.endPoint!,
          infoWindow: InfoWindow(
            title: 'End Location',
            snippet: 'Service end point',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    if (post!.geoConfig?.coveragePolygon != null && post!.geoConfig!.coveragePolygon!.isNotEmpty) {
      for (int i = 0; i < post!.geoConfig!.coveragePolygon!.length; i++) {
        final point = post!.geoConfig!.coveragePolygon![i];
        _markers.add(
          Marker(
            markerId: MarkerId('coverage_point_$i'),
            position: point,
            infoWindow: InfoWindow(
              title: 'Coverage Point ${i + 1}',
              snippet: 'Lat: ${point.latitude}, Lng: ${point.longitude}',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      }

      if (post!.geoConfig!.coveragePolygon!.length > 2) {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('coverage_area'),
            points: [...post!.geoConfig!.coveragePolygon!, post!.geoConfig!.coveragePolygon!.first],
            color: AppTheme.primary,
            width: 3,
            patterns: [PatternItem.dash(20), PatternItem.gap(10)],
          ),
        );
      }
    }

    if (post!.location != null && post!.endPoint != null) {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('service_route'),
          points: [post!.location!, post!.endPoint!],
          color: AppTheme.accent,
          width: 4,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: Text('Error', style: AppTheme.headlineMedium.copyWith(color: AppTheme.textWhite)),
          backgroundColor: AppTheme.primary,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            errorMessage!,
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (post == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          CircularParticle(
            key: UniqueKey(),
            awayRadius: 80,
            numberOfParticles: 25,
            speedOfParticles: 0.8,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            onTapAnimation: true,
            particleColor: AppTheme.primary.withOpacity(0.08),
            awayAnimationDuration: Duration(milliseconds: 500),
            maxParticleSize: 3,
            isRandomColor: false,
            connectDots: true,
            enableHover: true,
            hoverRadius: 20,
          ),
          Column(
            children: [
              _buildCompactHeader(),
              Expanded(
                child: AnimationLimiter(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: Duration(milliseconds: 300),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          verticalOffset: 40.0,
                          child: FadeInAnimation(child: widget),
                        ),
                        children: [
                          _buildMapSection(),
                          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                          _buildPostDetails(),
                          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                          if (post!.serviceData.isNotEmpty) _buildServiceDataSection(),
                          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                          if (post!.geoConfig != null) _buildGeoConfigSection(),
                          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                          _buildRequirementsSection(),
                          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                          _buildBidHistory(),
                          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                          _buildBidForm(),
                          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 2),
                        ],
                      ),
                    ),
                ),
              )
            ,
          ),
        ],
          ), ] ) , );
      
  }

Widget _buildCompactHeader() {
  final timeLeft = post!.biddingExpiresAt?.difference(DateTime.now()) ?? Duration.zero;
  final isExpired = timeLeft.isNegative || post!.status != ServiceRequestStatus.OPEN;

  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.primary, // Primary color (e.g., a deep blue)
          AppTheme.primary.withOpacity(0.8), // Slightly lighter for gradient effect
          AppTheme.accent.withOpacity(0.7), // Complementary accent color
        ],
        stops: [0.0, 0.5, 1.0],
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(AppTheme.radiusM),
        bottomRight: Radius.circular(AppTheme.radiusM),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: Offset(0, 4),
          spreadRadius: 1,
        ),
      ],
    ),
    child: SafeArea(
      child: Column(
        children: [
          AppBar(
            title: Text(
              post!.title,
              style: AppTheme.headlineMedium.copyWith(
                color: AppTheme.textWhite,
                fontSize: ResponsiveHelper.getFontSizeEnhanced(context, 20),
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 60,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getPaddingEnhanced(context),
              vertical: ResponsiveHelper.getPaddingEnhanced(context) * 0.6,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.textWhite,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: ResponsiveHelper.getResponsiveValue(
                          context,
                          mobile: 24.0,
                          tablet: 26.0,
                          desktop: 28.0,
                          largeDesktop: 30.0,
                        ),
                        backgroundImage: AssetImage(post!.posterImage),
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post!.posterName,
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: ResponsiveHelper.getFontSizeEnhanced(context, 16),
                            color: AppTheme.textWhite,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppTheme.accent,
                              size: ResponsiveHelper.getResponsiveIconSize(context) * 0.8,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${post!.posterRating ?? 0.0}',
                              style: AppTheme.bodySmall.copyWith(
                                fontSize: ResponsiveHelper.getFontSizeEnhanced(context, 12),
                                color: AppTheme.textWhite.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.getPaddingEnhanced(context) * 0.8,
                        vertical: ResponsiveHelper.getPaddingEnhanced(context) * 0.4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.textWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                        border: Border.all(
                          color: AppTheme.accent.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '₹${post!.currentBid.toStringAsFixed(0)}',
                        style: AppTheme.bodyLarge.copyWith(
                          color: AppTheme.onPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: ResponsiveHelper.getFontSizeEnhanced(context, 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      isExpired ? 'Bidding Ended' : '${timeLeft.inHours}h ${timeLeft.inMinutes % 60}m Left',
                      style: AppTheme.bodySmall.copyWith(
                        color: isExpired ? AppTheme.error : AppTheme.success,
                        fontSize: ResponsiveHelper.getFontSizeEnhanced(context, 12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildMapSection() {
    if (post!.location == null && (post!.geoConfig?.coveragePolygon == null || post!.geoConfig!.coveragePolygon!.isEmpty)) {
      return SizedBox.shrink();
    }

    return Container(
      height: 200,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.getResponsiveSpacing(context)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: post!.location ?? post!.geoConfig!.coveragePolygon!.first,
            zoom: 14.0,
          ),
          markers: _markers,
          polylines: _polylines,
          mapType: MapType.normal,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: false,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
        ),
      ),
    );
  }

  Widget _buildPostDetails() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context) * 0.8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Service Details', style: AppTheme.headlineSmall.copyWith(color: AppTheme.textPrimary)),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
          // ... (Rest of the _buildPostDetails method remains unchanged)
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary, size: 18),
          SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context) * 0.8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                Text(value, style: AppTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getBudgetText() {
    switch (post!.budgetType) {
      case BudgetType.RANGE:
        return '₹${post!.budgetMin?.toStringAsFixed(0)} - ₹${post!.budgetMax?.toStringAsFixed(0)}';
      case BudgetType.NEGOTIABLE:
        return 'Negotiable';
      case BudgetType.HOURLY:
        return '₹${post!.budgetMin?.toStringAsFixed(0)}/hour';
      default:
        return '₹${post!.budgetMin?.toStringAsFixed(0)}';
    }
  }

  Widget _buildServiceDataSection() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context) * 0.8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Service Specific Details', style: AppTheme.headlineSmall.copyWith(color: AppTheme.textPrimary)),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
          ...post!.serviceData.entries.map((entry) {
            final fieldDef = post!.category.configData.fields.firstWhere(
              (field) => field.name == entry.key,
              orElse: () => FieldDefinition(name: entry.key, type: 'String', required: false),
            );
            return _buildServiceDataItem(entry.key, entry.value, fieldDef);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildServiceDataItem(String key, dynamic value, FieldDefinition fieldDef) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: AppTheme.primary, size: 18),
          SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context) * 0.8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _formatFieldName(key),
                      style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (fieldDef.required) ...[
                      SizedBox(width: 4),
                      Text('*', style: AppTheme.bodyMedium.copyWith(color: AppTheme.error)),
                    ],
                  ],
                ),
                Text(
                  _formatServiceData(value, fieldDef.type),
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeoConfigSection() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context) * 0.8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Geo Configuration', style: AppTheme.headlineSmall.copyWith(color: AppTheme.textPrimary)),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
          if (post!.geoConfig!.serviceRoutes.isNotEmpty)
            _buildDetailItem(Icons.route, 'Service Routes', post!.geoConfig!.serviceRoutes.join(", ")),
          if (post!.geoConfig!.movementPattern != null)
            _buildDetailItem(Icons.directions, 'Movement Pattern', post!.geoConfig!.movementPattern!),
          if (post!.geoConfig!.coverageType != null)
            _buildDetailItem(Icons.map, 'Coverage Type', post!.geoConfig!.coverageType!),
        ],
      ),
    );
  }

  Widget _buildRequirementsSection() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context) * 0.8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Requirements', style: AppTheme.headlineSmall.copyWith(color: AppTheme.textPrimary)),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
          if (post!.requirements.mustHave.isNotEmpty)
            _buildRequirementItem('Must Have', post!.requirements.mustHave, Icons.check_circle, AppTheme.success),
          if (post!.requirements.niceToHave.isNotEmpty)
            _buildRequirementItem('Nice to Have', post!.requirements.niceToHave, Icons.star, AppTheme.info),
          if (post!.requirements.dealBreakers.isNotEmpty)
            _buildRequirementItem('Deal Breakers', post!.requirements.dealBreakers, Icons.block, AppTheme.error),
          if (post!.requirements.qualifications.isNotEmpty)
            _buildQualificationItem('Qualifications', post!.requirements.qualifications),
          if (post!.requirements.preferences.isNotEmpty)
            _buildPreferenceItem('Preferences', post!.requirements.preferences),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String title, List<String> items, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context) * 0.8),
              Text(title, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: items.map((item) => Chip(
              label: Text(item, style: AppTheme.caption),
              backgroundColor: color.withOpacity(0.1),
              side: BorderSide(color: color.withOpacity(0.3)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQualificationItem(String title, Map<String, String> qualifications) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified, color: AppTheme.accent, size: 18),
              SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context) * 0.8),
              Text(title, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: qualifications.entries.map((entry) => Chip(
              label: Text('${entry.key}: ${entry.value}', style: AppTheme.caption),
              backgroundColor: AppTheme.accent.withOpacity(0.1),
              side: BorderSide(color: AppTheme.accent.withOpacity(0.3)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(String title, Map<String, dynamic> preferences) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: AppTheme.primary, size: 18),
              SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context) * 0.8),
              Text(title, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: preferences.entries.map((entry) => Chip(
              label: Text('${_formatFieldName(entry.key)}: ${_formatServiceData(entry.value, "String")}', style: AppTheme.caption),
              backgroundColor: AppTheme.primary.withOpacity(0.1),
              side: BorderSide(color: AppTheme.primary.withOpacity(0.3)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBidHistory() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context) * 0.8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bid History (${post!.bids.length})', style: AppTheme.headlineSmall.copyWith(color: AppTheme.textPrimary)),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
          if (post!.bids.isEmpty)
            ListTile(
              title: Text('No bids yet', style: AppTheme.bodyMedium),
            )
          else
            ...post!.bids.map((bid) => Card(
              margin: EdgeInsets.only(bottom: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusS)),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/images/user${bid.id % 3 + 1}.jpg'),
                ),
                title: Text(
                  bid.bidderName,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveHelper.getFontSizeEnhanced(context, 14),
                  ),
                ),
                subtitle: Text(
                  bid.message ?? _formatTime(bid.bidTime),
                  style: AppTheme.caption.copyWith(
                    fontSize: ResponsiveHelper.getFontSizeEnhanced(context, 12),
                  ),
                ),
                trailing: Text(
                  '₹${bid.amount.toStringAsFixed(0)}',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                    fontSize: ResponsiveHelper.getFontSizeEnhanced(context, 14),
                  ),
                ),
              ),
            )).toList(),
        ],
      ),
    );
  }

  Widget _buildBidForm() {
    final timeLeft = post!.biddingExpiresAt?.difference(DateTime.now()) ?? Duration.zero;
    final isExpired = timeLeft.isNegative || post!.status != ServiceRequestStatus.OPEN;

    if (isExpired || !post!.category.configData.biddingEnabled) {
      return Container(
        padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context) * 0.8),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          boxShadow: [AppTheme.cardShadow],
        ),
        child: Text(
          isExpired ? 'Bidding has ended for this post' : 'Bidding is not enabled for this service',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.error),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context) * 0.8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Place Your Bid', style: AppTheme.headlineSmall.copyWith(color: AppTheme.textPrimary)),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
          TextField(
            controller: _bidController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Bid Amount (₹)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusS)),
              prefixIcon: Icon(Icons.currency_rupee, color: AppTheme.primary),
              filled: true,
              fillColor: AppTheme.surfaceLight,
            ),
            style: AppTheme.bodyMedium.copyWith(fontSize: ResponsiveHelper.getFontSizeEnhanced(context, 14)),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
          TextField(
            controller: _messageController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Message (Optional)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusS)),
              hintText: 'Add a message...',
              filled: true,
              fillColor: AppTheme.surfaceLight,
            ),
            style: AppTheme.bodyMedium.copyWith(fontSize: ResponsiveHelper.getFontSizeEnhanced(context, 14)),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _submitBid,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.getResponsiveSpacing(context),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusS)),
                  ),
                  child: Text(
                    'Place Bid',
                    style: AppTheme.buttonText.copyWith(
                      fontSize: ResponsiveHelper.getFontSizeEnhanced(context, 14),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
              IconButton(
                onPressed: () => _updateBidAmount(100),
                icon: Icon(Icons.add, color: AppTheme.textWhite),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: EdgeInsets.all(ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
                ),
              ),
              IconButton(
                onPressed: () => _updateBidAmount(-100),
                icon: Icon(Icons.remove, color: AppTheme.textWhite),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: EdgeInsets.all(ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateBidAmount(int increment) {
    final currentAmount = double.tryParse(_bidController.text) ?? 0;
    final newAmount = currentAmount + increment;
    if (newAmount >= 0) {
      _bidController.text = newAmount.toStringAsFixed(0);
    }
  }

  void _submitBid() {
    final bidAmount = double.tryParse(_bidController.text);
    if (bidAmount == null || bidAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid bid amount'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    if (post!.budgetType == BudgetType.FIXED && bidAmount != post!.budgetMin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bid amount must be ₹${post!.budgetMin?.toStringAsFixed(0)} for fixed budget'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    // Placeholder for bid submission logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bid submitted successfully!'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  String _formatFieldName(String fieldName) {
    return fieldName
        .replaceAll(RegExp(r'([A-Z])'), ' \$1')
        .split(' ')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ')
        .trim();
  }

  String _formatServiceData(dynamic value, String type) {
    if (type == 'DateTime' && value is DateTime) {
      return '${value.day}/${value.month}/${value.year} ${value.hour}:${value.minute.toString().padLeft(2, '0')}';
    } else if (type == 'Time' && value is TimeOfDay) {
      return value.format(context);
    } else if (type == 'Boolean' && value is bool) {
      return value ? 'Yes' : 'No';
    } else if (type == 'Integer' || type == 'Double') {
      return value.toString();
    }
    return value.toString();
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  @override
  void dispose() {
    _bidController.dispose();
    _messageController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}