import '../models/demo_account.dart';

// Adapter penyimpanan akun demo yang sudah dipakai aplikasi.
class AuthRepository {
  bool authenticate(String phone, String password) {
    return DemoAccount.authenticate(phone, password);
  }

  void register({
    required String name,
    required String phone,
    required String password,
    required String address,
    required String rt,
  }) {
    DemoAccount.register(
      name: name,
      phone: phone,
      password: password,
      address: address,
      rt: rt,
    );
  }

  // Menghapus akun demo yang sedang tersimpan.
  void deleteAccount() {
    DemoAccount.deleteAccount();
  }
}
