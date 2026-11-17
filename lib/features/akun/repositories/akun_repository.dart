import 'dart:typed_data';

import 'package:lapordesa/features/auth/models/demo_account.dart';
import 'package:lapordesa/features/akun/models/akun_model.dart';

/// Penyimpanan sementara. Data mengikuti DemoAccount, belum persisten.
class AkunRepository {
  AkunRepository._();
  static final AkunRepository instance = AkunRepository._();

  Uint8List? photoBytes;

  AkunModel get profile => AkunModel(
    name: DemoAccount.name,
    phone: DemoAccount.phone,
    address: DemoAccount.address,
    rt: DemoAccount.rt,
    photoBytes: photoBytes,
  );

  void updateAddress(String address) => DemoAccount.address = address;

  void saveProfile({
    required String name,
    required String phone,
    required String address,
    required String rt,
    Uint8List? photoBytes,
  }) {
    DemoAccount.name = name.trim();
    DemoAccount.phone = phone.trim();
    DemoAccount.address = address.trim();
    DemoAccount.rt = rt;
    this.photoBytes = photoBytes;
  }

  bool matchesPassword(String password) => DemoAccount.password == password;

  void changePassword(String password) => DemoAccount.password = password;
}
