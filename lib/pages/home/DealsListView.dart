// lib/components/deals_list_view.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/main.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/pages/home/DealCard.dart';
import 'package:my_flutter_app/pages/home/responsive-helper.dart';


// Import your OfferingServiceDTO class
// import 'package:my_flutter_app/models/offering_service_dto.dart';

class DealsListView extends StatelessWidget {
  final List<OfferingServiceDTO> offerings;
  final Position? currentPosition;

  const DealsListView({
    super.key,
    required this.offerings,
    this.currentPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
        tablet: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
        desktop: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed height header with Pinterest-style design
          SizedBox(
            height: ResponsiveHelper.isMobile(context) ? 56 : 64,
            child: _buildHeader(context),
          ),
          SizedBox(height: ResponsiveHelper.isMobile(context) ? AppTheme.spacingS : AppTheme.spacingM),
          // Flexible offerings list
          Expanded(
            child: offerings.isEmpty
                ? _buildEmptyState(context)
                : _buildOfferingsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: const [AppTheme.cardShadow],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Available Services',
                  style: AppTheme.headlineMedium.copyWith(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 18,
                      tablet: 20,
                      desktop: 22,
                    ),
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '${offerings.length} services found',
                  style: AppTheme.bodySmall.copyWith(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 12,
                      tablet: 13,
                      desktop: 14,
                    ),
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingS,
              vertical: AppTheme.spacingXS,
            ),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.fiber_manual_record,
                  color: Colors.white,
                  size: 8,
                ),
                const SizedBox(width: AppTheme.spacingXS),
                Text(
                  'Live',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 11,
                      tablet: 12,
                      desktop: 13,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferingsList(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return _buildDesktopGrid(context);
    } else if (ResponsiveHelper.isTablet(context)) {
      return _buildTabletGrid(context);
    } else {
      return _buildMobileList(context);
    }
  }

  Widget _buildMobileList(BuildContext context) {
    return ListView.builder(
      itemCount: offerings.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
          child: _buildOfferingCard(context, offerings[index]),
        );
      },
    );
  }

  Widget _buildTabletGrid(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppTheme.spacingM,
        mainAxisSpacing: AppTheme.spacingM,
        childAspectRatio: 0.8,
      ),
      itemCount: offerings.length,
      itemBuilder: (context, index) {
        return _buildOfferingCard(context, offerings[index]);
      },
    );
  }

  Widget _buildDesktopGrid(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppTheme.spacingL,
        mainAxisSpacing: AppTheme.spacingL,
        childAspectRatio: 0.75,
      ),
      itemCount: offerings.length,
      itemBuilder: (context, index) {
        return _buildOfferingCard(context, offerings[index]);
      },
    );
  }

  Widget _buildOfferingCard(BuildContext context, OfferingServiceDTO offering) {
    // Convert OfferingServiceDTO to Deal format for your existing DealCard
    // This maintains compatibility with your existing DealCard component
    // final deal = Deal(
    //   id: offering.id,
    //   title: offering.title,
    //   description: offering.description,
    //   category: offering.category,
    //   // Map other properties as needed based on your Deal class structure
    //   // You might need to adjust these mappings based on your actual Deal class
    // );

    return DealCard(
      deal: offering,
      onDirectionsTap: () {
        // Handle directions tap if needed
        // You can access offering.geography.latitude and offering.geography.longitude
        // for location-based functionality
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingXL),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient.scale(0.1),
                  shape: BoxShape.circle,
                  boxShadow: const [AppTheme.elevatedShadow],
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  size: ResponsiveHelper.getResponsiveWidth(
                    context,
                    mobile: 56,
                    tablet: 64,
                    desktop: 72,
                  ),
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              Text(
                'No services found',
                style: AppTheme.headlineMedium.copyWith(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 20,
                    tablet: 22,
                    desktop: 24,
                  ),
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXL),
                child: Text(
                  'Try adjusting your filters or search in a different area to find available services',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 14,
                      tablet: 15,
                      desktop: 16,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              // Pinterest-style CTA button
              Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  boxShadow: const [AppTheme.elevatedShadow],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    onTap: () {
                      // Handle refresh or filter action
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingL,
                        vertical: AppTheme.spacingM,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Text(
                            'Refresh Search',
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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