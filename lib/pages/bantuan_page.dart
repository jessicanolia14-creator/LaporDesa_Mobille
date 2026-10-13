import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cara_membuat_laporan.dart';
import 'kontak_kami.dart';

class BantuanPage extends StatefulWidget {
  const BantuanPage({
    super.key,
    required this.onBack,
    required this.onNavigationChanged,
    this.showBottomNavigation = true,
  });

  final VoidCallback onBack;
  final ValueChanged<int> onNavigationChanged;
  final bool showBottomNavigation;

  @override
  State<BantuanPage> createState() => _BantuanPageState();
}

class _BantuanPageState extends State<BantuanPage> {
  static const Color _green = Color(0xFF08935B);
  static const Color _darkGreen = Color(0xFF00865B);
  static const Color _ink = Color(0xFF080808);
  static const Color _muted = Color(0xFF68717B);
  static const Color _neutral = Color(0xFF506788);
  static const Color _cardGrey = Color(0xFFEDF0F3);
  static const Color _border = Color(0xFFD1D6DD);

  final TextEditingController _questionController =
      TextEditingController();

  String? _selectedMenu;
  bool _openingGuide = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
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

  Future<void> _openGuide() async {
    if (_openingGuide) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _selectedMenu = 'guide';
      _openingGuide = true;
    });

    await Future<void>.delayed(
      const Duration(milliseconds: 180),
    );

    if (!mounted) return;

    try {
      final int? selectedTab =
          await Navigator.of(context).push<int>(
        MaterialPageRoute<int>(
          builder: (_) => const CaraMembuatLaporanPage(),
        ),
      );

      if (!mounted) return;

      if (selectedTab != null) {
        widget.onNavigationChanged(selectedTab);
      }
    } finally {
      if (mounted) {
        setState(() {
          _openingGuide = false;
        });
      }
    }
  }

  Future<void> _toggleContact() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _selectedMenu = 'contact';
    });

    final int? selectedTab =
        await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(
        builder: (_) => const KontakKamiPage(),
      ),
    );

    if (!mounted) return;

    if (selectedTab != null) {
      widget.onNavigationChanged(selectedTab);
    }
  }

  // Jawaban bantuan lokal untuk prototipe frontend.
  String _answerQuestion(String question) {
    final String text = question.toLowerCase();

    if (text.contains('password') || text.contains('sandi')) {
      return 'Buka halaman Login, kemudian pilih '
          '“Lupa password?” untuk membuka halaman pemulihan.';
    }

    if (text.contains('foto') || text.contains('gambar')) {
      return 'Pada halaman Isi detail laporan, tekan '
          '“Tambah Foto”, lalu pilih foto masalah dari galeri.';
    }

    if (text.contains('lokasi') || text.contains('maps')) {
      return 'Pada halaman Tentukan Lokasi, tekan '
          '“Buka Google Maps”. Cari tempat laporan, lalu kembali '
          'ke LaporDesa dan masukkan alamat atau tautan lokasinya.';
    }

    if (text.contains('status') || text.contains('riwayat')) {
      return 'Buka menu Riwayat. Gunakan filter Semua, '
          'Diproses, atau Selesai untuk melihat daftar laporan.';
    }

    if (text.contains('kontak') || text.contains('admin')) {
      return 'Hubungi pengurus RT sesuai wilayahmu '
          'untuk bantuan terkait laporan.';
    }

    if (text.contains('rt')) {
      return 'Tekan bagian “Pilih RT”, kemudian pilih '
          'RT 01 atau RT 02 sesuai lokasi masalah.';
    }

    return 'Untuk membuat laporan, buka menu Lapor, pilih '
        'kategori masalah, isi judul dan deskripsi, tambahkan '
        'foto, lalu tentukan lokasi dan RT sebelum mengirim.';
  }

  void _sendQuestion() {
    final String question = _questionController.text.trim();

    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tuliskan pertanyaan terlebih dahulu.'),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final String answer = _answerQuestion(question);
    _questionController.clear();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asisten AI LaporDesa',
                  style: _textStyle(
                    size: 20,
                    color: _green,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  question,
                  style: _textStyle(
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  answer,
                  style: _textStyle(
                    size: 14,
                    color: _muted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'Tutup',
                      style: _textStyle(
                        size: 15,
                        color: Colors.white,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _header(double scale) {
    return SizedBox(
      height: 66 * scale,
      child: Row(
        children: [
          SizedBox(
            width: 48 * scale,
            child: IconButton(
              onPressed: widget.onBack,
              tooltip: 'Kembali',
              icon: Icon(
                Icons.chevron_left_rounded,
                size: 30 * scale,
                color: _ink,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Bantuan',
              textAlign: TextAlign.center,
              style: _textStyle(
                size: 35 * scale,
                weight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
          SizedBox(width: 48 * scale),
        ],
      ),
    );
  }

  Widget _menuButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
    required double scale,
    bool expanded = false,
  }) {
    final BorderRadius radius =
        BorderRadius.circular(11 * scale);

    return Semantics(
      button: true,
      selected: selected,
      label: title,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: selected ? _green : _cardGrey,
          borderRadius: radius,
          border: Border.all(
            color: selected ? _green : _border,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15 * scale,
                vertical: 17 * scale,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: _textStyle(
                        size: 16 * scale,
                        color: selected ? Colors.white : _ink,
                        weight: FontWeight.w500,
                        height: 1.25,
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 19 * scale,
                    color: selected ? Colors.white : _ink,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _guide(double scale) {
    return _menuButton(
      title: 'Cara membuat laporan',
      selected: _selectedMenu == 'guide',
      onTap: _openGuide,
      scale: scale,
    );
  }

  Widget _contact(double scale) {
    return _menuButton(
      title: 'Kontak Kami',
      selected: _selectedMenu == 'contact',
      onTap: _toggleContact,
      scale: scale,
    );
  }

  Widget _assistantCard(double scale) {
    return Container(
      padding: EdgeInsets.all(13 * scale),
      decoration: BoxDecoration(
        color: _cardGrey,
        borderRadius: BorderRadius.circular(11 * scale),
        border: Border.all(color: _border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/asisten_ai.png',
                width: 57 * scale,
                height: 57 * scale,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
              SizedBox(width: 11 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Asisten AI LaporDesa',
                      style: _textStyle(
                        size: 16 * scale,
                        color: _green,
                        weight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 2 * scale),
                    Text(
                      'Tanyakan apa saja tentang pelaporan,\n'
                      'kami siap membantu 24/7',
                      style: _textStyle(
                        size: 12 * scale,
                        color: _muted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 9 * scale),
          TextField(
            controller: _questionController,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _sendQuestion(),
            cursorColor: _darkGreen,
            style: _textStyle(size: 13 * scale),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10 * scale,
                vertical: 9 * scale,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 19 * scale,
                color: const Color(0xFF808080),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 35 * scale,
                minHeight: 34 * scale,
              ),
              suffixIcon: IconButton(
                tooltip: 'Kirim pertanyaan',
                onPressed: _sendQuestion,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: 35 * scale,
                  minHeight: 34 * scale,
                ),
                icon: Icon(
                  Icons.send_rounded,
                  size: 21 * scale,
                  color: const Color(0xFF808080),
                ),
              ),
              suffixIconConstraints: BoxConstraints(
                minWidth: 35 * scale,
                minHeight: 34 * scale,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10 * scale),
                borderSide: const BorderSide(color: _border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10 * scale),
                borderSide: const BorderSide(
                  color: _green,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(double scale) {
    return ListView(
      padding: EdgeInsets.only(
        top: 24 * scale,
        bottom: 24 * scale,
      ),
      children: [
        _header(scale),
        SizedBox(height: 12 * scale),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 23 * scale,
          ),
          child: Column(
            children: [
              _guide(scale),
              SizedBox(height: 8 * scale),
              _contact(scale),
              SizedBox(height: 8 * scale),
              _assistantCard(scale),
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
    final bool selected = index == 3;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            widget.onNavigationChanged(index);
          },
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
        border: Border(
          top: BorderSide(color: _border),
        ),
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
      bottomNavigationBar: widget.showBottomNavigation
          ? Center(
              heightFactor: 1,
              child: SizedBox(
                width: contentWidth,
                child: _bottomNavigation(scale),
              ),
            )
          : null,
    );
  }
}