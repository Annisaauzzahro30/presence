import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != "password") {
        try {
          User? user = auth.currentUser;
          String email = user?.email ?? "";

          if (email.isEmpty) {
            Get.snackbar(
                "Terjadi kesalahan", "Email pengguna tidak ditemukan.");
            return;
          }

          await user!.updatePassword(newPassC.text);
          await auth.signOut();
          await auth.signInWithEmailAndPassword(
            email: email,
            password: newPassC.text,
          );

          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("Terjadi kesalahan",
                "Password terlalu lemah. Setidaknya 6 karakter.");
          } else if (e.code == 'requires-recent-login') {
            Get.snackbar("Terjadi kesalahan",
                "Untuk mengubah password, silakan login kembali.");
          } else {
            Get.snackbar(
                "Terjadi kesalahan",
                e.message ??
                    "Tidak dapat membuat password baru. Hubungi admin atau customer service.");
          }
        } catch (e) {
          Get.snackbar("Terjadi kesalahan",
              "Tidak dapat membuat password baru. Hubungi admin atau customer service.");
        }
      } else {
        Get.snackbar("Terjadi Kesalahan",
            "Password baru harus diubah, jangan 'password' kembali.");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Password baru wajib diisi.");
    }
  }
}
