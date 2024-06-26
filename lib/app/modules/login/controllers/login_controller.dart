import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        final UserCredential credential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        User? user = credential.user;

        if (user != null) {
          if (user.emailVerified == true) {
            isLoading.value = false;
            Get.offAllNamed(Routes.HOME);
          } else {
            Get.defaultDialog(
              title: "Belum Verifikasi",
              middleText:
                  "Kamu belum verifikasi akun ini. Lakukan verifikasi di email kamu",
              actions: [
                OutlinedButton(
                  onPressed: () {
                    isLoading.value = false;
                    Get.back();
                  },
                  child: Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await user.sendEmailVerification();
                      Get.back();
                      Get.snackbar("Berhasil",
                          "Kami telah berhasil mengirim email verifikasi ke akun kamu");
                      isLoading.value = false;
                    } catch (e) {
                      isLoading.value = false;
                      Get.snackbar("Terjadi kesalahan",
                          "Tidak dapat mengirim email verifikasi. Hubungi admin atau customer service");
                    }
                  },
                  child: Text("KIRIM ULANG"),
                ),
              ],
            );
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi Kesalahan", "Email tidak terdaftar");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "Password salah");
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak Dapat login");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email dan password wajib diisi");
    }
  }
}
