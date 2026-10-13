import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/demo_account.dart';

class UbahPasswordPage extends StatefulWidget {
  const UbahPasswordPage({
    super.key,
    this.onNavigationSelected,
  });

  final ValueChanged<int>? onNavigationSelected;

  @override
  State<UbahPasswordPage> createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends State<UbahPasswordPage> {
  static const Color _green = Color(0xFF08935B);
  static const Color _darkGreen = Color(0xFF007F58);
  static const Color _mint = Color(0xFFD3F7E9);
  static const Color _ink = Color(0xFF080808);
  static const Color _muted = Color(0xFF68717B);
  static const Color _neutral = Color(0xFF506788);
  static const Color _grey = Color(0xFFEDF0F3);
  static const Color _border = Color(0xFFD1D6DD);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _currentController =
      TextEditingController();

  final TextEditingController _newController =
      TextEditingController();

  final TextEditingController _confirmController =
      TextEditingController();

  bool _hideCurrent = true;
  bool _hideNew = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  TextStyle _textStyle(
    double size, {
    Color color = _ink,
    FontWeight weight = FontWeight.w400,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: 1.3,
    );
  }

  bool _hasEightCharacters(String password) {
    return password.runes.length >= 8;
  }

  bool _hasUpperAndLowerCase(String password) {
    return RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password);
  }

  bool _hasNumber(String password) {
    return RegExp(r'[0-9]').hasMatch(password);
  }

  bool _hasSymbol(String password) {
    return RegExp(r'[^a-zA-Z0-9\s]').hasMatch(password);
  }

  void _savePassword() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Memperbarui password akun simulasi yang dipakai saat login.
    DemoAccount.password = _newController.text;

