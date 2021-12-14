import 'package:dio/dio.dart';
import 'package:dzaro_assignment/constants.dart';
import 'package:dzaro_assignment/routes.dart';
import 'package:dzaro_assignment/screen_arguments.dart';
import 'package:dzaro_assignment/state_management_providers/dashboard_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DashboardProvider provider;

  List<String> properties = ["Name", "Launch Site", "Launch At", "Popularity"];
  List<String> orders = ["ASC", "DESC"];

  var dropdownMenuOptionProperties, dropdownMenuOptionOrder;

  @override
  Widget build(BuildContext context) {
    dropdownMenuOptionProperties = properties
        .map(
          (String item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              textAlign: TextAlign.left,
            ),
          ),
        )
        .toList();

    dropdownMenuOptionOrder = orders
        .map(
          (String item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              textAlign: TextAlign.left,
            ),
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("DZARO"),
        actions: [
          InkWell(
            onTap: () => Navigator.of(context)
                .pushNamed(addProductRoute,
                    arguments: ScreenArguments.addProduct())
                .then((value) => fetchProducts(false)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Icon(Icons.add_circle_outline_outlined),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: ChangeNotifierProvider(
          create: (context) => DashboardProvider(),
          child: Builder(
            builder: (context) {
              return Consumer<DashboardProvider>(
                builder: (context, _provider, child) {
                  provider = _provider;

                  if (!provider.build) {
                    WidgetsBinding.instance!
                        .addPostFrameCallback((_) => fetchProducts(true));
                  }

                  return provider.processing
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Text("Please wait...")
                          ],
                        )
                      : provider.productsList.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  "Empty List",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Product list is empty.\nProducts you add will be displayed here.",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                print("Max Width:  ${constraints.maxWidth}");
                                return Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 10),
                                      color: greyBackgroundColor,
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            flex: 2,
                                            child: Text(
                                              "SORT BY : ",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: DropdownButton<String>(
                                              value: provider.selectedProperty,
                                              isExpanded: true,
                                              hint:
                                                  const Text("Select Property"),
                                              items:
                                                  dropdownMenuOptionProperties,
                                              underline: const SizedBox(),
                                              onChanged: (valueSelected) {
                                                setState(
                                                  () {
                                                    provider.selectedProperty =
                                                        valueSelected!;
                                                    fetchProducts(false);
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            flex: 1,
                                            child: DropdownButton<String>(
                                              value: provider.selectedOrder,
                                              isExpanded: true,
                                              hint: const Text("Select Order"),
                                              items: dropdownMenuOptionOrder,
                                              underline: const SizedBox(),
                                              onChanged: (valueSelected) {
                                                setState(
                                                  () {
                                                    provider.selectedOrder =
                                                        valueSelected!;

                                                    fetchProducts(false);
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    constraints.maxWidth > 710
                                        ? Expanded(
                                            child: Column(
                                              children: [
                                                Divider(
                                                  color: Colors.grey.shade600,
                                                ),
                                                //if (kIsWeb) //If we want to show this options to only web users.
                                                Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 25,
                                                      vertical: 15),
                                                  color: greyBackgroundColor,
                                                  child: Row(
                                                    children: [
                                                      const Expanded(
                                                        child: Text(
                                                            "You can see products in grid or list view :"),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () => provider
                                                            .showGrid = true,
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Icon(Icons
                                                              .grid_view_sharp),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 20),
                                                      GestureDetector(
                                                        onTap: () => provider
                                                            .showGrid = false,
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child:
                                                              Icon(Icons.list),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: provider.showGrid
                                                      ? GridView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: provider
                                                              .productsList
                                                              .length,
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: constraints
                                                                        .maxWidth >
                                                                    1400
                                                                ? 4
                                                                : constraints
                                                                            .maxWidth >
                                                                        1200
                                                                    ? 3
                                                                    : 2,
                                                            childAspectRatio: constraints
                                                                        .maxWidth >
                                                                    1650
                                                                ? 1.5
                                                                : constraints
                                                                            .maxWidth >
                                                                        1400
                                                                    ? 1.3
                                                                    : constraints.maxWidth >
                                                                            1200
                                                                        ? 1.5
                                                                        : constraints.maxWidth >
                                                                                1150
                                                                            ? 2.5
                                                                            : constraints.maxWidth > 900
                                                                                ? 1.8
                                                                                : constraints.maxWidth > 750
                                                                                    ? 1.3
                                                                                    : 1.2,
                                                          ),
                                                          itemBuilder:
                                                              (context, index) {
                                                            return gridItem(
                                                                index);
                                                          },
                                                        )
                                                      : ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: provider
                                                              .productsList
                                                              .length,
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              listItem(index),
                                                        ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Expanded(
                                            child: ListView.builder(
                                              itemCount:
                                                  provider.productsList.length,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder: (context, index) =>
                                                  listItem(index),
                                            ),
                                          )
                                  ],
                                );
                              },
                            );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget listItem(index) {
    ScreenArguments productDetails = provider.productsList[index];

    return Container(
      decoration: BoxDecoration(
        color: greyBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productDetails.productName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Launch Site : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: productDetails.launchSite,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Launch At : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: productDetails.launchAt,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "Popularity : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: RatingBarIndicator(
                        rating: double.parse("${productDetails.popularity}"),
                        itemPadding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: primaryColor,
                        ),
                        itemCount: 5,
                        itemSize: 30.0,
                        direction: Axis.horizontal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context)
                      .pushNamed(addProductRoute, arguments: productDetails)
                      .then((value) => fetchProducts(false)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.edit),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => showDeleteAlert(context, productDetails),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget gridItem(int index) {
    ScreenArguments productDetails = provider.productsList[index];
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: greyBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            productDetails.productName,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: "Launch Site : ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: productDetails.launchSite,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: "Launch At : ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: productDetails.launchAt,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                "Popularity : ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: RatingBarIndicator(
                  rating: double.parse("${productDetails.popularity}"),
                  itemPadding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: primaryColor,
                  ),
                  itemCount: 5,
                  itemSize: 30.0,
                  direction: Axis.horizontal,
                ),
              ),
            ],
          ),
          const Divider(height: 10),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(addProductRoute, arguments: productDetails)
                        .then((value) => fetchProducts(false)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () => showDeleteAlert(context, productDetails),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.delete),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> fetchProducts(process) async {
    if (!provider.build) provider.build = true;

    if (process) provider.processing = true;

    List<ScreenArguments> productsList = [];

    FormData formData = FormData.fromMap({
      "request": "get_all_products",
      "property": provider.selectedProperty,
      "order": provider.selectedOrder,
    });

    Dio().post(requestUrl, data: formData).then((result) {
      var jsonObject = result.data;

      if (process) provider.processing = false;

      print(jsonObject);

      if (jsonObject['type'] == 'success') {
        var data = jsonObject['data'];

        for (int i = 0; i < data.length; i++) {
          var product = data[i];

          ScreenArguments productItem = ScreenArguments.productDetails(
              productId: product['id'],
              productName: product['name'],
              launchSite: product['launch_site'],
              launchAt: product['launch_at'],
              popularity: double.parse(product['popularity']));

          productsList.add(productItem);
        }

        provider.productsList = productsList;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${jsonObject['message']}",
            ),
          ),
        );
      }
    });
  }

  showDeleteAlert(BuildContext context, ScreenArguments productDetails) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Delete Product"),
        content: const Text("Do you really want to delete?"),
        actions: <Widget>[
          TextButton(
            child: const Text("No"),
            onPressed: () => {
              Navigator.pop(context),
            },
          ),
          TextButton(
            child: const Text("Delete"),
            onPressed: () => {
              deleteProduct(productDetails),
              Navigator.pop(context),
            },
          ),
        ],
      ),
    );
  }

  deleteProduct(ScreenArguments productDetails) {
    List<ScreenArguments> productsList = [];

    FormData formData = FormData.fromMap({
      "request": "delete_product",
      "id": productDetails.productId,
    });

    Dio().post(requestUrl, data: formData).then((result) {
      var jsonObject = result.data;

      print(jsonObject);

      if (result.statusCode == 200) {
        if (jsonObject['type'] == 'success') {
          var data = jsonObject['data'];

          for (int i = 0; i < data.length; i++) {
            var product = data[i];

            ScreenArguments productItem = ScreenArguments.productDetails(
                productId: product['id'],
                productName: product['name'],
                launchSite: product['launch_site'],
                launchAt: product['launch_at'],
                popularity: double.parse(product['popularity']));

            productsList.add(productItem);
          }

          provider.productsList = productsList;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${jsonObject['message']}",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Something went wrong. Status Code: ${result.statusCode}",
            ),
          ),
        );
      }
    });
  }
}
