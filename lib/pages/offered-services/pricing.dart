



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/pages/home/responsive-helper.dart';

class PricingTab extends StatefulWidget {
  final OfferingServiceDTO formData;
  final Function(OfferingServiceDTO) onFormDataChanged;

  const PricingTab({
    Key? key,
    required this.formData,
    required this.onFormDataChanged,
  }) : super(key: key);

  @override
  State<PricingTab> createState() => _PricingTabState();
}

class _PricingTabState extends State<PricingTab> {
  final _formKey = GlobalKey<FormState>();
  final _basePriceController = TextEditingController();
  final _additionalChargesController = TextEditingController();
  final _discountController = TextEditingController();
  final _advanceAmountController = TextEditingController();
  final _advanceTermsController = TextEditingController();

  PricingType _selectedPricingType = PricingType.FIXED;
  String _selectedCurrency = 'USD';
  bool _advanceRequired = false;
  String? _selectedAdvancePaymentMethod;
  Set<String> _selectedPaymentMethods = {};
  Map<String, String> _conditions = {};

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'INR', 'CAD', 'AUD'];
  final List<String> _paymentMethods = [
     'CASH',              // Physical cash
    'CARD',              // Debit/Credit cards
    'UPI',               // Unified Payments Interface (popular in India)
    'NET_BANKING',       // Online banking
    'WALLET',            // Digital wallets (e.g., Paytm, PhonePe, Google Pay Wallet)
    'PAY_LATER',         // Buy Now, Pay Later (e.g., LazyPay, Simpl)
    'BANK_TRANSFER',     // Direct bank transfer (e.g., NEFT, IMPS, RTGS)
    'EMI',               // Equated Monthly Installments (via card or fintech)
    'QR_CODE',           // QR Code-based payments (e.g., Bharat QR, Google Pay)
    'CHEQUE',            // Physical cheque
    'CRYPTOCURRENCY',    // Bitcoin, Ethereum, etc. (optional/future-ready)
    'DEMAND_DRAFT'   
  ];

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    final pricing = widget.formData.primaryPricing;
    _basePriceController.text = pricing.basePrice.amount.toString();
    _selectedCurrency = pricing.basePrice.currency;
    _selectedPricingType = pricing.type;
    _additionalChargesController.text = pricing.additionalCharges ?? '';
    _discountController.text = pricing.discount ?? '';
    _selectedPaymentMethods = Set.from(pricing.paymentMethods);
    _conditions = Map.from(pricing.conditions);

    final advancePolicy = widget.formData.advancePolicy;
    if (advancePolicy != null) {
      _advanceRequired = advancePolicy.advanceRequired;
      _selectedAdvancePaymentMethod = advancePolicy.advancePaymentMethod;
      _advanceTermsController.text = advancePolicy.advanceTerms ?? '';
      if (advancePolicy.advanceAmount != null) {
        _advanceAmountController.text = advancePolicy.advanceAmount!.amount.toString();
      }
    }
  }

  void _updateFormData() {
    if (!_formKey.currentState!.validate()) return;

    final basePrice = MoneyDTO(
      amount: double.tryParse(_basePriceController.text) ?? 0.0,
      currency: _selectedCurrency,
    );

    final pricing = OfferingPricingDTO(
      type: _selectedPricingType,
      basePrice: basePrice,
      additionalCharges: _additionalChargesController.text.isNotEmpty
          ? _additionalChargesController.text
          : null,
      discount: _discountController.text.isNotEmpty
          ? _discountController.text
          : null,
      conditions: _conditions,
      paymentMethods: _selectedPaymentMethods,
    );

    AdvancePolicy? advancePolicy;
    if (_advanceRequired) {
      MoneyDTO? advanceAmount;
      if (_advanceAmountController.text.isNotEmpty) {
        advanceAmount = MoneyDTO(
          amount: double.tryParse(_advanceAmountController.text) ?? 0.0,
          currency: _selectedCurrency,
        );
      }

      advancePolicy = AdvancePolicy(
        advanceRequired: _advanceRequired,
        advanceAmount: advanceAmount,
        advancePaymentMethod: _selectedAdvancePaymentMethod,
        advanceTerms: _advanceTermsController.text.isNotEmpty
            ? _advanceTermsController.text
            : null,
      );
    }

    final updatedFormData = widget.formData.copyWith(
      primaryPricing: pricing,
      advancePolicy: advancePolicy,
    );

    widget.onFormDataChanged(updatedFormData);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context),
              ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),

              // Pricing Type Section
              _buildPricingTypeSection(context),
              ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),

              // Base Price Section
              _buildBasePriceSection(context),
              ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),

              // Additional Charges & Discount
              _buildAdditionalSection(context),
              ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),

              // Payment Methods
              _buildPaymentMethodsSection(context),
              ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),

              // Conditions
              _buildConditionsSection(context),
              ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),

              // Advance Policy
              _buildAdvancePolicySection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pricing & Payment',
          style: ResponsiveHelper.isMobile(context)
              ? AppTheme.headlineMedium
              : AppTheme.headlineLarge,
        ),
        ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context) * 0.5),
        Text(
          'Set your pricing structure and payment preferences',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPricingTypeSection(BuildContext context) {
    return Card(
      elevation: ResponsiveHelper.getResponsiveElevation(context),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing Type',
              style: AppTheme.headlineSmall,
            ),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
            Row(
              children: PricingType.values.map((type) {
                return Expanded(
                  child: RadioListTile<PricingType>(
                    title: Text(
                      type.toString().split('.').last,
                      style: AppTheme.bodyMedium,
                    ),
                    value: type,
                    groupValue: _selectedPricingType,
                    onChanged: (PricingType? value) {
                      setState(() {
                        _selectedPricingType = value!;
                        _updateFormData();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasePriceSection(BuildContext context) {
    return Card(
      elevation: ResponsiveHelper.getResponsiveElevation(context),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Base Price',
              style: AppTheme.headlineSmall,
            ),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
            ResponsiveHelper.isMobile(context)
                ? Column(
                    children: [
                      _buildPriceField(context),
                      ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                      _buildCurrencyDropdown(context),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(flex: 2, child: _buildPriceField(context)),
                      ResponsiveSizedBox(width: ResponsiveHelper.getResponsiveSpacing(context)),
                      Expanded(child: _buildCurrencyDropdown(context)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceField(BuildContext context) {
    return TextFormField(
      controller: _basePriceController,
      decoration: const InputDecoration(
        labelText: 'Amount',
        prefixIcon: Icon(Icons.attach_money),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an amount';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
      onChanged: (value) => _updateFormData(),
    );
  }

  Widget _buildCurrencyDropdown(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedCurrency,
      decoration: const InputDecoration(
        labelText: 'Currency',
        prefixIcon: Icon(Icons.currency_exchange),
      ),
      items: _currencies.map((currency) {
        return DropdownMenuItem(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCurrency = value!;
          _updateFormData();
        });
      },
    );
  }

  Widget _buildAdditionalSection(BuildContext context) {
    return Card(
      elevation: ResponsiveHelper.getResponsiveElevation(context),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Information',
              style: AppTheme.headlineSmall,
            ),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
            TextFormField(
              controller: _additionalChargesController,
              decoration: const InputDecoration(
                labelText: 'Additional Charges (Optional)',
                prefixIcon: Icon(Icons.add_circle_outline),
                helperText: 'e.g., Travel charges, material costs',
              ),
              maxLines: 2,
              onChanged: (value) => _updateFormData(),
            ),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
            TextFormField(
              controller: _discountController,
              decoration: const InputDecoration(
                labelText: 'Discount Information (Optional)',
                prefixIcon: Icon(Icons.discount),
                helperText: 'e.g., 10% off for first-time customers',
              ),
              maxLines: 2,
              onChanged: (value) => _updateFormData(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsSection(BuildContext context) {
    return Card(
      elevation: ResponsiveHelper.getResponsiveElevation(context),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accepted Payment Methods',
              style: AppTheme.headlineSmall,
            ),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
            Wrap(
              spacing: ResponsiveHelper.getResponsiveSpacing(context),
              runSpacing: ResponsiveHelper.getResponsiveSpacing(context) * 0.5,
              children: _paymentMethods.map((method) {
                return FilterChip(
                  label: Text(method),
                  selected: _selectedPaymentMethods.contains(method),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedPaymentMethods.add(method);
                      } else {
                        _selectedPaymentMethods.remove(method);
                      }
                      _updateFormData();
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionsSection(BuildContext context) {
    return Card(
      elevation: ResponsiveHelper.getResponsiveElevation(context),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pricing Conditions',
                  style: AppTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddConditionDialog(context),
                ),
              ],
            ),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
            if (_conditions.isEmpty)
              Text(
                'No conditions set. Tap + to add conditions.',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
              )
            else
              ..._conditions.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  subtitle: Text(entry.value),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _conditions.remove(entry.key);
                        _updateFormData();
                      });
                    },
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancePolicySection(BuildContext context) {
    return Card(
      elevation: ResponsiveHelper.getResponsiveElevation(context),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advance Payment Policy',
              style: AppTheme.headlineSmall,
            ),
            ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
            SwitchListTile(
              title: const Text('Require Advance Payment'),
              value: _advanceRequired,
              onChanged: (bool value) {
                setState(() {
                  _advanceRequired = value;
                  _updateFormData();
                });
              },
            ),
            if (_advanceRequired) ...[
              ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
              TextFormField(
                controller: _advanceAmountController,
                decoration: const InputDecoration(
                  labelText: 'Advance Amount',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                onChanged: (value) => _updateFormData(),
              ),
              ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
              DropdownButtonFormField<String>(
                value: _selectedAdvancePaymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Advance Payment Method',
                  prefixIcon: Icon(Icons.payment),
                ),
                items: _paymentMethods.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAdvancePaymentMethod = value;
                    _updateFormData();
                  });
                },
              ),
              ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
              TextFormField(
                controller: _advanceTermsController,
                decoration: const InputDecoration(
                  labelText: 'Advance Terms & Conditions',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                onChanged: (value) => _updateFormData(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddConditionDialog(BuildContext context) {
    final keyController = TextEditingController();
    final valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Pricing Condition'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: keyController,
                decoration: const InputDecoration(
                  labelText: 'Condition Name',
                  hintText: 'e.g., Minimum Hours',
                ),
              ),
              ResponsiveSizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
              TextFormField(
                controller: valueController,
                decoration: const InputDecoration(
                  labelText: 'Condition Value',
                  hintText: 'e.g., 2 hours minimum',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (keyController.text.isNotEmpty && valueController.text.isNotEmpty) {
                  setState(() {
                    _conditions[keyController.text] = valueController.text;
                    _updateFormData();
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _basePriceController.dispose();
    _additionalChargesController.dispose();
    _discountController.dispose();
    _advanceAmountController.dispose();
    _advanceTermsController.dispose();
    super.dispose();
  }
}



