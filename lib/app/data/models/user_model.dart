class UserModel {
  final int id;
  final String email;
  final String username;
  final String phone;
  final NameModel name;
  final AddressModel address;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.phone,
    required this.name,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      phone: json['phone'] as String,
      name: NameModel.fromJson(json['name'] as Map<String, dynamic>),
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
    );
  }

  String get fullName => '${name.firstname} ${name.lastname}';
}

class NameModel {
  final String firstname;
  final String lastname;

  NameModel({required this.firstname, required this.lastname});

  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
    );
  }
}

class AddressModel {
  final String city;
  final String street;
  final int number;
  final String zipcode;
  final GeoModel geolocation;

  AddressModel({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    required this.geolocation,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      city: json['city'] as String,
      street: json['street'] as String,
      number: json['number'] as int,
      zipcode: json['zipcode'] as String,
      geolocation: GeoModel.fromJson(
        json['geolocation'] as Map<String, dynamic>,
      ),
    );
  }

  String get fullAddress => '$number $street, $city, $zipcode';
}

class GeoModel {
  final String lat;
  final String long;

  GeoModel({required this.lat, required this.long});

  factory GeoModel.fromJson(Map<String, dynamic> json) {
    return GeoModel(
      lat: json['lat'] as String,
      long: json['long'] as String,
    );
  }
}
