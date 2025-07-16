import 'package:flutter/material.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/pages/ViewDealPage.dart';
import 'package:my_flutter_app/pages/home/responsive-helper.dart';


// Import your OfferingServiceDTO class
// import 'package:my_flutter_app/models/offering_service_dto.dart';

class DealBottomSheet extends StatelessWidget {
  final OfferingServiceDTO offering;
  final VoidCallback? onDirectionsTap;

  const DealBottomSheet({
    super.key,
    required this.offering,
    this.onDirectionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = ResponsiveHelper.isTablet(context);
        final isDesktop = ResponsiveHelper.isDesktop(context);
        
        double height;
        if (isDesktop) {
          height = MediaQuery.of(context).size.height * 0.6;
        } else if (isTablet) {
          height = MediaQuery.of(context).size.height * 0.5;
        } else {
          height = MediaQuery.of(context).size.height * 0.45;
        }
        
        return Container(
          height: height,
          decoration: const BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusL)),
            boxShadow: [AppTheme.elevatedShadow],
          ),
          child: Column(
            children: [
              _buildHandle(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(
                    isDesktop ? AppTheme.spacingXL : (isTablet ? AppTheme.spacingL : AppTheme.spacingM),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: AppTheme.spacingS),
                      _buildDescription(context),
                      const SizedBox(height: AppTheme.spacingM),
                      _buildServiceInfo(context),
                      const SizedBox(height: AppTheme.spacingM),
                      _buildPriceInfo(context),
                      const SizedBox(height: AppTheme.spacingM),
                      _buildTimingInfo(context),
                      const Spacer(),
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      decoration: BoxDecoration(
        color: AppTheme.borderColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                offering.title,
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
              const SizedBox(height: AppTheme.spacingXS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingS,
                  vertical: AppTheme.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: Text(
                  offering.category.name,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppTheme.spacingS),
        // Verification badge
        if (offering.verified)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingS,
              vertical: AppTheme.spacingXS,
            ),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: AppTheme.spacingXS),
                Text(
                  'Verified',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      offering.description,
      style: AppTheme.bodyMedium.copyWith(
        color: AppTheme.textSecondary,
        fontSize: ResponsiveHelper.getResponsiveFontSize(
          context,
          mobile: 14,
          tablet: 15,
          desktop: 16,
        ),
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildServiceInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoItem(
              icon: Icons.room_service,
              label: 'Service Area',
              value: offering.geography.serviceArea ?? 'Not specified',
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: _buildInfoItem(
              icon: Icons.access_time,
              label: 'Duration',
              value: offering.timing.durationMinutes != null
                  ? '${offering.timing.durationMinutes} min'
                  : 'Variable',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 16,
        ),
        const SizedBox(width: AppTheme.spacingXS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTheme.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient.scale(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Starting Price',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  '${offering.primaryPricing.basePrice.currency} ${offering.primaryPricing.basePrice.amount}',
                  style: AppTheme.headlineMedium.copyWith(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                      context,
                      mobile: 22,
                      tablet: 24,
                      desktop: 26,
                    ),
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  offering.primaryPricing.type == PricingType.HOURLY ? 'per hour' : 'fixed price',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (offering.primaryPricing.discount != null)
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
                offering.primaryPricing.discount!,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimingInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Availability',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: AppTheme.textSecondary,
                size: 16,
              ),
              const SizedBox(width: AppTheme.spacingXS),
              Text(
                offering.timing.availableDays.isNotEmpty
                    ? offering.timing.availableDays.join(', ')
                    : 'All days',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          if (offering.timing.startTime != null && offering.timing.endTime != null)
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: AppTheme.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: AppTheme.spacingXS),
                Text(
                  '${offering.timing.startTime} - ${offering.timing.endTime}',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          if (offering.timing.emergencyService)
            Row(
              children: [
                Icon(
                  Icons.emergency,
                  color: AppTheme.accentColor,
                  size: 16,
                ),
                const SizedBox(width: AppTheme.spacingXS),
                Text(
                  'Emergency service available',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);
    
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onDirectionsTap,
            icon: const Icon(Icons.directions),
            label: const Text('Get Directions'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: BorderSide(color: AppTheme.primaryColor),
              padding: EdgeInsets.symmetric(
                vertical: isDesktop ? 18 : (isTablet ? 16 : 14),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              boxShadow: const [AppTheme.cardShadow],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Convert OfferingServiceDTO to Deal for existing ViewDealPage
                // You might need to create a new page or modify ViewDealPage
                // to accept OfferingServiceDTO directly
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewDealPage(offering: offering),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(
                  vertical: isDesktop ? 18 : (isTablet ? 16 : 14),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
              ),
              child: Text(
                'Book Now',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}