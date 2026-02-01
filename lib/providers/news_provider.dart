import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/api_service.dart';

class NewsProvider extends ChangeNotifier {
  List<News> _news = [];
  bool _isLoading = false;
  String? _error;

  List<News> get news => _news;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNews() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _news = await ApiService.getNews();
    } catch (e) {
      debugPrint("NEWS ERROR: $e");
      _error = e.toString();
    }finally {
      _isLoading = false;
      notifyListeners();
    }

    
  }
}
