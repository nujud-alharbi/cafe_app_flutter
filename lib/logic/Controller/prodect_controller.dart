import 'dart:io';

import 'package:cafe_app_project/logic/Controller/auth_controller.dart';
import 'package:cafe_app_project/logic/Controller/cart_controller.dart';
import 'package:cafe_app_project/model/product.dart';
import 'package:cafe_app_project/routes/routs.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

class ProdectController extends GetxController {
  final authController = Get.put(AuthController());
  final cartController = Get.put(CartController());

  TextEditingController productNumberController = TextEditingController();
  TextEditingController productNameControlller = TextEditingController();
  TextEditingController productCategoryController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  TextEditingController searchTextController = TextEditingController();

  File? pickedFile;
  String imgUrl = "";
  final imagePicker = ImagePicker();

  final prodectRefUser = FirebaseFirestore.instance.collection('users');
  final getData = FirebaseFirestore.instance.collection('prodects').snapshots();

  List<Prodect> prodects = [];
  var searchList = <Prodect>[].obs;

  var prodectsFav = <Prodect>[];
  //update varible
  var productName = ''.obs;
  var productCategory = ''.obs;
  var productQuantity = ''.obs;
  var productPrice = ''.obs;
  var productDescription = ''.obs;

  List<String> imageListSlider = [
    "https://images.unsplash.com/photo-1592663527359-cf6642f54cff?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fGNvb2ZmZWV8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1559496417-e7f25cb247f3?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fGNvb2ZmZWV8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1572286258217-40142c1c6a70?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTl8fGNvb2ZmZWV8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1520903304654-28bd223f96d7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8Mnw3NDk0MzIwN3x8ZW58MHx8fHw%3D&auto=format&fit=crop&w=800&q=60"
  ];

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();

    // TODO: implement initState
    searchTextController
      ..addListener(() {
        update();
      });
  }

  // add to firebase

  Future<void> addProdect(Prodect prodect) async {
    if (pickedFile == null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child("productImage")
          .child(productNameControlller.text + ".jpg");
      await ref.putFile(pickedFile!);
      imgUrl = await ref.getDownloadURL();
    } else {
      final ref = FirebaseStorage.instance
          .ref()
          .child("productImage")
          .child(productNameControlller.text + ".jpg");
      await ref.putFile(pickedFile!);
      imgUrl = await ref.getDownloadURL();
    }
    // we nede Refrence to firebase
    final prodectRef = FirebaseFirestore.instance.collection('prodects').doc();
    prodect.productNumber = prodectRef.id;
    prodect.imageUrl = imgUrl.toString();
    final data = prodect.toJson(); // insert to fiserbase
    prodectRef.set(data).whenComplete(() {
      clearController();
      Get.snackbar("", "Added successfully..");
      Get.offNamed(Routes.stockScreen);
      update();
    }).catchError((error) {
      Get.snackbar("Error", "something went wrong");
    });
  }

  Future<void> TakePhoto(ImageSource sourse) async {
    final pickedImage =
        await imagePicker.pickImage(source: sourse, imageQuality: 100);

    pickedFile = File(pickedImage!.path);
    print("..............");
    print(pickedFile);
    print("..............");
  }

  // update on firebase

  Future<void> updateProduct(
      productNumberController,
      productNameControlller,
      productCategoryController,
      productQuantityController,
      productPriceController,
      productDescriptionController,
      imgUrl) async {
    productName.value = productNameControlller.text;
    productCategory.value = productCategoryController.text;
    productQuantity.value = productQuantityController.text;
    productPrice.value = productPriceController.text;
    productDescription.value = productDescriptionController.text;
    imgUrl;

    final ref = FirebaseStorage.instance
        .ref()
        .child("productImage")
        .child(productNameControlller.text + ".jpg");
    if (pickedFile == null) {
    } else {
      await ref.putFile(pickedFile!);
      imgUrl = await ref.getDownloadURL();
    }

    final docProduct = FirebaseFirestore.instance
        .collection("prodects")
        .doc(productNumberController);
    docProduct.update({
      "productName": productName.value,
      "category": productCategory.value,
      "quantity": int.parse(productQuantity.value),
      "price": double.parse(productPrice.value),
      "description": productDescription.value,
      "imageUrl": imgUrl.toString(),
    }).whenComplete(() {
      print("update done");
      Get.snackbar("", "Update successfully..");
      clearController();
      update();
      Get.offNamed(Routes.stockScreen);
    });
  }

  // delete on firebase
  Future<void> deleteData(
      productNumberController, productNameControlller) async {
    await FirebaseFirestore.instance
        .collection('prodects')
        .doc(productNumberController)
        .delete()
        .whenComplete(() async {
      Get.snackbar("", "Delete successfully..");
      print("delete ${productNumberController}");

      FirebaseStorage.instance
          .ref()
          .child("productImage/")
          .child(productNameControlller + ".jpg")
          .delete()
          .whenComplete(() => print("image delete"));
    });
  }

  // clear Controller
  void clearController() {
    productNameControlller.clear();
    productCategoryController.clear();
    productQuantityController.clear();
    productPriceController.clear();
    productDescriptionController.clear();
    pickedFile = null;
  }

  void addSearchToList(String searchName) {
    searchName = searchName.toLowerCase();
    searchList.value = prodects.where((search) {
      var searchTitle = search.productName.toLowerCase();
      var searchPrice = search.price.toString().toLowerCase();
      return searchTitle.contains(searchName) ||
          searchPrice.toString().contains(searchName);
    }).toList();

    update();
  }

  void clearSearch() {
    searchTextController.clear();
    addSearchToList("");
  }

//

  Future<void> addProdectFav(Prodect prodect) async {
    var indexWanted = prodectsFav.indexWhere((element) {
      print("-----------------nnn${element.productNumber}");
      return element.productNumber == prodect.productNumber;
    });
    print("-------------nn ${prodect.productNumber}");
    print(indexWanted);

    print("------------nn-");

    if (indexWanted >= 0) {
      await prodectRefUser
          .doc(authController.displayUserEmail.value)
          .collection("Favorite")
          .doc(prodect.productNumber)
          .delete();

      Get.snackbar("", "deleted successfully..");
      update();
    } else {
      final ref = FirebaseStorage.instance
          .ref()
          .child("productImage")
          .child(productNameControlller.text + ".jpg");
      final favRef = prodectRefUser
          .doc(authController.displayUserEmail.value)
          .collection("Favorite")
          .doc(prodect.productNumber);
      prodect.productNumber = favRef.id;

      final data = prodect.toJson(); // insert to fiserbase
      print("----- ${favRef.id}");
      print("------------- ${prodect.productNumber}");

      favRef.set(data).whenComplete(() {
        if (favRef.id == prodect.productNumber.toString()) {
          Get.snackbar("", "Added successfully..");
          // Get.toNamed(Routes.cartScreen);
        } else {
          Get.snackbar("Error", "something went wrong");
        }
        update();
      }).catchError((error) {
        Get.snackbar("Error", "something went wrong");
      });
    }
  }

  bool isFave(String productId) {
    print("------&&&&&&$productId");
    print(productNumberController.text);

    return prodectsFav.any((element) => element.productNumber == productId);
  }

  Future<void> deleteDataFav(String nameId) async {
    await prodectRefUser
        .doc(authController.displayUserEmail.value)
        .collection("Favorite")
        .doc(nameId)
        .delete();
    update();
  }
}
