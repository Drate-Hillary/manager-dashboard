import 'package:flutter/material.dart';

// Data Models
class Role {
  final String id;
  final String name;
  Role({required this.id, required this.name});
}

class Restaurant {
  final String id;
  final String name;
  Restaurant({required this.id, required this.name});
}

class Manager {
  final String staffId;
  final String name;
  Manager({required this.staffId, required this.name});
}

class AddStaff extends StatefulWidget {
  const AddStaff({super.key});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _salaryController = TextEditingController();

  // Dropdown Values
  Role? _selectedRole;
  Restaurant? _selectedRestaurant;
  Manager? _selectedManager;
  DateTime? _hireDate;

  // Mock Data
  final List<Role> _roles = [
    Role(id: '1', name: 'Waiter'),
    Role(id: '2', name: 'Kitchen Staff (Chef)'),
    Role(id: '3', name: 'Manager'),
    Role(id: '4', name: 'Cashier'),
    Role(id: '5', name: 'Host/Hostess'),
  ];

  final List<Restaurant> _restaurants = [
    Restaurant(id: '1', name: 'DineSwift HQ'),
    Restaurant(id: '2', name: 'The Pizza Palace'),
    Restaurant(id: '3', name: 'Burger Corner'),
    Restaurant(id: '4', name: 'Seafood Delight'),
  ];

  final List<Manager> _managers = [
    Manager(staffId: '1', name: 'Jane Smith'),
    Manager(staffId: '2', name: 'Bob Johnson'),
    Manager(staffId: '3', name: 'Alice Brown'),
  ];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _employeeIdController.dispose();
    _salaryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _selectHireDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _hireDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              onSurface: Colors.grey[800]!,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _hireDate) {
      setState(() {
        _hireDate = picked;
      });
    }
  }

  Future<void> _createStaff() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      // Show success dialog
      await _showSuccessDialog();

      // Clear form
      _formKey.currentState!.reset();
      setState(() {
        _selectedRole = null;
        _selectedRestaurant = null;
        _selectedManager = null;
        _hireDate = null;
      });

      // Scroll to top
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _showSuccessDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.green, size: 40),
          ),
          title: const Text('Staff Created Successfully!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${_fullNameController.text}'),
              Text('Email: ${_emailController.text}'),
              Text('Role: ${_selectedRole?.name}'),
              const SizedBox(height: 16),
              const Text('The staff member has been added to the system.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedRole = null;
      _selectedRestaurant = null;
      _selectedManager = null;
      _hireDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use Scaffold for appBar and body properties.
    return Container(
      width: 650, // Constrain width for larger screens
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Create New Staff Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearForm,
            tooltip: 'Clear Form',
          ),
        ],
      ),
      // Wrap the body in a Container to constrain the width.
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: _scrollController,
              children: [
                _buildWelcomeCard(),
                const SizedBox(height: 24),
                
                // All sections in a column for compact layout
                Column(
                  children: [
                    // Section 1: Account Details
                    _buildSection(
                      title: 'Account Details',
                      icon: Icons.person_outline,
                      children: [
                        _buildTextField(
                          controller: _fullNameController,
                          label: 'Full Name',
                          icon: Icons.person,
                          validator: (value) => value?.isEmpty ?? true ? 'Please enter a name' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value == null || !value.contains('@') 
                              ? 'Enter a valid email' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Section 2: Job & Role
                    _buildSection(
                      title: 'Job & Role',
                      icon: Icons.work_outline,
                      children: [
                        _buildDropdown<Role>(
                          value: _selectedRole,
                          items: _roles,
                          label: 'Job Role',
                          onChanged: (Role? value) => setState(() => _selectedRole = value),
                          validator: (value) => value == null ? 'Please select a role' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown<Restaurant>(
                          value: _selectedRestaurant,
                          items: _restaurants,
                          label: 'Restaurant Location',
                          onChanged: (Restaurant? value) => setState(() => _selectedRestaurant = value),
                          validator: (value) => value == null ? 'Please select a restaurant' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown<Manager>(
                          value: _selectedManager,
                          items: _managers,
                          label: 'Reports To (Manager)',
                          onChanged: (Manager? value) => setState(() => _selectedManager = value),
                          validator: (value) => value == null ? 'Please select a manager' : null,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Section 3: Employment Details
                    _buildSection(
                      title: 'Employment Details',
                      icon: Icons.business_center,
                      children: [
                        _buildTextField(
                          controller: _employeeIdController,
                          label: 'Employee ID',
                          icon: Icons.badge,
                          validator: (value) => value?.isEmpty ?? true ? 'Enter an Employee ID' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _salaryController,
                          label: 'Salary',
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (value) => value?.isEmpty ?? true ? 'Enter a salary' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildDateField(),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Submit Button
                    _buildSubmitButton(),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.group_add,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'Add New Staff Member',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Fill in the details below to create a new staff account. All fields marked with * are required.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required List<T> items,
    required String label,
    required void Function(T?) onChanged,
    required String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(_getItemDisplayName(item)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      isExpanded: true,
    );
  }

  String _getItemDisplayName(dynamic item) {
    if (item is Role) return item.name;
    if (item is Restaurant) return item.name;
    if (item is Manager) return item.name;
    return item.toString();
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () => _selectHireDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Hire Date',
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              _hireDate == null
                  ? 'Select a date'
                  : '${_hireDate!.day}/${_hireDate!.month}/${_hireDate!.year}',
              style: TextStyle(
                color: _hireDate == null ? Colors.grey[600] : null,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _createStaff,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add, size: 20),
                  SizedBox(width: 8),
                  Text('Create Staff Account'),
                ],
              ),
      ),
    );
  }
}