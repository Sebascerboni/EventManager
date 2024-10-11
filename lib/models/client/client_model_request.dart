class ClientModelRequest {
  final String dni;
  final String typeId;
  final String address;
  final String email;
  final String firstName;
  final String lastName;
  final bool gender;
  final String phone;
  final bool privacy;
  final bool termsCondition;

  ClientModelRequest({
    required this.dni,
    required this.typeId,
    required this.address,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phone,
    required this.privacy,
    required this.termsCondition,
  });

  factory ClientModelRequest.fromJson(Map<String, dynamic> json) {
    final clientJson = json['client'];

    return ClientModelRequest(
      dni: clientJson['dni'] ?? json['Dni'],
      typeId: clientJson['typeDni'] ?? json['typeid'],
      address: clientJson['address'] ?? json['Address'],
      email: clientJson['email'] ?? json['Email'],
      firstName: clientJson['firstName'] ?? json['FirstName'],
      lastName: clientJson['lastName'] ?? json['LastName'],
      gender: clientJson['gender'] ?? json['Gender'],
      phone: clientJson['phone'] ?? json['Phone'],
      privacy: json['systemPrivacyPolicy'] ?? json['Privacy'],
      termsCondition: json['systemTermsAndConditions'] ?? json['TermsCondition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client': {
        'dni': dni,
        'typeDni': typeId,
        'address': address,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'phone': phone,
      },
      'systemPrivacyPolicy': privacy,
      'systemTermsAndConditions': termsCondition,
    };
  }
}
