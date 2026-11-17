import '../repositories/auth_repository.dart';

// Logika autentikasi dipisahkan dari widget/UI.
class AuthViewModel {
  AuthViewModel({AuthRepository? repository})
    : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  bool login(String phone, String password) =>
      _repository.authenticate(phone, password);

  void register({
    required String name,
    required String phone,
    required String password,
    required String address,
    required String rt,
  }) {
    _repository.register(
      name: name,
      phone: phone,
      password: password,
      address: address,
      rt: rt,
    );
  }

  String? validatePhone(String? value) {
    final phone = (value ?? '').trim();
    if (!RegExp(r'^0[0-9]{9,12}$').hasMatch(phone)) {
      return 'Isi nomor HP 10–13 digit, diawali 0';
    }
    return null;
  }

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bagian ini wajib diisi';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  String? validateConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }
    if (value != password) {
      return 'Password tidak sama';
    }
    return null;
  }
}
