import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();

  XFile? image;

  void pickImage() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = pickedImage;
      print(image!.name);
      print(image!.name.split(".").last);
      print(image!.path);
      update(); // Notify GetBuilder to rebuild the widget
    } else {
      print(image);
    }
  }

  Future<void> updateProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await firestore.collection("pegawai").doc(uid).update({
          "name": nameC.text,
        });
        Get.snackbar("Berhasil", "Berhasil update profile.");
      } catch (e) {
        Get.snackbar("Terjadi kesalahan", "Tidak dapat update profile.");
      } finally {
        isLoading.value = false;
      }
    }
  }
}
