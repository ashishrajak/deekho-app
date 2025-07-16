// models/address_dto.dart

enum AddressType {
  home,
  work,
  other,
}

class AddressDTO {
  final int? id;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final AddressType? addressType;
  final bool? isActive;
  final String? landmark;
  final String? contactPerson;
  final String? contactPhone;
  final bool? isDefault;

  const AddressDTO({
    this.id,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.addressType,
    this.isActive,
    this.landmark,
    this.contactPerson,
    this.contactPhone,
    this.isDefault,
  });

  factory AddressDTO.fromJson(Map<String, dynamic> json) {
    return AddressDTO(
      id: json['id'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'],
      addressType: json['addressType'] != null 
          ? AddressType.values.firstWhere(
              (e) => e.name.toUpperCase() == json['addressType'].toString().toUpperCase(),
              orElse: () => AddressType.other,
            )
          : null,
      isActive: json['isActive'],
      landmark: json['landmark'],
      contactPerson: json['contactPerson'],
      contactPhone: json['contactPhone'],
      isDefault: json['isDefault'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'addressType': addressType?.name.toUpperCase(),
      'isActive': isActive,
      'landmark': landmark,
      'contactPerson': contactPerson,
      'contactPhone': contactPhone,
      'isDefault': isDefault,
    };
  }

  AddressDTO copyWith({
    int? id,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    AddressType? addressType,
    bool? isActive,
    String? landmark,
    String? contactPerson,
    String? contactPhone,
    bool? isDefault,
  }) {
    return AddressDTO(
      id: id ?? this.id,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      addressType: addressType ?? this.addressType,
      isActive: isActive ?? this.isActive,
      landmark: landmark ?? this.landmark,
      contactPerson: contactPerson ?? this.contactPerson,
      contactPhone: contactPhone ?? this.contactPhone,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  String toString() {
    return 'AddressDTO(id: $id, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, country: $country, postalCode: $postalCode, addressType: $addressType, isActive: $isActive, landmark: $landmark, contactPerson: $contactPerson, contactPhone: $contactPhone, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is AddressDTO &&
        other.id == id &&
        other.addressLine1 == addressLine1 &&
        other.addressLine2 == addressLine2 &&
        other.city == city &&
        other.state == state &&
        other.country == country &&
        other.postalCode == postalCode &&
        other.addressType == addressType &&
        other.isActive == isActive &&
        other.landmark == landmark &&
        other.contactPerson == contactPerson &&
        other.contactPhone == contactPhone &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        addressLine1.hashCode ^
        addressLine2.hashCode ^
        city.hashCode ^
        state.hashCode ^
        country.hashCode ^
        postalCode.hashCode ^
        addressType.hashCode ^
        isActive.hashCode ^
        landmark.hashCode ^
        contactPerson.hashCode ^
        contactPhone.hashCode ^
        isDefault.hashCode;
  }
}