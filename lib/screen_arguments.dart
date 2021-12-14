class ScreenArguments {
  var updateProduct, productId, productName, launchSite, launchAt, popularity;

  ScreenArguments.addProduct({
    this.updateProduct = false,
  });

  ScreenArguments.productDetails({
    this.updateProduct = true,
    required this.productId,
    required this.productName,
    required this.launchSite,
    required this.launchAt,
    required this.popularity,
  });
}
