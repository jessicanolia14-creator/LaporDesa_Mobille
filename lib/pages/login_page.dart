import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/demo_account.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    this.authenticate,
  });

  final bool Function(String phone, String password)? authenticate;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color _green = Color(0xFF08935B);
  static const Color _ink = Color(0xFF12192B);
  static const Color _muted = Color(0xFF7C8494);
  static const Color _field = Color(0xFFEDF0F3);
  static const Color _border = Color(0xFFD9DDE4);
  static const Color _mint = Color(0xFFD3F7E9);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _hidePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
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

  void _showMessage(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            title,
            style: _textStyle(
              size: 20,
              weight: FontWeight.w600,
            ),
          ),
          content: Text(
            message,
            style: _textStyle(size: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Oke',
                style: _textStyle(
                  size: 14,
                  color: _green,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _login() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    final authenticate =
        widget.authenticate ?? DemoAccount.authenticate;

    final isValid = authenticate(phone, password);

    if (isValid) {
      Navigator.of(context).pushNamedAndRemoveUntil(
  '/home',
  (route) => false,
);
    } else {
      _showMessage(
        'Login gagal',
        'Nomor HP atau password salah.',
      );
    }
  }

  Widget _inputIcon(IconData icon, double scale) {
    return Padding(
      padding: EdgeInsets.all(8 * scale),
      child: Container(
        width: 30 * scale,
        height: 30 * scale,
        decoration: BoxDecoration(
          color: _mint,
          borderRadius: BorderRadius.circular(5 * scale),
          border: Border.all(
            color: const Color(0xFF97B8AC),
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 21 * scale,
          color: _green,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required double scale,
    Widget? suffixIcon,
  }) {
    final radius = BorderRadius.circular(5 * scale);

    return InputDecoration(
      hintText: hint,
      hintStyle: _textStyle(
        size: 13 * scale,
        color: _muted,
      ),
      filled: true,
      fillColor: _field,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12 * scale,
        vertical: 15 * scale,
      ),
      prefixIcon: _inputIcon(icon, scale),
      prefixIconConstraints: BoxConstraints(
        minWidth: 46 * scale,
        minHeight: 48 * scale,
      ),
      suffixIcon: suffixIcon,
      suffixIconConstraints: BoxConstraints(
        minWidth: 44 * scale,
        minHeight: 48 * scale,
      ),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(
          color: _green,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
      errorStyle: _textStyle(
        size: 11 * scale,
        color: Colors.red,
      ),
      errorMaxLines: 2,
    );
  }

  Widget _buildHeader(double scale) {
    return Column(
      children: [
        Text(
          'Login',
          textAlign: TextAlign.center,
          style: _textStyle(
            size: 40 * scale,
            weight: FontWeight.w800,
            height: 1.2,
          ),
        ),

        SizedBox(height: 16 * scale),

        // Logo ditampilkan utuh sesuai proporsinya.
        Image.asset(
          'assets/images/logo.png',
          width: 180 * scale,
          height: 174 * scale,
          fit: BoxFit.contain,
        ),

        SizedBox(height: 6 * scale),

        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Lapor',
                style: TextStyle(color: _ink),
              ),
              const TextSpan(
                text: 'Desa',
                style: TextStyle(color: _green),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: _textStyle(
            size: 44 * scale,
            weight: FontWeight.w800,
            height: 1.15,
          ),
        ),

        SizedBox(height: 12 * scale),

        Text(
          'Laporkan masalah di sekitar Anda,\n'
          'untuk lingkungan yang lebih baik',
          textAlign: TextAlign.left,
          style: _textStyle(
            size: 17 * scale,
            color: _muted,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(double scale) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form sedikit lebih sempit daripada tombol.
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 7 * scale,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Nomor HP',
                  style: _textStyle(
                    size: 15 * scale,
                    weight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 5 * scale),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [
                    AutofillHints.telephoneNumber,
                  ],
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(13),
                  ],
                  style: _textStyle(size: 14 * scale),
                  decoration: _inputDecoration(
                    hint: 'Contoh: 081234567890',
                    icon: Icons.phone_outlined,
                    scale: scale,
                  ),
                  validator: (value) {
                    final phone = (value ?? '').trim();

                    if (!RegExp(r'^0[0-9]{9,12}$').hasMatch(phone)) {
                      return 'Isi nomor HP 10–13 digit, diawali 0';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 14 * scale),

                Text(
                  'Password',
                  style: _textStyle(
                    size: 15 * scale,
                    weight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 5 * scale),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [
                    AutofillHints.password,
                  ],
                  style: _textStyle(size: 14 * scale),
                  decoration: _inputDecoration(
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    scale: scale,
                    suffixIcon: IconButton(
                      tooltip: _hidePassword
                          ? 'Tampilkan password'
                          : 'Sembunyikan password',
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                      icon: Icon(
                        _hidePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20 * scale,
                        color: _muted,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Bagian ini wajib diisi';
                    }

                    return null;
                  },
                  onFieldSubmitted: (_) => _login(),
                ),

                SizedBox(height: 8 * scale),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
  FocusScope.of(context).unfocus();

  Navigator.of(context).pushNamed('/forgot-password');
},
                    style: TextButton.styleFrom(
                      foregroundColor: _green,
                      padding: EdgeInsets.symmetric(
                        vertical: 4 * scale,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Lupa password?',
                      style: _textStyle(
                        size: 13 * scale,
                        color: _green,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 30 * scale),

          SizedBox(
            height: 46 * scale,
            child: ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4 * scale),
                ),
              ),
              child: Text(
                'Login',
                style: _textStyle(
                  size: 23 * scale,
                  color: Colors.white,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 20 * scale),

          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4 * scale,
            children: [
              Text(
                'Belum punya akun?',
                style: _textStyle(
                  size: 14 * scale,
                  color: _muted,
                ),
              ),
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  Navigator.of(context).pushNamed('/register');
                },
                style: TextButton.styleFrom(
                  foregroundColor: _green,
                  padding: EdgeInsets.symmetric(
                    vertical: 4 * scale,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Daftar sekarang',
                  style: _textStyle(
                    size: 14 * scale,
                    color: _green,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Ukuran acuan desain: lebar 390.
            // Batas lebar menjaga tampilan tetap rapi di layar besar.
            final pageWidth = math.min(
              constraints.maxWidth,
              480.0,
            );

            final scale = pageWidth / 390.0;

            return SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: SizedBox(
                        width: pageWidth,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            50 * scale,
                            24 * scale,
                            50 * scale,
                            24 * scale,
                          ),
                          child: AutofillGroup(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              children: [
                                _buildHeader(scale),

                                SizedBox(height: 20 * scale),

                                _buildForm(scale),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Tidak diberi tinggi tetap:
                    // Flutter mengikuti rasio asli gambar.
                    Center(
                      child: Image.asset(
                        'assets/images/village.png',
                        width: pageWidth,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}