    Navigator.of(context).pop<bool>(true);
  }

  void _navigate(int index) {
    FocusScope.of(context).unfocus();

    final ValueChanged<int>? callback = widget.onNavigationSelected;

    Navigator.of(context).pop<bool>(false);

    callback?.call(index);
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
              'Ubah Password',
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

  Widget _lockIllustration(double scale) {
    return Center(
      child: Container(
        width: 110 * scale,
        height: 110 * scale,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _mint,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF87919B),
          ),
        ),
        child: Icon(
          Icons.lock_rounded,
          size: 76 * scale,
          color: _darkGreen,
        ),
      ),
    );
  }

  Widget _lockBox(double scale) {
    return Container(
      width: 35 * scale,
      height: 35 * scale,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _mint,
        borderRadius: BorderRadius.circular(5 * scale),
        border: Border.all(
          color: const Color(0xFF9CABAA),
        ),
      ),
      child: Icon(
        Icons.lock_rounded,
        size: 24 * scale,
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

  Widget _passwordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    required FormFieldValidator<String> validator,
    required double scale,
    bool isLast = false,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _textStyle(
            16 * scale,
            weight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 7 * scale),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.visiblePassword,
          textInputAction:
              isLast ? TextInputAction.done : TextInputAction.next,
          style: _textStyle(
            14 * scale,
            color: _ink,
          ),
          onChanged: onChanged,
          onFieldSubmitted: isLast
              ? (_) {
                  _savePassword();
                }
              : null,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: _textStyle(
              12 * scale,
              color: _muted,
            ),
            filled: true,
            fillColor: _grey,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12 * scale,
              vertical: 14 * scale,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(7 * scale),
              child: _lockBox(scale),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 49 * scale,
              minHeight: 49 * scale,
            ),
            suffixIcon: IconButton(
              tooltip: obscureText
                  ? 'Tampilkan password'
                  : 'Sembunyikan password',
              onPressed: onToggle,
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 22 * scale,
                color: _neutral,
              ),
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
            errorMaxLines: 3,
          ),
        ),
      ],
    );
  }

  Widget _requirement({
    required String text,
    required bool fulfilled,
    required double scale,
  }) {
    final bool hasInput = _newController.text.isNotEmpty;

    // Sebelum mengetik, tampilkan ikon hijau seperti desain.
    // Setelah mengetik, ikon mengikuti syarat yang terpenuhi.
    final Color iconColor =
        !hasInput || fulfilled ? _green : _muted;

    return Padding(
      padding: EdgeInsets.only(top: 5 * scale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1 * scale),
            child: Icon(
              !hasInput || fulfilled
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 15 * scale,
              color: iconColor,
            ),
          ),
          SizedBox(width: 10 * scale),
          Expanded(
            child: Text(
              text,
              style: _textStyle(
                13 * scale,
                color: hasInput && fulfilled ? _darkGreen : _muted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordRequirements(double scale) {
    final String password = _newController.text;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        10 * scale,
        9 * scale,
        10 * scale,
        11 * scale,
      ),
      decoration: BoxDecoration(
        color: _mint,
        borderRadius: BorderRadius.circular(6 * scale),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password harus mengandung:',
            style: _textStyle(14 * scale),
          ),
          _requirement(
            text: 'Minimal 8 Karakter',
            fulfilled: _hasEightCharacters(password),
            scale: scale,
          ),
          _requirement(
            text: 'Huruf besar dan huruf kecil',
            fulfilled: _hasUpperAndLowerCase(password),
            scale: scale,
          ),
          _requirement(
            text: 'Minimal 1 angka',
            fulfilled: _hasNumber(password),
            scale: scale,
          ),
          _requirement(
            text: 'Minimal 1 simbol (contoh: !@#)',
            fulfilled: _hasSymbol(password),
            scale: scale,
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
          _lockIllustration(scale),
          SizedBox(height: 13 * scale),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30 * scale),
            child: Text(
              'Pastikan password baru Anda\n'
              'kuat dan mudah diingat',
              textAlign: TextAlign.center,
              style: _textStyle(
                13 * scale,
                color: _muted,
              ),
            ),
          ),
          SizedBox(height: 20 * scale),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25 * scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _passwordField(
                  label: 'Password Saat Ini',
                  hint: 'Masukkan Password saat ini',
                  controller: _currentController,
                  obscureText: _hideCurrent,
                  scale: scale,
                  onToggle: () {
                    setState(() {
                      _hideCurrent = !_hideCurrent;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password saat ini wajib diisi';
                    }

                    if (value != DemoAccount.password) {
                      return 'Password saat ini tidak sesuai';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 13 * scale),
                _passwordField(
                  label: 'Password Baru',
                  hint: 'Masukkan Password baru',
                  controller: _newController,
                  obscureText: _hideNew,
                  scale: scale,
                  onToggle: () {
                    setState(() {
                      _hideNew = !_hideNew;
                    });
                  },
                  onChanged: (_) {
                    setState(() {});
                  },
                  validator: (value) {
                    final String password = value ?? '';

                    if (password.isEmpty) {
                      return 'Password baru wajib diisi';
                    }

                    if (!_hasEightCharacters(password) ||
                        !_hasUpperAndLowerCase(password) ||
                        !_hasNumber(password) ||
                        !_hasSymbol(password)) {
                      return 'Password baru belum memenuhi semua syarat';
                    }

                    if (password == DemoAccount.password) {
                      return 'Password baru harus berbeda dari password saat ini';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 11 * scale),
                _passwordRequirements(scale),
                SizedBox(height: 20 * scale),
                _passwordField(
                  label: 'Konfirmasi Password Baru',
                  hint: 'Masukkan ulang Password baru',
                  controller: _confirmController,
                  obscureText: _hideConfirm,
                  scale: scale,
                  isLast: true,
                  onToggle: () {
                    setState(() {
                      _hideConfirm = !_hideConfirm;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi password wajib diisi';
                    }

                    if (value != _newController.text) {
                      return 'Konfirmasi password tidak sama';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 46 * scale),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 37 * scale),
            child: SizedBox(
              height: 51 * scale,
              child: ElevatedButton(
                onPressed: _savePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8 * scale,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5 * scale),
                  ),
                ),
                child: Text(
                  'Simpan Password',
                  style: _textStyle(
                    23 * scale,
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