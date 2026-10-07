import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/demo_account.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const Color green = Color(0xFF08935B);
  static const Color ink = Color(0xFF12192B);
  static const Color muted = Color(0xFF7C8494);
  static const Color field = Color(0xFFEDF0F3);
  static const Color borderColor = Color(0xFFD9DDE4);
  static const Color mint = Color(0xFFD3F7E9);

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _addressController = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  String? _selectedRt;

  // Pilihan RT hanya dua.
  static const List<String> _rtOptions = [
    'RT 01',
    'RT 02',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  TextStyle _textStyle({
    double size = 15,
    Color color = ink,
    FontWeight weight = FontWeight.w400,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      color: color,
      fontWeight: weight,
    );
  }

  String? _requiredValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bagian ini wajib diisi';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    final phone = (value ?? '').trim();

    if (!RegExp(r'^0[0-9]{9,12}$').hasMatch(phone)) {
      return 'Isi nomor HP 10–13 digit, diawali 0';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password wajib diisi';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  String? _validateConfirmation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }

    if (value != _passwordController.text) {
      return 'Password tidak sama';
    }

    return null;
  }

  void _backToLogin() {
    FocusScope.of(context).unfocus();

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _register() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    DemoAccount.register(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      address: _addressController.text.trim(),
      rt: _selectedRt!,
    );

    final messenger = ScaffoldMessenger.of(context);

    _backToLogin();

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: green,
          content: Text(
            'Registrasi berhasil! Silakan login '
            'dengan akun yang baru dibuat.',
            style: _textStyle(
              size: 13,
              color: Colors.white,
            ),
          ),
        ),
      );
  }

  Widget _fieldIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: mint,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0xFF97B8AC),
          ),
        ),
        child: Icon(
          icon,
          size: 22,
          color: green,
        ),
      ),
    );
  }

  InputDecoration _decoration({
    required String hint,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    OutlineInputBorder outline(
      Color color, {
      double width = 1,
    }) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: color,
          width: width,
        ),
      );
    }

    return InputDecoration(
      filled: true,
      fillColor: field,
      isDense: true,
      hintText: hint,
      hintStyle: _textStyle(
        size: 15,
        color: muted,
      ),
      prefixIcon: icon == null ? null : _fieldIcon(icon),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 46,
        minHeight: 48,
      ),
      suffixIcon: suffixIcon,
      suffixIconConstraints: const BoxConstraints(
        minWidth: 44,
        minHeight: 48,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: outline(borderColor),
      enabledBorder: outline(borderColor),
      focusedBorder: outline(green, width: 1.5),
      errorBorder: outline(const Color(0xFFD32F2F)),
      focusedErrorBorder: outline(
        const Color(0xFFD32F2F),
        width: 1.5,
      ),
      errorStyle: _textStyle(
        size: 11,
        color: const Color(0xFFD32F2F),
      ),
      errorMaxLines: 2,
    );
  }

  Widget _passwordToggle({
    required bool hidden,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      tooltip: hidden
          ? 'Tampilkan password'
          : 'Sembunyikan password',
      onPressed: onPressed,
      icon: Icon(
        hidden
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        size: 19,
        color: const Color(0xFF657695),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Registrasi',
            style: _textStyle(
              size: 30,
              weight: FontWeight.w800,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: 'Kembali ke Login',
              onPressed: _backToLogin,
              icon: const Icon(
                Icons.chevron_left,
                color: ink,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRtDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedRt,
      isExpanded: true,
      dropdownColor: field,
      borderRadius: BorderRadius.circular(6),
      elevation: 2,
      itemHeight: 56,
      style: _textStyle(),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.black,
        size: 22,
      ),
      decoration: _decoration(
        hint: 'Pilih RT',
        icon: Icons.groups,
      ),
      hint: Text(
        'Pilih RT',
        style: _textStyle(color: muted),
      ),

      // Teks yang tampil di kolom setelah RT dipilih.
      selectedItemBuilder: (context) {
        return _rtOptions.map((rt) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              rt,
              style: _textStyle(size: 15),
            ),
          );
        }).toList();
      },

      // Dua pilihan pada menu dropdown.
      items: _rtOptions.map((rt) {
        final isSelected = _selectedRt == rt;

        return DropdownMenuItem<String>(
          value: rt,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(vertical: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? green : Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isSelected ? green : borderColor,
              ),
            ),
            child: Text(
              rt,
              style: _textStyle(
                size: 22,
                color: isSelected ? Colors.white : muted,
                weight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),

      onChanged: (value) {
        setState(() {
          _selectedRt = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Pilih RT kamu';
        }

        return null;
      },
    );
  }

  Widget _buildAddress() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
      decoration: BoxDecoration(
        color: field,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _fieldIcon(Icons.location_on),
              Text(
                'Alamat',
                style: _textStyle(
                  size: 15,
                  color: muted,
                ),
              ),
            ],
          ),

          TextFormField(
            controller: _addressController,
            validator: _requiredValue,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [
              AutofillHints.fullStreetAddress,
            ],
            minLines: 1,
            maxLines: 3,
            style: _textStyle(),
            decoration: _decoration(
              hint: 'Masukkan alamat lengkap',
            ),
          ),

          const SizedBox(height: 12),

          _buildRtDropdown(),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: green,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(
          'Daftar',
          style: _textStyle(
            size: 23,
            color: Colors.white,
            weight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(color: borderColor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              child: Text(
                'atau',
                style: _textStyle(
                  size: 14,
                  color: muted,
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: borderColor),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            Text(
              'Sudah punya akun?',
              style: _textStyle(
                size: 14,
                color: muted,
              ),
            ),
            TextButton(
              onPressed: _backToLogin,
              style: TextButton.styleFrom(
                foregroundColor: green,
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Login sekarang',
                style: _textStyle(
                  size: 14,
                  color: green,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),

          const SizedBox(height: 25),

          // Nama lengkap.
          TextFormField(
            controller: _nameController,
            validator: _requiredValue,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
            style: _textStyle(),
            decoration: _decoration(
              hint: 'Nama Lengkap',
              icon: Icons.person,
            ),
          ),

          const SizedBox(height: 12),

          // Nomor HP.
          TextFormField(
            controller: _phoneController,
            validator: _validatePhone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            autofillHints: const [
              AutofillHints.telephoneNumber,
            ],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(13),
            ],
            style: _textStyle(),
            decoration: _decoration(
              hint: 'Nomor HP',
              icon: Icons.phone,
            ),
          ),

          const SizedBox(height: 12),

          // Password.
          TextFormField(
            controller: _passwordController,
            validator: _validatePassword,
            obscureText: _hidePassword,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            autofillHints: const [
              AutofillHints.newPassword,
            ],
            style: _textStyle(),
            decoration: _decoration(
              hint: 'Password',
              icon: Icons.lock,
              suffixIcon: _passwordToggle(
                hidden: _hidePassword,
                onPressed: () {
                  setState(() {
                    _hidePassword = !_hidePassword;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Konfirmasi password.
          // Teks tetap "Password" mengikuti gambar referensi.
          TextFormField(
            controller: _confirmController,
            validator: _validateConfirmation,
            obscureText: _hideConfirmPassword,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            style: _textStyle(),
            decoration: _decoration(
              hint: 'Password',
              icon: Icons.lock,
              suffixIcon: _passwordToggle(
                hidden: _hideConfirmPassword,
                onPressed: () {
                  setState(() {
                    _hideConfirmPassword = !_hideConfirmPassword;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          _buildAddress(),

          const SizedBox(height: 36),

          _buildRegisterButton(),

          const SizedBox(height: 14),

          _buildLoginLink(),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 18,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 400,
                          ),
                          child: AutofillGroup(
                            child: _buildForm(),
                          ),
                        ),
                      ),
                    ),

                    // Tinggi mengikuti proporsi asli gambar.
                    Image.asset(
                      'assets/images/village.png',
                      width: constraints.maxWidth,
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
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