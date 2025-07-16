// lib/utils/responsive_helper.dart
import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Updated breakpoints to match your existing ones
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1200;
  static const double largeDesktopBreakpoint = 1440;

  // Your existing methods - maintained for compatibility
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  // New method for large desktop detection
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= largeDesktopBreakpoint;
  }

  // Enhanced screen type detection
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < mobileBreakpoint) {
      return ScreenType.mobile;
    } else if (width < tabletBreakpoint) {
      return ScreenType.tablet;
    } else if (width < largeDesktopBreakpoint) {
      return ScreenType.desktop;
    } else {
      return ScreenType.largeDesktop;
    }
  }

  // Your existing responsive width method
  static double getResponsiveWidth(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Enhanced responsive width with large desktop support
  static double getResponsiveWidthEnhanced(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
    double? largeDesktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    if (isLargeDesktop(context)) return largeDesktop ?? desktop;
    return desktop;
  }

  // Your existing responsive font size method
  static double getResponsiveFontSize(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Enhanced responsive font size with large desktop support
  static double getResponsiveFontSizeEnhanced(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
    double? largeDesktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    if (isLargeDesktop(context)) return largeDesktop ?? desktop;
    return desktop;
  }

  // Your existing responsive padding method
  static EdgeInsets getResponsivePadding(BuildContext context, {
    required EdgeInsets mobile,
    required EdgeInsets tablet,
    required EdgeInsets desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Enhanced responsive padding with large desktop support
  static EdgeInsets getResponsivePaddingEnhanced(BuildContext context, {
    required EdgeInsets mobile,
    required EdgeInsets tablet,
    required EdgeInsets desktop,
    EdgeInsets? largeDesktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    if (isLargeDesktop(context)) return largeDesktop ?? desktop;
    return desktop;
  }

  // Your existing padding method - maintained
  static double getPadding(BuildContext context) {
    if (isMobile(context)) {
      return 8.0;
    } else if (isTablet(context)) {
      return 16.0;
    } else {
      return 24.0;
    }
  }

  // Enhanced padding with large desktop support
  static double getPaddingEnhanced(BuildContext context) {
    if (isMobile(context)) {
      return 8.0;
    } else if (isTablet(context)) {
      return 16.0;
    } else if (isLargeDesktop(context)) {
      return 32.0;
    } else {
      return 24.0;
    }
  }

  // Your existing font size method - maintained
  static double getFontSize(BuildContext context, double fontSize) {
    if (isMobile(context)) {
      return fontSize;
    } else if (isTablet(context)) {
      return fontSize * 1.1;
    } else {
      return fontSize * 1.2;
    }
  }

  // Enhanced font size with large desktop support
  static double getFontSizeEnhanced(BuildContext context, double fontSize) {
    if (isMobile(context)) {
      return fontSize;
    } else if (isTablet(context)) {
      return fontSize * 1.1;
    } else if (isLargeDesktop(context)) {
      return fontSize * 1.3;
    } else {
      return fontSize * 1.2;
    }
  }

  // Your existing grid cross axis count method
  static int getGridCrossAxisCount(BuildContext context, {
    int mobile = 2,
    int tablet = 3,
    int desktop = 4,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Enhanced grid cross axis count with large desktop support
  static int getGridCrossAxisCountEnhanced(BuildContext context, {
    int mobile = 2,
    int tablet = 3,
    int desktop = 4,
    int? largeDesktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    if (isLargeDesktop(context)) return largeDesktop ?? desktop;
    return desktop;
  }

  // Your existing service category tile methods - maintained
  static double getServiceCategoryTileWidth(BuildContext context) {
    if (isMobile(context)) return 100.0;
    if (isTablet(context)) return 120.0;
    return 140.0;
  }

  static double getServiceCategoryTileHeight(BuildContext context) {
    if (isMobile(context)) return 90.0;
    if (isTablet(context)) return 110.0;
    return 130.0;
  }

  // Enhanced service category tile methods with large desktop support
  static double getServiceCategoryTileWidthEnhanced(BuildContext context) {
    if (isMobile(context)) return 100.0;
    if (isTablet(context)) return 120.0;
    if (isLargeDesktop(context)) return 160.0;
    return 140.0;
  }

  static double getServiceCategoryTileHeightEnhanced(BuildContext context) {
    if (isMobile(context)) return 90.0;
    if (isTablet(context)) return 110.0;
    if (isLargeDesktop(context)) return 150.0;
    return 130.0;
  }

  // NEW ENHANCED METHODS FOR BETTER RESPONSIVENESS

  // Generic responsive value getter
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet ?? mobile;
    if (isLargeDesktop(context)) return largeDesktop ?? desktop ?? tablet ?? mobile;
    return desktop ?? tablet ?? mobile;
  }

  // Responsive margin
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: const EdgeInsets.all(4),
      tablet: const EdgeInsets.all(8),
      desktop: const EdgeInsets.all(12),
      largeDesktop: const EdgeInsets.all(16),
    );
  }

  // Responsive border radius
  static BorderRadius getResponsiveBorderRadius(BuildContext context) {
    return BorderRadius.circular(
      getResponsiveValue(
        context,
        mobile: 8.0,
        tablet: 10.0,
        desktop: 12.0,
        largeDesktop: 16.0,
      ),
    );
  }

  // Responsive icon size
  static double getResponsiveIconSize(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 20.0,
      tablet: 24.0,
      desktop: 28.0,
      largeDesktop: 32.0,
    );
  }

  // Responsive spacing
  static double getResponsiveSpacing(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 8.0,
      tablet: 12.0,
      desktop: 16.0,
      largeDesktop: 20.0,
    );
  }

  // Responsive sidebar width for your HomeScreen
  static double getResponsiveSidebarWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (isMobile(context)) {
      return screenWidth * 0.8; // 80% for mobile drawer
    } else if (isTablet(context)) {
      return screenWidth * 0.4; // 40% for tablet
    } else if (isLargeDesktop(context)) {
      return 480; // Larger fixed width for large desktop
    } else {
      return 400; // Fixed width for desktop
    }
  }

  // Responsive header height
  static double getResponsiveHeaderHeight(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 60.0,
      tablet: 70.0,
      desktop: 80.0,
      largeDesktop: 90.0,
    );
  }

  // Responsive max width for content
  static double getResponsiveMaxWidth(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: double.infinity,
      tablet: 800,
      desktop: 1200,
      largeDesktop: 1600,
    );
  }

  // Responsive layout builder widget
  static Widget responsiveBuilder(
    BuildContext context, {
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
    Widget? largeDesktop,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile(context)) {
          return mobile;
        } else if (isTablet(context)) {
          return tablet ?? mobile;
        } else if (isLargeDesktop(context)) {
          return largeDesktop ?? desktop ?? tablet ?? mobile;
        } else {
          return desktop ?? tablet ?? mobile;
        }
      },
    );
  }

  // Orientation helpers
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Safe area helpers
  static EdgeInsets getResponsiveSafeArea(BuildContext context) {
    final safeArea = MediaQuery.of(context).padding;
    final additionalPadding = EdgeInsets.all(getPaddingEnhanced(context));
    
    return EdgeInsets.only(
      top: safeArea.top + additionalPadding.top,
      bottom: safeArea.bottom + additionalPadding.bottom,
      left: safeArea.left + additionalPadding.left,
      right: safeArea.right + additionalPadding.right,
    );
  }

  // Responsive constraints
  static BoxConstraints getResponsiveConstraints(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return BoxConstraints(
      minWidth: getResponsiveValue(
        context,
        mobile: 0,
        tablet: 300,
        desktop: 400,
        largeDesktop: 480,
      ),
      maxWidth: getResponsiveMaxWidth(context),
      minHeight: 0,
      maxHeight: screenSize.height,
    );
  }

  // Responsive flex values for layouts
  static int getResponsiveFlex(BuildContext context, {
    int mobile = 1,
    int? tablet,
    int? desktop,
    int? largeDesktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  // Responsive elevation
  static double getResponsiveElevation(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 2.0,
      tablet: 4.0,
      desktop: 6.0,
      largeDesktop: 8.0,
    );
  }

  // Responsive app bar height
  static double getResponsiveAppBarHeight(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: kToolbarHeight,
      tablet: kToolbarHeight + 10,
      desktop: kToolbarHeight + 20,
      largeDesktop: kToolbarHeight + 30,
    );
  }

  // Responsive card aspect ratio
  static double getResponsiveCardAspectRatio(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 1.5,
      tablet: 1.3,
      desktop: 1.2,
      largeDesktop: 1.1,
    );
  }

  // Responsive list tile height
  static double getResponsiveListTileHeight(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 60.0,
      tablet: 70.0,
      desktop: 80.0,
      largeDesktop: 90.0,
    );
  }
}

// Screen type enumeration
enum ScreenType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

// Responsive breakpoint widget for easy usage
class ResponsiveBreakpoint extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveBreakpoint({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.responsiveBuilder(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }
}

// Responsive container widget
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxConstraints? constraints;
  final Decoration? decoration;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.constraints,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
      margin: margin ?? ResponsiveHelper.getResponsiveMargin(context),
      constraints: constraints ?? ResponsiveHelper.getResponsiveConstraints(context),
      decoration: decoration,
      child: child,
    );
  }
}

// Responsive SizedBox for spacing
class ResponsiveSizedBox extends StatelessWidget {
  final double? width;
  final double? height;
  final bool useSpacing;

  const ResponsiveSizedBox({
    Key? key,
    this.width,
    this.height,
    this.useSpacing = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (useSpacing) {
      final spacing = ResponsiveHelper.getResponsiveSpacing(context);
      return SizedBox(
        width: width ?? spacing,
        height: height ?? spacing,
      );
    }
    return SizedBox(width: width, height: height);
  }
}