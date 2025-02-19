import 'address_model.dart';

class User {
  String? firstName;
  String? lastName;
  DateTime? birthDate;
  List<Address> addresses = [];

  User({
    this.firstName,
    this.lastName,
    this.birthDate,
    List<Address>? addresses,
  }) : addresses = addresses ?? [];

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate?.toIso8601String(),
      'addresses': addresses.map((address) => address.toMap()).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'],
      lastName: map['lastName'],
      birthDate:
          map['birthDate'] != null ? DateTime.parse(map['birthDate']) : null,
      addresses: List<Address>.from(
        map['addresses']?.map((x) => Address.fromMap(x)) ?? [],
      ),
    );
  }
}
