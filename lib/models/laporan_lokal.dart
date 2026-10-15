import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class LaporanLokal {
  LaporanLokal({
    required this.judul,
    required this.deskripsi,
    required this.foto,
    required this.lokasi,
    required this.rt,
    required this.patokan,
    required this.dibuatPada,
  });

  final String judul;
  final String deskripsi;
  final List<Uint8List> foto;
  final String lokasi;
  final String rt;
  final String patokan;
  final DateTime dibuatPada;

  static final List<LaporanLokal> daftar = [];

  static final ValueNotifier<int> perubahan = ValueNotifier<int>(0);

  static Future<void>? _prosesMuat;

  static Future<File> _filePenyimpanan() async {
    final Directory directory =
        await getApplicationDocumentsDirectory();

    return File(
      '${directory.path}${Platform.pathSeparator}'
      'lapordesa_laporan.json',
    );
  }

  Map<String, dynamic> _toJson() {
    return {
      'judul': judul,
      'deskripsi': deskripsi,
      'foto': foto.map((bytes) => base64Encode(bytes)).toList(),
      'lokasi': lokasi,
      'rt': rt,
      'patokan': patokan,
      'dibuatPada': dibuatPada.toIso8601String(),
    };
  }

  factory LaporanLokal._fromJson(Map<String, dynamic> json) {
    return LaporanLokal(
      judul: json['judul'] as String,
      deskripsi: json['deskripsi'] as String,
      foto: (json['foto'] as List<dynamic>)
          .map((value) => base64Decode(value as String))
          .toList(),
      lokasi: json['lokasi'] as String,
      rt: json['rt'] as String,
      patokan: json['patokan'] as String,
      dibuatPada: DateTime.parse(
        json['dibuatPada'] as String,
      ),
    );
  }

  static Future<void> muat() {
    return _prosesMuat ??= _muatDariFile();
  }

  static Future<void> _muatDariFile() async {
    try {
      final File file = await _filePenyimpanan();

      if (!await file.exists()) {
        return;
      }

      final String isi = await file.readAsString();
      final List<dynamic> data = jsonDecode(isi) as List<dynamic>;

      final List<LaporanLokal> laporan = data.map((item) {
        return LaporanLokal._fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList();

      daftar
        ..clear()
        ..addAll(laporan);

      perubahan.value++;
    } catch (_) {
      _prosesMuat = null;
      rethrow;
    }
  }

  static Future<void> tambah(LaporanLokal laporan) async {
    await muat();

    final List<LaporanLokal> dataBaru = [
      ...daftar,
      laporan,
    ];

    final File file = await _filePenyimpanan();
    final File temporaryFile = File('${file.path}.tmp');

    await temporaryFile.writeAsString(
      jsonEncode(
        dataBaru.map((item) => item._toJson()).toList(),
      ),
      flush: true,
    );

    await temporaryFile.rename(file.path);

    daftar
      ..clear()
      ..addAll(dataBaru);

    perubahan.value++;
  }
}