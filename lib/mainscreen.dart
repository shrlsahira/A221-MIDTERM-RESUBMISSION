import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mainscreen/model/product.dart';
import 'package:mainscreen/model/user.dart';
import 'package:mainscreen/mainmenu.dart';
import 'ServerConfig.dart';
import 'detailscreen.dart';
import 'profilescreen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Product> productList = <Product>[];
  String titlecenter = "Loading...";
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('HOMESTAY'),
            actions: [
              IconButton(
                  onPressed: _profile,
                  icon: const Icon(Icons.account_circle_sharp)),
              IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
            ],
          ),
          drawer: MainMenuWidget(user: widget.user),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Your current products/services (${productList.length} found)",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: rowcount,
                  children: List.generate(productList.length, (index) {
                    return Card(
                      elevation: 8,
                      child: InkWell(
                        onTap: () {
                          _showDetails(index);
                        },
                        child: Column(children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Flexible(
                            flex: 6,
                            child: CachedNetworkImage(
                              width: resWidth / 2,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${ServerConfig}/assets/productimages/${productList[index].productId}.png",
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          Flexible(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      truncateString(
                                          productList[index]
                                              .productName
                                              .toString(),
                                          15),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        "RM ${double.parse(productList[index].productPrice.toString()).toStringAsFixed(2)}"),
                                    Text(df.format(DateTime.parse(
                                        productList[index]
                                            .productDate
                                            .toString()))),
                                  ],
                                ),
                              ))
                        ]),
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ));
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  void _loadProducts() {
    http
        .post(
      Uri.parse("http://192.168.0.9/homeStayRayaProject/php/loadAllProduct.php"),
    )
        .then((response) {
      print(response.body);
      // wait for response from the request
      if (response.statusCode == 200) {
        //if statuscode OK
        var jsondata =
            jsonDecode(response.body); //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array
          if (extractdata['products'] != null) {
            //check if  array object is not null
            productList = <Product>[]; //complete the array object definition
            extractdata['products'].forEach((v) {
              //traverse products array list and add to the list object array productList
              productList.add(Product.fromJson(
                  v)); //add each product array to the list object array productList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Product Available"; //if no data returned show title center
            productList.clear();
          }
        }
      } else {
        titlecenter = "No Product Available"; //status code other than 200
        productList.clear(); //clear productList array
      }
      setState(() {}); //refresh UI
    });
  }

  User user = User(
      id: "0",
      email: "unregistered",
      name: "unregistered",
      phone: "0123456789");

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Log out?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
                onPressed: _yesButton,
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                )),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _yesButton() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => MainScreen(
                  user: user,
                )));
    Fluttertoast.showToast(
        msg: "Logout Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 14.0);
  }

  Future<void> _showDetails(int index) async {
    Product product = Product.fromJson(productList[index].toJson());
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => DetailsScreen(
                  product: product,
                  user: widget.user,
                )));
    _loadProducts();
  }

  void _profile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => ProfileScreen(
                  user: user,
        )));
        }
}