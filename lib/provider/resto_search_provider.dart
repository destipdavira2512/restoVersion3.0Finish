import 'package:flutter/material.dart';
import 'package:resto_cepat_saji_3/data/model/resto_search.dart';
import 'package:resto_cepat_saji_3/data/api/api_service.dart';
import 'package:resto_cepat_saji_3/utils/result_state.dart';

class RestoSearchProvider extends ChangeNotifier {
  final ApiService apiService;

  RestoSearchProvider({required this.apiService}) {
    fetchRestoQuery(query);
  }

  ResultState? _state;
  RestoSearch? _search;
  String _query = '';
  String _message = '';

  ResultState? get state => _state;
  RestoSearch? get result => _search;
  String get query => _query;
  String get message => _message;

  Future<dynamic> fetchRestoQuery(String query) async {
    try {
      if (query.isNotEmpty) {
        _state = ResultState.loading;
        _query = query;
        notifyListeners();
        final restoResult = await apiService.restoSearch(query);
        if (restoResult.restaurants.isNotEmpty) {
          _state = ResultState.hasData;
          notifyListeners();
          return _search = restoResult;
        } else {
          _state = ResultState.noData;
          notifyListeners();
          return _message = 'Restoran tidak ditemukan';
        }
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Gagal memuat data';
    }
  }
}
