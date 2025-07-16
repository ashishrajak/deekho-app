import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_flutter_app/config/AppTheme.dart';

class PostServicePage extends StatefulWidget {
  @override
  _PostServicePageState createState() => _PostServicePageState();
}

class _PostServicePageState extends State<PostServicePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _budgetMinController = TextEditingController();
  final _budgetMaxController = TextEditingController();
  final _serviceRadiusController = TextEditingController();
  final _trackingIntervalController = TextEditingController();
  final _trackingDurationController = TextEditingController();
  final _mustHaveController = TextEditingController();
  final _niceToHaveController = TextEditingController();
  final _dealBreakersController = TextEditingController();
  final _qualificationKeyController = TextEditingController();
  final _qualificationValueController = TextEditingController();

  Map<String, dynamic>? selectedCategory;
  String selectedBudgetType = 'FIXED';
  String selectedUrgencyLevel = 'MEDIUM';
  bool isFlexibleTiming = false;
  DateTime? preferredDate;
  TimeOfDay? preferredTime;
  DateTime? biddingExpiresAt;

  List<String> mustHave = [];
  List<String> niceToHave = [];
  List<String> dealBreakers = [];
  Map<String, String> qualifications = {};
  Map<String, dynamic> serviceData = {}; // Dynamic fields data

  // Dynamic field controllers
  Map<String, TextEditingController> dynamicControllers = {};

  // Mock categories with enhanced structure (as per your first code snippet)
  final List<Map<String, dynamic>> categories = [
    {
      'id': 1,
      'name': 'plumber',
      'displayName': 'Plumber',
      'iconUrl': Icons.plumbing,
      'isActive': true,
      'sortOrder': 1,
      'configData': {
        'requiresLocation': true,
        'supportsEquipment': true,
        'allowsGroupBooking': false,
        'biddingEnabled': true,
        'commonFields': ['location', 'timing', 'budget'],
        'fields': [
          {'name': 'plumbingType', 'type': 'String', 'required': true, 'options': ['Kitchen', 'Bathroom', 'General']},
          {'name': 'urgencyLevel', 'type': 'String', 'required': true, 'options': ['Emergency', 'Same Day', 'Within Week']},
          {'name': 'hasTools', 'type': 'Boolean', 'required': false},
        ]
      }
    },
    {
      'id': 2,
      'name': 'bike_service',
      'displayName': 'Bike Service',
      'iconUrl': Icons.motorcycle,
      'isActive': true,
      'sortOrder': 2,
      'configData': {
        'requiresLocation': true,
        'supportsEquipment': false,
        'allowsGroupBooking': true,
        'biddingEnabled': false,
        'commonFields': ['location', 'timing'],
        'fields': [
          {'name': 'fromLocation', 'type': 'String', 'required': true},
          {'name': 'toLocation', 'type': 'String', 'required': true},
          {'name': 'departureTime', 'type': 'DateTime', 'required': true},
          {'name': 'maxPassengers', 'type': 'Integer', 'required': true},
          {'name': 'farePerPerson', 'type': 'Double', 'required': false},
          {'name': 'allowsLuggage', 'type': 'Boolean', 'required': false},
        ]
      }
    },
    {
      'id': 3,
      'name': 'thele_vala',
      'displayName': 'Thele Vala (Fruit Vendor)',
      'iconUrl': Icons.shopping_cart,
      'isActive': true,
      'sortOrder': 3,
      'configData': {
        'requiresLocation': true,
        'supportsEquipment': false,
        'allowsGroupBooking': false,
        'biddingEnabled': false,
        'commonFields': ['location', 'timing'],
        'fields': [
          {'name': 'vendorType', 'type': 'String', 'required': true, 'options': ['Fruits', 'Vegetables', 'Both']},
          {'name': 'startTime', 'type': 'Time', 'required': true},
          {'name': 'endTime', 'type': 'Time', 'required': true},
          {'name': 'route', 'type': 'String', 'required': true},
          {'name': 'liveTracking', 'type': 'Boolean', 'required': false},
          {'name': 'contactNumber', 'type': 'String', 'required': true},
        ]
      }
    },
    {
      'id': 4,
      'name': 'electrician',
      'displayName': 'Electrician',
      'iconUrl': Icons.electrical_services,
      'isActive': true,
      'sortOrder': 4,
      'configData': {
        'requiresLocation': true,
        'supportsEquipment': true,
        'allowsGroupBooking': false,
        'biddingEnabled': true,
        'commonFields': ['location', 'timing', 'budget'],
        'fields': [
          {'name': 'workType', 'type': 'String', 'required': true, 'options': ['Wiring', 'Repair', 'Installation']},
          {'name': 'voltage', 'type': 'String', 'required': false, 'options': ['220V', '440V', 'Both']},
          {'name': 'hasLicense', 'type': 'Boolean', 'required': true},
        ]
      }
    },
    {
      'id': 5,
      'name': 'mason',
      'displayName': 'Mason',
      'iconUrl': Icons.construction,
      'isActive': true,
      'sortOrder': 5,
      'configData': {
        'requiresLocation': true,
        'supportsEquipment': true,
        'allowsGroupBooking': false,
        'biddingEnabled': true,
        'commonFields': ['location', 'timing', 'budget'],
        'fields': [
          {'name': 'constructionType', 'type': 'String', 'required': true, 'options': ['New Construction', 'Renovation', 'Repair']},
          {'name': 'materialProvider', 'type': 'String', 'required': true, 'options': ['Client', 'Contractor', 'Both']},
          {'name': 'experienceYears', 'type': 'Integer', 'required': false},
        ]
      }
    },
    {
      'id': 6,
      'name': 'carpenter',
      'displayName': 'Carpenter',
      'iconUrl': Icons.carpenter,
      'isActive': true,
      'sortOrder': 6,
      'configData': {
        'requiresLocation': true,
        'supportsEquipment': true,
        'allowsGroupBooking': false,
        'biddingEnabled': true,
        'commonFields': ['location', 'timing', 'budget'],
        'fields': [
          {'name': 'woodType', 'type': 'String', 'required': false, 'options': ['Teak', 'Pine', 'Oak', 'Plywood']},
          {'name': 'workType', 'type': 'String', 'required': true, 'options': ['Furniture', 'Doors', 'Windows', 'Flooring']},
          {'name': 'hasOwnTools', 'type': 'Boolean', 'required': true},
        ]
      }
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeDynamicControllers();
  }

  void _initializeDynamicControllers() {
    for (var category in categories) {
      var fields = category['configData']['fields'] as List<Map<String, dynamic>>;
      for (var field in fields) {
        dynamicControllers[field['name']] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _budgetMinController.dispose();
    _budgetMaxController.dispose();
    _serviceRadiusController.dispose();
    _trackingIntervalController.dispose();
    _trackingDurationController.dispose();
    _mustHaveController.dispose();
    _niceToHaveController.dispose();
    _dealBreakersController.dispose();
    _qualificationKeyController.dispose();
    _qualificationValueController.dispose();
    dynamicControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primary,
        title: Text('Post Service Request', style: TextStyle(color: AppTheme.textWhite)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  _buildBasicInfoSection(),
                  SizedBox(height: 20),
                  _buildCategorySection(),
                  SizedBox(height: 20),
                  if (selectedCategory != null) _buildDynamicFieldsSection(),
                  if (selectedCategory != null) SizedBox(height: 20),
                  if (selectedCategory != null && _shouldShowLocationSection()) _buildLocationSection(),
                  if (selectedCategory != null && _shouldShowLocationSection()) SizedBox(height: 20),
                  if (selectedCategory != null && _shouldShowBudgetSection()) _buildBudgetSection(),
                  if (selectedCategory != null && _shouldShowBudgetSection()) SizedBox(height: 20),
                  if (selectedCategory != null && _shouldShowTimingSection()) _buildTimingSection(),
                  if (selectedCategory != null && _shouldShowTimingSection()) SizedBox(height: 20),
                  if (selectedCategory != null && _shouldShowBiddingSection()) _buildRequirementsSection(),
                  if (selectedCategory != null && _shouldShowBiddingSection()) SizedBox(height: 20),
                  if (selectedCategory != null && _shouldShowTrackingSection()) _buildTrackingSection(),
                  if (selectedCategory != null && _shouldShowTrackingSection()) SizedBox(height: 20),
                  if (selectedCategory != null) _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldShowLocationSection() {
    return selectedCategory?['configData']['requiresLocation'] ?? false;
  }

  bool _shouldShowBudgetSection() {
    var commonFields = selectedCategory?['configData']['commonFields'] as List<dynamic>?;
    return commonFields?.contains('budget') ?? false;
  }

  bool _shouldShowTimingSection() {
    var commonFields = selectedCategory?['configData']['commonFields'] as List<dynamic>?;
    return commonFields?.contains('timing') ?? false;
  }

  bool _shouldShowBiddingSection() {
    return selectedCategory?['configData']['biddingEnabled'] ?? false;
  }

  bool _shouldShowTrackingSection() {
    return selectedCategory?['name'] == 'thele_vala';
  }

  Widget _buildBasicInfoSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppTheme.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Basic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Service Title',
              hintText: 'e.g., Need plumber for kitchen sink repair',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: Icon(Icons.title, color: AppTheme.primary),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Title is required' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Describe your service requirement in detail...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: Icon(Icons.description, color: AppTheme.primary),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Description is required' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppTheme.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 600 ? 4 : constraints.maxWidth > 400 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory?['id'] == category['id'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                        _clearDynamicFields();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primary : AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category['iconUrl'], color: isSelected ? AppTheme.textWhite : AppTheme.primary, size: 28),
                          SizedBox(height: 4),
                          Text(
                            category['displayName'],
                            style: TextStyle(
                              color: isSelected ? AppTheme.textWhite : AppTheme.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicFieldsSection() {
    if (selectedCategory == null) return SizedBox.shrink();

    var fields = selectedCategory!['configData']['fields'] as List<Map<String, dynamic>>;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppTheme.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${selectedCategory!['displayName']} Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          SizedBox(height: 16),
          ...fields.map((field) => _buildDynamicField(field)).toList(),
        ],
      ),
    );
  }

  Widget _buildDynamicField(Map<String, dynamic> field) {
    String fieldName = field['name'];
    String fieldType = field['type'];
    bool isRequired = field['required'] ?? false;
    List<String>? options = field['options']?.cast<String>();

    Widget fieldWidget;

    switch (fieldType) {
      case 'Boolean':
        fieldWidget = SwitchListTile(
          title: Text(_formatFieldName(fieldName)),
          value: serviceData[fieldName] ?? false,
          onChanged: (value) => setState(() => serviceData[fieldName] = value),
          activeColor: AppTheme.primary,
        );
        break;
      case 'Integer':
        fieldWidget = TextFormField(
          controller: dynamicControllers[fieldName],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: _formatFieldName(fieldName) + (isRequired ? ' *' : ''),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: Icon(Icons.numbers, color: AppTheme.primary),
          ),
          validator: isRequired ? (value) => value?.isEmpty ?? true ? '${_formatFieldName(fieldName)} is required' : null : null,
          onChanged: (value) => serviceData[fieldName] = int.tryParse(value),
        );
        break;
      case 'Double':
        fieldWidget = TextFormField(
          controller: dynamicControllers[fieldName],
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: _formatFieldName(fieldName) + (isRequired ? ' *' : ''),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: Icon(Icons.attach_money, color: AppTheme.primary),
          ),
          validator: isRequired ? (value) => value?.isEmpty ?? true ? '${_formatFieldName(fieldName)} is required' : null : null,
          onChanged: (value) => serviceData[fieldName] = double.tryParse(value),
        );
        break;
      case 'DateTime':
        fieldWidget = InkWell(
          onTap: () => _selectDateTime(fieldName),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppTheme.primary),
                SizedBox(width: 8),
                Text(
                  serviceData[fieldName] != null
                      ? _formatDateTime(serviceData[fieldName])
                      : '${_formatFieldName(fieldName)}${isRequired ? ' *' : ''}',
                ),
              ],
            ),
          ),
        );
        break;
      case 'Time':
        fieldWidget = InkWell(
          onTap: () => _selectTime(context, fieldName),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: AppTheme.primary),
                SizedBox(width: 8),
                Text(
                  serviceData[fieldName] != null
                      ? (serviceData[fieldName] as TimeOfDay).format(context)
                      : '${_formatFieldName(fieldName)}${isRequired ? ' *' : ''}',
                ),
              ],
            ),
          ),
        );
        break;
      default: // String
        if (options != null && options.isNotEmpty) {
          fieldWidget = DropdownButtonFormField<String>(
            value: serviceData[fieldName],
            decoration: InputDecoration(
              labelText: _formatFieldName(fieldName) + (isRequired ? ' *' : ''),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: Icon(Icons.list, color: AppTheme.primary),
            ),
            items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
            onChanged: (value) => setState(() => serviceData[fieldName] = value),
            validator: isRequired ? (value) => value == null ? '${_formatFieldName(fieldName)} is required' : null : null,
          );
        } else {
          fieldWidget = TextFormField(
            controller: dynamicControllers[fieldName],
            decoration: InputDecoration(
              labelText: _formatFieldName(fieldName) + (isRequired ? ' *' : ''),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: Icon(Icons.text_fields, color: AppTheme.primary),
            ),
            validator: isRequired ? (value) => value?.isEmpty ?? true ? '${_formatFieldName(fieldName)} is required' : null : null,
            onChanged: (value) => serviceData[fieldName] = value,
          );
        }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: fieldWidget,
    );
  }

  String _formatFieldName(String fieldName) {
    return fieldName.replaceAll(RegExp(r'([A-Z])'), ' \$1').split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join(' ').trim();
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _clearDynamicFields() {
    serviceData.clear();
    dynamicControllers.values.forEach((controller) => controller.clear());
  }

  Future<void> _selectDateTime(String fieldName) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          serviceData[fieldName] = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _selectTime(BuildContext context, String fieldName) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => serviceData[fieldName] = picked);
    }
  }

  Widget _buildLocationSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppTheme.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Service Address',
              hintText: 'Enter complete address',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: Icon(Icons.location_on, color: AppTheme.primary),
              suffixIcon: IconButton(
                icon: Icon(Icons.my_location, color: AppTheme.primary),
                onPressed: () {
                  // TODO: Implement current location fetching
                },
              ),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Address is required' : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _serviceRadiusController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Service Radius (km)',
              hintText: '5',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: Icon(Icons.outbox_outlined, color: AppTheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppTheme.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Budget', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedBudgetType,
            decoration: InputDecoration(
              labelText: 'Budget Type',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: Icon(Icons.attach_money, color: AppTheme.primary),
            ),
            items: ['FIXED', 'RANGE', 'HOURLY', 'NEGOTIABLE'].map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (value) => setState(() => selectedBudgetType = value!),
          ),
          SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 400) {
                return Row(
                  children: [
                    Expanded(child: _buildBudgetMinField()),
                    if (selectedBudgetType == 'RANGE') ...[
                      SizedBox(width: 16),
                      Expanded(child: _buildBudgetMaxField()),
                    ],
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildBudgetMinField(),
                    if (selectedBudgetType == 'RANGE') ...[
                      SizedBox(height: 16),
                      _buildBudgetMaxField(),
                    ],
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetMinField() {
    return TextFormField(
      controller: _budgetMinController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: selectedBudgetType == 'RANGE' ? 'Min Budget' : 'Budget',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: Icon(Icons.currency_rupee, color: AppTheme.primary),
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Budget is required' : null,
    );
  }

  Widget _buildBudgetMaxField() {
    return TextFormField(
      controller: _budgetMaxController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Max Budget',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: Icon(Icons.currency_rupee, color: AppTheme.primary),
      ),
    );
  }

  Widget _buildTimingSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppTheme.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Timing & Urgency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedUrgencyLevel,
            decoration: InputDecoration(
              labelText: 'Urgency Level',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: Icon(Icons.priority_high, color: AppTheme.primary),
            ),
            items: ['LOW', 'MEDIUM', 'HIGH', 'URGENT'].map((level) {
              return DropdownMenuItem(value: level, child: Text(level));
            }).toList(),
            onChanged: (value) => setState(() => selectedUrgencyLevel = value!),
          ),
          SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 400) {
                return Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.border),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: AppTheme.primary),
                              SizedBox(width: 8),
                              Text(
                                preferredDate != null
                                    ? '${preferredDate!.day}/${preferredDate!.month}/${preferredDate!.year}'
                                    : 'Preferred Date',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context, ''),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.border),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time, color: AppTheme.primary),
                              SizedBox(width: 8),
                              Text(
                                preferredTime != null ? preferredTime!.format(context) : 'Preferred Time',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: AppTheme.primary),
                            SizedBox(width: 8),
                            Text(
                              preferredDate != null
                                  ? '${preferredDate!.day}/${preferredDate!.month}/${preferredDate!.year}'
                                  : 'Preferred Date',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectTime(context,''),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: AppTheme.primary),
                            SizedBox(width: 8),
                            Text(
                              preferredTime != null ? preferredTime!.format(context) : 'Preferred Time',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          SizedBox(height: 16),
          SwitchListTile(
            title: Text('Flexible Timing'),
            value: isFlexibleTiming,
            onChanged: (value) => setState(() => isFlexibleTiming = value),
            activeColor: AppTheme.primary,
          ),
          if (_shouldShowBiddingSection()) ...[
            SizedBox(height: 16),
            InkWell(
              onTap: () => _selectBiddingExpiry(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer, color: AppTheme.primary),
                    SizedBox(width: 8),
                    Text(
                      biddingExpiresAt != null
                          ? 'Expires: ${biddingExpiresAt!.day}/${biddingExpiresAt!.month}/${biddingExpiresAt!.year}'
                          : 'Bidding Expires At',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRequirementsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppTheme.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Requirements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          SizedBox(height: 16),
          _buildRequirementList('Must Have', mustHave, _mustHaveController, AppTheme.success),
          SizedBox(height: 16),
          _buildRequirementList('Nice to Have', niceToHave, _niceToHaveController, AppTheme.info),
          SizedBox(height: 16),
          _buildRequirementList('Deal Breakers', dealBreakers, _dealBreakersController, AppTheme.error),
          SizedBox(height: 16),
          _buildQualificationSection(),
        ],
      ),
    );
  }

  Widget _buildRequirementList(String title, List<String> items, TextEditingController controller, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Add $title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    items.add(controller.text);
                    controller.clear();
                  });
                }
              },
              icon: Icon(Icons.add, color: color),
            ),
          ],
        ),
        if (items.isNotEmpty) ...[
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: items
                .map(
                  (item) => Chip(
                    label: Text(item, style: TextStyle(fontSize: 12)),
                    deleteIcon: Icon(Icons.close, size: 16),
                    onDeleted: () => setState(() => items.remove(item)),
                    backgroundColor: color.withOpacity(0.1),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildQualificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Qualifications', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.accent)),
        SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 400) {
              return Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _qualificationKeyController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Experience',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _qualificationValueController,
                      decoration: InputDecoration(
                        hintText: 'e.g., 5+ years',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: _addQualification,
                    icon: Icon(Icons.add, color: AppTheme.accent),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  TextFormField(
                    controller: _qualificationKeyController,
                    decoration: InputDecoration(
                      hintText: 'e.g., Experience',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _qualificationValueController,
                    decoration: InputDecoration(
                      hintText: 'e.g., 5+ years',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: _addQualification,
                      icon: Icon(Icons.add, color: AppTheme.accent),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        if (qualifications.isNotEmpty) ...[
          SizedBox(height: 8),
          ...qualifications.entries.map(
            (entry) => Container(
              margin: EdgeInsets.only(bottom: 4),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${entry.key}: ${entry.value}', style: TextStyle(fontSize: 12)),
                  GestureDetector(
                    onTap: () => setState(() => qualifications.remove(entry.key)),
                    child: Icon(Icons.close, size: 16, color: AppTheme.error),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _addQualification() {
    if (_qualificationKeyController.text.isNotEmpty && _qualificationValueController.text.isNotEmpty) {
      setState(() {
        qualifications[_qualificationKeyController.text] = _qualificationValueController.text;
        _qualificationKeyController.clear();
        _qualificationValueController.clear();
      });
    }
  }

  Widget _buildTrackingSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppTheme.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Service Tracking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 400) {
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _trackingIntervalController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Tracking Interval (seconds)',
                          hintText: '30',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: Icon(Icons.timer, color: AppTheme.primary),
                        ),
                        validator: (value) => value?.isEmpty ?? true ? 'Tracking interval is required' : null,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _trackingDurationController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Duration (minutes)',
                          hintText: '60',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: Icon(Icons.schedule, color: AppTheme.primary),
                        ),
                        validator: (value) => value?.isEmpty ?? true ? 'Tracking duration is required' : null,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    TextFormField(
                      controller: _trackingIntervalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Tracking Interval (seconds)',
                        hintText: '30',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(Icons.timer, color: AppTheme.primary),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Tracking interval is required' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _trackingDurationController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Duration (minutes)',
                        hintText: '60',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: Icon(Icons.schedule, color: AppTheme.primary),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Tracking duration is required' : null,
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: ElevatedButton(
        onPressed: _submitServiceRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          'Post Service Request',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textWhite),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: preferredDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) setState(() => preferredDate = picked);
  }


  Future<void> _selectBiddingExpiry(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: biddingExpiresAt ?? DateTime.now().add(Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null) setState(() => biddingExpiresAt = picked);
  }

  void _submitServiceRequest() {
    if (_formKey.currentState!.validate() && selectedCategory != null) {
      final serviceRequest = {
        'category': {
          'id': selectedCategory!['id'],
          'name': selectedCategory!['name'],
        },
        'title': _titleController.text,
        'description': _descriptionController.text,
        'serviceAddress': _addressController.text,
        'budgetMin': double.tryParse(_budgetMinController.text),
        'budgetMax': selectedBudgetType == 'RANGE' ? double.tryParse(_budgetMaxController.text) : null,
        'budgetType': selectedBudgetType,
        'serviceRadiusKm': int.tryParse(_serviceRadiusController.text),
        'preferredDate': preferredDate?.toIso8601String(),
        'preferredTime': preferredTime?.format(context),
        'isFlexibleTiming': isFlexibleTiming,
        'urgencyLevel': selectedUrgencyLevel,
        'biddingExpiresAt': biddingExpiresAt?.toIso8601String(),
        'trackingIntervalSec': int.tryParse(_trackingIntervalController.text),
        'trackingDurationMin': int.tryParse(_trackingDurationController.text),
        'requirements': {
          'mustHave': mustHave,
          'niceToHave': niceToHave,
          'dealBreakers': dealBreakers,
          'qualifications': qualifications,
        },
        'serviceData': serviceData,
      };

      // TODO: Call API to submit service request
      print('Service Request: $serviceRequest');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Service request posted successfully!'),
          backgroundColor: AppTheme.success,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields and select a category'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }
}