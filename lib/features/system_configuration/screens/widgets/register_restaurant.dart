import 'package:dineswift_management/util/constants/colors.dart';
import 'package:dineswift_management/data/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

class RestaurantRegistrationForm extends StatefulWidget {
  const RestaurantRegistrationForm({super.key});

  @override
  State<RestaurantRegistrationForm> createState() => RestaurantRegistrationFormState();
}

class RestaurantRegistrationFormState
    extends State<RestaurantRegistrationForm> {
  final formKey = GlobalKey<FormState>();
  bool _isFetchingLocation = false;
  final uuid = const Uuid();

  // --- Form Field Controllers ---
  // Core Details
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cuisineTypeController = TextEditingController();
  String? _selectedStatus;

  // Address
  final _addressStreetController = TextEditingController();
  final _addressCityController = TextEditingController();
  final _addressCountryController = TextEditingController();
  final _addressLatController = TextEditingController();
  final _addressLngController = TextEditingController();

  // Contact
  final _contactPhoneController = TextEditingController();
  final _contactEmailController = TextEditingController();

  // Operations
  final _operationHoursController = TextEditingController();
  final _deliveryOptionsController = TextEditingController();
  final _avgDeliveryTimeController = TextEditingController();

  // Optional
  final _paymentMethodsController = TextEditingController();
  final _socialMediaController = TextEditingController();

  @override
  void dispose() {
    // Dispose all controllers
    _nameController.dispose();
    _descriptionController.dispose();
    _cuisineTypeController.dispose();
    _addressStreetController.dispose();
    _addressCityController.dispose();
    _addressCountryController.dispose();
    _addressLatController.dispose();
    _addressLngController.dispose();
    _contactPhoneController.dispose();
    _contactEmailController.dispose();
    _operationHoursController.dispose();
    _deliveryOptionsController.dispose();
    _avgDeliveryTimeController.dispose();
    _paymentMethodsController.dispose();
    _socialMediaController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: 'Please fix the errors in the form.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    Fluttertoast.showToast(
      msg: 'Registering restaurant...',
    );

    final Map<String, dynamic> restaurantData = {
      'id': uuid.v4(),
      'name': _nameController.text,
      'status': _selectedStatus,
      'average_rating': 0.0,
      'total_reviews': 0,
      "created_at": DateTime.now().toIso8601String(),
      "updated_at": DateTime.now().toIso8601String(),
      'address': {
        'street': _addressStreetController.text,
        'city': _addressCityController.text,
        'country': _addressCountryController.text,
        'coordinates': {
          'lat': double.tryParse(_addressLatController.text) ?? 0.0,
          'lng': double.tryParse(_addressLngController.text) ?? 0.0,
        },
      },
      'contact_info': {
        'phone': _contactPhoneController.text,
        'email': _contactEmailController.text,
      },
      'operation_hours': jsonDecode(_operationHoursController.text),
      if (_descriptionController.text.isNotEmpty)
        'description': _descriptionController.text,
      if (_cuisineTypeController.text.isNotEmpty)
        'cuisine_type': _cuisineTypeController.text,
      if (_socialMediaController.text.isNotEmpty)
        'social_media_links': jsonDecode(_socialMediaController.text),
      if (_deliveryOptionsController.text.isNotEmpty)
        'delivery_options': jsonDecode(_deliveryOptionsController.text),
      if (_paymentMethodsController.text.isNotEmpty)
        'payment_methods_accepted': jsonDecode(_paymentMethodsController.text),
      if (_avgDeliveryTimeController.text.isNotEmpty)
        'average_delivery_time': int.tryParse(_avgDeliveryTimeController.text),
    };

    try {
      await SupabaseService.registerRestaurant(restaurantData);
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Restaurant registered successfully!',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        formKey.currentState!.reset();
        setState(() => _selectedStatus = null);
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Error: $e',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Fluttertoast.showToast(msg: 'Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
            msg:
                'Location permissions are permanently denied, we cannot request permissions.');
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _addressLatController.text = position.latitude.toString();
        _addressLngController.text = position.longitude.toString();
      });

      Fluttertoast.showToast(msg: 'Location fetched successfully!');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to get location: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingLocation = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      decoration: BoxDecoration(
        color: DineSwiftColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Register New Restaurant',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: DineSwiftColors.whiteColor,
              ),
            ),
            backgroundColor: DineSwiftColors.primaryColor,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionHeader('Core Details'),
                    buildTwoColumnLayout(
                      leftChild: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Restaurant Name',
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Name is required'
                            : null,
                      ),
                      rightChild: TextFormField(
                        controller: _cuisineTypeController,
                        decoration: const InputDecoration(
                          labelText: 'Cuisine Type',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                          hintText: 'e.g., Italian',
                        ),
                      ),
                    ),
                    _buildSpacer(),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: DineSwiftColors.blackColor,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: DineSwiftColors.infoColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      maxLines: 2,
                    ),
                    _buildSpacer(),

                    // Address Section
                    buildSectionHeader('Address'),
                    buildTwoColumnLayout(
                      leftChild: TextFormField(
                        controller: _addressStreetController,
                        decoration: const InputDecoration(
                          labelText: 'Street Address',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Street is required' : null,
                      ),
                      rightChild: TextFormField(
                        controller: _addressCityController,
                        decoration: const InputDecoration(
                          labelText:'City',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'City is required': null,
                      ),
                    ),

                    _buildSpacer(),
                    buildTwoColumnLayout(
                      leftChild: TextFormField(
                        controller: _addressCountryController,
                        decoration: const InputDecoration(
                          labelText: 'Country',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Country is required' : null,
                      ), 
                      rightChild: Container()
                    ),
                    _buildSpacer(),
                    buildTwoColumnLayout(
                      leftChild: TextFormField(
                        controller: _addressLatController,
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) =>
                            double.tryParse(value ?? '') == null
                            ? 'Must be a number'
                            : null,
                      ),
                      rightChild: TextFormField(
                        controller: _addressLngController,
                        decoration: const InputDecoration(
                          labelText: 'Longitude',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) =>
                            double.tryParse(value ?? '') == null
                            ? 'Must be a number'
                            : null,
                      ),
                    ),
                    _buildSpacer(),
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: _isFetchingLocation ? null : _getCurrentLocation,
                        icon: _isFetchingLocation
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.my_location),
                        label: Text(_isFetchingLocation
                            ? 'Fetching Location...'
                            : 'Use Current Location'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: DineSwiftColors.primaryColor,
                          side: const BorderSide(color: DineSwiftColors.primaryColor),
                        ),
                      ),
                    ),

                    // --- Contact Information Section ---
                    buildSectionHeader('Contact Information'),
                    buildTwoColumnLayout(
                      leftChild: TextFormField(
                        controller: _contactPhoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) => value == null || value.isEmpty
                          ? 'Phone is required'
                          : null,
                      ),
                      rightChild: TextFormField(
                        controller: _contactEmailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Email is required';
                          if (!value.contains('@'))
                            return 'Enter a valid email';
                          return null;
                        },
                      ),
                    ),
                    _buildSpacer(),

                    // --- Operations Section ---
                    buildSectionHeader('Operations'),
                    buildTwoColumnLayout(
                      leftChild: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        items: ['active', 'inactive', 'suspended']
                            .map(
                              (status) => DropdownMenuItem(
                                value: status,
                                child: Text(
                                  status[0].toUpperCase() + status.substring(1),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Status is required' : null,
                      ),
                      rightChild: TextFormField(
                        controller: _avgDeliveryTimeController,
                        decoration: const InputDecoration(
                          labelText: 'Avg. Delivery Time (mins)',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    _buildSpacer(),
                    TextFormField(
                      controller: _operationHoursController,
                      decoration: const InputDecoration(
                        labelText: 'Operation Hours',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: DineSwiftColors.blackColor,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: DineSwiftColors.infoColor,
                            width: 2.0,
                          ),
                        ),
                        hintText: '{"Mon": "9-5", "Tue": "9-5"}',
                        hintStyle: TextStyle(
                          color: DineSwiftColors.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Hours are required';
                        }
                        try {
                          jsonDecode(value);
                          return null;
                        } catch (e) {
                          return 'Invalid JSON format';
                        }
                      },
                    ),
                    _buildSpacer(),
                    TextFormField(
                      controller: _deliveryOptionsController,
                      decoration: const InputDecoration(
                        labelText: 'Delivery Options',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: DineSwiftColors.blackColor,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: DineSwiftColors.infoColor,
                            width: 2.0,
                          ),
                        ),
                        hintText: '{"fee": 5.0, "min_order": 20.0}',
                        hintStyle: TextStyle(
                          color: DineSwiftColors.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                      maxLines: 2,
                    ),
                    _buildSpacer(),

                    // --- Additional Information Section ---
                    buildSectionHeader('Additional Information'),
                    buildTwoColumnLayout(
                      leftChild: TextFormField(
                        controller: _paymentMethodsController,
                        decoration: const InputDecoration(
                          labelText: 'Payment Methods',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                          hintText: '["card", "cash", "mobile_money"]',
                          hintStyle: TextStyle(
                            color: DineSwiftColors.darkGrey,
                            fontSize: 14,
                          ),
                        ),
                        maxLines: 2,
                      ),
                      rightChild: TextFormField(
                        controller: _socialMediaController,
                        decoration: const InputDecoration(
                          labelText: 'Social Media Links',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                          hintText: '{"twitter": "...", "facebook": "..."}',
                          hintStyle: TextStyle(
                            color: DineSwiftColors.darkGrey,
                            fontSize: 14,
                          ),
                        ),
                        maxLines: 2,
                      ),
                    ),
                    _buildSpacer(height: 32),

                    // --- Submit Button ---
                    Center(
                      child: SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DineSwiftColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Register Restaurant',
                            style: TextStyle(
                              color: DineSwiftColors.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // section header widget
  Widget buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.normal,
          color: DineSwiftColors.blackColor,
          fontSize: 17,
        ),
      ),
    );
  }

  Widget buildTwoColumnLayout({
    required Widget leftChild,
    required Widget rightChild,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: leftChild,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: rightChild,
          ),
        ),
      ],
    );
  }

  Widget _buildSpacer({double height = 16}) {
    return SizedBox(height: height);
  }
}
