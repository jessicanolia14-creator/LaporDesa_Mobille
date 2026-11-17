import 'package:flutter/foundation.dart';

import '../models/home_report.dart';
import '../repositories/home_repository.dart';

/// State navigasi dan daftar laporan pada beranda.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({HomeRepository? repository})
    : _repository = repository ?? HomeRepository();

  final HomeRepository _repository;
  int _selectedIndex = 0;
  int? _selectedReportIndex;

  int get selectedIndex => _selectedIndex;
  int? get selectedReportIndex => _selectedReportIndex;
  List<HomeReport> get reports => _repository.getReports();

  void selectTab(int index) {
    if (index < 0 || index > 3 || index == _selectedIndex) return;
    _selectedIndex = index;
    notifyListeners();
  }

  void selectReport(int index) {
    if (index < 0 || index >= reports.length || index == _selectedReportIndex) {
      return;
    }
    _selectedReportIndex = index;
    notifyListeners();
  }
}
