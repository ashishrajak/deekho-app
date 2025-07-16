
import 'package:flutter/material.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/pages/home/responsive-helper.dart';

class BasicInfoTab extends StatefulWidget {
  final OfferingServiceDTO formData;
  final Function(OfferingServiceDTO) onFormDataChanged;

  const BasicInfoTab({
    Key? key,
    required this.formData,
    required this.onFormDataChanged,
  }) : super(key: key);

  @override
  State<BasicInfoTab> createState() => _BasicInfoTabState();
}

class _BasicInfoTabState extends State<BasicInfoTab> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _offeringCodeController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.formData.title);
    _descriptionController = TextEditingController(text: widget.formData.description);
    _offeringCodeController = TextEditingController(text: widget.formData.offeringCode);
  }

  void _updateFormData() {
    widget.onFormDataChanged(
      widget.formData.copyWith(
        displayName: _titleController.text,
        shortDescription: _descriptionController.text,
        offeringCode: _offeringCodeController.text,
      ),
    );
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
                'Basic Information',
                style: AppTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Provide basic details about your service offering',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 32),
              
              // Service Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Service Title *',
                  hintText: 'Enter a descriptive title for your service',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a service title';
                  }
                  return null;
                },
                onChanged: (_) => _updateFormData(),
              ),
              const SizedBox(height: 24),
              
              // Offering Code
              TextFormField(
                controller: _offeringCodeController,
                decoration: const InputDecoration(
                  labelText: 'Offering Code',
                  hintText: 'Optional unique identifier',
                  prefixIcon: Icon(Icons.code),
                ),
                onChanged: (_) => _updateFormData(),
              ),
              const SizedBox(height: 24),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Service Description *',
                  hintText: 'Describe your service in detail',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 4,
                  tablet: 5,
                  desktop: 6,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a service description';
                  }
                  return null;
                },
                onChanged: (_) => _updateFormData(),
              ),
              const SizedBox(height: 24),
              
              // Service Status
              DropdownButtonFormField<String>(
                value: widget.formData.status,
                decoration: const InputDecoration(
                  labelText: 'Service Status',
                  prefixIcon: Icon(Icons.toggle_on),
                ),
                items: const [
                  DropdownMenuItem(value: 'ACTIVE', child: Text('Active')),
                  DropdownMenuItem(value: 'INACTIVE', child: Text('Inactive')),
                  DropdownMenuItem(value: 'DRAFT', child: Text('Draft')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    widget.onFormDataChanged(
                      widget.formData.copyWith(status: value),
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
              
              // Verification Status
              SwitchListTile(
                title: const Text('Verified Service'),
                subtitle: const Text('Mark this service as verified'),
                value: widget.formData.verified,
                onChanged: (value) {
                  widget.onFormDataChanged(
                    widget.formData.copyWith(verified: value),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _offeringCodeController.dispose();
    super.dispose();
  }
}
