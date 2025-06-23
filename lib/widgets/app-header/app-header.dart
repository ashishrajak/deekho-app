import 'package:flutter/material.dart';
import 'package:my_flutter_app/main.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor, // Use your color here
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Search bar row with notification bell
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for services, products...",
                      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
                      prefixIcon: Icon(Icons.search, color: AppColors.textLight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppColors.dividerColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppColors.dividerColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppColors.primaryBlue),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(Icons.notifications_none, color: AppColors.primaryBlue),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Filters row (same as before)
         
          ],
      ),
    );
  }

  Widget _buildFilter(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.dividerColor),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          const Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );
  }
}
