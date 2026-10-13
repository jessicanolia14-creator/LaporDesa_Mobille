import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailSaluranAirPage extends StatelessWidget {
  const DetailSaluranAirPage({
    super.key,
    this.wilayah = 'RT 01/RW 01',
    this.tanggal = '25 Agustus 2026',
  });

  final String wilayah;
  final String tanggal;

  static const Color _darkGreen = Color(0xFF00865B);
  static const Color _ink = Color(0xFF080808);
  static const Color _muted = Color(0xFF7C8494);
  static const Color _neutral = Color(0xFF506788);
  static const Color _cardGrey = Color(0xFFEDF0F3);
  static const Color _border = Color(0xFFD1D6DD);

  static const Color _statusBackground = Color(0xFFA5D3C0);
  static const Color _statusText = Color(0xFF186D50);

  static const String _description =
      'Air tidak mengalir dan mulai menggenang '
      'di sekitar selokan.';

  static const List<String> _photos = [
    'assets/images/saluran_air_.png',
    'assets/images/saluran_air_2.png',
    'assets/images/saluran_air_3.png',
  ];

  TextStyle _textStyle(
    double size, {
    Color color = _ink,
    FontWeight weight = FontWeight.w400,
    double height = 1.3,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  Widget _photo({
    required String path,
    required double width,
    required double height,
    required double radius,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: _cardGrey,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.image_outlined,
                  color: _neutral,
                  size: 30,
                ),
                const SizedBox(height: 6),
                Text(
                  'Foto belum tersedia',
                  textAlign: TextAlign.center,
                  style: _textStyle(
                    11,
                    color: _muted,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openPhoto(BuildContext context, String path) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(20),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Foto Laporan',
                      style: _textStyle(
                        17,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tutup',
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.sizeOf(dialogContext).height * 0.65,
                ),
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Image.asset(
                    path,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('Foto belum tersedia.'),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context, double scale) {
    return SizedBox(
      height: 60 * scale,
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
              'Detail Laporan',
              textAlign: TextAlign.center,
              style: _textStyle(
                25 * scale,
                weight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 48 * scale),
        ],
      ),
    );
  }

  Widget _status(double scale) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12 * scale,
          vertical: 5 * scale,
        ),
        decoration: BoxDecoration(
          color: _statusBackground,
          borderRadius: BorderRadius.circular(5 * scale),
        ),
        child: Text(
          'Selesai',
          style: _textStyle(
            17 * scale,
            color: _statusText,
            weight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _informationRow({
    required IconData icon,
    required String text,
    required double scale,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 21 * scale,
          color: _ink,
        ),
        SizedBox(width: 10 * scale),
        Expanded(
          child: Text(
            text,
            style: _textStyle(
              14 * scale,
              color: _muted,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _informationCard(double scale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13 * scale),
      decoration: BoxDecoration(
        color: _cardGrey,
        borderRadius: BorderRadius.circular(13 * scale),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saluran Air Tersumbat',
            style: _textStyle(
              17 * scale,
              weight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8 * scale),
          _informationRow(
            icon: Icons.location_on_outlined,
            text: wilayah,
            scale: scale,
          ),
          SizedBox(height: 8 * scale),
          _informationRow(
            icon: Icons.calendar_month_outlined,
            text: tanggal,
            scale: scale,
          ),
        ],
      ),
    );
  }

  Widget _descriptionCard(double scale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13 * scale),
      decoration: BoxDecoration(
        color: _cardGrey,
        borderRadius: BorderRadius.circular(13 * scale),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deskripsi',
            style: _textStyle(
              17 * scale,
              weight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5 * scale),
          Text(
            _description,
            style: _textStyle(
              15 * scale,
              color: _muted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _otherPhotos(BuildContext context, double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto Lainnya',
          style: _textStyle(
            22 * scale,
            weight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15 * scale),
        Row(
          children: [
            for (int index = 0; index < _photos.length; index++) ...[
              if (index > 0) SizedBox(width: 15 * scale),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Semantics(
                      button: true,
                      label: 'Buka foto laporan ${index + 1}',
                      child: GestureDetector(
                        onTap: () {
                          _openPhoto(context, _photos[index]);
                        },
                        child: _photo(
                          path: _photos[index],
                          width: constraints.maxWidth,
                          height: 95 * scale,
                          radius: 6 * scale,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _content(BuildContext context, double scale) {
    return ListView(
      padding: EdgeInsets.only(
        top: 8 * scale,
        bottom: 24 * scale,
      ),
      children: [
        _header(context, scale),
        SizedBox(height: 15 * scale),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onTap: () {
                      _openPhoto(context, _photos.first);
                    },
                    child: _photo(
                      path: _photos.first,
                      width: constraints.maxWidth,
                      height: 220 * scale,
                      radius: 6 * scale,
                    ),
                  );
                },
              ),
              SizedBox(height: 16 * scale),
              _status(scale),
              SizedBox(height: 16 * scale),
              _informationCard(scale),
              SizedBox(height: 24 * scale),
              const Divider(
                height: 1,
                thickness: 1,
                color: _border,
              ),
              SizedBox(height: 24 * scale),
              _descriptionCard(scale),
              SizedBox(height: 20 * scale),
              const Divider(
                height: 1,
                thickness: 1,
                color: _border,
              ),
              SizedBox(height: 16 * scale),
              _otherPhotos(context, scale),
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
    final bool selected = index == 0;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop<int>(index);
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
                    13 * scale,
                    color: selected ? _darkGreen : _ink,
                    weight: selected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomNavigation(BuildContext context, double scale) {
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
              icon: Icons.home_rounded,
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
    final double width = screenWidth > 480 ? 480.0 : screenWidth;
    final double scale = width / 390;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: SizedBox(
            width: width,
            child: _content(context, scale),
          ),
        ),
      ),
      bottomNavigationBar: Center(
        heightFactor: 1,
        child: SizedBox(
          width: width,
          child: _bottomNavigation(context, scale),
        ),
      ),
    );
  }
}