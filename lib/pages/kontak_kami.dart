import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class KontakKamiPage extends StatelessWidget {
  const KontakKamiPage({super.key});

  static const Color _green = Color(0xFF08935B);
  static const Color _darkGreen = Color(0xFF00865B);
  static const Color _mint = Color(0xFFD3F7E9);
  static const Color _ink = Color(0xFF121212);
  static const Color _muted = Color(0xFF68717B);
  static const Color _neutral = Color(0xFF506788);
  static const Color _cardGrey = Color(0xFFEDF0F3);
  static const Color _border = Color(0xFFD1D6DD);

  // Data kontak Ketua RT sesuai Figma.
  static const String _phone = '08123456';
  static const String _whatsAppNumber = '628123456';
  static const String _email = 'joko@gmail.com';

  static const String _address =
      'Jl. Melati, RT 01, RW 01\n'
      'Sukoharjo 1\n'
      'Kecamatan Sukoharjo\n'
      'Kabupaten Pringsewu\n'
      'Lampung';

  static const String _mapsAddress =
      'Jl. Melati, RT 01, RW 01, Sukoharjo 1, '
      'Kecamatan Sukoharjo, Kabupaten Pringsewu, Lampung';

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

  Future<void> _openLink(
    BuildContext context,
    Uri uri,
  ) async {
    try {
      final bool opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!context.mounted) return;

      if (!opened) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aplikasi tujuan belum bisa dibuka.'),
          ),
        );
      }
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tautan belum bisa dibuka. Coba lagi.'),
        ),
      );
    }
  }

  Widget _header(BuildContext context, double scale) {
    return SizedBox(
      height: 66 * scale,
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

  Widget _heading(double scale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16 * scale,
        vertical: 17 * scale,
      ),
      decoration: BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.circular(12 * scale),
      ),
      child: Row(
        children: [
          Icon(
            Icons.support_agent_rounded,
            size: 27 * scale,
            color: Colors.white,
          ),
          SizedBox(width: 12 * scale),
          Text(
            'Kontak Kami',
            style: _textStyle(
              size: 19 * scale,
              color: Colors.white,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactCard({
    required String title,
    required String detail,
    required IconData icon,
    required VoidCallback onTap,
    required double scale,
  }) {
    final BorderRadius radius = BorderRadius.circular(13 * scale);

    return Material(
      color: _cardGrey,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: _border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(15 * scale),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46 * scale,
                height: 46 * scale,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _mint,
                  borderRadius: BorderRadius.circular(10 * scale),
                ),
                child: Icon(
                  icon,
                  size: 28 * scale,
                  color: _darkGreen,
                ),
              ),
              SizedBox(width: 13 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: _textStyle(
                        size: 16 * scale,
                        weight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5 * scale),
                    Text(
                      detail,
                      style: _textStyle(
                        size: 14 * scale,
                        color: _muted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5 * scale),
              Icon(
                Icons.chevron_right_rounded,
                size: 22 * scale,
                color: _neutral,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _whatsAppButton(
    BuildContext context,
    double scale,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _openLink(
            context,
            Uri.parse('https://wa.me/$_whatsAppNumber'),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: 15 * scale,
            vertical: 17 * scale,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12 * scale),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.chat_outlined,
              size: 27 * scale,
              color: Colors.white,
            ),
            SizedBox(width: 12 * scale),
            Expanded(
              child: Text(
                'Hubungi via WhatsApp',
                style: _textStyle(
                  size: 16 * scale,
                  color: Colors.white,
                  weight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              size: 21 * scale,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context, double scale) {
    return ListView(
      padding: EdgeInsets.only(
        top: 16 * scale,
        bottom: 24 * scale,
      ),
      children: [
        _header(context, scale),
        SizedBox(height: 12 * scale),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 23 * scale,
          ),
          child: Column(
            children: [
              _heading(scale),
              SizedBox(height: 18 * scale),
              _contactCard(
                title: 'Telepon',
                detail: '$_phone\n(08.00-17.00 WIB)',
                icon: Icons.phone_rounded,
                scale: scale,
                onTap: () {
                  _openLink(
                    context,
                    Uri(
                      scheme: 'tel',
                      path: _phone,
                    ),
                  );
                },
              ),
              SizedBox(height: 12 * scale),
              _contactCard(
                title: 'Email',
                detail: _email,
                icon: Icons.email_rounded,
                scale: scale,
                onTap: () {
                  _openLink(
                    context,
                    Uri(
                      scheme: 'mailto',
                      path: _email,
                    ),
                  );
                },
              ),
              SizedBox(height: 12 * scale),
              _contactCard(
                title: 'Alamat Rumah Ketua RT',
                detail: _address,
                icon: Icons.location_on_rounded,
                scale: scale,
                onTap: () {
                  _openLink(
                    context,
                    Uri.https(
                      'www.google.com',
                      '/maps/search/',
                      {
                        'api': '1',
                        'query': _mapsAddress,
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20 * scale),
              _whatsAppButton(context, scale),
            ],
          ),
        ),
      ],
    );
  }

  Widget _navigationItem({
    required BuildContext context,
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
            if (selected) return;

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

  Widget _bottomNavigation(
    BuildContext context,
    double scale,
  ) {
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
              context: context,
              index: 0,
              label: 'Beranda',
              icon: Icons.home_outlined,
              scale: scale,
            ),
            _navigationItem(
              context: context,
              index: 1,
              label: 'Lapor',
              icon: Icons.description_outlined,
              scale: scale,
            ),
            _navigationItem(
              context: context,
              index: 2,
              label: 'Riwayat',
              icon: Icons.access_time_rounded,
              scale: scale,
            ),
            _navigationItem(
              context: context,
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
            child: _content(context, scale),
          ),
        ),
      ),
      bottomNavigationBar: Center(
        heightFactor: 1,
        child: SizedBox(
          width: contentWidth,
          child: _bottomNavigation(context, scale),
        ),
      ),
    );
  }
}