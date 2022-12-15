

import 'package:cafe_app_project/routes/routs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../View/widgets/admin/stock/products_in_stock.dart';
import '../../../logic/Controller/prodect_controller.dart';
import '../../../model/product.dart';
import '../../widgets/admin/stock/empty_screen.dart';

class StockScreen extends StatelessWidget {
  StockScreen({Key? key}) : super(key: key);
  final controller = Get.put(ProdectController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 154,
          iconTheme: IconThemeData(color: Colors.black),
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
                "Book Store",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.addProductForm);
              },
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: StreamBuilder(
            stream: controller.getData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("not empty screen");
                controller.prodects = snapshot.data!.docs
                    .map((e) => Prodect(
                        productNumber: e['productNumber'],
                        productName: e['productName'],
                        description: e['description'],
                        category: e['category'],
                        price: e['price'],
                        quantity: e['quantity'],
                        imageUrl: e['imageUrl']))
                    .toList();
                print("prodects.length   ${controller.prodects.length}");

                if (controller.prodects.isNotEmpty) {
                  return ProuctsInStock(
                    prodect: controller.prodects,
                  );
                } else {
                  print("empty screen");
                  return EmptyScreen();
                }
              } else {
                return ProuctsInStock(
                  prodect: controller.prodects,
                );
              }
            }
            ),
        // drawer: SideBarMenu()
    );
  }
}
