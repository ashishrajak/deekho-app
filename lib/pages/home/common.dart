
// lib/widgets/common/app_card.dart
import 'package:flutter/material.dart';
import 'package:my_flutter_app/config/AppTheme.dart';

// lib/widgets/common/app_card.dart
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? borderRadius;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.shadows,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(AppTheme.spacingS),
      child: Material(
        color: color ?? AppTheme.cardColor,
        borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusM),
        shadowColor: AppTheme.shadowColor,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusM),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusM),
              boxShadow: shadows ?? [AppTheme.cardShadow],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// lib/widgets/home/offer_banner.dart
class OfferBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String discount;
  final VoidCallback? onTap;

  const OfferBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.discount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;
    final isMobile = screenWidth <= 768;
    
    double bannerWidth = screenWidth - (AppTheme.spacingM * 2);
    if (isDesktop) {
      bannerWidth = screenWidth * 0.8;
    } else if (isTablet) {
      bannerWidth = screenWidth * 0.9;
    }

    return Container(
      width: bannerWidth,
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: AppCard(
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.offerGradient,
            borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusM)),
          ),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? AppTheme.spacingM : AppTheme.spacingL),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          discount,
                          style: AppTheme.headlineLarge.copyWith(
                            color: Colors.white,
                            fontSize: isMobile ? 20 : (isTablet ? 24 : 28),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      Text(
                        title,
                        style: AppTheme.headlineSmall.copyWith(
                          color: Colors.white,
                          fontSize: isMobile ? 14 : 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      Text(
                        subtitle,
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: isMobile ? 10 : 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: isMobile ? 16 : 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/widgets/home/category_chip.dart
class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 768;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: AppTheme.spacingM),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? AppTheme.spacingS : AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isMobile ? 14 : 16,
              color: isSelected ? Colors.white : AppTheme.textSecondary,
            ),
            const SizedBox(width: AppTheme.spacingXS),
            Flexible(
              child: Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: isMobile ? 12 : 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/widgets/home/custom_tab_bar.dart
class CustomTabBar extends StatelessWidget {
  final TabController tabController;

  const CustomTabBar({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 768;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? AppTheme.spacingS : AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      height: isMobile ? 40 : 48,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: AppTheme.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: isMobile ? 12 : 14,
        ),
        unselectedLabelStyle: AppTheme.bodyMedium.copyWith(
          fontSize: isMobile ? 12 : 14,
        ),
        tabs: [
          Tab(
            icon: Icon(Icons.list_alt, size: isMobile ? 16 : 20),
            text: 'Services',
          ),
          Tab(
            icon: Icon(Icons.map, size: isMobile ? 16 : 20),
            text: 'Map',
          ),
        ],
      ),
    );
  }
}