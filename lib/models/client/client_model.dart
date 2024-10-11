class ClientModel {
  final int id;
  final String dni;
  final String typeId;
  final String address;
  final String email;
  final String firstName;
  final String lastName;
  final bool gender;
  final String phone;
  final bool? systemPrivacyPolicy;
  final bool? systemTermsAndConditions;
  final DateTime createAt;
  final DateTime updateAt;

  ClientModel({
    required this.id,
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
    required this.createAt,
    required this.updateAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    final clientJson = json['client'];

    return ClientModel(
      id: clientJson['id'],
      dni: clientJson['dni'],
      typeId: clientJson['typeDni'],
      address: clientJson['address'],
      email: clientJson['email'],
      firstName: clientJson['firstName'],
      lastName: clientJson['lastName'],
      gender: clientJson['gender'],
      phone: clientJson['phone'],
      systemPrivacyPolicy: json['systemPrivacyPolicy'],
      systemTermsAndConditions: json['systemTermsAndConditions'],
      createAt: DateTime.parse(clientJson['createAt']),
      updateAt: DateTime.parse(clientJson['updateAt']),
    );
  }
}
