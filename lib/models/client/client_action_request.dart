class ClientModelRequest {
  final String dni;
  final String typeId;
  final String address;
  final String email;
  final String firstName;
  final String lastName;
  final bool? gender;
  final String phone;
  final bool? systemPrivacyPolicy;
  final bool? systemTermsAndConditions;

  ClientModelRequest({
    required this.dni,
    required this.typeId,
    required this.address,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phone,
    this.systemPrivacyPolicy,
    this.systemTermsAndConditions,
  });

  factory ClientModelRequest.fromJson(Map<String, dynamic> json) {
    return ClientModelRequest(
      dni: json['Dni'] ?? json['dni'],
      typeId: json['typeDni'],
      address: json['Address'] ?? json['address'],
      email: json['Email'] ?? json['email'],
      firstName: json['FirstName'] ?? json['firstName'],
      lastName: json['LastName'] ?? json['lastName'],
      gender: json['Gender'] ?? json['gender'],
      phone: json['Phone'] ?? json['phone'],
      systemPrivacyPolicy: json['SystemPrivacyPolicy'] ?? json['systemPrivacyPolicy'],
      systemTermsAndConditions: json['SystemTermsAndConditions'] ?? json['systemTermsAndConditions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dni': dni,
      'typeDni': typeId,
      'address': address,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'phone': phone,
      'systemPrivacyPolicy': systemPrivacyPolicy,
      'systemTermsAndConditions': systemTermsAndConditions,
    };
  }
}
