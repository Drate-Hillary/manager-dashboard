import 'package:dineswift_management/features/system_configuration/models/restaurant_registration.dart';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:dineswift_management/util/constants/text_strings.dart';
import 'package:dineswift_management/data/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:get_storage/get_storage.dart';

class RestaurantRegistrationForm extends StatefulWidget {
  const RestaurantRegistrationForm({super.key});

  @override
  State<RestaurantRegistrationForm> createState() => RestaurantRegistrationFormState();
}

class RestaurantRegistrationFormState extends State<RestaurantRegistrationForm> {
  final formKey = GlobalKey<FormState>();
  bool isFetchingLocation = false;
  final uuid = const Uuid();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final cuisineTypeController = TextEditingController();
  String? selectedStatus;

  // Address
  final addressStreetController = TextEditingController();
  final addressCityController = TextEditingController();
  final addressCountryController = TextEditingController();
  final addressLatController = TextEditingController();
  final addressLngController = TextEditingController();

  // Contact
  final contactPhoneController = TextEditingController();
  final contactEmailController = TextEditingController();

  // Operations
  final operationHoursController = TextEditingController();
  final deliveryOptionsController = TextEditingController();
  final avgDeliveryTimeController = TextEditingController();


  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    cuisineTypeController.dispose();
    addressStreetController.dispose();
    addressCityController.dispose();
    addressCountryController.dispose();
    addressLatController.dispose();
    addressLngController.dispose();
    contactPhoneController.dispose();
    contactEmailController.dispose();
    operationHoursController.dispose();
    deliveryOptionsController.dispose();
    avgDeliveryTimeController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: DineSwiftTextStrings.fixFormErrors,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final storage = GetStorage();
    final isSuperuser = storage.read('is_superuser') ?? false;
    final isActive = storage.read('is_active') ?? false;
    final userId = storage.read('user_id');

