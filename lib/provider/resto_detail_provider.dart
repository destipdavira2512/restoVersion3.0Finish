import 'package:flutter/material.dart';
import 'package:resto_cepat_saji_3/data/model/resto_detail.dart';
import 'package:resto_cepat_saji_3/data/api/api_service.dart';
import 'package:resto_cepat_saji_3/utils/result_state.dart';

class RestoDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;

  RestoDetailProvider({required this.apiService, required this.id}) {
    _fetchRestoDetail(id);
  }

  late ResultState _state;
  late RestoDetail _detail;
  String _message = '';

  ResultState get state => _state;
  RestoDetail get result => _detail;
  String get message => _message;

  Future<dynamic> _fetchRestoDetail(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restoDetail = await apiService.restoDetail(id);
      if (restoDetail.restaurant.id.isNotEmpty) {
        _state = ResultState.hasData;
        notifyListeners();
        return _detail = restoDetail;
      } else {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data tidak ditemukan';
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Gagal memuat data';
    }
  }
}
