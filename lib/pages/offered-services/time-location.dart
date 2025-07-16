
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/pages/home/responsive-helper.dart';

class TimingLocationTab extends StatefulWidget {
  final OfferingServiceDTO formData;
  final Function(OfferingServiceDTO) onFormDataChanged;

  const TimingLocationTab({
    Key? key,
    required this.formData,
    required this.onFormDataChanged,
  }) : super(key: key);

  @override
  State<TimingLocationTab> createState() => _TimingLocationTabState();
}

class _TimingLocationTabState extends State<TimingLocationTab> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _durationController;
  late TextEditingController _serviceAreaController;
  late TextEditingController _travelRadiusController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  
  final List<String> _weekDays = ['MONDAY', 'WEDNESDAY', 'SATURDAY', 'THURSDAY', 'TUESDAY', 'FRIDAY', 'SUNDAY'];
  
  Set<String> _selectedDays = <String>{};
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isEmergencyService = false;
  bool _isRemoteService = false;
  bool _isOnSiteService = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeData();
  }

  void _initializeControllers() {
    _durationController = TextEditingController(
      text: widget.formData.timing.durationMinutes?.toString() ?? ''
    );
    _serviceAreaController = TextEditingController(
      text: widget.formData.geography.serviceArea ?? ''
    );
    _travelRadiusController = TextEditingController(
      text: widget.formData.geography.travelRadius?.toString() ?? ''
    );
    _addressController = TextEditingController(
      text: widget.formData.geography.serviceArea ?? ''
    );
    _cityController = TextEditingController(
      // text: widget.formData.geography. ?? ''
    );
    _stateController = TextEditingController(
     // text: widget.formData.geography.state ?? ''
    );
    _zipCodeController = TextEditingController(
     // text: widget.formData.geography.zipCode ?? ''
    );
  }

  void _initializeData() {
    _selectedDays = Set.from(widget.formData.timing.availableDays);
    _isEmergencyService = widget.formData.timing.emergencyService;
    
    // Parse start and end times if available
    if (widget.formData.timing.startTime != null) {
      final parts = widget.formData.timing.startTime!.split(':');
      if (parts.length == 2) {
        _startTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    }
    
    if (widget.formData.timing.endTime != null) {
      final parts = widget.formData.timing.endTime!.split(':');
      if (parts.length == 2) {
        _endTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    }
  }

  void _updateTiming() {
    final updatedTiming = widget.formData.timing.copyWith(
      durationMinutes: int.tryParse(_durationController.text),
      availableDays: _selectedDays.toList(),
      startTime: _startTime != null ? '${_startTime!.hour}:${_startTime!.minute.toString().padLeft(2, '0')}' : null,
      endTime: _endTime != null ? '${_endTime!.hour}:${_endTime!.minute.toString().padLeft(2, '0')}' : null,
      emergencyService: _isEmergencyService,
    );
    
    widget.onFormDataChanged(
      widget.formData.copyWith(timing: updatedTiming),
    );
  }

  void _updateGeography() {
    final updatedGeography = widget.formData.geography.copyWith(
      serviceArea: _serviceAreaController.text,
      travelRadius: double.tryParse(_travelRadiusController.text),
      // address: _addressController.text,
      // city: _cityController.text,
      // state: _stateController.text,
      // zipCode: _zipCodeController.text,
    );
    
    widget.onFormDataChanged(
      widget.formData.copyWith(geography: updatedGeography),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime ?? TimeOfDay.now() : _endTime ?? TimeOfDay.now(),
    );
    
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
      _updateTiming();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Timing & Location',
                style: AppTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Set your service availability and location preferences',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 32),
              
              // Service Duration
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Service Duration (minutes)',
                  hintText: 'e.g., 60',
                  prefixIcon: Icon(Icons.access_time),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => _updateTiming(),
              ),
              const SizedBox(height: 24),
              
              // Available Days
              _buildAvailableDaysSection(),
              const SizedBox(height: 24),
              
              // Time Range
              _buildTimeRangeSection(),
              const SizedBox(height: 24),
              
              // Service Options
              _buildServiceOptionsSection(),
              const SizedBox(height: 32),
              
              // Location Section
              _buildLocationSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableDaysSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Days',
          style: AppTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _weekDays.map((day) {
            final isSelected = _selectedDays.contains(day);
            return FilterChip(
              label: Text(day),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedDays.add(day);
                  } else {
                    _selectedDays.remove(day);
                  }
                });
                _updateTiming();
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Hours',
          style: AppTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectTime(context, true),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        _startTime != null
                            ? _startTime!.format(context)
                            : 'Start Time',
                        style: AppTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectTime(context, false),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        _endTime != null
                            ? _endTime!.format(context)
                            : 'End Time',
                        style: AppTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Options',
          style: AppTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Emergency Service'),
          subtitle: const Text('Available for emergency calls'),
          value: _isEmergencyService,
          onChanged: (value) {
            setState(() {
              _isEmergencyService = value;
            });
            _updateTiming();
          },
        ),
        SwitchListTile(
          title: const Text('Remote Service'),
          subtitle: const Text('Can be provided remotely'),
          value: _isRemoteService,
          onChanged: (value) {
            setState(() {
              _isRemoteService = value;
            });
            _updateGeography();
          },
        ),
        SwitchListTile(
          title: const Text('On-Site Service'),
          subtitle: const Text('Provided at customer location'),
          value: _isOnSiteService,
          onChanged: (value) {
            setState(() {
              _isOnSiteService = value;
            });
            _updateGeography();
          },
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location Details',
          style: AppTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        
        // Service Area
        TextFormField(
          controller: _serviceAreaController,
          decoration: const InputDecoration(
            labelText: 'Service Area',
            hintText: 'e.g., Downtown, North Side',
            prefixIcon: Icon(Icons.location_on),
          ),
          onChanged: (_) => _updateGeography(),
        ),
        const SizedBox(height: 16),
        
        // Travel Radius
        TextFormField(
          controller: _travelRadiusController,
          decoration: const InputDecoration(
            labelText: 'Travel Radius (miles)',
            hintText: 'e.g., 10',
            prefixIcon: Icon(Icons.radio_button_checked),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _updateGeography(),
        ),
        const SizedBox(height: 16),
        
        // Address
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address',
            hintText: 'Street address',
            prefixIcon: Icon(Icons.home),
          ),
          onChanged: (_) => _updateGeography(),
        ),
        const SizedBox(height: 16),
        
        // City, State, ZIP
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city),
                ),
                onChanged: (_) => _updateGeography(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                  prefixIcon: Icon(Icons.map),
                ),
                onChanged: (_) => _updateGeography(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(
                  labelText: 'ZIP Code',
                  prefixIcon: Icon(Icons.pin_drop),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _updateGeography(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _durationController.dispose();
    _serviceAreaController.dispose();
    _travelRadiusController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }
}


