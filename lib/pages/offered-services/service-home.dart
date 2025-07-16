import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/main.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/pages/add-service_page.dart';
import 'package:my_flutter_app/pages/offered-services/edit-service.dart';
import 'package:my_flutter_app/pages/offered-services/test.dart';
import 'package:my_flutter_app/services/offering_service.dart';

import 'add-service.dart';

// App Text Styles
class AppTextStyles {
  static const headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
  );

  static const buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}

// Service Card Widget
class ServiceCard extends StatelessWidget {
  final OfferingServiceDTO service;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onStatusChanged;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildCategoryIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      if (service.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            service.description,
                            style: AppTextStyles.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                Switch(
                  value: service.status == 'true', // Assuming status is a String
                  activeColor: AppTheme.accentGreen,
                  onChanged: onStatusChanged,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${service.primaryPricing.basePrice.amount.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (service.timing.durationMinutes != null)
                      Text(
                        '${service.timing.durationMinutes} days',
                        style: AppTextStyles.bodyMedium,
                      ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: onEdit,
                      child: Text(
                        'EDIT',
                        style: AppTextStyles.buttonText.copyWith(
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: onDelete,
                      child: Text(
                        'DELETE',
                        style: AppTextStyles.buttonText.copyWith(
                          color: AppTheme.accentOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    IconData icon;
    Color color;

    switch (service.category) {
      case 'Vehicle':
        icon = Icons.directions_car;
        color = AppTheme.primaryBlue;
        break;
      case 'Home':
        icon = Icons.home;
        color = AppTheme.accentOrange;
        break;
      case 'Contract':
        icon = Icons.assignment;
        color = Colors.purple;
        break;
      case 'Full Time':
        icon = Icons.person;
        color = Colors.teal;
        break;
      default:
        icon = Icons.category;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color),
    );
  }
}

// Service Management Screen
class ServiceManagementScreen extends StatefulWidget {

  const ServiceManagementScreen({super.key});

  @override
  State<ServiceManagementScreen> createState() => _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
  final OfferingService _offeringService = OfferingService();
  List<OfferingServiceDTO> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    print('[LoadOfferings] Starting to fetch offerings...');
    setState(() {
      isLoading = true;
    });

    try {
      final offerings = await _offeringService.fetchOfferings();
      print('[LoadOfferings] Success! Received ${offerings.length} offerings');

      setState(() {
        services = offerings;
        isLoading = false;
      });
    } catch (e, stackTrace) {
      print('[LoadOfferings] ERROR: $e');
      print('[LoadOfferings] StackTrace: $stackTrace');

      setState(() {
        isLoading = false;
      });

      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load services: ${e.toString()}'),
            backgroundColor: AppTheme.accentOrange,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _loadOfferings,
            ),
          ),
        );
      }
    } finally {
      print('[LoadOfferings] Completed loading attempt');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('My Services', style: AppTextStyles.headlineLarge),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _loadOfferings,
        color: AppTheme.primaryBlue,
        child: isLoading
            ? _buildLoadingShimmer()
            : services.isEmpty
            ? _buildEmptyState()
            : _buildServicesList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleAddService(context),
        backgroundColor: AppTheme.accentOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.cardColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.handyman,
                  size: 48,
                  color: AppTheme.dividerColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'No services added yet',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Pull down to refresh or tap the + button to add your first service',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppTheme.dividerColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesList() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return ServiceCard(
          service: service,
          onEdit: () => _navigateToEdit(service),
          onDelete: () => _confirmDelete(service),
          onStatusChanged: (value) => _toggleServiceStatus(service, value),
        );
      },
    );
  }

  void _handleAddService(BuildContext context) {
    // In a real app, you would check if user is a provider here
    final isProvider = true; // Temporary for demo

    if (isProvider) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OfferingServiceFormScreen()),
      ).then((_) => _loadOfferings());
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Become a Provider', style: AppTextStyles.headlineSmall),
          content: Text(
            'Do you want to offer a service?',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: AppTextStyles.buttonText),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // In a real app, you would navigate to provider setup
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Redirecting to provider setup')),
                );
              },
              child: Text(
                'Enable Provider',
                style: AppTextStyles.buttonText.copyWith(
                  color: AppTheme.accentGreen,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _navigateToEdit(OfferingServiceDTO service) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfferingServiceFormScreen(
          existingService: service,
          isEditing: true,
        ),
      ),
    );

    if (result == true) {
      _loadOfferings();
    }
  }

  void _confirmDelete(OfferingServiceDTO service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete', style: AppTextStyles.headlineSmall),
        content: Text(
          'Are you sure you want to delete this service?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.buttonText),
          ),
          TextButton(
            onPressed: () {
              // In a real app, you would call API here
              setState(() => services.removeWhere((s) => s.id == service.id));
              _offeringService.deleteOfferingService(service.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Service deleted')),
              );
            },
            child: Text(
              'Delete',
              style: AppTextStyles.buttonText.copyWith(
                color: AppTheme.accentOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleServiceStatus(OfferingServiceDTO service, bool value) {
    // In a real app, you would call API here
    setState(() {
      services = services.map((s) {
        if (s.id == service.id) {
          return OfferingServiceDTO(
            id: s.id,
            offeringCode: s.offeringCode,
            title: s.title,
            description: s.description,
            category: s.category,
            status: value ? 'ACTIVE' : 'INACTIVE', // Convert bool to status string
            verified: s.verified,
            timing: s.timing,
            geography: s.geography,
            tags: s.tags,
            primaryPricing: s.primaryPricing,
            mediaItems: s.mediaItems,
          );
        }
        return s;
      }).toList();
    });
  }
}