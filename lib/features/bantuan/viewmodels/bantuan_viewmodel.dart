import 'package:flutter/foundation.dart';

import '../models/bantuan_faq.dart';
import '../repositories/bantuan_repository.dart';

/// Logika pencarian jawaban bantuan, terpisah dari tampilan.
class BantuanViewModel extends ChangeNotifier {
  BantuanViewModel({BantuanRepository? repository})
    : _repository = repository ?? const BantuanRepository();

  final BantuanRepository _repository;
  BantuanFaq? _jawabanTerakhir;

  BantuanFaq? get jawabanTerakhir => _jawabanTerakhir;

  BantuanFaq tanya(String pertanyaan) {
    final hasil = _repository.cariJawaban(pertanyaan.trim());
    _jawabanTerakhir = hasil;
    notifyListeners();
    return hasil;
  }
}
