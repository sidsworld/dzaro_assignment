import 'package:date_format/date_format.dart';
import 'package:dzaro_assignment/screen_arguments.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddProductProvider extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController launchSiteController = TextEditingController();

  bool _build = false;
  bool _processing = false;

  int _productId = 0;

  double _popularity = 1.0;

  DateTime _launchAt = DateTime.now();
  String _launchAtString = "Select Date";
  String _launchAtUploadString = "";

  bool get processing => _processing;
  get build => _build;
  get productid => _productId;
  get popularity => _popularity;
  get launchAtDateTime => _launchAt;
  get launchAt => _launchAtString;
  get launchAtUpload => _launchAtUploadString;

  set processing(bool value) {
    _processing = value;
    notifyListeners();
  }

  set productid(value) {
    _productId = value;
    notifyListeners();
  }

  set popularity(value) {
    _popularity = value;
    notifyListeners();
  }

  set launchAt(value) {
    _launchAt = value;
    _launchAtString = formatDate(
      _launchAt,
      [dd, '-', mm, '-', yyyy],
    );
    _launchAtUploadString = formatDate(
      _launchAt,
      [yyyy, '-', mm, '-', dd],
    );
    notifyListeners();
  }

  setProductDetails(ScreenArguments productDetails) {
    nameController.text = productDetails.productName;
    launchSiteController.text = productDetails.launchSite;

    _popularity = productDetails.popularity;

    _launchAt = DateTime.parse(productDetails.launchAt);

    _launchAtString = formatDate(
      _launchAt,
      [dd, '-', mm, '-', yyyy],
    );

    _launchAtUploadString = formatDate(
      _launchAt,
      [yyyy, '-', mm, '-', dd],
    );

    if (productDetails.updateProduct) {
      _productId = productDetails.productId;
    }

    _build = true;
    notifyListeners();
  }

  updateUi() {
    notifyListeners();
  }
}
