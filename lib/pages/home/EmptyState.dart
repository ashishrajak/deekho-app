import 'package:flutter/material.dart';
import 'package:my_flutter_app/pages/home/responsive-helper.dart';


class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onActionTap;
  final String? actionText;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onActionTap,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = ResponsiveHelper.isTablet(context);
        final iconSize = isTablet ? 80.0 : 64.0;
        final titleSize = isTablet ? 24.0 : 20.0;
        final subtitleSize = isTablet ? 18.0 : 16.0;
        final padding = isTablet ? 40.0 : 32.0;
        
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  color: const Color(0xFF667EEA).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: iconSize,
                  color: const Color(0xFF667EEA),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 80 : 40),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: subtitleSize,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (onActionTap != null && actionText != null) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onActionTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667EEA),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 32 : 24,
                      vertical: isTablet ? 16 : 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    actionText!,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}