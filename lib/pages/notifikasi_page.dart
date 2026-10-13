import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  static const Color _green = Color(0xFF08935B);
  static const Color _mint = Color(0xFFD3F7E9);
  static const Color _ink = Color(0xFF080808);
  static const Color _muted = Color(0xFF68717B);
  static const Color _neutral = Color(0xFF506788);
  static const Color _cardGrey = Color(0xFFEDF0F3);
  static const Color _border = Color(0xFFD1D6DD);

  static Future<int?> open(BuildContext context) {
    return Navigator.of(context).push<int>(
      PageRouteBuilder<int>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const NotifikasiPage();
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          final Animation<Offset> position = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            ),
          );

          return SlideTransition(
            position: position,
            child: child,
          );
        },
      ),
    );
  }

  static const List<_NotificationData> _today = [
    _NotificationData(
      title: 'Laporan berhasil dikirim',
      message:
          'Laporan “Jalan Rusak” telah berhasil dikirim dan '
          'sedang menunggu proses verifikasi oleh RT.',
      time: '2 menit yang lalu',
      icon: Icons.description_outlined,
      iconColor: _green,
    ),
    _NotificationData(
      title: 'Laporan dalam proses',
      message:
          'Laporan “Lampu Jalan Mati” sedang '
          'ditindaklanjuti oleh RT.',
      time: '1 jam yang lalu',
      icon: Icons.hourglass_empty_rounded,
      iconColor: Color(0xFFFFA000),
    ),
    _NotificationData(
      title: 'Ada pembaruan dari RT',
      message:
          'RT 02 telah menambahkan catatan pada '
          'laporan “Sampah Menumpuk”.',
      time: '3 jam yang lalu',
      icon: Icons.chat_bubble_rounded,
      iconColor: Color(0xFF087BFF),
      kind: _NotificationIconKind.chat,
    ),
    _NotificationData(
      title: 'Laporan selesai',
      message:
          'Laporan “Saluran Air Tersumbat” telah '
          'diselesaikan.',
      time: '5 jam yang lalu',
      icon: Icons.check_rounded,
      iconColor: _green,
      kind: _NotificationIconKind.completed,
    ),
  ];

  static const List<_NotificationData> _yesterday = [
    _NotificationData(
      title: 'Selamat datang di LaporDesa!',
      message:
          'Yuk, mulai buat laporan untuk lingkungan '
          'yang lebih baik.',
      time: '1 hari yang lalu',
      icon: Icons.notifications_none_rounded,
      iconColor: _neutral,
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

  void _showNotification(
    BuildContext context,
    _NotificationData notification,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: _textStyle(
                    size: 21,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  notification.message,
                  style: _textStyle(
                    size: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  notification.time,
                  style: _textStyle(
                    size: 12,
                    color: _muted,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'Tutup',
                      style: _textStyle(
                        size: 15,
                        color: Colors.white,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _notificationIcon(
    _NotificationData notification,
    double scale,
  ) {
    Widget icon;

    switch (notification.kind) {
      case _NotificationIconKind.chat:
        icon = Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.chat_bubble_rounded,
              size: 43 * scale,
              color: notification.iconColor,
            ),
            Positioned(
              top: 15 * scale,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int index = 0; index < 3; index++)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2 * scale,
                      ),
                      child: Container(
                        width: 4 * scale,
                        height: 4 * scale,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 10 * scale,
                height: 10 * scale,
                decoration: const BoxDecoration(
                  color: Color(0xFF39A7FF),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
        break;

      case _NotificationIconKind.completed:
        icon = Container(
          width: 43 * scale,
          height: 43 * scale,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF18D78B),
                Color(0xFF00955E),
              ],
            ),
          ),
          child: Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 33 * scale,
          ),
        );
        break;

      case _NotificationIconKind.standard:
        icon = Icon(
          notification.icon,
          size: 45 * scale,
          color: notification.iconColor,
        );
        break;
    }

    return Container(
      width: 71 * scale,
      height: 71 * scale,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: _mint,
        shape: BoxShape.circle,
      ),
      child: icon,
    );
  }

  Widget _notificationCard({
    required BuildContext context,
    required _NotificationData notification,
    required double scale,
    bool welcome = false,
  }) {
    final BorderRadius radius =
        BorderRadius.circular(15 * scale);

    return Material(
      color: _cardGrey,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          _showNotification(context, notification);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 11 * scale,
            vertical: 8 * scale,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _notificationIcon(notification, scale),
              SizedBox(width: 15 * scale),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: _textStyle(
                        size: (welcome ? 13 : 16) * scale,
                        weight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4 * scale),
                    Text(
                      notification.message,
                      style: _textStyle(
                        size: 10.5 * scale,
                        height: 1.35,
                      ),
                    ),
                    SizedBox(height: 3 * scale),
                    Text(
                      notification.time,
                      style: _textStyle(
                        size: 9.5 * scale,
                        color: _muted,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2 * scale),
              Align(
                alignment: Alignment.topCenter,
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 20 * scale,
                  color: _ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, double scale) {
    return ListView(
      padding: EdgeInsets.only(
        top: 8 * scale,
        bottom: 24 * scale,
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            tooltip: 'Kembali',
            icon: Icon(
              Icons.chevron_left_rounded,
              size: 30 * scale,
              color: _ink,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 25 * scale,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 7 * scale),
                child: Text(
                  'Hari Ini',
                  style: _textStyle(
                    size: 24 * scale,
                    weight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
              SizedBox(height: 28 * scale),
              for (int index = 0; index < _today.length; index++) ...[
                _notificationCard(
                  context: context,
                  notification: _today[index],
                  scale: scale,
                ),
                if (index < _today.length - 1)
                  SizedBox(height: 10 * scale),
              ],
              SizedBox(height: 31 * scale),
              Padding(
                padding: EdgeInsets.only(left: 7 * scale),
                child: Text(
                  'Kemarin',
                  style: _textStyle(
                    size: 24 * scale,
                    weight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
              SizedBox(height: 15 * scale),
              for (final notification in _yesterday)
                _notificationCard(
                  context: context,
                  notification: notification,
                  scale: scale,
                  welcome: true,
                ),
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
                style: _textStyle(
                  size: 13 * scale,
                  height: 1.2,
                ),
              ),
            ],
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

enum _NotificationIconKind {
  standard,
  chat,
  completed,
}

class _NotificationData {
  const _NotificationData({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.kind = _NotificationIconKind.standard,
  });

  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final _NotificationIconKind kind;
}