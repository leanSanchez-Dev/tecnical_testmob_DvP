class Address {
  String street;
  String city;
  String state;
  String zipCode;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  Map<String, dynamic> toMap() {
    return {'street': street, 'city': city, 'state': state, 'zipCode': zipCode};
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zipCode'],
    );
  }
}
