import 'package:flutter/material.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/models/address_dto.dart';
import 'package:my_flutter_app/services/UserService.dart';


class AddEditAddressScreen extends StatefulWidget {
  final AddressDTO? address; // null for add, non-null for edit
  final String userId;

  const AddEditAddressScreen({
    Key? key,
    this.address,
    required this.userId,
  }) : super(key: key);

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late final UserService _userService;
  bool _isLoading = false;
  
  // Form controllers
  final _contactPersonController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  
  // Form state
  AddressType _selectedAddressType = AddressType.home;
  bool _isDefault = false;

  bool get isEditMode => widget.address != null;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _initializeForm();
  }

  void _initializeForm() {
    if (isEditMode) {
      final address = widget.address!;
      _contactPersonController.text = address.contactPerson ?? '';
      _addressLine1Controller.text = address.addressLine1 ?? '';
      _addressLine2Controller.text = address.addressLine2 ?? '';
      _landmarkController.text = address.landmark ?? '';
      _cityController.text = address.city ?? '';
      _stateController.text = address.state ?? '';
      _postalCodeController.text = address.postalCode ?? '';
      _countryController.text = address.country ?? '';
      _contactPhoneController.text = address.contactPhone ?? '';
      _selectedAddressType = address.addressType ?? AddressType.home;
      _isDefault = address.isDefault ?? false;
    }
  }

  @override
  void dispose() {
    _contactPersonController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        isEditMode ? 'Edit Address' : 'Add New Address',
        style: AppTheme.headlineSmall.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryDark,
        ),
      ),
      centerTitle: false,
      backgroundColor: AppTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close, color: AppTheme.primaryDark, size: 24),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else
          TextButton(
            onPressed: _saveAddress,
            child: Text(
              isEditMode ? 'UPDATE' : 'SAVE',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressTypeSelector(),
            const SizedBox(height: 24),
            _buildContactPersonField(),
            const SizedBox(height: 16),
            _buildAddressLine1Field(),
            const SizedBox(height: 16),
            _buildAddressLine2Field(),
            const SizedBox(height: 16),
            _buildLandmarkField(),
            const SizedBox(height: 16),
            _buildCityStateRow(),
            const SizedBox(height: 16),
            _buildPostalCodeCountryRow(),
            const SizedBox(height: 16),
            _buildContactPhoneField(),
            const SizedBox(height: 24),
            _buildDefaultAddressSwitch(),
            const SizedBox(height: 32),
            _buildSaveButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address Type',
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: AddressType.values.map((type) {
            final isSelected = _selectedAddressType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAddressType = type;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryBlue : AppTheme.dividerColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      type.name.toUpperCase(),
                      style: AppTheme.bodySmall.copyWith(
                        color: isSelected ? Colors.white : AppTheme.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContactPersonField() {
    return TextFormField(
      controller: _contactPersonController,
      decoration: InputDecoration(
        labelText: 'Contact Person',
        hintText: 'Enter full name',
        prefixIcon: Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Contact person is required';
        }
        return null;
      },
    );
  }

  Widget _buildAddressLine1Field() {
    return TextFormField(
      controller: _addressLine1Controller,
      decoration: InputDecoration(
        labelText: 'Address Line 1',
        hintText: 'House/Flat/Building number and street',
        prefixIcon: Icon(Icons.home_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Address line 1 is required';
        }
        return null;
      },
    );
  }

  Widget _buildAddressLine2Field() {
    return TextFormField(
      controller: _addressLine2Controller,
      decoration: InputDecoration(
        labelText: 'Address Line 2 (Optional)',
        hintText: 'Area, Colony, Sector',
        prefixIcon: Icon(Icons.location_on_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLandmarkField() {
    return TextFormField(
      controller: _landmarkController,
      decoration: InputDecoration(
        labelText: 'Landmark (Optional)',
        hintText: 'Near famous location',
        prefixIcon: Icon(Icons.place_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildCityStateRow() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: 'City',
              hintText: 'Enter city',
              prefixIcon: Icon(Icons.location_city_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'City is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _stateController,
            decoration: InputDecoration(
              labelText: 'State',
              hintText: 'Enter state',
              prefixIcon: Icon(Icons.map_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'State is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPostalCodeCountryRow() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _postalCodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Postal Code',
              hintText: 'Enter postal code',
              prefixIcon: Icon(Icons.markunread_mailbox_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Postal code is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _countryController,
            decoration: InputDecoration(
              labelText: 'Country',
              hintText: 'Enter country',
              prefixIcon: Icon(Icons.public_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Country is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContactPhoneField() {
    return TextFormField(
      controller: _contactPhoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Contact Phone',
        hintText: 'Enter phone number',
        prefixIcon: Icon(Icons.phone_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Contact phone is required';
        }
        if (value.length < 10) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }

  Widget _buildDefaultAddressSwitch() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.dividerColor),
      ),
      child: SwitchListTile(
        title: Text(
          'Set as Default Address',
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'This address will be used as default for deliveries',
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textMedium,
          ),
        ),
        value: _isDefault,
        onChanged: (value) {
          setState(() {
            _isDefault = value;
          });
        },
        activeColor: AppTheme.primaryBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isLoading ? null : _saveAddress,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                isEditMode ? 'UPDATE ADDRESS' : 'SAVE ADDRESS',
                style: AppTheme.buttonText,
              ),
      ),
    );
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final addressDTO = AddressDTO(
        id: isEditMode ? widget.address!.id : null,
        addressLine1: _addressLine1Controller.text.trim(),
        addressLine2: _addressLine2Controller.text.trim().isEmpty 
            ? null 
            : _addressLine2Controller.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        country: _countryController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        addressType: _selectedAddressType,
        isActive: true,
        landmark: _landmarkController.text.trim().isEmpty 
            ? null 
            : _landmarkController.text.trim(),
        contactPerson: _contactPersonController.text.trim(),
        contactPhone: _contactPhoneController.text.trim(),
        isDefault: _isDefault,
      );

      if (isEditMode) {
        await _userService.updateAddress(
          widget.userId,
          widget.address!.id!,
          addressDTO,
        );
        _showSuccessMessage('Address updated successfully');
      } else {
        await _userService.addAddress(widget.userId, addressDTO);
        _showSuccessMessage('Address added successfully');
      }

      Navigator.pop(context, true); // Return true to indicate success
    } on ValidationException catch (e) {
      _showErrorMessage('Validation error: ${e.validationErrors.join(', ')}');
    } catch (e) {
      _showErrorMessage('Failed to save address: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}