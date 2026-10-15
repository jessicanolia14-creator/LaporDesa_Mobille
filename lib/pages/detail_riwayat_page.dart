import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/laporan_lokal.dart';

class DetailRiwayatPage extends StatelessWidget {
  const DetailRiwayatPage({
    super.key,
    required this.laporan,
  });

  final LaporanLokal laporan;

  static const Color _green = Color(0xFF08935B);
  static const Color _darkGreen = Color(0xFF00865B);
  static const Color _mint = Color(0xFFD3F7E9);
  static const Color _ink = Color(0xFF121212);
  static const Color _muted = Color(0xFF68717B);
  static const Color _grey = Color(0xFFEDF0F3);
  static const Color _border = Color(0xFFD1D6DD);

  TextStyle _style(
    double size, {
    Color color = _ink,
    FontWeight weight = FontWeight.w400,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: 1.45,
    );
  }

  String _tanggal(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} ${date.year}';
  }

  String _jam(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String _isi(String value) {
    return value.trim().isEmpty ? 'Belum dicantumkan' : value.trim();
  }

  void _lihatFoto(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: MediaQuery.sizeOf(dialogContext).height * 0.7,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Foto ${index + 1}',
                          style: _style(
                            16,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Tutup',
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: Center(
                      child: Image.memory(
                        laporan.foto[index],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return _fotoGagal();
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _fotoGagal() {
    return Container(
      color: _grey,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.image_not_supported_outlined,
            size: 40,
            color: _muted,
          ),
          const SizedBox(height: 8),
          Text(
            'Foto tidak tersedia',
            style: _style(13, color: _muted),
          ),
        ],
      ),
    );
  }

  Widget _fotoUtama(BuildContext context) {
    if (laporan.foto.isEmpty) {
      return SizedBox(
        height: 220,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: _fotoGagal(),
        ),
      );
    }

    return Semantics(
      button: true,
      label: 'Perbesar foto utama laporan',
      child: GestureDetector(
        onTap: () => _lihatFoto(context, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 230,
                child: Image.memory(
                  laporan.foto.first,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return _fotoGagal();
                  },
                ),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.zoom_in_rounded,
                        size: 18,
                        color: _darkGreen,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Lihat foto',
                        style: _style(
                          11,
                          color: _darkGreen,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _judulBagian(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: _mint,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: _darkGreen,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: _style(
              16,
              weight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: child,
    );
  }

  Widget _informasi({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 21,
            color: _darkGreen,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: _style(12, color: _muted),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: _style(
                    14,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _status() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Diproses',
        style: _style(
          12,
          color: const Color(0xFFD98200),
          weight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _fotoLaporan(BuildContext context) {
    if (laporan.foto.isEmpty) {
      return const SizedBox.shrink();
    }

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _judulBagian(
            'Dokumentasi foto',
            Icons.photo_library_outlined,
          ),
          const SizedBox(height: 14),
          Text(
            'Ketuk foto untuk melihat lebih jelas.',
            style: _style(12, color: _muted),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: laporan.foto.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return Semantics(
                button: true,
                label: 'Lihat foto laporan ${index + 1}',
                child: GestureDetector(
                  onTap: () => _lihatFoto(context, index),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      laporan.foto[index],
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: _grey,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: _muted,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final contentWidth = screenWidth > 480 ? 480.0 : screenWidth;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: contentWidth,
            child: Column(
              children: [
                SizedBox(
                  height: 64,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 52,
                        child: IconButton(
                          tooltip: 'Kembali ke riwayat',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.chevron_left_rounded,
                            size: 30,
                            color: _ink,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Detail Laporan',
                          textAlign: TextAlign.center,
                          style: _style(
                            22,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 52),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
                    children: [
                      _fotoUtama(context),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              _isi(laporan.judul),
                              style: _style(
                                22,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: _status(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 15,
                            color: _muted,
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              '${_tanggal(laporan.dibuatPada)}'
                              ' • ${_jam(laporan.dibuatPada)}',
                              style: _style(12, color: _muted),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _judulBagian(
                              'Deskripsi laporan',
                              Icons.description_outlined,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              _isi(laporan.deskripsi),
                              style: _style(14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _judulBagian(
                              'Lokasi kejadian',
                              Icons.location_on_outlined,
                            ),
                            const SizedBox(height: 8),
                            _informasi(
                              icon: Icons.groups_outlined,
                              label: 'Wilayah RT',
                              value: _isi(laporan.rt),
                            ),
                            const Divider(
                              height: 16,
                              color: _border,
                            ),
                            _informasi(
                              icon: Icons.map_outlined,
                              label: 'Alamat / lokasi',
                              value: _isi(laporan.lokasi),
                            ),
                            const Divider(
                              height: 16,
                              color: _border,
                            ),
                            _informasi(
                              icon: Icons.flag_outlined,
                              label: 'Patokan lokasi',
                              value: laporan.patokan.trim().isEmpty
                                  ? 'Tidak ada patokan tambahan'
                                  : laporan.patokan.trim(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _fotoLaporan(context),
                      const SizedBox(height: 22),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _green,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Kembali ke Riwayat',
                            style: _style(
                              15,
                              color: Colors.white,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}