    if (!isSuperuser) {
      Fluttertoast.showToast(
        msg: 'Only superusers can register restaurants',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (!isActive) {
      Fluttertoast.showToast(
        msg: 'Your account is not active',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (userId == null) {
      Fluttertoast.showToast(
        msg: 'User ID not found. Please logout and login again',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    Fluttertoast.showToast(
      msg: DineSwiftTextStrings.registeringRestaurant,
    );

    // Create restaurant model
    final restaurant = RestaurantModel(
      id: uuid.v4(),
      name: nameController.text,
      status: selectedStatus,
      managerId: userId,
      averageRating: 0.0,
      totalReviews: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      address: RestaurantAddress(
        street: addressStreetController.text,
        city: addressCityController.text,
        country: addressCountryController.text,
        coordinates: RestaurantCoordinates(
          lat: double.tryParse(addressLatController.text) ?? 0.0,
          lng: double.tryParse(addressLngController.text) ?? 0.0,
        ),
      ),
      contactInfo: RestaurantContact(
        phone: contactPhoneController.text,
        email: contactEmailController.text,
      ),
      operationHours: jsonDecode(operationHoursController.text),
      description: descriptionController.text.isNotEmpty ? descriptionController.text : null,
      cuisineType: cuisineTypeController.text.isNotEmpty ? cuisineTypeController.text : null,
      averageDeliveryTime: avgDeliveryTimeController.text.isNotEmpty ? int.tryParse(avgDeliveryTimeController.text) : null,
    );

    try {
      await SupabaseService.registerRestaurant(restaurant.toJson());
      if (mounted) {
        Fluttertoast.showToast(
          msg: DineSwiftTextStrings.restaurantRegistered,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        formKey.currentState!.reset();
        setState(() => selectedStatus = null);
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

  Future<void> getCurrentLocation() async {
    setState(() {
      isFetchingLocation = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Fluttertoast.showToast(msg: DineSwiftTextStrings.locationPermissionsDenied);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
          msg: DineSwiftTextStrings.locationPermissionsPermanentlyDenied
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );

      setState(() {
        addressLatController.text = position.latitude.toString();
        addressLngController.text = position.longitude.toString();
      });

      Fluttertoast.showToast(msg: DineSwiftTextStrings.locationFetched);
    } catch (e) {
      Fluttertoast.showToast(
        msg: '${DineSwiftTextStrings.locationFailed}$e',
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          isFetchingLocation = false;
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
      ),
      child: SafeArea(
        
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              DineSwiftTextStrings.registerRestaurantTitle,
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
                    buildSectionHeader(DineSwiftTextStrings.coreDetailsHeader),
                    buildTwoColumnLayout(
                      leftChild: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: DineSwiftTextStrings.restaurantName,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.darkGrey.withAlpha(20),
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? DineSwiftTextStrings.nameRequired
                            : null,
                      ),
                      rightChild: TextFormField(
                        controller: cuisineTypeController,
                        decoration: InputDecoration(
                          labelText: DineSwiftTextStrings.cuisineType,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.darkGrey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                          hintText: DineSwiftTextStrings.cuisineTypeHint,
                        ),
                      ),
                    ),
                    buildSpacer(),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: DineSwiftTextStrings.description,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: DineSwiftColors.blackColor,
                          fontSize: 16,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: DineSwiftColors.darkGrey,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: DineSwiftColors.infoColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      maxLines: 2,
                    ),
                    buildSpacer(),

                    // Address Section
                    buildSectionHeader(DineSwiftTextStrings.addressHeader),
                    buildTwoColumnLayout(
                      leftChild: TextFormField(
                        controller: addressStreetController,
                        decoration: const InputDecoration(
                          labelText: DineSwiftTextStrings.streetAddress,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.darkGrey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? DineSwiftTextStrings.streetRequired : null,
                      ),
                      rightChild: TextFormField(
                        controller: addressCityController,
                        decoration: const InputDecoration(
                          labelText: DineSwiftTextStrings.city,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.darkGrey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? DineSwiftTextStrings.cityRequired : null,
                      ),
                    ),

                    buildSpacer(),
                    buildTwoColumnLayout(
                      leftChild: TextFormField(
                        controller: addressCountryController,
                        decoration: const InputDecoration(
                          labelText: DineSwiftTextStrings.country,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.darkGrey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? DineSwiftTextStrings.countryRequired : null,
                      ), 
                      rightChild: Container()
                    ),
                    buildSpacer(),
                    buildTwoColumnLayout(
                      leftChild: TextFormField(
                        controller: addressLatController,
                        decoration: const InputDecoration(
                          labelText: DineSwiftTextStrings.latitude,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.darkGrey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
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
                            ? DineSwiftTextStrings.mustBeNumber
                            : null,
                      ),
                      rightChild: TextFormField(
                        controller: addressLngController,
                        decoration: const InputDecoration(
                          labelText: DineSwiftTextStrings.longitude,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.darkGrey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
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
                            ? DineSwiftTextStrings.mustBeNumber
                            : null,
                      ),
                    ),
                    buildSpacer(),
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: isFetchingLocation ? null : getCurrentLocation,
                        icon: isFetchingLocation
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.my_location),
                        label: Text(isFetchingLocation
                            ? DineSwiftTextStrings.fetchingLocation
                            : DineSwiftTextStrings.useCurrentLocation
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: DineSwiftColors.primaryColor,
                          side: const BorderSide(color: DineSwiftColors.primaryColor),
                        ),
                      ),
                    ),

                    // --- Contact Information Section ---
                    buildSectionHeader(DineSwiftTextStrings.contactInfoHeader),
                    buildTwoColumnLayout(
                      leftChild: TextFormField(
                        controller: contactPhoneController,
                        decoration: const InputDecoration(
                          labelText: DineSwiftTextStrings.phoneNumber,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.darkGrey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) => value == null || value.isEmpty
                          ? DineSwiftTextStrings.phoneRequired
                          : null,
                      ),
                      rightChild: TextFormField(
                        controller: contactEmailController,
                        decoration: const InputDecoration(
                          labelText: DineSwiftTextStrings.emailAddress,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.darkGrey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.infoColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return DineSwiftTextStrings.emailRequired;
                          if (!value.contains('@'))
                            return DineSwiftTextStrings.validEmail;
                          return null;
                        },
                      ),
                    ),
                    buildSpacer(),

                    // --- Operations Section ---
                    buildSectionHeader(DineSwiftTextStrings.operationsHeader),
                    buildTwoColumnLayout(
                      leftChild: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: selectedStatus,
                        decoration: InputDecoration(
                          labelText: DineSwiftTextStrings.status,
                          border: UnderlineInputBorder(
                            borderSide: const BorderSide(
                              color: DineSwiftColors.darkGrey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.primaryColor,
                              width: 2.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        dropdownColor: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8.0),
                        items: ['active', 'inactive', 'suspended']
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(
                                status[0].toUpperCase() + status.substring(1),
                                style: TextStyle(
                                  color: DineSwiftColors.blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value;
                          });
                        },
                        validator: (value) => value == null ? DineSwiftTextStrings.statusRequired : null,
                      ),
                      rightChild: TextFormField(
                        controller: avgDeliveryTimeController,
                        decoration: const InputDecoration(
                          labelText: DineSwiftTextStrings.avgDeliveryTime,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: DineSwiftColors.blackColor,
                            fontSize: 16,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.darkGrey,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
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
                    buildSpacer(),
                    TextFormField(
                      controller: operationHoursController,
                      decoration: InputDecoration(
                        labelText: DineSwiftTextStrings.operationHours,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: DineSwiftColors.blackColor,
                          fontSize: 16,
                        ),
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: DineSwiftColors.darkGrey,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: DineSwiftColors.infoColor,
                            width: 2.0,
                          ),
                        ),
                        hintText: DineSwiftTextStrings.operationHoursHint,
                        hintStyle: const TextStyle(
                          color: DineSwiftColors.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return DineSwiftTextStrings.hoursRequired;
                        }
                        try {
                          jsonDecode(value);
                          return null;
                        } catch (e) {
                          return DineSwiftTextStrings.invalidJsonFormat;
                        }
                      },
                    ),
                    buildSpacer(),
                    TextFormField(
                      controller: deliveryOptionsController,
                      decoration: InputDecoration(
                        labelText: DineSwiftTextStrings.deliveryOptions,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: DineSwiftColors.blackColor,
                          fontSize: 16,
                        ),
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: DineSwiftColors.darkGrey,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: DineSwiftColors.infoColor,
                            width: 2.0,
                          ),
                        ),
                        hintText: DineSwiftTextStrings.deliveryOptionsHint,
                        hintStyle: const TextStyle(
                          color: DineSwiftColors.darkGrey,
                          fontSize: 14,
                        ),
                      ),
                      maxLines: 2,
                    ),
                    buildSpacer(height: 32),

                    // --- Submit Button ---
                    Center(
                      child: SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DineSwiftColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            DineSwiftTextStrings.registerRestaurantButton,
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

  Widget buildSpacer({double height = 10}) {
    return SizedBox(height: height);
  }
}