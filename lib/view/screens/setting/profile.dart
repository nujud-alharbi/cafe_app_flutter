import 'package:cafe_app_project/View/widgets/textUtils.dart';
import 'package:cafe_app_project/logic/Controller/auth_controller.dart';
import 'package:cafe_app_project/model/UserImages.dart';
import 'package:cafe_app_project/utils/theme.dart';
import 'package:cafe_app_project/view/screens/setting/uploadImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../logic/Controller/imagesProfile.dart';
import '../../../logic/Controller/setting_controller.dart';


import '../../widgets/settings/imageUserProfile.dart';


class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final controllerImages = Get.put(ImagesController());
  final controller = Get.put(SettingController());
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    print("image path ${controller.imagePath1}");
    print("username ${authController.displayUserName.value}");
    return SafeArea(
      child: Scaffold(body: GetBuilder<AuthController>(builder: (_) {
        return Obx(() => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: authController.displayUserPhoto.value == ""
                              ? const AssetImage("images/avtar.png")
                                  as ImageProvider
                              : NetworkImage(
                                  authController.displayUserPhoto.value,
                                ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextUtils(
                      text: authController.displayUserName.value,
                      color: Colors.black,
                      fointSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextUtils(
                      text: authController.displayDescription.value,
                      color: Colors.black87,
                      fointSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 7)),
                          onPressed: () {
                            Get.to(UplodImageProfile());
                            // Get.toNamed(Routes.loginScreen);
                          },
                          child: TextUtils(
                            text: 'Select Image',
                            fointSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            underLine: TextDecoration.none,
                          )),
                      // SizedBox(width: 100,),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      height: 400,
                      width: 371,

                      color: Colors.white,

                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(authController.displayUserEmail.value)
                            .collection("ImagesUserProfile")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            print("not empty screen");
                            controllerImages.userImages = snapshot.data!.docs
                                .map((e) => UserImages(imageUrl: e['image']))
                                .toList();
                            print(
                                "prodects.length   ${controllerImages.userImages.length}");

                            if (controllerImages.userImages.isNotEmpty) {
                              return ImageUserProfile(
                                prodect: controllerImages.userImages,
                              );
                            } else {
                              return Center(
                                  child: TextUtils(
                                text:
                                    "Share your creativity with us if you love art on coffee.. ",
                                fointSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ));
                            }
                          } else {
                            return ImageUserProfile(
                              prodect: controllerImages.userImages,
                            );
                          }
                        },
                      ),
                      // ImagesProfileUser(),
                    ),
                  )
                ],
              ),
            ));
      })),
    );
  }
}
