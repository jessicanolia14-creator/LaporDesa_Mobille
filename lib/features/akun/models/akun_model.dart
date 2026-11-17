import 'dart:typed_data';

/// Snapshot profil warga untuk lapisan UI.
class AkunModel {
  const AkunModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.rt,
    this.photoBytes,
  });

  final String name;
  final String phone;
  final String address;
  final String rt;
  final Uint8List? photoBytes;
}
