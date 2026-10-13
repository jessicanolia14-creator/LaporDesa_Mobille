import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiwayatLaporanPage extends StatefulWidget {
  const RiwayatLaporanPage({
    super.key,
    required this.onBack,
    required this.onNavigationChanged,
    this.showBottomNavigation = true,
  });

  final VoidCallback onBack;
  final ValueChanged<int> onNavigationChanged;
  final bool showBottomNavigation;

  @override
  State<RiwayatLaporanPage> createState() =>
      _RiwayatLaporanPageState();
}

class _RiwayatLaporanPageState extends State<RiwayatLaporanPage> {
  static const Color _green = Color(0xFF08935B);
  static const Color _darkGreen = Color(0xFF00865B);
  static const Color _mint = Color(0xFFD3F7E9);
  static const Color _ink = Color(0xFF121212);
  static const Color _muted = Color(0xFF68717B);
  static const Color _neutral = Color(0xFF506788);
  static const Color _cardGrey = Color(0xFFEDF0F3);
  static const Color _border = Color(0xFFD1D6DD);

  String _selectedFilter = 'Semua';

  // Mengikuti kartu pertama yang aktif pada Figma.
  String? _selectedReportId = 'jalan';

  static const List<_HistoryReport> _reports = [
    _HistoryReport(
      id: 'jalan',
      title: 'Jalan Rusak',
      date: '08 September 2025',
      status: 'Diproses',
      image: 'assets/images/jalan_berlubang.png',
      fallbackIcon: Icons.add_road,
    ),
    _HistoryReport(
      id: 'lampu',
      title: 'Lampu Jalan Mati',
      date: '25 Juli 2025',
      status: 'Selesai',
      image: 'assets/images/lampu_jalan.png',
      fallbackIcon: Icons.lightbulb_outline,
    ),
    _HistoryReport(
      id: 'sampah',
      title: 'Sampah Menumpuk',
      date: '10 Juli 2025',
      status: 'Diproses',
      image: 'assets/images/sampah_menumpuk.png',
      fallbackIcon: Icons.delete_outline,
    ),
    _HistoryReport(
      id: 'saluran',
      title: 'Saluran Air Tersumbat',
      date: '30 Juni 2025',
      status: 'Selesai',
      image: 'assets/images/saluran_air.png',
      fallbackIcon: Icons.water_drop_outlined,
    ),
    _HistoryReport(
      id: 'bantuan',
      title: 'Bantuan Warga',
      date: '25 Juni 2025',
      status: 'Diproses',
      image: 'assets/images/bantuan_warga.png',
      fallbackIcon: Icons.groups_outlined,
    ),
  ];

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

  List<_HistoryReport> get _visibleReports {
    if (_selectedFilter == 'Semua') {
      return _reports;
    }

    return _reports
        .where((report) => report.status == _selectedFilter)
        .toList();
  }

  void _selectFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _selectReport(String id) {
    setState(() {
      _selectedReportId = id;
    });
  }

  Widget _header(double scale) {
    return SizedBox(
      height: 60 * scale,
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
              'Riwayat Laporan',
              textAlign: TextAlign.center,
              style: _textStyle(
                size: 25 * scale,
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

  Widget _filterButton(String label, double scale) {
    final bool selected = _selectedFilter == label;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: selected ? _green : _mint,
            borderRadius: BorderRadius.circular(5 * scale),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(5 * scale),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _selectFilter(label),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 9 * scale,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: _textStyle(
                    size: 15 * scale,
                    color: selected ? Colors.white : _muted,
                    weight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filters(double scale) {
    return Row(
      children: [
        _filterButton('Semua', scale),
        SizedBox(width: 19 * scale),
        _filterButton('Diproses', scale),
        SizedBox(width: 19 * scale),
        _filterButton('Selesai', scale),
      ],
    );
  }

  Widget _photo(_HistoryReport report, double scale) {
    return Container(
      width: 52 * scale,
      height: 52 * scale,
      decoration: BoxDecoration(
        color: _mint,
        borderRadius: BorderRadius.circular(5 * scale),
        border: Border.all(
          color: const Color(0xFFCDD4D9),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        report.image,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              report.fallbackIcon,
              size: 28 * scale,
              color: _darkGreen,
            ),
          );
        },
      ),
    );
  }

  Widget _statusBadge(String status, double scale) {
    final bool finished = status == 'Selesai';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6 * scale,
        vertical: 3 * scale,
      ),
      decoration: BoxDecoration(
        color: finished
            ? _green
            : const Color(0xFFFFF3E1),
        borderRadius: BorderRadius.circular(3 * scale),
      ),
      child: Text(
        status,
        style: _textStyle(
          size: 13 * scale,
          color: finished
              ? Colors.white
              : const Color(0xFFFF9800),
          weight: FontWeight.w500,
          height: 1.15,
        ),
      ),
    );
  }

  Widget _reportCard(_HistoryReport report, double scale) {
    final bool selected = _selectedReportId == report.id;
    final BorderRadius radius =
        BorderRadius.circular(11 * scale);

    return Semantics(
      button: true,
      selected: selected,
      label: '${report.title}, ${report.status}',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
            onTap: () => _selectReport(report.id),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 9 * scale,
                vertical: 9 * scale,
              ),
              child: Row(
                children: [
                  _photo(report, scale),
                  SizedBox(width: 10 * scale),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.title,
                          style: _textStyle(
                            size: 14 * scale,
                            color: selected ? Colors.white : _ink,
                            weight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 3 * scale),
                        Text(
                          report.date,
                          style: _textStyle(
                            size: 12 * scale,
                            color: selected
                                ? Colors.white
                                : _muted,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5 * scale),
                  _statusBadge(report.status, scale),
                  SizedBox(width: 2 * scale),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20 * scale,
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

  Widget _content(double scale) {
    final List<_HistoryReport> reports = _visibleReports;

    return ListView(
      padding: EdgeInsets.only(
        top: 8 * scale,
        bottom: 24 * scale,
      ),
      children: [
        _header(scale),
        SizedBox(height: 18 * scale),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 25 * scale,
          ),
          child: Column(
            children: [
              _filters(scale),
              SizedBox(height: 25 * scale),
              for (int index = 0; index < reports.length; index++) ...[
                _reportCard(reports[index], scale),
                if (index < reports.length - 1)
                  SizedBox(height: 36 * scale),
              ],
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
    final bool selected = index == 2;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: () {
            widget.onNavigationChanged(index);
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

class _HistoryReport {
  const _HistoryReport({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.image,
    required this.fallbackIcon,
  });

  final String id;
  final String title;
  final String date;
  final String status;
  final String image;
  final IconData fallbackIcon;
}