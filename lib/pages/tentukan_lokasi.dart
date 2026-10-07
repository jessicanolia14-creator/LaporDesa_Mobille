import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class TentukanLokasiPage extends StatefulWidget {
  const TentukanLokasiPage({
    super.key,
    required this.judul,
    required this.deskripsi,
    required this.foto,
  });

  final String judul;
  final String deskripsi;
  final List<Uint8List> foto;

  @override
  State<TentukanLokasiPage> createState() =>
      _TentukanLokasiPageState();
}

class _TentukanLokasiPageState extends State<TentukanLokasiPage>
    with WidgetsBindingObserver {
  static const Color _green = Color(0xFF08935B);
  static const Color _darkGreen = Color(0xFF00865B);
  static const Color _mint = Color(0xFFD3F7E9);
  static const Color _ink = Color(0xFF121212);
  static const Color _muted = Color(0xFF68717B);
  static const Color _neutral = Color(0xFF506788);
  static const Color _grey = Color(0xFFEDF0F3);
  static const Color _border = Color(0xFFD1D6DD);
  static const Color _progressBackground = Color(0xFFE2E8F0);

  final TextEditingController _patokanController =
      TextEditingController();

  String? _selectedRt;
  String? _lokasi;

  bool _waitingForMaps = false;
  bool _openingMaps = false;
  bool _editingLocation = false;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _patokanController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _waitingForMaps) {
      _waitingForMaps = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _editLocation();
        }
      });
    }
  }

  TextStyle _textStyle({
    required double size,
    Color color = _ink,
    FontWeight weight = FontWeight.w400,
    double height = 1.3,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: height,
    );
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Future<void> _openMaps() async {
    if (_openingMaps) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _openingMaps = true;
    });

    _waitingForMaps = true;

    try {
      final Uri uri = Uri.https(
        'www.google.com',
        '/maps',
        {
          'api': '1',
          'map_action': 'map',
        },
      );

      final bool opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        _waitingForMaps = false;

        if (mounted) {
          _message('Google Maps belum bisa dibuka.');
        }
      }
    } catch (_) {
      _waitingForMaps = false;

      if (mounted) {
        _message('Google Maps belum bisa dibuka. Coba lagi.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _openingMaps = false;
        });
      }
    }
  }

  Future<void> _editLocation() async {
    if (_editingLocation || !mounted) return;

    _editingLocation = true;

    final TextEditingController controller =
        TextEditingController(text: _lokasi ?? '');

    try {
      final String? result = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Lokasi laporan',
              style: _textStyle(
                size: 20,
                weight: FontWeight.w600,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masukkan alamat atau tempel tautan tempat '
                  'yang kamu pilih di Google Maps.',
                  style: _textStyle(
                    size: 13,
                    color: _muted,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  autofocus: true,
                  minLines: 2,
                  maxLines: 4,
                  cursorColor: _darkGreen,
                  style: _textStyle(size: 14),
                  decoration: InputDecoration(
                    hintText: 'Alamat atau tautan Google Maps',
                    hintStyle: _textStyle(
                      size: 13,
                      color: _muted,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        color: _darkGreen,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text(
                  'Batal',
                  style: _textStyle(
                    size: 14,
                    color: _muted,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  final String value = controller.text.trim();

                  if (value.isEmpty) return;

                  Navigator.of(dialogContext).pop(value);
                },
                child: Text(
                  'Gunakan Lokasi',
                  style: _textStyle(
                    size: 14,
                    color: _darkGreen,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (!mounted || result == null) return;

      setState(() {
        _lokasi = result;
      });
    } finally {
      // Tunggu animasi penutupan dialog sebelum controller dibuang.
      await Future<void>.delayed(
        const Duration(milliseconds: 300),
      );
      controller.dispose();
      _editingLocation = false;
    }
  }

  Future<void> _chooseRt() async {
    FocusScope.of(context).unfocus();

    final String? result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Pilih RT',
            style: _textStyle(
              size: 20,
              weight: FontWeight.w600,
            ),
          ),
          children: [
            for (final String rt in ['RT 01', 'RT 02'])
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 5,
                ),
                child: Material(
                  color: _selectedRt == rt ? _green : _grey,
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {
                      Navigator.of(dialogContext).pop(rt);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: Text(
                        rt,
                        textAlign: TextAlign.center,
                        style: _textStyle(
                          size: 16,
                          color: _selectedRt == rt
                              ? Colors.white
                              : _muted,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
          ],
        );
      },
    );

    if (!mounted || result == null) return;

    setState(() {
      _selectedRt = result;
    });
  }

  Future<void> _sendReport() async {
    if (_sending) return;

    FocusScope.of(context).unfocus();

    if (_lokasi == null || _lokasi!.trim().isEmpty) {
      _message('Tentukan lokasi laporan terlebih dahulu.');
      await _editLocation();
      return;
    }

    if (_selectedRt == null) {
      _message('Pilih RT terlebih dahulu.');
      return;
    }

    setState(() {
      _sending = true;
    });

    // Penyimpanan sementara di memori aplikasi.
    // Belum mengirim ke server.
    LaporanLokal.daftar.add(
      LaporanLokal(
        judul: widget.judul,
        deskripsi: widget.deskripsi,
        foto: List<Uint8List>.unmodifiable(widget.foto),
        lokasi: _lokasi!,
        rt: _selectedRt!,
        patokan: _patokanController.text.trim(),
        dibuatPada: DateTime.now(),
      ),
    );

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Laporan tersimpan',
            style: _textStyle(
              size: 20,
              weight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Detail laporan dan lokasi sudah tersimpan '
            'di aplikasi.',
            style: _textStyle(
              size: 14,
              color: _muted,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Kembali ke Beranda',
                style: _textStyle(
                  size: 14,
                  color: _darkGreen,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    Navigator.of(context).pop<int>(0);
  }

  void _changeNavigation(int index) {
    if (index == 1 || _sending) return;

    FocusScope.of(context).unfocus();
    Navigator.of(context).pop<int>(index);
  }

  Widget _header(double scale) {
    return SizedBox(
      height: 56 * scale,
      child: Row(
        children: [
          SizedBox(
            width: 48 * scale,
            child: IconButton(
              tooltip: 'Kembali',
              onPressed: _sending
                  ? null
                  : () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.chevron_left_rounded,
                size: 30 * scale,
                color: _ink,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Tentukan Lokasi',
              textAlign: TextAlign.center,
              style: _textStyle(
                size: 25 * scale,
                weight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 48 * scale),
        ],
      ),
    );
  }

  Widget _progress(double scale) {
    return Padding(
      padding: EdgeInsets.only(
        left: 54 * scale,
        right: 18 * scale,
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              label: 'Langkah 3 dari 3',
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 2 / 3,
                  end: 1,
                ),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOutCubic,
                builder: (context, value, child) {
                  return Container(
                    height: 12 * scale,
                    decoration: BoxDecoration(
                      color: _progressBackground,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: value,
                        heightFactor: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: _green,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 8 * scale),
          Text(
            '3/3',
            style: _textStyle(
              size: 15 * scale,
              color: _muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapCard(double scale) {
    return Container(
      height: 280 * scale,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9 * scale),
        border: Border.all(
          color: const Color(0xFF2196F3),
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_lokasi == null)
            const CustomPaint(
              painter: _EmptyMapPainter(),
            )
          else
            Padding(
              padding: EdgeInsets.fromLTRB(
                20 * scale,
                20 * scale,
                20 * scale,
                65 * scale,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 76 * scale,
                    color: _darkGreen,
                  ),
                  SizedBox(height: 10 * scale),
                  Text(
                    _lokasi!,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: _textStyle(
                      size: 14 * scale,
                      color: _muted,
                    ),
                  ),
                ],
              ),
            ),
          Positioned(
            right: 6 * scale,
            bottom: 7 * scale,
            child: OutlinedButton(
              onPressed: _openingMaps || _sending
                  ? null
                  : _openMaps,
              style: OutlinedButton.styleFrom(
                backgroundColor:
                    _lokasi == null ? Colors.white : _green,
                foregroundColor:
                    _lokasi == null ? _muted : Colors.white,
                side: BorderSide(
                  color: _lokasi == null ? _muted : _green,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10 * scale,
                  vertical: 7 * scale,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4 * scale),
                ),
              ),
              child: Text(
                _openingMaps
                    ? 'Membuka Maps...'
                    : 'Buka Google Maps',
                style: _textStyle(
                  size: 14 * scale,
                  color:
                      _lokasi == null ? _muted : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rtField(double scale) {
    return Material(
      color: _grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5 * scale),
        side: const BorderSide(color: _border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _sending ? null : _chooseRt,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 7 * scale,
            vertical: 8 * scale,
          ),
          child: Row(
            children: [
              Container(
                width: 35 * scale,
                height: 35 * scale,
                decoration: BoxDecoration(
                  color: _mint,
                  borderRadius: BorderRadius.circular(5 * scale),
                  border: Border.all(color: _border),
                ),
                child: Icon(
                  Icons.groups_rounded,
                  size: 30 * scale,
                  color: _darkGreen,
                ),
              ),
              SizedBox(width: 7 * scale),
              Expanded(
                child: Text(
                  _selectedRt ?? 'Pilih RT',
                  style: _textStyle(size: 15 * scale),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _ink,
                size: 25 * scale,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _patokanField(double scale) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5 * scale),
      borderSide: const BorderSide(color: _border),
    );

    return TextField(
      controller: _patokanController,
      enabled: !_sending,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: _darkGreen,
      style: _textStyle(size: 15 * scale),
      decoration: InputDecoration(
        hintText: 'Contoh: deket balai desa',
        hintStyle: _textStyle(
          size: 15 * scale,
          color: _muted,
        ),
        filled: true,
        fillColor: _grey,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 13 * scale,
          vertical: 13 * scale,
        ),
        enabledBorder: border,
        disabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5 * scale),
          borderSide: const BorderSide(
            color: _darkGreen,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _content(double scale) {
    return ListView(
      padding: EdgeInsets.only(
        top: 8 * scale,
        bottom: 20 * scale,
      ),
      children: [
        _header(scale),
        SizedBox(height: 4 * scale),
        _progress(scale),
        SizedBox(height: 26 * scale),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32 * scale,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _mapCard(scale),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _sending ? null : _editLocation,
                  child: Text(
                    _lokasi == null
                        ? 'Masukkan alamat / tautan lokasi'
                        : 'Ubah lokasi laporan',
                    style: _textStyle(
                      size: 12 * scale,
                      color: _darkGreen,
                    ),
                  ),
                ),
              ),
              Text(
                'Pilih RT',
                style: _textStyle(
                  size: 19 * scale,
                  weight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5 * scale),
              _rtField(scale),
              SizedBox(height: 80 * scale),
              Text(
                'Patokan Lokasi (Opsional)',
                style: _textStyle(
                  size: 19 * scale,
                  weight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 13 * scale),
              _patokanField(scale),
              SizedBox(height: 21 * scale),
              SizedBox(
                width: double.infinity,
                height: 49 * scale,
                child: ElevatedButton(
                  onPressed: _sending ? null : _sendReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5 * scale),
                    ),
                  ),
                  child: Text(
                    _sending ? 'Menyimpan...' : 'Kirim Laporan',
                    style: _textStyle(
                      size: 23 * scale,
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
    );
  }

  Widget _navigationItem({
    required int index,
    required String label,
    required IconData icon,
    required double scale,
  }) {
    final bool selected = index == 1;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: () => _changeNavigation(index),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8 * scale),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 34 * scale,
                  color: selected ? _darkGreen : _neutral,
                ),
                SizedBox(height: 4 * scale),
                Text(
                  label,
                  style: _textStyle(
                    size: 13 * scale,
                    color: selected ? _darkGreen : _ink,
                    weight: selected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomNavigation(double scale) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _navigationItem(
              index: 0,
              label: 'Beranda',
              icon: Icons.home_outlined,
              scale: scale,
            ),
            _navigationItem(
              index: 1,
              label: 'Lapor',
              icon: Icons.description_outlined,
              scale: scale,
            ),
            _navigationItem(
              index: 2,
              label: 'Riwayat',
              icon: Icons.access_time_rounded,
              scale: scale,
            ),
            _navigationItem(
              index: 3,
              label: 'Bantuan',
              icon: Icons.headset_mic_outlined,
              scale: scale,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double contentWidth =
        screenWidth > 480 ? 480.0 : screenWidth;
    final double scale = contentWidth / 390;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: SizedBox(
            width: contentWidth,
            child: _content(scale),
          ),
        ),
      ),
      bottomNavigationBar: Center(
        heightFactor: 1,
        child: SizedBox(
          width: contentWidth,
          child: _bottomNavigation(scale),
        ),
      ),
    );
  }
}

// Tampilan awal kotak lokasi mengikuti gambar ketiga.
// Ini placeholder, bukan peta Google Maps interaktif.
class _EmptyMapPainter extends CustomPainter {
  const _EmptyMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF68717B)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset.zero,
      Offset(size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _EmptyMapPainter oldDelegate) {
    return false;
  }
}

// Data sementara untuk frontend.
// Data akan hilang saat aplikasi dimulai ulang.
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

  static final List<LaporanLokal> daftar = [];

  final String judul;
  final String deskripsi;
  final List<Uint8List> foto;
  final String lokasi;
  final String rt;
  final String patokan;
  final DateTime dibuatPada;
}