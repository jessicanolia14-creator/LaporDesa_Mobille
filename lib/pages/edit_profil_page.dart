import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../models/demo_account.dart';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({
    super.key,
    this.onNavigationSelected,
  });

  final ValueChanged<int>? onNavigationSelected;

  // Penyimpanan sementara untuk frontend demonstrasi.
  // Data ini akan kembali ke awal jika aplikasi dimulai ulang.
  static Uint8List? photoBytes;
  static String profileAddress = 'Jl. Melati, RT 02/RW 01';

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  static const Color _green = Color(0xFF08935B);
  static const Color _darkGreen = Color(0xFF007F58);
  static const Color _mint = Color(0xFFD3F7E9);
  static const Color _ink = Color(0xFF080808);
  static const Color _muted = Color(0xFF68717B);
  static const Color _neutral = Color(0xFF506788);
  static const Color _grey = Color(0xFFEDF0F3);
  static const Color _lightGrey = Color(0xFFF2F3F8);
  static const Color _border = Color(0xFFD1D6DD);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  Uint8List? _photo;
  String? _selectedRt;
  bool _rtExpanded = false;
  bool _pickingPhoto = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: DemoAccount.name,
    );

    _phoneController = TextEditingController(
      text: DemoAccount.phone,
    );

    _addressController = TextEditingController(
      text: EditProfilPage.profileAddress,
    );

    _photo = EditProfilPage.photoBytes;

    final String currentRt = DemoAccount.rt.trim();

    final RegExpMatch? match = RegExp(
      r'RT\s*0?([12])\b',
      caseSensitive: false,
    ).firstMatch(currentRt);

    if (match != null) {
      _selectedRt = match.group(1) == '1' ? 'RT 01' : 'RT 02';
    } else if (currentRt == '01' || currentRt == '1') {
      _selectedRt = 'RT 01';
    } else if (currentRt == '02' || currentRt == '2') {
      _selectedRt = 'RT 02';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  TextStyle _textStyle(
    double size, {
    Color color = _ink,
    FontWeight weight = FontWeight.w400,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: 1.3,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _isSupportedPhoto(Uint8List bytes) {
    final bool isJpg = bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF;

    final bool isPng = bytes.length >= 8 &&
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

  Future<void> _pickPhoto() async {
    if (_pickingPhoto) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _pickingPhoto = true;
    });

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) return;

      final Uint8List bytes = await image.readAsBytes();

      if (!mounted) return;

      if (!_isSupportedPhoto(bytes)) {
        _showMessage('Gunakan foto berformat JPG atau PNG.');
        return;
      }

      if (bytes.length > 2 * 1024 * 1024) {
        _showMessage('Ukuran foto maksimal 2MB.');
        return;
      }

      setState(() {
        _photo = bytes;
      });
    } catch (_) {
      if (mounted) {
        _showMessage('Foto belum bisa dibuka. Silakan coba lagi.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _pickingPhoto = false;
        });
      }
    }
  }

  void _saveProfile() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    DemoAccount.name = _nameController.text.trim();
    DemoAccount.phone = _phoneController.text.trim();
    DemoAccount.rt = _selectedRt!;

    EditProfilPage.profileAddress = _addressController.text.trim();
    EditProfilPage.photoBytes = _photo;

    Navigator.of(context).pop<bool>(true);
  }

  void _navigate(int index) {
    FocusScope.of(context).unfocus();

    final ValueChanged<int>? callback = widget.onNavigationSelected;

    // Halaman Edit Profil dibuka dengan hasil bertipe bool.
    Navigator.of(context).pop<bool>(false);

    callback?.call(index);
  }

  Widget _iconBox(IconData icon, double scale) {
    return Container(
      width: 35 * scale,
      height: 35 * scale,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _mint,
        borderRadius: BorderRadius.circular(5 * scale),
        border: Border.all(
          color: const Color(0xFFC4E0D5),
        ),
      ),
      child: Icon(
        icon,
        size: 26 * scale,
        color: _darkGreen,
      ),
    );
  }

  OutlineInputBorder _inputBorder(
    double scale,
    Color color, {
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

  InputDecoration _inputDecoration({
    required double scale,
    required String hint,
    IconData? icon,
    Color fillColor = _grey,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: _textStyle(
        14 * scale,
        color: _muted,
      ),
      filled: true,
      fillColor: fillColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 14 * scale,
        vertical: 14 * scale,
      ),
      prefixIcon: icon == null
          ? null
          : Padding(
              padding: EdgeInsets.all(7 * scale),
              child: _iconBox(icon, scale),
            ),
      prefixIconConstraints: BoxConstraints(
        minWidth: 49 * scale,
        minHeight: 49 * scale,
      ),
      border: _inputBorder(scale, _border),
      enabledBorder: _inputBorder(scale, _border),
      focusedBorder: _inputBorder(
        scale,
        _green,
        width: 1.5,
      ),
      errorBorder: _inputBorder(scale, Colors.red),
      focusedErrorBorder: _inputBorder(scale, Colors.red),
      errorStyle: _textStyle(
        11 * scale,
        color: Colors.red,
      ),
      errorMaxLines: 2,
    );
  }

  Widget _header(double scale) {
    return SizedBox(
      height: 52 * scale,
      child: Row(
        children: [
          SizedBox(
            width: 48 * scale,
            child: IconButton(
              tooltip: 'Kembali',
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.chevron_left_rounded,
                size: 29 * scale,
                color: _ink,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Edit Profil',
              textAlign: TextAlign.center,
              style: _textStyle(
                21 * scale,
                weight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 48 * scale),
        ],
      ),
    );
  }

  Widget _avatar(double scale) {
    return Center(
      child: SizedBox(
        width: 114 * scale,
        height: 114 * scale,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: _mint,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF87919B),
                  ),
                ),
                child: _photo == null
                    ? Icon(
                        Icons.person,
                        size: 94 * scale,
                        color: _darkGreen,
                      )
                    : Image.memory(
                        _photo!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 94 * scale,
                            color: _darkGreen,
                          );
                        },
                      ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Material(
                color: _green,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _pickingPhoto ? null : _pickPhoto,
                  child: SizedBox(
                    width: 43 * scale,
                    height: 43 * scale,
                    child: _pickingPhoto
                        ? Padding(
                            padding: EdgeInsets.all(12 * scale),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 27 * scale,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text, double scale) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6 * scale),
      child: Text(
        text,
        style: _textStyle(
          16 * scale,
          weight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _rtOption(String value, double scale) {
    final bool selected = _selectedRt == value;

    return Material(
      color: selected ? _green : Colors.white,
      borderRadius: BorderRadius.circular(3 * scale),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedRt = value;
            _rtExpanded = false;
          });
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 7 * scale),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3 * scale),
            border: Border.all(
              color: selected ? _green : _border,
            ),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: _textStyle(
              17 * scale,
              color: selected ? Colors.white : _muted,
              weight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _addressSection(double scale) {
    return Container(
      padding: EdgeInsets.all(9 * scale),
      decoration: BoxDecoration(
        color: _grey,
        borderRadius: BorderRadius.circular(5 * scale),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBox(Icons.location_on, scale),
              SizedBox(width: 15 * scale),
              Text(
                'Alamat',
                style: _textStyle(
                  15 * scale,
                  color: _muted,
                ),
              ),
            ],
          ),
          SizedBox(height: 7 * scale),
          TextFormField(
            controller: _addressController,
            style: _textStyle(
              14 * scale,
              color: _muted,
            ),
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.done,
            minLines: 1,
            maxLines: 3,
            decoration: _inputDecoration(
              scale: scale,
              hint: 'Masukkan alamat',
              fillColor: _lightGrey,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Alamat wajib diisi';
              }
              return null;
            },
          ),
          SizedBox(height: 13 * scale),
          FormField<String>(
            initialValue: _selectedRt,
            validator: (_) {
              if (_selectedRt == null) {
                return 'Pilih RT terlebih dahulu';
              }
              return null;
            },
            builder: (field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    color: _lightGrey,
                    borderRadius: BorderRadius.circular(4 * scale),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();

                        setState(() {
                          _rtExpanded = !_rtExpanded;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(6 * scale),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4 * scale),
                          border: Border.all(
                            color: field.hasError ? Colors.red : _border,
                          ),
                        ),
                        child: Row(
                          children: [
                            _iconBox(Icons.groups, scale),
                            SizedBox(width: 12 * scale),
                            Expanded(
                              child: Text(
                                _selectedRt ?? 'Pilih RT',
                                style: _textStyle(
                                  15 * scale,
                                  color: _muted,
                                ),
                              ),
                            ),
                            Icon(
                              _rtExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: _ink,
                              size: 22 * scale,
                            ),
                            SizedBox(width: 5 * scale),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_rtExpanded)
                    Container(
                      margin: EdgeInsets.only(top: 5 * scale),
                      padding: EdgeInsets.all(9 * scale),
                      decoration: BoxDecoration(
                        color: _lightGrey,
                        borderRadius: BorderRadius.circular(4 * scale),
                        border: Border.all(color: _border),
                      ),
                      child: Column(
                        children: [
                          _rtOption('RT 01', scale),
                          SizedBox(height: 9 * scale),
                          _rtOption('RT 02', scale),
                        ],
                      ),
                    ),
                  if (field.hasError)
                    Padding(
                      padding: EdgeInsets.only(
                        top: 6 * scale,
                        left: 8 * scale,
                      ),
                      child: Text(
                        field.errorText!,
                        style: _textStyle(
                          11 * scale,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _content(double scale) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.only(
          top: 8 * scale,
          bottom: 24 * scale,
        ),
        children: [
          _header(scale),
          SizedBox(height: 7 * scale),
          _avatar(scale),
          SizedBox(height: 29 * scale),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 47 * scale),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 6 * scale,
                vertical: 6 * scale,
              ),
              decoration: BoxDecoration(
                color: _grey,
                borderRadius: BorderRadius.circular(4 * scale),
                border: Border.all(color: _border),
              ),
              child: Text(
                'Format Foto: JPG, PNG, (maks, 2MB)',
                textAlign: TextAlign.center,
                style: _textStyle(
                  11 * scale,
                  color: _muted,
                ),
              ),
            ),
          ),
          SizedBox(height: 9 * scale),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 44 * scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('Nama Lengkap', scale),
                TextFormField(
                  controller: _nameController,
                  style: _textStyle(
                    14 * scale,
                    color: _muted,
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    scale: scale,
                    icon: Icons.person,
                    hint: 'Masukkan nama lengkap',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama lengkap wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15 * scale),
                _label('Nomor HP', scale),
                TextFormField(
                  controller: _phoneController,
                  style: _textStyle(
                    15 * scale,
                    color: _muted,
                  ),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    scale: scale,
                    icon: Icons.phone,
                    hint: 'Masukkan nomor HP',
                  ),
                  validator: (value) {
                    final String phone = (value ?? '').trim();

                    if (!RegExp(r'^0\d{9,12}$').hasMatch(phone)) {
                      return 'Isi nomor HP 10–13 digit, diawali 0';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 22 * scale),
                _addressSection(scale),
              ],
            ),
          ),
          SizedBox(height: 33 * scale),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 37 * scale),
            child: SizedBox(
              height: 51 * scale,
              child: ElevatedButton(
                onPressed: _pickingPhoto ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _grey,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 8 * scale),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5 * scale),
                  ),
                ),
                child: Text(
                  'Simpan Perubahan',
                  textAlign: TextAlign.center,
                  style: _textStyle(
                    22 * scale,
                    color: Colors.white,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
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
    return Expanded(
      child: InkWell(
        onTap: () => _navigate(index),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8 * scale),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 34 * scale,
                color: _neutral,
              ),
              SizedBox(height: 4 * scale),
              Text(
                label,
                style: _textStyle(13 * scale),
              ),
            ],
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
    final double width = screenWidth > 480 ? 480.0 : screenWidth;
    final double scale = width / 390;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: SizedBox(
            width: width,
            child: _content(scale),
          ),
        ),
      ),
      bottomNavigationBar: Center(
        heightFactor: 1,
        child: SizedBox(
          width: width,
          child: _bottomNavigation(scale),
        ),
      ),
    );
  }
}