import 'package:dzaro_assignment/screen_arguments.dart';
import 'package:flutter/foundation.dart';

class DashboardProvider extends ChangeNotifier {
  List<ScreenArguments> _productsList = [];

  bool _processing = false;
  bool _showGrid = false;
  bool _build = false;

  String _selectedProperty = "Name";
  String _selectedOrder = "ASC";

  String get selectedProperty => _selectedProperty;
  String get selectedOrder => _selectedOrder;
  bool get showGrid => _showGrid;
  bool get processing => _processing;
  bool get build => _build;

  List<ScreenArguments> get productsList => _productsList;

  set selectedProperty(String value) {
    _selectedProperty = value;
    notifyListeners();
  }

  set selectedOrder(String value) {
    _selectedOrder = value;
    notifyListeners();
  }

  set productsList(List<ScreenArguments> value) {
    _productsList = value;
    notifyListeners();
  }

  set showGrid(bool value) {
    _showGrid = value;
    notifyListeners();
  }

  set build(bool value) {
    _build = value;
    notifyListeners();
  }

  set processing(bool value) {
    _processing = value;
    notifyListeners();
  }
}
