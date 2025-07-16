import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/models/address_dto.dart';
import 'package:my_flutter_app/pages/main/AddEditAddressScreen.dart';
import 'package:my_flutter_app/pages/profile_tabs.dart';
import 'package:my_flutter_app/services/UserService.dart';


class AddressesScreen extends StatefulWidget {
  const AddressesScreen({Key? key}) : super(key: key);

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<AddressDTO> addresses = [];
  bool _isLoading = true;
  String? _errorMessage;
  late final UserService _userService;
  
  // Replace with actual user ID - get from auth/session
  final String userId = '16d9da82-a6ba-4c5f-a63b-61c3b5b8ed76'; // TODO: Get from authentication

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'My Addresses',
        style: AppTheme.headlineSmall.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryDark,
        ),
      ),
      centerTitle: false,
      backgroundColor: AppTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(FeatherIcons.arrowLeft, color: AppTheme.primaryDark, size: 24),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(FeatherIcons.plus, color: AppTheme.primaryDark, size: 24),
          onPressed: _addNewAddress,
          tooltip: 'Add new address',
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: ErrorRetryWidget(
          message: _errorMessage!,
          onRetry: _loadAddresses,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAddresses,
      child: addresses.isEmpty ? _buildEmptyState() : _buildAddressList(),
    );
  }

  Widget _buildAddressList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Default address section
          if (addresses.any((a) => a.isDefault == true))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Text(
                    'DEFAULT ADDRESS',
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.textMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildAddressCard(
                  addresses.firstWhere((a) => a.isDefault == true),
                  isDefault: true,
                ),
                const SizedBox(height: 24),
                if (addresses.where((a) => a.isDefault != true).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: Text(
                      'OTHER ADDRESSES',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.textMedium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          // Other addresses
          ...addresses.where((a) => a.isDefault != true).map(
                (address) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildAddressCard(address),
                ),
              ),
          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildAddressCard(AddressDTO address, {bool isDefault = false}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDefault ? AppTheme.primaryBlue : AppTheme.dividerColor,
          width: isDefault ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _editAddress(address),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    address.contactPerson ?? 'Unknown',
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      if (address.addressType != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.textMedium.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            address.addressType!.name.toUpperCase(),
                            style: AppTheme.caption.copyWith(
                              color: AppTheme.textMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (address.addressType != null) const SizedBox(width: 8),
                      if (isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'DEFAULT',
                            style: AppTheme.caption.copyWith(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                address.addressLine1 ?? '',
                style: AppTheme.bodyMedium,
              ),
              if (address.addressLine2 != null && address.addressLine2!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    address.addressLine2!,
                    style: AppTheme.bodyMedium,
                  ),
                ),
              if (address.landmark != null && address.landmark!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Near ${address.landmark}',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textMedium,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                '${address.city ?? ''}, ${address.state ?? ''} - ${address.postalCode ?? ''}',
                style: AppTheme.bodyMedium,
              ),
              if (address.country != null && address.country!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    address.country!,
                    style: AppTheme.bodyMedium,
                  ),
                ),
              if (address.contactPhone != null && address.contactPhone!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Phone: ${address.contactPhone}',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textMedium,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildActionButton(
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    onPressed: () => _editAddress(address),
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    icon: Icons.delete_outline,
                    label: 'Delete',
                    color: AppTheme.errorColor,
                    onPressed: () => _confirmDelete(address),
                  ),
                  const Spacer(),
                  if (!isDefault)
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _setAsDefault(address),
                      child: Text(
                        'SET AS DEFAULT',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18,
        color: color ?? AppTheme.primaryBlue,
      ),
      label: Text(
        label,
        style: AppTheme.bodySmall.copyWith(
          color: color ?? AppTheme.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.home_outlined,
            size: MediaQuery.of(context).size.width * 0.6,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 32),
          Text(
            'No Addresses Added',
            style: AppTheme.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add your delivery addresses for faster checkout experience',
            textAlign: TextAlign.center,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textMedium,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _addNewAddress,
              child: Text(
                'Add New Address',
                style: AppTheme.buttonText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _addNewAddress,
      backgroundColor: AppTheme.primaryBlue,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.add,
        size: 24,
        color: Colors.white,
      ),
    );
  }

  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final loadedAddresses = await _userService.getUserAddresses(userId);
      
      setState(() {
        addresses = loadedAddresses;
        _isLoading = false;
      });
    } on ValidationException catch (e) {
      setState(() {
        _errorMessage = 'Validation error: ${e.validationErrors.join(', ')}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load addresses. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _addNewAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(userId: userId),
        fullscreenDialog: true,
      ),
    ).then((result) {
      if (result == true) {
        _loadAddresses();
      }
    });
  }

  void _editAddress(AddressDTO address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(
          address: address,
          userId: userId,
        ),
        fullscreenDialog: true,
      ),
    ).then((result) {
      if (result == true) {
        _loadAddresses();
      }
    });
  }

  void _confirmDelete(AddressDTO address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Address',
          style: AppTheme.headlineSmall,
        ),
        content: Text(
          'Are you sure you want to delete this address?',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _deleteAddress(address);
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAddress(AddressDTO address) async {
    if (address.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot delete address: Invalid address ID'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      // Show loading state
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deleting address...'),
          duration: Duration(seconds: 2),
        ),
      );

      await _userService.deleteAddress(userId, address.id!);

      setState(() {
        addresses.removeWhere((item) => item.id == address.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } on ValidationException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Validation error: ${e.validationErrors.join(', ')}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete address: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _setAsDefault(AddressDTO address) async {
    if (address.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot set as default: Invalid address ID'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      // Show loading state
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updating default address...'),
          duration: Duration(seconds: 2),
        ),
      );

      // Update the address with isDefault: true
      final updatedAddress = address.copyWith(isDefault: true);
      await _userService.updateAddress(userId, address.id!, updatedAddress);

      // Refresh the addresses list to get the updated state
      await _loadAddresses();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Default address updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } on ValidationException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Validation error: ${e.validationErrors.join(', ')}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update default address: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}