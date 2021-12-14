import 'package:dio/dio.dart';
import 'package:dzaro_assignment/constants.dart';
import 'package:dzaro_assignment/routes.dart';
import 'package:dzaro_assignment/screen_arguments.dart';
import 'package:dzaro_assignment/state_management_providers/add_product_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({Key? key}) : super(key: key);

  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  String title = "Add Product";

  final _formKey = GlobalKey<FormState>();

  late AddProductProvider provider;

  @override
  Widget build(BuildContext context) {
    try {
      ScreenArguments screenArguments =
          ModalRoute.of(context)!.settings.arguments as ScreenArguments;

      if (screenArguments.updateProduct) {
        title = "Update Product";
        print(screenArguments.productName);
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ChangeNotifierProvider(
                create: (context) => AddProductProvider(),
                child: Builder(
                  builder: (context) {
                    return Consumer<AddProductProvider>(
                      builder: (context, _provider, child) {
                        provider = _provider;
                        if (!provider.build && screenArguments.updateProduct) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) =>
                              provider.setProductDetails(screenArguments));
                        }

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return constraints.maxWidth < 800
                                ? verticalLayout(constraints, screenArguments)
                                : horizantalLayout(
                                    constraints, screenArguments);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      return notAllowed();
    }
  }

  selectDate(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: provider.launchAtDateTime,
            firstDate: DateTime(2015, 8),
            lastDate: DateTime(2101))
        .then((value) {
      if (value != null && value != provider.launchAtDateTime) {
        provider.launchAt = value;
      }
    });
  }

  Widget notAllowed() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "401",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryColor,
                fontSize: 40,
              ),
            ),
            const Text(
              "You are not authorized to access this page.\nKindly contact admin for more details.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, dashboardRoute, (route) => false),
              child: const Text("Go To Dashboard"),
            )
          ],
        ),
      ),
    );
  }

  void saveProduct(bool updateProduct) {
    if (provider.launchAtUpload == "") {
      showAlert(
          context, title, "Please select the product launch date.", "Okay");
    } else {
      provider.processing = true;

      FormData formData = FormData();

      if (updateProduct) {
        formData = FormData.fromMap({
          "request": "update_product",
          "id": provider.productid,
          "name": provider.nameController.text.trim(),
          "launch_site": provider.launchSiteController.text,
          "launch_at": provider.launchAtUpload,
          "popularity": provider.popularity,
        });
      } else {
        formData = FormData.fromMap({
          "request": "add_product",
          "name": provider.nameController.text.trim(),
          "launch_site": provider.launchSiteController.text,
          "launch_at": provider.launchAtUpload,
          "popularity": provider.popularity,
        });
      }

      Dio().post(requestUrl, data: formData).then((result) {
        var jsonObject = result.data;

        provider.processing = false;

        print(jsonObject);

        if (result.statusCode == 200) {
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

  showAlert(BuildContext context, String title, String body, String btnText) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: <Widget>[
          TextButton(
            child: Text(btnText),
            onPressed: () => {
              Navigator.pop(context),
            },
          ),
        ],
      ),
    );
  }

  verticalLayout(BoxConstraints constraints, ScreenArguments screenArguments) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 15),
          const Text(
            "Enter all product details to save this product, All feilds are compulsory.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: provider.nameController,
            decoration: InputDecoration(
              labelText: "Product Name",
              hintText: "Product Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 1,
                ),
              ),
            ),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return "Please enter product name ";
              }
            },
          ),
          const SizedBox(height: 15),
          Stack(
            children: [
              GestureDetector(
                onTap: () => selectDate(context),
                child: Container(
                  width: double.infinity,
                  decoration: constBoxDecoration(
                      Colors.white, 5, Colors.grey, 1, false),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    provider.launchAt,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 10,
                child: Container(
                  decoration: constBoxDecoration(
                      Colors.white, 1, Colors.white, 0, false),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: const Text(
                    "Launch At",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: provider.launchSiteController,
            decoration: InputDecoration(
              labelText: "Launch Site",
              hintText: "Launch Site",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 1,
                ),
              ),
            ),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return "Please enter launch site";
              }
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                "Popularity : ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Expanded(
                child: Center(
                  child: RatingBar.builder(
                    initialRating: provider.popularity,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: primaryColor,
                    ),
                    onRatingUpdate: (rating) {
                      provider.popularity = rating;
                      print(rating);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          provider.processing
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      saveProduct(screenArguments.updateProduct);
                    }
                  },
                  child: const Text("Save Product"),
                )
        ],
      ),
    );
  }

  horizantalLayout(
      BoxConstraints constraints, ScreenArguments screenArguments) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 15),
          const Text(
            "Enter all product details to save this product, All feilds are compulsory.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: provider.nameController,
                  decoration: InputDecoration(
                    labelText: "Product Name",
                    hintText: "Product Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Please enter product name ";
                    }
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () => selectDate(context),
                      child: Container(
                        width: double.infinity,
                        decoration: constBoxDecoration(
                            Colors.white, 5, Colors.grey, 1, false),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          provider.launchAt,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 10,
                      child: Container(
                        decoration: constBoxDecoration(
                            Colors.white, 1, Colors.white, 0, false),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        child: const Text(
                          "Launch At",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: provider.launchSiteController,
                  decoration: InputDecoration(
                    labelText: "Launch Site",
                    hintText: "Launch Site",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Please enter launch site";
                    }
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      "Popularity : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: RatingBar.builder(
                          initialRating: provider.popularity,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: primaryColor,
                          ),
                          onRatingUpdate: (rating) {
                            provider.popularity = rating;
                            print(rating);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          provider.processing
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      saveProduct(screenArguments.updateProduct);
                    }
                  },
                  child: const Text("Save Product"),
                )
        ],
      ),
    );
  }
}
