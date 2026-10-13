import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/demo_account.dart';
import 'edit_profil_page.dart';
import 'ubah_password_page.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({super.key});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  static const Color _green = Color(0xFF08935B);
  static const Color _darkGreen = Color(0xFF007F58);
  static const Color _mint = Color(0xFFD3F7E9);
  static const Color _ink = Color(0xFF080808);
  static const Color _muted = Color(0xFF68717B);
  static const Color _neutral = Color(0xFF506788);
  static const Color _grey = Color(0xFFEDF0F3);
  static const Color _border = Color(0xFFD1D6DD);

  String? _selectedMenu;

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

    Future<void> _openEditProfile() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _selectedMenu = 'profile';
    });

    final bool? saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => EditProfilPage(
          onNavigationSelected: (index) {
            if (!mounted) return;

            // Mengembalikan pilihan tab ke halaman utama.
            Navigator.of(context).pop<int>(index);
          },
        ),
      ),
    );

    if (!mounted) return;

    setState(() {});

    if (saved == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui.'),
        ),
      );
    }
  }

    Future<void> _openPassword() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _selectedMenu = 'password';
    });

    final bool? saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => UbahPasswordPage(
          onNavigationSelected: (index) {
            if (!mounted) return;

            Navigator.of(context).pop<int>(index);
          },
        ),
      ),
    );

    if (!mounted) return;

    if (saved == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password berhasil diperbarui.'),
        ),
      );
    }
  }

  Widget _menu({
    required String title,
    required String id,
    required IconData icon,
    required VoidCallback onTap,
    required double scale,
  }) {
    final bool selected = _selectedMenu == id;
    final BorderRadius radius = BorderRadius.circular(9 * scale);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: selected ? _green : _grey,
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
              horizontal: 18 * scale,
              vertical: 11 * scale,
            ),
            child: Row(
              children: [
                Container(
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
                    size: 25 * scale,
                    color: _darkGreen,
                  ),
                ),
                SizedBox(width: 25 * scale),
                Expanded(
                  child: Text(
                    title,
                    style: _textStyle(
                      16 * scale,
                      color: selected ? Colors.white : _muted,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 21 * scale,
                  color: selected ? Colors.white : _ink,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(double scale) {
    final String name = DemoAccount.name.trim();
    final String rt = DemoAccount.rt.trim();

    final String region = rt.contains('RW')
        ? rt
        : '${rt.isEmpty ? 'RT 02' : rt} / RW 01';

    return ListView(
      padding: EdgeInsets.only(
        top: 12 * scale,
        bottom: 24 * scale,
      ),
      children: [
        SizedBox(
          height: 50 * scale,
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
                    size: 28 * scale,
                    color: _ink,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Akun',
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
        ),
        SizedBox(height: 7 * scale),
                Center(
          child: Container(
            width: 110 * scale,
            height: 110 * scale,
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: _mint,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF87919B),
              ),
            ),
            child: EditProfilPage.photoBytes == null
                ? Icon(
                    Icons.person,
                    size: 88 * scale,
                    color: _darkGreen,
                  )
                : Image.memory(
                    EditProfilPage.photoBytes!,
                    width: 110 * scale,
                    height: 110 * scale,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 88 * scale,
                        color: _darkGreen,
                      );
                    },
                  ),
          ),
        ),
        SizedBox(height: 16 * scale),
        Text(
          name.isEmpty ? 'Warga' : name,
          textAlign: TextAlign.center,
          style: _textStyle(
            21 * scale,
            weight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 2 * scale),
        Text(
          region,
          textAlign: TextAlign.center,
          style: _textStyle(
            16 * scale,
            color: _muted,
          ),
        ),
        SizedBox(height: 36 * scale),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24 * scale,
          ),
          child: Column(
            children: [
              _menu(
                title: 'Edit Profil',
                id: 'profile',
                icon: Icons.person,
                onTap: _openEditProfile,
                scale: scale,
              ),
              SizedBox(height: 38 * scale),
              _menu(
                title: 'Ubah Password',
                id: 'password',
                icon: Icons.lock,
                onTap: _openPassword,
                scale: scale,
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
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop<int>(index);
        },
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