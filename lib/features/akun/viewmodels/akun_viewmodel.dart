import 'package:flutter/foundation.dart';
import 'package:lapordesa/features/akun/models/akun_model.dart';
import 'package:lapordesa/features/akun/repositories/akun_repository.dart';

/// Menangani state data dan aturan fitur Akun, tanpa kode tampilan.
class AkunViewModel extends ChangeNotifier {
  AkunViewModel({AkunRepository? repository})
    : _repository = repository ?? AkunRepository.instance;

  final AkunRepository _repository;
  AkunModel get profile => _repository.profile;

  void saveProfile({
    required String name,
    required String phone,
    required String address,
    required String rt,
    Uint8List? photoBytes,
  }) {
    _repository.saveProfile(
      name: name,
      phone: phone,
      address: address,
      rt: rt,
      photoBytes: photoBytes,
    );
    notifyListeners();
  }

  bool isSupportedPhoto(Uint8List bytes) {
    final isJpg =
        bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF;
    final isPng =
        bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A;
    return isJpg || isPng;
  }

  bool isPhotoSizeValid(Uint8List bytes) => bytes.length <= 2 * 1024 * 1024;
  bool isCurrentPassword(String password) =>
      _repository.matchesPassword(password);
  bool hasEightCharacters(String password) => password.runes.length >= 8;
  bool hasUpperAndLowerCase(String password) =>
      RegExp(r'[A-Z]').hasMatch(password) &&
      RegExp(r'[a-z]').hasMatch(password);
  bool hasNumber(String password) => RegExp(r'[0-9]').hasMatch(password);
  bool hasSymbol(String password) =>
      RegExp(r'[^a-zA-Z0-9\s]').hasMatch(password);

  void changePassword(String password) {
    _repository.changePassword(password);
    notifyListeners();
  }
}
