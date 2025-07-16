
// Helper classes that might be needed if not already defined elsewhere

import 'package:flutter/material.dart';
import 'package:my_flutter_app/pages/home/responsive-helper.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  
  const ResponsiveContainer({Key? key, required this.child}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
      child: child,
    );
  }
}

class ResponsiveSizedBox extends StatelessWidget {
  final double? width;
  final double? height;
  
  const ResponsiveSizedBox({Key? key, this.width, this.height}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}