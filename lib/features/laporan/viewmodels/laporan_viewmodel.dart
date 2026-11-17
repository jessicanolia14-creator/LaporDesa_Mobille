import 'package:flutter/foundation.dart';

import '../models/laporan_lokal.dart';
import '../repositories/laporan_repository.dart';

/// Menjembatani halaman dengan repository laporan tanpa mengatur tampilan.
class LaporanViewModel extends ChangeNotifier {
  LaporanViewModel({LaporanRepository? repository})
    : _repository = repository ?? LaporanRepository() {
    _repository.perubahan.addListener(_onDataChanged);
  }

  final LaporanRepository _repository;

  List<LaporanLokal> get daftarTerbaru {
    final hasil = List<LaporanLokal>.from(_repository.daftar);
    hasil.sort((a, b) => b.dibuatPada.compareTo(a.dibuatPada));
    return hasil;
  }

  Future<void> muat() => _repository.muat();

  Future<void> simpan(LaporanLokal laporan) => _repository.simpan(laporan);

  void _onDataChanged() => notifyListeners();

  @override
  void dispose() {
    _repository.perubahan.removeListener(_onDataChanged);
    super.dispose();
  }
}
