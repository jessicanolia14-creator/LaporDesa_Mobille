import 'package:flutter/foundation.dart';

import '../models/laporan_lokal.dart';

/// Akses penyimpanan laporan lokal yang sudah dipakai aplikasi.
class LaporanRepository {
  ValueListenable<int> get perubahan => LaporanLokal.perubahan;

  Future<void> muat() => LaporanLokal.muat();

  List<LaporanLokal> get daftar =>
      List<LaporanLokal>.unmodifiable(LaporanLokal.daftar);

  Future<void> simpan(LaporanLokal laporan) => LaporanLokal.tambah(laporan);
}
