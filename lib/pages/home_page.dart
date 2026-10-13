import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/demo_account.dart';
import 'home_detail_page.dart';
import 'buat_laporan.dart';
import 'riwayat_laporan.dart';
import 'notifikasi_page.dart';
import 'bantuan_page.dart';
import 'akun.dart';
import 'detail_lampu_jalan.dart';
import 'detail_saluran_air.dart';
import 'detail_bantuan_banjir.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color green = Color(0xFF08935B);
  static const Color darkGreen = Color(0xFF00865B);
  static const Color mint = Color(0xFFD3F7E9);
  static const Color ink = Color(0xFF12192B);
  static const Color muted = Color(0xFF68717B);
  static const Color neutral = Color(0xFF506788);

  static const Color cardGrey = Color(0xFFEDF0F3);
  static const Color cardBorder = Color(0xFFD1D6DD);
  static const Color selectedCard = Color(0xFF62A68D);

  int _selectedIndex = 0;
  int? _selectedReportIndex;

  static const List<_ReportData> _reports = [
    _ReportData(
      title: 'Jalan berlubang di depan RT01',
      description:
          'Jalan Berlubang dan Membahayakan pengendara, '
          'terutama saat hujan.',
      status: 'Diproses',
      image: 'assets/images/jalan_berlubang.png',
      fallbackIcon: Icons.add_road,
    ),
    _ReportData(
      title: 'Lampu Jalan Mati',
      description:
          'Lampu jalan tidak menyala pada malam hari '
          'sehingga area menjadi gelap.',
      status: 'Ditangani',
      image: 'assets/images/lampu_jalan_mati.png',
      fallbackIcon: Icons.lightbulb_outline,
    ),
    _ReportData(
      title: 'Saluran Air Tersumbat',
      description:
          'Air tidak mengalir dan mulai menggenang '
          'di sekitar selokan.',
      status: 'Selesai',
      image: 'assets/images/saluran_air_.png',
      fallbackIcon: Icons.water_drop_outlined,
    ),
    _ReportData(
      title: 'Bantuan untuk warga terdampak banjir',
      description:
          'Memerlukan bantuan logistik seperti '
          'makanan, air bersih, dan selimut.',
      status: 'Diproses',
      image: 'assets/images/bantuan_banjir.png',
      fallbackIcon: Icons.flood_outlined,
    ),
  ];

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

  void _selectReport(int index) {
    setState(() {
      _selectedReportIndex = index;
    });
  }

  Future<void> _showAccount() async {
    final int? selectedTab = await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(
        builder: (_) => const AkunPage(),
      ),
    );

    if (!mounted) return;

    setState(() {
      if (selectedTab != null) {
        _selectedIndex = selectedTab;
      }
    });
  }

      Future<void> _showReport(int index) async {
    _selectReport(index);

    final int? selectedTab = await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(
        builder: (_) {
          switch (index) {
            case 0:
              return const ReportDetailPage();

            case 1:
              return const DetailLampuJalanPage();

            case 2:
              return const DetailSaluranAirPage();

            case 3:
              return const DetailBantuanBanjirPage();

            default:
              return const ReportDetailPage();
          }
        },
      ),
    );

    if (!mounted) return;

    if (selectedTab != null) {
      setState(() {
        _selectedIndex = selectedTab;
      });
    }
  }

  Widget _headerAction({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required double scale,
    bool showDot = false,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 4 * scale,
            vertical: 4 * scale,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    width: 38 * scale,
                    height: 38 * scale,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: mint,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: darkGreen,
                      size: 28 * scale,
                    ),
                  ),
                  if (showDot)
                    Positioned(
                      top: 7 * scale,
                      right: 6 * scale,
                      child: Container(
                        width: 6 * scale,
                        height: 6 * scale,
                        decoration: const BoxDecoration(
                          color: green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 4 * scale),
              Text(
                label,
                style: _textStyle(
                  size: 12 * scale,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double scale) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20 * scale,
        16 * scale,
        20 * scale,
        12 * scale,
      ),
      child: Row(
        children: [
          _headerAction(
            label: 'Akun',
            icon: Icons.person,
            onTap: _showAccount,
            scale: scale,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 42 * scale,
                  height: 42 * scale,
                  fit: BoxFit.contain,
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text.rich(
                      const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Lapor',
                            style: TextStyle(color: ink),
                          ),
                          TextSpan(
                            text: 'Desa',
                            style: TextStyle(color: green),
                          ),
                        ],
                      ),
                      style: _textStyle(
                        size: 28 * scale,
                        weight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _headerAction(
            label: 'Notifikasi',
            icon: Icons.notifications_none_outlined,
            scale: scale,
            showDot: true,
            onTap: () async {
              final int? selectedTab =
                  await NotifikasiPage.open(context);

              if (!mounted) return;

              if (selectedTab != null) {
                setState(() {
                  _selectedIndex = selectedTab;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status, double scale) {
    final Color background;
    final Color foreground;

    switch (status) {
      case 'Ditangani':
        background = const Color(0xFFFFE5E7);
        foreground = const Color(0xFFE94853);
        break;
      case 'Selesai':
        background = const Color(0xFFA5D3C0);
        foreground = const Color(0xFF186D50);
        break;
      default:
        background = const Color(0xFFFFF0D4);
        foreground = const Color(0xFFD98200);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 9 * scale,
        vertical: 3 * scale,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4 * scale),
      ),
      child: Text(
        status,
        style: _textStyle(
          size: 12 * scale,
          color: foreground,
          weight: FontWeight.w500,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _reportCard(int index, double scale) {
    final report = _reports[index];
    final isSelected = _selectedReportIndex == index;

    final titleColor =
        isSelected ? const Color(0xFF092F24) : Colors.black;

    final descriptionColor =
        isSelected ? const Color(0xFF123D30) : muted;

    final radius = BorderRadius.circular(15 * scale);

    return Padding(
      padding: EdgeInsets.only(bottom: 12 * scale),
      child: Semantics(
        button: true,
        selected: isSelected,
        label: report.title,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: isSelected ? selectedCard : cardGrey,
            borderRadius: radius,
            border: Border.all(
              color: isSelected ? selectedCard : cardBorder,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
                            onTap: () {
                _showReport(index);
              },
              borderRadius: radius,
              child: Padding(
                padding: EdgeInsets.all(10 * scale),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 74 * scale,
                      height: 74 * scale,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(6 * scale),
                        border: Border.all(
                          color: const Color(0xFFCDD4D9),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        report.image,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: mint,
                            alignment: Alignment.center,
                            child: Icon(
                              report.fallbackIcon,
                              size: 30 * scale,
                              color: darkGreen,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 9 * scale),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.title,
                            style: _textStyle(
                              size: 15 * scale,
                              color: titleColor,
                              weight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 5 * scale),
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  report.description,
                                  style: _textStyle(
                                    size: 11.5 * scale,
                                    color: descriptionColor,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6 * scale),
                              _statusBadge(report.status, scale),
                              SizedBox(width: 2 * scale),
                              SizedBox(
                                width: 23 * scale,
                                child: IconButton(
                                  tooltip: 'Lihat detail laporan',
                                  onPressed: () => _showReport(index),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(
                                    minWidth: 23 * scale,
                                    minHeight: 48,
                                  ),
                                  icon: Icon(
                                    Icons.chevron_right,
                                    color: titleColor,
                                    size: 25 * scale,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHome(double scale) {
    final name = DemoAccount.name.trim();
    final displayName = name.isEmpty ? 'Warga' : name;

    return ListView(
      key: const PageStorageKey<String>('home-scroll'),
      padding: EdgeInsets.zero,
      children: [
        _buildHeader(scale),
        Image.asset(
          'assets/images/village.png',
          width: double.infinity,
          fit: BoxFit.contain,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            20 * scale,
            22 * scale,
            20 * scale,
            16 * scale,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $displayName',
                style: _textStyle(
                  size: 29 * scale,
                  weight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8 * scale),
              Text(
                'Ada masalah di lingkunganmu?\n'
                'Yuk, buat laporan sekarang!',
                style: _textStyle(
                  size: 15 * scale,
                  color: Colors.black,
                  height: 1.35,
                ),
              ),
              SizedBox(height: 20 * scale),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Laporan Terbaru',
                      style: _textStyle(
                        size: 18 * scale,
                        color: Colors.black,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: ink,
                      padding: EdgeInsets.symmetric(
                        horizontal: 2 * scale,
                        vertical: 8 * scale,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Lihat Semua  ›',
                      style: _textStyle(
                        size: 13 * scale,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14 * scale),
              ...List.generate(
                _reports.length,
                (index) => _reportCard(index, scale),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistory(double scale) {
    return RiwayatLaporanPage(
      showBottomNavigation: false,
      onBack: () {
        setState(() {
          _selectedIndex = 0;
        });
      },
      onNavigationChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  Widget _buildSelectedPage(double scale) {
    switch (_selectedIndex) {
      case 1:
        return CreateReportPage(
          showBottomNavigation: false,
          onBack: () {
            setState(() {
              _selectedIndex = 0;
            });
          },
          onNavigationChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        );

      case 2:
        return _buildHistory(scale);

      case 3:
        return BantuanPage(
          showBottomNavigation: false,
          onBack: () {
            setState(() {
              _selectedIndex = 0;
            });
          },
          onNavigationChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        );

      default:
        return _buildHome(scale);
    }
  }

  Widget _navigationItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData selectedIcon,
    required double scale,
  }) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8 * scale,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  size: 34 * scale,
                  color: isSelected ? darkGreen : neutral,
                ),
                SizedBox(height: 4 * scale),
                Text(
                  label,
                  style: _textStyle(
                    size: 13 * scale,
                    color: isSelected ? darkGreen : Colors.black,
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

  Widget _buildBottomNavigation(double scale) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: cardBorder),
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
              selectedIcon: Icons.home_rounded,
              scale: scale,
            ),
            _navigationItem(
              index: 1,
              label: 'Lapor',
              icon: Icons.description_outlined,
              selectedIcon: Icons.description,
              scale: scale,
            ),
            _navigationItem(
              index: 2,
              label: 'Riwayat',
              icon: Icons.access_time,
              selectedIcon: Icons.access_time_filled,
              scale: scale,
            ),
            _navigationItem(
              index: 3,
              label: 'Bantuan',
              icon: Icons.headset_mic_outlined,
              selectedIcon: Icons.headset_mic_outlined,
              scale: scale,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final contentWidth = screenWidth > 480 ? 480.0 : screenWidth;
    final scale = contentWidth / 390.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: SizedBox(
            width: contentWidth,
            child: _buildSelectedPage(scale),
          ),
        ),
      ),
      bottomNavigationBar: Center(
        heightFactor: 1,
        child: SizedBox(
          width: contentWidth,
          child: _buildBottomNavigation(scale),
        ),
      ),
    );
  }
}

class _ReportData {
  const _ReportData({
    required this.title,
    required this.description,
    required this.status,
    required this.image,
    required this.fallbackIcon,
  });

  final String title;
  final String description;
  final String status;
  final String image;
  final IconData fallbackIcon;
}