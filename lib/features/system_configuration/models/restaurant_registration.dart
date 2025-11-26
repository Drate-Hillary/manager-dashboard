class RestaurantModel {
  final String id;
  final String name;
  final String? status;
  final String? managerId;
  final double averageRating;
  final int totalReviews;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RestaurantAddress address;
  final RestaurantContact contactInfo;
  final Map<String, dynamic> operationHours;
  final String? description;
  final String? cuisineType;
  final Map<String, dynamic>? deliveryOptions;
  final int? averageDeliveryTime;

  RestaurantModel({
    required this.id,
    required this.name,
    this.status,
    this.managerId,
    required this.averageRating,
    required this.totalReviews,
    required this.createdAt,
    required this.updatedAt,
    required this.address,
    required this.contactInfo,
    required this.operationHours,
    this.description,
    this.cuisineType,
    this.deliveryOptions,
    this.averageDeliveryTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      if (managerId != null) 'manager_id': managerId,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'address': address.toJson(),
      'contact_info': contactInfo.toJson(),
      'operation_hours': operationHours,
      if (description != null) 'description': description,
      if (cuisineType != null) 'cuisine_type': cuisineType,
      if (deliveryOptions != null) 'delivery_options': deliveryOptions,
    };
  }

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      managerId: json['manager_id'],
      averageRating: (json['average_rating'] as num).toDouble(),
      totalReviews: json['total_reviews'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      address: RestaurantAddress.fromJson(json['address']),
      contactInfo: RestaurantContact.fromJson(json['contact_info']),
      operationHours: Map<String, dynamic>.from(json['operation_hours']),
      description: json['description'],
      cuisineType: json['cuisine_type'],
      deliveryOptions: json['delivery_options'] != null 
          ? Map<String, dynamic>.from(json['delivery_options']) 
          : null,
      averageDeliveryTime: json['average_delivery_time'],
    );
  }
}

class RestaurantAddress {
  final String street;
  final String city;
  final String country;
  final RestaurantCoordinates coordinates;

  RestaurantAddress({
    required this.street,
    required this.city,
    required this.country,
    required this.coordinates,
  });

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'country': country,
      'coordinates': coordinates.toJson(),
    };
  }

  factory RestaurantAddress.fromJson(Map<String, dynamic> json) {
    return RestaurantAddress(
      street: json['street'],
      city: json['city'],
      country: json['country'],
      coordinates: RestaurantCoordinates.fromJson(json['coordinates']),
    );
  }
}

class RestaurantCoordinates {
  final double lat;
  final double lng;

  RestaurantCoordinates({required this.lat, required this.lng});

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  factory RestaurantCoordinates.fromJson(Map<String, dynamic> json) {
    return RestaurantCoordinates(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
}

class RestaurantContact {
  final String phone;
  final String email;

  RestaurantContact({required this.phone, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
    };
  }

  factory RestaurantContact.fromJson(Map<String, dynamic> json) {
    return RestaurantContact(
      phone: json['phone'],
      email: json['email'],
    );
  }
}