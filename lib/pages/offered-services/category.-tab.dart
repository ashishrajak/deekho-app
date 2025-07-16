
import 'package:flutter/material.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/models/OfferingService_dto.dart';
import 'package:my_flutter_app/pages/home/responsive-helper.dart';
import 'package:my_flutter_app/services/CommonDataService.dart';

class CategoryTab extends StatefulWidget {
  final OfferingServiceDTO formData;
  final Function(OfferingServiceDTO) onFormDataChanged;

  const CategoryTab({
    Key? key,
    required this.formData,
    required this.onFormDataChanged,
  }) : super(key: key);

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

// Updated CategoryTab methods to handle the DTO mismatch

class _CategoryTabState extends State<CategoryTab> {
  String? _selectedCategory;
  String? _selectedSubCategory;
  final Set<String> _selectedTags = <String>{};

  // Dynamic categories from API
  final CommonDataService _commonDataService = CommonDataService();
  List<CategoryDTO> _categoryList = [];
  bool _isLoading = true;

  final List<String> _availableTags = [
    'Premium', 'Budget-Friendly', 'Emergency', 'Same Day', 'Certified',
    'Eco-Friendly', 'Mobile Service', 'Online', 'Custom', 'Popular'
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // Load categories first, then initialize form data
  Future<void> _loadCategories() async {
    try {
      final categories = await _commonDataService.getCategories();
      setState(() {
        _categoryList = categories;
        _isLoading = false;
      });
      
      // Initialize form data AFTER categories are loaded
      _initializeFromFormData();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load categories: $e')),
        );
      }
    }
  }

  void _initializeFromFormData() {
    // Initialize from ServiceCategoryDto if exists
    if (widget.formData.category.name.isNotEmpty) {
      _parseExistingCategory(widget.formData.category.name);
    }
    _selectedTags.addAll(widget.formData.tags);
  }

    void _parseExistingCategory(String categoryName) {
    // First, check if this name matches any main category
    if (_findCategoryByName(categoryName) != null) {
      _selectedCategory = categoryName;
      _selectedSubCategory = null;
    } else {
      // If not a main category, check if it's a subcategory
      final mainCategory = _findMainCategoryForSubCategory(categoryName);
      if (mainCategory != null) {
        _selectedCategory = mainCategory.categoryName;
        _selectedSubCategory = categoryName;
      } else {
        // Not found in either main categories or subcategories
        _selectedCategory = null;
        _selectedSubCategory = null;
      }
    }
  }
  // Helper method to find CategoryDTO by name
  CategoryDTO? _findCategoryByName(String categoryName) {
    try {
      return _categoryList.firstWhere(
        (cat) => cat.categoryName.toLowerCase() == categoryName.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Helper method to find if subcategory exists in a main category
  bool _findSubCategoryInCategory(String mainCategoryName, String subCategoryName) {
    final category = _findCategoryByName(mainCategoryName);
    if (category == null) return false;
    
    return category.subcategories.any(
      (sub) => sub.toLowerCase() == subCategoryName.toLowerCase(),
    );
  }

  // Helper method to find main category for a subcategory
  CategoryDTO? _findMainCategoryForSubCategory(String subCategoryName) {
    try {
      return _categoryList.firstWhere(
        (cat) => cat.subcategories.any(
          (sub) => sub.toLowerCase() == subCategoryName.toLowerCase(),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  // Get all available subcategories for a main category
  List<String> _getSubcategoriesForCategory(String categoryName) {
    final category = _findCategoryByName(categoryName);
    return category?.subcategories ?? [];
  }

  // Check if selected category is valid
  bool _isValidCategory(String? categoryName) {
    if (categoryName == null || _categoryList.isEmpty) return false;
    return _findCategoryByName(categoryName) != null;
  }

  // Check if selected subcategory is valid for the given category
  bool _isValidSubCategory(String categoryName, String? subCategoryName) {
    if (subCategoryName == null) return false;
    return _findSubCategoryInCategory(categoryName, subCategoryName);
  }

  void _updateCategory(String? category, String? subCategory) {
    setState(() {
      _selectedCategory = category;
      _selectedSubCategory = subCategory;
    });
    
    _updateFormData();
  }

  void _updateFormData() {
    final categoryName = _selectedSubCategory != null 
        ? '$_selectedSubCategory' 
        : _selectedCategory ?? '';
    
    // Create or update ServiceCategoryDto
    final updatedCategory = ServiceCategoryDto(
      id: widget.formData.category.id.isNotEmpty ? widget.formData.category.id : '',
      name: categoryName,
      description: widget.formData.category.description,
      parentId: widget.formData.category.parentId,
      route: widget.formData.category.route,
      createdOn: widget.formData.category.createdOn,
    );
    
    widget.onFormDataChanged(
      widget.formData.copyWith(category: updatedCategory),
    );
  }

  void _updateTags(Set<String> tags) {
    setState(() {
      _selectedTags.clear();
      _selectedTags.addAll(tags);
    });
    
    widget.onFormDataChanged(
      widget.formData.copyWith(tags: Set.from(tags)),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Category *',
          style: AppTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        
        // Main Category Dropdown
        DropdownButtonFormField<String>(
          value: _isValidCategory(_selectedCategory) ? _selectedCategory : null,
          decoration: const InputDecoration(
            labelText: 'Main Category',
            prefixIcon: Icon(Icons.category),
            hintText: 'Select a main category',
          ),
          items: _categoryList.map((category) {
            return DropdownMenuItem(
              value: category.categoryName,
              child: Text(category.categoryName),
            );
          }).toList(),
          onChanged: (value) {
            // When main category changes, clear subcategory
            _updateCategory(value, null);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a main category';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Sub Category Dropdown (only show if main category is selected)
        if (_selectedCategory != null && _isValidCategory(_selectedCategory)) ...[
          DropdownButtonFormField<String>(
            value: _isValidSubCategory(_selectedCategory!, _selectedSubCategory) 
                ? _selectedSubCategory 
                : null,
            decoration: const InputDecoration(
              labelText: 'Sub Category (Optional)',
              prefixIcon: Icon(Icons.subdirectory_arrow_right),
              hintText: 'Select a sub category',
            ),
            items: _getSubcategoriesForCategory(_selectedCategory!).map((subCategory) {
              return DropdownMenuItem(
                value: subCategory,
                child: Text(subCategory),
              );
            }).toList(),
            onChanged: (value) {
              _updateCategory(_selectedCategory, value);
            },
          ),
        ],
        
        // Debug info (remove in production)
        if (_selectedCategory != null) ...[
          const SizedBox(height: 8),
          Text(
            'Selected: ${_selectedCategory}${_selectedSubCategory != null ? " > $_selectedSubCategory" : ""}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Tags',
          style: AppTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Add tags to help customers find your service',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 16),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                final newTags = Set<String>.from(_selectedTags);
                if (selected) {
                  newTags.add(tag);
                } else {
                  newTags.remove(tag);
                }
                _updateTags(newTags);
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            );
          }).toList(),
        ),
        
        if (_selectedTags.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Selected Tags: ${_selectedTags.length}',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ResponsiveContainer(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveHelper.getPaddingEnhanced(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category & Tags',
              style: AppTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Select the category and add relevant tags for your service',
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 32),
            
            // Category Selection
            _buildCategorySection(),
            const SizedBox(height: 32),
            
            // Tags Selection
            _buildTagsSection(),
          ],
        ),
      ),
    );
  }
}
// lib/widgets/form_tabs/timing_location_tab.dart
