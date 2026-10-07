import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  static const Color green = Color(0xFF08935B);
  static const Color ink = Color(0xFF12192B);
  static const Color muted = Color(0xFF7C8494);
  static const Color field = Color(0xFFEDF0F3);
  static const Color borderColor = Color(0xFFD9DDE4);
  static const Color mint = Color(0xFFD3F7E9);

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  TextStyle _textStyle({
    required double size,
    Color color = ink,
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

  void _backToLogin() {
    FocusScope.of(context).unfocus();

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _sendVerificationCode() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final phone = _phoneController.text.trim();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Simulasi kode verifikasi',
            style: _textStyle(
              size: 20,
              weight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Nomor tujuan: $phone\n\n'
            'Tampilan formulir sudah berfungsi. '
            'Pengiriman kode melalui SMS belum diaktifkan.',
            style: _textStyle(size: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Oke',
                style: _textStyle(
                  size: 14,
                  color: green,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPhoneIcon(double scale) {
    return Padding(
      padding: EdgeInsets.all(7 * scale),
      child: Container(
        width: 30 * scale,
        height: 30 * scale,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: mint,
          borderRadius: BorderRadius.circular(5 * scale),
          border: Border.all(
            color: const Color(0xFF97B8AC),
          ),
        ),
        child: Icon(
          Icons.phone,
          color: green,
          size: 22 * scale,
        ),
      ),
    );
  }

  InputDecoration _phoneDecoration(double scale) {
    OutlineInputBorder outline(
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

    return InputDecoration(
      hintText: 'Masukkan No.HP',
      hintStyle: _textStyle(
        size: 14 * scale,
        color: muted,
      ),
      filled: true,
      fillColor: field,
      isDense: true,
      prefixIcon: _buildPhoneIcon(scale),
      prefixIconConstraints: BoxConstraints(
        minWidth: 44 * scale,
        minHeight: 46 * scale,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12 * scale,
        vertical: 13 * scale,
      ),
      border: outline(borderColor),
      enabledBorder: outline(borderColor),
      focusedBorder: outline(green, width: 1.5),
      errorBorder: outline(Colors.red),
      focusedErrorBorder: outline(
        Colors.red,
        width: 1.5,
      ),
      errorStyle: _textStyle(
        size: 11 * scale,
        color: Colors.red,
      ),
      errorMaxLines: 2,
    );
  }

  Widget _buildContent(double scale) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo rumah dan daun.
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 180 * scale,
              height: 180 * scale,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(height: 8 * scale),

          // Nama aplikasi.
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Lapor ',
                  style: TextStyle(color: ink),
                ),
                const TextSpan(
                  text: 'Desa',
                  style: TextStyle(color: green),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: _textStyle(
              size: 40 * scale,
              weight: FontWeight.w800,
              height: 1.15,
            ),
          ),

          SizedBox(height: 28 * scale),

          Text(
            'Lupa password',
            style: _textStyle(
              size: 23 * scale,
              weight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 8 * scale),

          Text(
            'Masukkan nomor hp yang telah terdaftar '
            'pada akun Anda. Kami akan mengirimkan '
            'kode verifikasi untuk mengatur '
            'ulang password.',
            style: _textStyle(
              size: 14 * scale,
              color: muted,
              height: 1.3,
            ),
          ),

          SizedBox(height: 34 * scale),

          Text(
            'Nomor HP',
            style: _textStyle(
              size: 15 * scale,
              weight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 6 * scale),

          AutofillGroup(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              autofillHints: const [
                AutofillHints.telephoneNumber,
              ],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(13),
              ],
              style: _textStyle(size: 14 * scale),
              decoration: _phoneDecoration(scale),
              validator: (value) {
                final phone = (value ?? '').trim();

                if (!RegExp(r'^0[0-9]{9,12}$').hasMatch(phone)) {
                  return 'Isi nomor HP 10–13 digit, diawali 0';
                }

                return null;
              },
              onFieldSubmitted: (_) {
                _sendVerificationCode();
              },
            ),
          ),

          SizedBox(height: 18 * scale),

          SizedBox(
            height: 44 * scale,
            child: ElevatedButton(
              onPressed: _sendVerificationCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: 8 * scale,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4 * scale),
                ),
              ),
              child: Text(
                'Kirim Kode Verifikasi',
                textAlign: TextAlign.center,
                style: _textStyle(
                  size: 21 * scale,
                  color: Colors.white,
                  weight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
          ),

          SizedBox(height: 12 * scale),

          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4 * scale,
            children: [
              Text(
                'Ingat Password?',
                style: _textStyle(
                  size: 14 * scale,
                  color: muted,
                ),
              ),
              TextButton(
                onPressed: _backToLogin,
                style: TextButton.styleFrom(
                  foregroundColor: green,
                  padding: EdgeInsets.symmetric(
                    vertical: 4 * scale,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Kembali ke login',
                  style: _textStyle(
                    size: 14 * scale,
                    color: green,
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
            final pageWidth = constraints.maxWidth > 480
                ? 480.0
                : constraints.maxWidth;

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
                            40 * scale,
                            32 * scale,
                            40 * scale,
                            24 * scale,
                          ),
                          child: _buildContent(scale),
                        ),
                      ),
                    ),

                    // Gambar tampil utuh sesuai rasio aslinya.
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