import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'tentukan_lokasi.dart';

class BuatLaporanDetailPage extends StatefulWidget {
  const BuatLaporanDetailPage({super.key});

  @override
  State<BuatLaporanDetailPage> createState() =>
      _BuatLaporanDetailPageState();
}

class _BuatLaporanDetailPageState
    extends State<BuatLaporanDetailPage> {
  static const Color _green = Color(0xFF08935B);
  static const Color _darkGreen = Color(0xFF00865B);
  static const Color _ink = Color(0xFF121212);
  static const Color _muted = Color(0xFF68717B);
  static const Color _neutral = Color(0xFF506788);
  static const Color _border = Color(0xFFD1D6DD);
  static const Color _progressBackground = Color(0xFFE2E8F0);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Form kosong saat pertama dibuka.
  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _descriptionController =
      TextEditingController();

  // Tidak ada foto contoh.
  final List<Uint8List> _addedPhotos = [];

  bool _isPickingPhoto = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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

  void _back() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  void _changeNavigation(int index) {
    if (index == 1) return;

    FocusScope.of(context).unfocus();
    Navigator.of(context).pop<int>(index);
  }

  Future<void> _addPhoto() async {
    if (_isPickingPhoto) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isPickingPhoto = true;
    });

    try {
      final XFile? selectedPhoto = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );

      if (selectedPhoto == null) return;

      final Uint8List bytes = await selectedPhoto.readAsBytes();

      if (!mounted) return;

      setState(() {
        _addedPhotos.add(bytes);
      });
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Foto belum bisa dibuka. Silakan coba lagi.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingPhoto = false;
        });
      }
    }
  }

    Future<void> _continue() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final int? selectedTab =
        await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(
        builder: (_) => TentukanLokasiPage(
          judul: _titleController.text.trim(),
          deskripsi: _descriptionController.text.trim(),
          foto: List<Uint8List>.unmodifiable(_addedPhotos),
        ),
      ),
    );

    if (!mounted) return;

    if (selectedTab != null) {
      Navigator.of(context).pop<int>(selectedTab);
    }
  }

  Widget _header(double scale) {
    return SizedBox(
      height: 56 * scale,
      child: Row(
        children: [
          SizedBox(
            width: 48 * scale,
            child: IconButton(
              onPressed: _back,
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
              'Buat Laporan',
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
        left: 46 * scale,
        right: 26 * scale,
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              label: 'Langkah 2 dari 3',
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 1 / 3,
                  end: 2 / 3,
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
          SizedBox(width: 14 * scale),
          Text(
            '2/3',
            style: _textStyle(
              size: 15 * scale,
              color: _muted,
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _fieldBorder({
    required double scale,
    Color color = _border,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5 * scale),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }

  Widget _label(String text, double scale) {
    return Text(
      text,
      style: _textStyle(
        size: 19 * scale,
        weight: FontWeight.w600,
      ),
    );
  }

  Widget _titleField(double scale) {
    return FractionallySizedBox(
      widthFactor: 0.86,
      alignment: Alignment.centerLeft,
      child: TextFormField(
        controller: _titleController,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        style: _textStyle(
          size: 16 * scale,
        ),
        cursorColor: _darkGreen,
        decoration: InputDecoration(
          hintText: 'contoh: Jalan rusak di depan rumah',
          hintStyle: _textStyle(
            size: 14 * scale,
            color: _muted,
          ),
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 11 * scale,
            vertical: 11 * scale,
          ),
          enabledBorder: _fieldBorder(scale: scale),
          focusedBorder: _fieldBorder(
            scale: scale,
            color: _darkGreen,
            width: 1.5,
          ),
          errorBorder: _fieldBorder(
            scale: scale,
            color: Colors.red,
          ),
          focusedErrorBorder: _fieldBorder(
            scale: scale,
            color: Colors.red,
          ),
          errorStyle: _textStyle(
            size: 12 * scale,
            color: Colors.red,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Judul laporan wajib diisi';
          }
          return null;
        },
      ),
    );
  }

  Widget _descriptionField(double scale) {
    return TextFormField(
      controller: _descriptionController,
      minLines: 6,
      maxLines: 6,
      maxLength: 500,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      style: _textStyle(
        size: 14 * scale,
        height: 1.5,
      ),
      cursorColor: _darkGreen,
      decoration: InputDecoration(
        hintText: 'Jelaskan Detail Masalah...',
        hintStyle: _textStyle(
          size: 14 * scale,
          color: _muted,
          height: 1.5,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(12 * scale),
        enabledBorder: _fieldBorder(scale: scale),
        focusedBorder: _fieldBorder(
          scale: scale,
          color: _darkGreen,
          width: 1.5,
        ),
        errorBorder: _fieldBorder(
          scale: scale,
          color: Colors.red,
        ),
        focusedErrorBorder: _fieldBorder(
          scale: scale,
          color: Colors.red,
        ),
        counterStyle: _textStyle(
          size: 12 * scale,
          color: _muted,
        ),
        errorStyle: _textStyle(
          size: 12 * scale,
          color: Colors.red,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Deskripsi laporan wajib diisi';
        }
        return null;
      },
    );
  }

  Widget _photoFrame({
    required Widget child,
    required double size,
    required double scale,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5 * scale),
        border: Border.all(color: _border),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _photos(double scale, double availableWidth) {
    final double gap = 26 * scale;
    final double photoSize = (availableWidth - gap) / 2;

    return Wrap(
      spacing: gap,
      runSpacing: 14 * scale,
      children: [
        // Foto hanya tampil setelah pengguna memilih dari galeri.
        for (final Uint8List bytes in _addedPhotos)
          _photoFrame(
            size: photoSize,
            scale: scale,
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
            ),
          ),

        // Saat form masih kosong, hanya kotak ini yang tampil.
        _photoFrame(
          size: photoSize,
          scale: scale,
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: _isPickingPhoto ? null : _addPhoto,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isPickingPhoto)
                    SizedBox(
                      width: 30 * scale,
                      height: 30 * scale,
                      child: const CircularProgressIndicator(
                        color: _darkGreen,
                        strokeWidth: 2,
                      ),
                    )
                  else
                    Icon(
                      Icons.add,
                      size: 58 * scale,
                      color: _muted,
                    ),
                  SizedBox(height: 12 * scale),
                  Text(
                    'Tambah Foto',
                    style: _textStyle(
                      size: 15 * scale,
                      color: _muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _continueButton(double scale) {
    return SizedBox(
      width: double.infinity,
      height: 49 * scale,
      child: ElevatedButton(
        onPressed: _continue,
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5 * scale),
          ),
        ),
        child: Text(
          'Lanjut',
          style: _textStyle(
            size: 23 * scale,
            color: Colors.white,
            weight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _content(double scale) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.only(
          top: 8 * scale,
          bottom: 10 * scale,
        ),
        children: [
          _header(scale),
          SizedBox(height: 2 * scale),
          _progress(scale),
          SizedBox(height: 32 * scale),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30 * scale,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('Isi detail laporan', scale),
                SizedBox(height: 7 * scale),
                Text(
                  'Tuliskan informasi yang jelas dan lengkap.',
                  style: _textStyle(
                    size: 15 * scale,
                    color: _muted,
                  ),
                ),
                SizedBox(height: 10 * scale),
                _label('Judul Laporan', scale),
                SizedBox(height: 7 * scale),
                _titleField(scale),
                SizedBox(height: 18 * scale),
                _label('Diskripsi Laporan', scale),
                SizedBox(height: 7 * scale),
                _descriptionField(scale),
                SizedBox(height: 26 * scale),
                _label('Tambah Foto', scale),
                SizedBox(height: 16 * scale),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return _photos(
                      scale,
                      constraints.maxWidth,
                    );
                  },
                ),
                SizedBox(height: 10 * scale),
                _continueButton(scale),
              ],
            ),
          ),
        ],
      ),
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
            padding: EdgeInsets.symmetric(
              vertical: 8 * scale,
            ),
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
                    weight:
                        selected ? FontWeight.w600 : FontWeight.w400,
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