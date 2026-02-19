import 'package:flutter/material.dart';

class Customer {
  final String medicalRecord;
  final String name;
  final String idCardNumber;
  final String birthDate;
  final String address;
  final String phoneNumber;
  final String email;
  final String profilePicture;
  final String genderRaw;
  final String age;

  const Customer({
    required this.medicalRecord,
    required this.name,
    required this.idCardNumber,
    required this.birthDate,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.profilePicture,
    required this.genderRaw,
    required this.age,
  });

  /// ================= FROM JSON =================
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      medicalRecord: json['no_rkm_medis']?.toString() ?? '',
      name: json['nm_pasien']?.toString() ?? '',
      idCardNumber: json['no_ktp']?.toString() ?? '',
      birthDate: json['tgl_lahir']?.toString() ?? '',
      address: json['alamat']?.toString() ?? '',
      phoneNumber: json['no_tlp']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profilePicture: json['foto']?.toString() ?? '',
      genderRaw: (json['jk']?.toString() ?? '').toUpperCase(),
      age: json['umur']?.toString() ?? '',
    );
  }

  /// ================= TO JSON =================
  Map<String, dynamic> toJson() {
    return {
      'no_rkm_medis': medicalRecord,
      'nm_pasien': name,
      'no_ktp': idCardNumber,
      'tgl_lahir': birthDate,
      'alamat': address,
      'no_tlp': phoneNumber,
      'email': email,
      'foto': profilePicture,
      'jk': genderRaw,
      'umur': age,
    };
  }

  /// ================= COPY WITH =================
  Customer copyWith({
    String? medicalRecord,
    String? name,
    String? idCardNumber,
    String? birthDate,
    String? address,
    String? phoneNumber,
    String? email,
    String? profilePicture,
    String? genderRaw,
    String? age,
  }) {
    return Customer(
      medicalRecord: medicalRecord ?? this.medicalRecord,
      name: name ?? this.name,
      idCardNumber: idCardNumber ?? this.idCardNumber,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      genderRaw: genderRaw ?? this.genderRaw,
      age: age ?? this.age,
    );
  }

  /// ================= DERIVED PROPERTIES =================

  String get genderText =>
      genderRaw == 'L' ? 'Laki-laki' : 'Perempuan';

  bool get hasProfilePicture => profilePicture.isNotEmpty;

  bool get isNetworkImage =>
      profilePicture.isNotEmpty &&
          profilePicture.startsWith('http');

  /// ================= SAFE IMAGE PROVIDER =================
  ImageProvider get imageProvider {
    if (isNetworkImage) {
      return NetworkImage(profilePicture);
    }

    if (genderRaw == 'L') {
      return const AssetImage('assets/images/male.png');
    }

    return const AssetImage('assets/images/female.png');
  }

  /// ================= OVERRIDE (OPTIONAL BUT GOOD PRACTICE) =================
  @override
  String toString() {
    return 'Customer(name: $name, medicalRecord: $medicalRecord)';
  }
}
